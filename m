Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F71140E3D;
	Thu, 11 Apr 2024 10:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830788; cv=none; b=HHVknV526rzVhnHhY9nLjwFiFyz+Au2QC/EVkFx+9xcRZzjFprRX+MRxgrOqczbCEcjeqTP1eA/f/dDM0lpz3z1/fW8MFYc4Lws6b70iQ5rQ9HTp6FZZTult/HUr8/GzbVSTeVh1cGDkORw3CiwNSlZ1IOPnRyLSa8Yv3rskvxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830788; c=relaxed/simple;
	bh=1mg21Uzz9+zqBYXkpHxnKRaR0eYb/3uY2cwhdzzdKDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBY0Hm9VJs5QVwm4CA8PfRn7YnkYjVs2WzFmKSVTyut0Nl6ajBYCfsPRk8TElim54TyrUG0voDugVw5avqql/7hFoaNF4DhfAxx3jqfuis1rmW5ViN92JD4Ug+3hjVA/tbsjkAHGgqr2wKOWZVCrnwHujSpP3tHo11LY85y3ZiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rpYeyoy6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rpYeyoy6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39D8CC433F1;
	Thu, 11 Apr 2024 10:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830788;
	bh=1mg21Uzz9+zqBYXkpHxnKRaR0eYb/3uY2cwhdzzdKDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rpYeyoy6hVFOEQUBYVQdSYCHXbehbT/ScDaQw4IWYQV/rhUSEbEVzSD3EIR/RH5MJ
	 M0Kkm/zKaVcJtnyYOZhXn5N6dZpSZ4x+n8c8zrrFYQcNwXTJjDgJGMohsYvbBk0R2X
	 J7qOPQoRdUEcwd4R8Bk9QInEdsxSra7qMDowlJGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c645abf505ed21f931b5@syzkaller.appspotmail.com,
	Bart Van Assche <bvanassche@acm.org>,
	John Garry <john.g.garry@oracle.com>,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	"Guilherme G. Piccoli" <gpiccoli@igalia.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.4 119/215] scsi: core: Fix unremoved procfs host directory regression
Date: Thu, 11 Apr 2024 11:55:28 +0200
Message-ID: <20240411095428.479769729@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095424.875421572@linuxfoundation.org>
References: <20240411095424.875421572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guilherme G. Piccoli <gpiccoli@igalia.com>

commit f23a4d6e07570826fe95023ca1aa96a011fa9f84 upstream.

Commit fc663711b944 ("scsi: core: Remove the /proc/scsi/${proc_name}
directory earlier") fixed a bug related to modules loading/unloading, by
adding a call to scsi_proc_hostdir_rm() on scsi_remove_host(). But that led
to a potential duplicate call to the hostdir_rm() routine, since it's also
called from scsi_host_dev_release(). That triggered a regression report,
which was then fixed by commit be03df3d4bfe ("scsi: core: Fix a procfs host
directory removal regression"). The fix just dropped the hostdir_rm() call
from dev_release().

But it happens that this proc directory is created on scsi_host_alloc(),
and that function "pairs" with scsi_host_dev_release(), while
scsi_remove_host() pairs with scsi_add_host(). In other words, it seems the
reason for removing the proc directory on dev_release() was meant to cover
cases in which a SCSI host structure was allocated, but the call to
scsi_add_host() didn't happen. And that pattern happens to exist in some
error paths, for example.

Syzkaller causes that by using USB raw gadget device, error'ing on
usb-storage driver, at usb_stor_probe2(). By checking that path, we can see
that the BadDevice label leads to a scsi_host_put() after a SCSI host
allocation, but there's no call to scsi_add_host() in such path. That leads
to messages like this in dmesg (and a leak of the SCSI host proc
structure):

usb-storage 4-1:87.51: USB Mass Storage device detected
proc_dir_entry 'scsi/usb-storage' already registered
WARNING: CPU: 1 PID: 3519 at fs/proc/generic.c:377 proc_register+0x347/0x4e0 fs/proc/generic.c:376

The proper fix seems to still call scsi_proc_hostdir_rm() on dev_release(),
but guard that with the state check for SHOST_CREATED; there is even a
comment in scsi_host_dev_release() detailing that: such conditional is
meant for cases where the SCSI host was allocated but there was no calls to
{add,remove}_host(), like the usb-storage case.

This is what we propose here and with that, the error path of usb-storage
does not trigger the warning anymore.

Reported-by: syzbot+c645abf505ed21f931b5@syzkaller.appspotmail.com
Fixes: be03df3d4bfe ("scsi: core: Fix a procfs host directory removal regression")
Cc: stable@vger.kernel.org
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Guilherme G. Piccoli <gpiccoli@igalia.com>
Link: https://lore.kernel.org/r/20240313113006.2834799-1-gpiccoli@igalia.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/hosts.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -331,12 +331,13 @@ static void scsi_host_dev_release(struct
 
 	if (shost->shost_state == SHOST_CREATED) {
 		/*
-		 * Free the shost_dev device name here if scsi_host_alloc()
-		 * and scsi_host_put() have been called but neither
+		 * Free the shost_dev device name and remove the proc host dir
+		 * here if scsi_host_{alloc,put}() have been called but neither
 		 * scsi_host_add() nor scsi_host_remove() has been called.
 		 * This avoids that the memory allocated for the shost_dev
-		 * name is leaked.
+		 * name as well as the proc dir structure are leaked.
 		 */
+		scsi_proc_hostdir_rm(shost->hostt);
 		kfree(dev_name(&shost->shost_dev));
 	}
 


