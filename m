Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 608E71581F4;
	Tue, 23 Jul 2024 18:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759884; cv=none; b=QmoT5Amtp85al1r6mIdzLOuRXdtctqo5mxeu1GRUVav7gaHLuIenRRQS6kY8UqTLqLYY/gzalHT6VzGrKObF2LW+Nxv78H8UobtOnW1ZhzbxZud8/SNTv143DaPIQJEizUO83zXkZishHpYx3XM9M9p4QuxgE2luz/GQPIyPPX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759884; c=relaxed/simple;
	bh=VBVBdY/swVRwZVXcX0at4Dt8vYH6Oxy5kT1YrNB8Mg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fG3KruOGg3s56auLC3QkblLSDmKtIofpjZf1A3jZH4Iqs9lR+bxxAP4QEqEpBAekzDClDA2N6tAJQalSZPVUrBHDKfVaQwXPioYp5qQyMjJPA24wUpNBdEz+QIXv4a/l3/6aTfYFx7vlQfowxsmWej8a6z8Qr1YQSsWToSwrJe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h8zcN0ml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h8zcN0ml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0F4C4AF09;
	Tue, 23 Jul 2024 18:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759884;
	bh=VBVBdY/swVRwZVXcX0at4Dt8vYH6Oxy5kT1YrNB8Mg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h8zcN0mlyrLGl8gmoKfjwuCrwj3mLFeSwXHW0IUE0Lp+Y4+r69mzRawGW0tehQPkz
	 cNu/tyFCQeg2uawzwtAi36wpQV/o0m/Ex3tdenR/4DN6ZlYulwhG8dAEJh68OEZ8DE
	 l3E21/fta14EI+Ci7zZFHHQmo6AAGuX2Tm+SVnBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	linux-hardening@vger.kernel.org,
	Justin Stitt <justinstitt@google.com>,
	Kees Cook <keescook@chromium.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 003/163] scsi: sr: Fix unintentional arithmetic wraparound
Date: Tue, 23 Jul 2024 20:22:12 +0200
Message-ID: <20240723180143.596702160@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Stitt <justinstitt@google.com>

[ Upstream commit 9fad9d560af5c654bb38e0b07ee54a4e9acdc5cd ]

Running syzkaller with the newly reintroduced signed integer overflow
sanitizer produces this report:

[   65.194362] ------------[ cut here ]------------
[   65.197752] UBSAN: signed-integer-overflow in ../drivers/scsi/sr_ioctl.c:436:9
[   65.203607] -2147483648 * 177 cannot be represented in type 'int'
[   65.207911] CPU: 2 PID: 10416 Comm: syz-executor.1 Not tainted 6.8.0-rc2-00035-gb3ef86b5a957 #1
[   65.213585] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
[   65.219923] Call Trace:
[   65.221556]  <TASK>
[   65.223029]  dump_stack_lvl+0x93/0xd0
[   65.225573]  handle_overflow+0x171/0x1b0
[   65.228219]  sr_select_speed+0xeb/0xf0
[   65.230786]  ? __pm_runtime_resume+0xe6/0x130
[   65.233606]  sr_block_ioctl+0x15d/0x1d0
...

Historically, the signed integer overflow sanitizer did not work in the
kernel due to its interaction with `-fwrapv` but this has since been
changed [1] in the newest version of Clang. It was re-enabled in the kernel
with Commit 557f8c582a9b ("ubsan: Reintroduce signed overflow sanitizer").

Firstly, let's change the type of "speed" to unsigned long as
sr_select_speed()'s only caller passes in an unsigned long anyways.

$ git grep '\.select_speed'
|	drivers/scsi/sr.c:      .select_speed           = sr_select_speed,
...
|	static int cdrom_ioctl_select_speed(struct cdrom_device_info *cdi,
|	                unsigned long arg)
|	{
|	        ...
|	        return cdi->ops->select_speed(cdi, arg);
|	}

Next, let's add an extra check to make sure we don't exceed 0xffff/177
(350) since 0xffff is the max speed. This has two benefits: 1) we deal
with integer overflow before it happens and 2) we properly respect the
max speed of 0xffff. There are some "magic" numbers here but I did not
want to change more than what was necessary.

Link: https://github.com/llvm/llvm-project/pull/82432 [1]
Closes: https://github.com/KSPP/linux/issues/357
Cc: linux-hardening@vger.kernel.org
Signed-off-by: Justin Stitt <justinstitt@google.com>
Link: https://lore.kernel.org/r/20240508-b4-b4-sio-sr_select_speed-v2-1-00b68f724290@google.com
Reviewed-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/cdrom/cdrom-standard.rst | 4 ++--
 drivers/scsi/sr.h                      | 2 +-
 drivers/scsi/sr_ioctl.c                | 5 ++++-
 include/linux/cdrom.h                  | 2 +-
 4 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/Documentation/cdrom/cdrom-standard.rst b/Documentation/cdrom/cdrom-standard.rst
index 7964fe134277b..6c1303cff159e 100644
--- a/Documentation/cdrom/cdrom-standard.rst
+++ b/Documentation/cdrom/cdrom-standard.rst
@@ -217,7 +217,7 @@ current *struct* is::
 		int (*media_changed)(struct cdrom_device_info *, int);
 		int (*tray_move)(struct cdrom_device_info *, int);
 		int (*lock_door)(struct cdrom_device_info *, int);
-		int (*select_speed)(struct cdrom_device_info *, int);
+		int (*select_speed)(struct cdrom_device_info *, unsigned long);
 		int (*get_last_session) (struct cdrom_device_info *,
 					 struct cdrom_multisession *);
 		int (*get_mcn)(struct cdrom_device_info *, struct cdrom_mcn *);
@@ -396,7 +396,7 @@ action need be taken, and the return value should be 0.
 
 ::
 
-	int select_speed(struct cdrom_device_info *cdi, int speed)
+	int select_speed(struct cdrom_device_info *cdi, unsigned long speed)
 
 Some CD-ROM drives are capable of changing their head-speed. There
 are several reasons for changing the speed of a CD-ROM drive. Badly
diff --git a/drivers/scsi/sr.h b/drivers/scsi/sr.h
index 1175f2e213b56..dc899277b3a44 100644
--- a/drivers/scsi/sr.h
+++ b/drivers/scsi/sr.h
@@ -65,7 +65,7 @@ int sr_disk_status(struct cdrom_device_info *);
 int sr_get_last_session(struct cdrom_device_info *, struct cdrom_multisession *);
 int sr_get_mcn(struct cdrom_device_info *, struct cdrom_mcn *);
 int sr_reset(struct cdrom_device_info *);
-int sr_select_speed(struct cdrom_device_info *cdi, int speed);
+int sr_select_speed(struct cdrom_device_info *cdi, unsigned long speed);
 int sr_audio_ioctl(struct cdrom_device_info *, unsigned int, void *);
 
 int sr_is_xa(Scsi_CD *);
diff --git a/drivers/scsi/sr_ioctl.c b/drivers/scsi/sr_ioctl.c
index 5b0b35e60e61f..a0d2556a27bba 100644
--- a/drivers/scsi/sr_ioctl.c
+++ b/drivers/scsi/sr_ioctl.c
@@ -425,11 +425,14 @@ int sr_reset(struct cdrom_device_info *cdi)
 	return 0;
 }
 
-int sr_select_speed(struct cdrom_device_info *cdi, int speed)
+int sr_select_speed(struct cdrom_device_info *cdi, unsigned long speed)
 {
 	Scsi_CD *cd = cdi->handle;
 	struct packet_command cgc;
 
+	/* avoid exceeding the max speed or overflowing integer bounds */
+	speed = clamp(0, speed, 0xffff / 177);
+
 	if (speed == 0)
 		speed = 0xffff;	/* set to max */
 	else
diff --git a/include/linux/cdrom.h b/include/linux/cdrom.h
index 98c6fd0b39b63..fdfb61ccf55ae 100644
--- a/include/linux/cdrom.h
+++ b/include/linux/cdrom.h
@@ -77,7 +77,7 @@ struct cdrom_device_ops {
 				      unsigned int clearing, int slot);
 	int (*tray_move) (struct cdrom_device_info *, int);
 	int (*lock_door) (struct cdrom_device_info *, int);
-	int (*select_speed) (struct cdrom_device_info *, int);
+	int (*select_speed) (struct cdrom_device_info *, unsigned long);
 	int (*get_last_session) (struct cdrom_device_info *,
 				 struct cdrom_multisession *);
 	int (*get_mcn) (struct cdrom_device_info *,
-- 
2.43.0



