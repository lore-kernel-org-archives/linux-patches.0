Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68B8B253F03;
	Mon, 23 Jun 2025 13:21:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684899; cv=none; b=CGcD7B4c4Re2kfH9f+d+GOnps6OtPwxcU46OaOXGpWYDU52zqvyRvNO90Zv0kzDuFlkOyso13HJygXWqNYNTRBH1HtOH1e3i6y664QSs6db8DKUb6KCpLCin/ATJQ99m1kUW9xnQ6kSkxU0QRs5hxpUI7hSUFBd8rCOCUGp2kJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684899; c=relaxed/simple;
	bh=PrTNEiScKSnjGCp1wKKc9sXfXHgsvK9Oybu50QAR2ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NB4pbxVtNufA+FtpS5dSYOxGcqNwN4fkaw5BRK/ebflfwaasssSL2XvN/bosEltxUjgrsyCBz9/ET/5LHtLNHDDTZtTnWOAqqlgIVQrEnPcKGPD143O2yJ+jl+T6C+4t8YI4RU11bwEd7pwFwRCSPWw+erPvoCzNL0afV8mWf9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1FmjzsBP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1FmjzsBP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F13C2C4CEEA;
	Mon, 23 Jun 2025 13:21:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684899;
	bh=PrTNEiScKSnjGCp1wKKc9sXfXHgsvK9Oybu50QAR2ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1FmjzsBPf4K4ljwdr/I1w9Z2JnYATyphSbVYdEEVNxSP/ZNPt7fKV2LjnoBlA8tm6
	 3pzYq4hhiQNQjM3EL+FCdfmZlIGBIQ13QazmQTmJ0rzlKbvOBf45j77ixH6InTPUC1
	 v9KruKcFsMeDQ1kvnwgg9Qo/HYm+KbhHcOb0zW8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+65761fc25a137b9c8c6e@syzkaller.appspotmail.com,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 044/222] Squashfs: check return result of sb_min_blocksize
Date: Mon, 23 Jun 2025 15:06:19 +0200
Message-ID: <20250623130613.244459792@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Phillip Lougher <phillip@squashfs.org.uk>

[ Upstream commit 734aa85390ea693bb7eaf2240623d41b03705c84 ]

Syzkaller reports an "UBSAN: shift-out-of-bounds in squashfs_bio_read" bug.

Syzkaller forks multiple processes which after mounting the Squashfs
filesystem, issues an ioctl("/dev/loop0", LOOP_SET_BLOCK_SIZE, 0x8000).
Now if this ioctl occurs at the same time another process is in the
process of mounting a Squashfs filesystem on /dev/loop0, the failure
occurs.  When this happens the following code in squashfs_fill_super()
fails.

----
msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
msblk->devblksize_log2 = ffz(~msblk->devblksize);
----

sb_min_blocksize() returns 0, which means msblk->devblksize is set to 0.

As a result, ffz(~msblk->devblksize) returns 64, and msblk->devblksize_log2
is set to 64.

This subsequently causes the

UBSAN: shift-out-of-bounds in fs/squashfs/block.c:195:36
shift exponent 64 is too large for 64-bit type 'u64' (aka
'unsigned long long')

This commit adds a check for a 0 return by sb_min_blocksize().

Link: https://lkml.kernel.org/r/20250409024747.876480-1-phillip@squashfs.org.uk
Fixes: 0aa666190509 ("Squashfs: super block operations")
Reported-by: syzbot+65761fc25a137b9c8c6e@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/67f0dd7a.050a0220.0a13.0230.GAE@google.com/
Signed-off-by: Phillip Lougher <phillip@squashfs.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/squashfs/super.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/squashfs/super.c b/fs/squashfs/super.c
index 2110323b610b9..545207683ddd7 100644
--- a/fs/squashfs/super.c
+++ b/fs/squashfs/super.c
@@ -86,6 +86,11 @@ static int squashfs_fill_super(struct super_block *sb, struct fs_context *fc)
 	msblk = sb->s_fs_info;
 
 	msblk->devblksize = sb_min_blocksize(sb, SQUASHFS_DEVBLK_SIZE);
+	if (!msblk->devblksize) {
+		errorf(fc, "squashfs: unable to set blocksize\n");
+		return -EINVAL;
+	}
+
 	msblk->devblksize_log2 = ffz(~msblk->devblksize);
 
 	mutex_init(&msblk->meta_index_mutex);
-- 
2.39.5



