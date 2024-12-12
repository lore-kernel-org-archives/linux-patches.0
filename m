Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB85F6F2FE;
	Thu, 12 Dec 2024 15:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017846; cv=none; b=kR0GpA0fcFQ4K6LPCt+8kLJ1fFJjD1S7dBu8ZJ7dqAcvVR3oSVr/rKFdQUJVtBpE20h24tmcvGcDA8f5odw0EsOuFtUtU7PUazVc4/hCtw8YVTOmQQGQHoz9UNYcESisp6e0ksSrWVIoa32Mic/Aaen+0zG35yXZhUzdqGKj5eE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017846; c=relaxed/simple;
	bh=3NPt5VFD3IA9+R/ziypU+D9BWnkg++o7HLjibRczAcA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKGgGSjXPS+WEeGA5JEdfaY9NWZ3sA1RxOS73oNoQWmR4CtlcDGGMrv+NbxTjZrq4YyGxZZViCdo4/1tlnANXHriuaeaOdlizVIpnUW16LMqTp2QHQFnwzjgJRjKbvrkDPNqIfwkFq3ynbDZjKjdeMNIkQINeBxuCemLg4rTtTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b+qCqkdq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b+qCqkdq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EF9CC4CECE;
	Thu, 12 Dec 2024 15:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017846;
	bh=3NPt5VFD3IA9+R/ziypU+D9BWnkg++o7HLjibRczAcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b+qCqkdqXC32OaYVrC4QuhihZsMZFfjVwdxG2rQrU5b+HRYTNooQvh10C9UW+I6Yx
	 ckWIU5kJg0JSN+X1jz1nHS5fq+fdgXRexGlM+5gYtMois0bvo+jrjx7+MsqUf8u52a
	 2au1PM2Y0jL1CmPntbRpNaeu2wQTw0eg1y9NfJbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
	Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 097/356] f2fs: fix to drop all discards after creating snapshot on lvm device
Date: Thu, 12 Dec 2024 15:56:56 +0100
Message-ID: <20241212144248.448477184@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

[ Upstream commit bc8aeb04fd80cb8cfae3058445c84410fd0beb5e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/segment.c |  9 +++++++++
 fs/f2fs/super.c   | 12 ++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/fs/f2fs/segment.c b/fs/f2fs/segment.c
index 670104628ddbe..156d92b945258 100644
--- a/fs/f2fs/segment.c
+++ b/fs/f2fs/segment.c
@@ -1282,6 +1282,15 @@ static int __submit_discard_cmd(struct f2fs_sb_info *sbi,
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
diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index f05d0e43db9e2..b72fa103b9632 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -1735,6 +1735,18 @@ static int f2fs_freeze(struct super_block *sb)
 
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
-- 
2.43.0



