Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D931494D9;
	Fri,  6 Dec 2024 14:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496164; cv=none; b=DjeYju4CgNmp63hI9q0IDZcwmt8faAp1kvC6kcZ31WufrG+HKGm1K9yhD/RSl3YHZsjQ+WFDu2CZWLfeeX64DQr9r7e70dKzUlLhbH5mRqU+ZakXn1fjEBAFrgzs6ji0TE450lqo96VpJG94o0Qvidwl2y7C+lEfmHKBcG6F9U0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496164; c=relaxed/simple;
	bh=RdrPPc4xWGM3Ahp1KUiUuX1GRP7JoSFZt4xoTDu/Q8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RI6bVdy91vSnzGRtlRnae1u4Qy6LP+4uoaCzSh9b0HzDvPDL+vYmjyg26NeLXKH43iw64jUrlQ1pFvrxxo28B1RPrnb0lH1FVmoaHhYhVijacjvuTVWkyB2fIGzMVpmevLNZ4fCg8pJmBRYQkTaJohDNsD3dobu1Rk7GKqPGtsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ijc/dO24; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ijc/dO24"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B90EC4CED1;
	Fri,  6 Dec 2024 14:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496164;
	bh=RdrPPc4xWGM3Ahp1KUiUuX1GRP7JoSFZt4xoTDu/Q8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ijc/dO24lTB+guoZYJ4y64i3jbf+VZcF8mSzlcTMu4w+yZTyY7Pga6Y1DQFOI++3i
	 9LI447rcBRUqV30M6+BYfURRquZkxvswtkreIDK6ufEzQkNdmli2Z2o4q3DnlN9cGc
	 peO9s5YbKZlsZxxt08CfkNiFQz/2klY2fhwBnMi4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH 6.12 070/146] f2fs: fix to drop all discards after creating snapshot on lvm device
Date: Fri,  6 Dec 2024 15:36:41 +0100
Message-ID: <20241206143530.360937430@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit bc8aeb04fd80cb8cfae3058445c84410fd0beb5e upstream.

Piergiorgio reported a bug in bugzilla as below:

------------[ cut here ]------------
WARNING: CPU: 2 PID: 969 at fs/f2fs/segment.c:1330
RIP: 0010:__submit_discard_cmd+0x27d/0x400 [f2fs]
Call Trace:
 __issue_discard_cmd+0x1ca/0x350 [f2fs]
 issue_discard_thread+0x191/0x480 [f2fs]
 kthread+0xcf/0x100
 ret_from_fork+0x31/0x50
 ret_from_fork_asm+0x1a/0x30

w/ below testcase, it can reproduce this bug quickly:
- pvcreate /dev/vdb
- vgcreate myvg1 /dev/vdb
- lvcreate -L 1024m -n mylv1 myvg1
- mount /dev/myvg1/mylv1 /mnt/f2fs
- dd if=/dev/zero of=/mnt/f2fs/file bs=1M count=20
- sync
- rm /mnt/f2fs/file
- sync
- lvcreate -L 1024m -s -n mylv1-snapshot /dev/myvg1/mylv1
- umount /mnt/f2fs

The root cause is: it will update discard_max_bytes of mounted lvm
device to zero after creating snapshot on this lvm device, then,
__submit_discard_cmd() will pass parameter @nr_sects w/ zero value
to __blkdev_issue_discard(), it returns a NULL bio pointer, result
in panic.

This patch changes as below for fixing:
1. Let's drop all remained discards in f2fs_unfreeze() if snapshot
of lvm device is created.
2. Checking discard_max_bytes before submitting discard during
__submit_discard_cmd().

Cc: stable@vger.kernel.org
Fixes: 35ec7d574884 ("f2fs: split discard command in prior to block layer")
Reported-by: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=219484
Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/f2fs/segment.c |   16 +++++++++-------
 fs/f2fs/super.c   |   12 ++++++++++++
 2 files changed, 21 insertions(+), 7 deletions(-)

--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1290,16 +1290,18 @@ static int __submit_discard_cmd(struct f
 						wait_list, issued);
 			return 0;
 		}
-
-		/*
-		 * Issue discard for conventional zones only if the device
-		 * supports discard.
-		 */
-		if (!bdev_max_discard_sectors(bdev))
-			return -EOPNOTSUPP;
 	}
 #endif
 
+	/*
+	 * stop issuing discard for any of below cases:
+	 * 1. device is conventional zone, but it doesn't support discard.
+	 * 2. device is regulare device, after snapshot it doesn't support
+	 * discard.
+	 */
+	if (!bdev_max_discard_sectors(bdev))
+		return -EOPNOTSUPP;
+
 	trace_f2fs_issue_discard(bdev, dc->di.start, dc->di.len);
 
 	lstart = dc->di.lstart;
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1748,6 +1748,18 @@ static int f2fs_freeze(struct super_bloc
 
 static int f2fs_unfreeze(struct super_block *sb)
 {
+	struct f2fs_sb_info *sbi = F2FS_SB(sb);
+
+	/*
+	 * It will update discard_max_bytes of mounted lvm device to zero
+	 * after creating snapshot on this lvm device, let's drop all
+	 * remained discards.
+	 * We don't need to disable real-time discard because discard_max_bytes
+	 * will recover after removal of snapshot.
+	 */
+	if (test_opt(sbi, DISCARD) && !f2fs_hw_support_discard(sbi))
+		f2fs_issue_discard_timeout(sbi);
+
 	clear_sbi_flag(F2FS_SB(sb), SBI_IS_FREEZING);
 	return 0;
 }


