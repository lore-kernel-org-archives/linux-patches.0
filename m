Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9676C27A131;
	Tue, 27 May 2025 17:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368141; cv=none; b=heoaZyXsmYOQzym+FQZAHyTFl9nHcvggT4aOATTtwWa/8XO06rQwFWcfekRKmdPC3j93n+oEXURmopBqaGO6O+/NLLJlsHw5b2Veiqwt4DRqoVx8IePQSI45fTTlBynYKvfpoput03sN4FMJ2aC/u6hr7cUoMbK7JUH1QKhED9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368141; c=relaxed/simple;
	bh=SF3p69MUL3MHbvPNpR9UxJTcxMP9O+5PhPjqywMQVg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CzMzjyWmlDwj+E6Z6Ugq1lqjZ2GeoSijaerv7x8IOihkGsdaiMPUezIJPkhUu6mG1GMVJuxTYIDtkCcL2JhHfbPkAFnTWrVJo8o9YDme6WVvsZRO9/8R3s7WRAbD3f7TTMQKrpl6ktau5wrmtP3P6Q/ftPaLmwamgaLxsahjs5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eIwtcRru; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eIwtcRru"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F57BC4CEE9;
	Tue, 27 May 2025 17:49:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368141;
	bh=SF3p69MUL3MHbvPNpR9UxJTcxMP9O+5PhPjqywMQVg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eIwtcRruFR5Z56AIQgbIg6KZRyTpdmvK865x/qfkwqyj7FYTotUzs+FQtuu/QwRnt
	 GyLy5CtH0drb3D+D/ZEQrz4laHofGFGgnLI8NfCZYcIvf88aBU9PKUohWwdqvkW4lY
	 PXhpdkgwVF46IwkBP1ELR7vvSIKrkYOf+Zy19oTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
	John Meneghini <jmeneghi@redhat.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 581/783] scsi: st: Restore some drive settings after reset
Date: Tue, 27 May 2025 18:26:18 +0200
Message-ID: <20250527162536.810074125@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kai Mäkisara <Kai.Makisara@kolumbus.fi>

[ Upstream commit 7081dc75df79696d8322d01821c28e53416c932c ]

Some of the allowed operations put the tape into a known position to
continue operation assuming only the tape position has changed.  But reset
sets partition, density and block size to drive default values. These
should be restored to the values before reset.

Normally the current block size and density are stored by the drive.  If
the settings have been changed, the changed values have to be saved by the
driver across reset.

Signed-off-by: Kai Mäkisara <Kai.Makisara@kolumbus.fi>
Link: https://lore.kernel.org/r/20250120194925.44432-2-Kai.Makisara@kolumbus.fi
Reviewed-by: John Meneghini <jmeneghi@redhat.com>
Tested-by: John Meneghini <jmeneghi@redhat.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/st.c | 24 +++++++++++++++++++++---
 drivers/scsi/st.h |  2 ++
 2 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 4add423f2f415..7dec7958344ea 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -952,7 +952,6 @@ static void reset_state(struct scsi_tape *STp)
 		STp->partition = find_partition(STp);
 		if (STp->partition < 0)
 			STp->partition = 0;
-		STp->new_partition = STp->partition;
 	}
 }
 
@@ -2929,14 +2928,17 @@ static int st_int_ioctl(struct scsi_tape *STp, unsigned int cmd_in, unsigned lon
 		if (cmd_in == MTSETDENSITY) {
 			(STp->buffer)->b_data[4] = arg;
 			STp->density_changed = 1;	/* At least we tried ;-) */
+			STp->changed_density = arg;
 		} else if (cmd_in == SET_DENS_AND_BLK)
 			(STp->buffer)->b_data[4] = arg >> 24;
 		else
 			(STp->buffer)->b_data[4] = STp->density;
 		if (cmd_in == MTSETBLK || cmd_in == SET_DENS_AND_BLK) {
 			ltmp = arg & MT_ST_BLKSIZE_MASK;
-			if (cmd_in == MTSETBLK)
+			if (cmd_in == MTSETBLK) {
 				STp->blksize_changed = 1; /* At least we tried ;-) */
+				STp->changed_blksize = arg;
+			}
 		} else
 			ltmp = STp->block_size;
 		(STp->buffer)->b_data[9] = (ltmp >> 16);
@@ -3637,9 +3639,25 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 				retval = (-EIO);
 				goto out;
 			}
-			reset_state(STp);
+			reset_state(STp); /* Clears pos_unknown */
 			/* remove this when the midlevel properly clears was_reset */
 			STp->device->was_reset = 0;
+
+			/* Fix the device settings after reset, ignore errors */
+			if (mtc.mt_op == MTREW || mtc.mt_op == MTSEEK ||
+				mtc.mt_op == MTEOM) {
+				if (STp->can_partitions) {
+					/* STp->new_partition contains the
+					 *  latest partition set
+					 */
+					STp->partition = 0;
+					switch_partition(STp);
+				}
+				if (STp->density_changed)
+					st_int_ioctl(STp, MTSETDENSITY, STp->changed_density);
+				if (STp->blksize_changed)
+					st_int_ioctl(STp, MTSETBLK, STp->changed_blksize);
+			}
 		}
 
 		if (mtc.mt_op != MTNOP && mtc.mt_op != MTSETBLK &&
diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
index 1aaaf5369a40f..6d31b894ee84c 100644
--- a/drivers/scsi/st.h
+++ b/drivers/scsi/st.h
@@ -165,6 +165,7 @@ struct scsi_tape {
 	unsigned char compression_changed;
 	unsigned char drv_buffer;
 	unsigned char density;
+	unsigned char changed_density;
 	unsigned char door_locked;
 	unsigned char autorew_dev;   /* auto-rewind device */
 	unsigned char rew_at_close;  /* rewind necessary at close */
@@ -172,6 +173,7 @@ struct scsi_tape {
 	unsigned char cleaning_req;  /* cleaning requested? */
 	unsigned char first_tur;     /* first TEST UNIT READY */
 	int block_size;
+	int changed_blksize;
 	int min_block;
 	int max_block;
 	int recover_count;     /* From tape opening */
-- 
2.39.5



