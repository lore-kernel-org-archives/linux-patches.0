Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16C0613A265;
	Mon, 23 Jun 2025 13:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684568; cv=none; b=R4OA/TXsvgNfGAPJlIn1nZw9jPFOBGZoZ9M+4Bw1FSSX2MUAlbpNcQnY6dsh3aRY19Ez/J8iqUxt2t7c8wtCYE4Xej0fanRVXjuG0JV9of2liFmwolUCMgrFX3im1oiHMr8Izw2dcTuDRcgKWajKG7FqgmvSdtMTDvIYQr1wmIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684568; c=relaxed/simple;
	bh=YIUztGI8+S7tk9eaIWPWCHM9BhnQEmDdhEQMToWi67o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBiYgOz8Dz6C9zhkz30IKb/L9xKV1LLRrXxKCRlxHlywOvfrlR20yZZXQj0QSgirn/09JeGd0nhLS1P9BnjRrEymEH8TOx0dYCGfhCAkmTwaNcqgxrcXGg/LQd/PevM00UY+mJREePRJj9UnMtGVT10MtLsJSheN3PR/Cq6LXig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Au6/0sn9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Au6/0sn9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C801C4CEEA;
	Mon, 23 Jun 2025 13:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684568;
	bh=YIUztGI8+S7tk9eaIWPWCHM9BhnQEmDdhEQMToWi67o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Au6/0sn9vx64sg8/pKL/BpXSyH/Ij3JQ+OZ77sqtmVJ+XqlC4eH0HdQutWHoKuPhd
	 6G6iuYLbIsI5YPKcwfLJ7UJZo9OjH1BEr8zqALjPwrIdjMKmHNnANMfWsD8Fm8+dMI
	 A/JocrPZFYmJ4Io60wAfLQZAAUUADlVe5Zan4sS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.15 115/592] ext4: fix incorrect punch max_end
Date: Mon, 23 Jun 2025 15:01:13 +0200
Message-ID: <20250623130703.009545713@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

commit 29ec9bed2395061350249ae356fb300dd82a78e7 upstream.

For the extents based inodes, the maxbytes should be sb->s_maxbytes
instead of sbi->s_bitmap_maxbytes. Additionally, for the calculation of
max_end, the -sb->s_blocksize operation is necessary only for
indirect-block based inodes. Correct the maxbytes and max_end value to
correct the behavior of punch hole.

Fixes: 2da376228a24 ("ext4: limit length to bitmap_maxbytes - blocksize in punch_hole")
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20250506012009.3896990-2-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/inode.c |   12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4006,7 +4006,7 @@ int ext4_punch_hole(struct file *file, l
 	struct inode *inode = file_inode(file);
 	struct super_block *sb = inode->i_sb;
 	ext4_lblk_t start_lblk, end_lblk;
-	loff_t max_end = EXT4_SB(sb)->s_bitmap_maxbytes - sb->s_blocksize;
+	loff_t max_end = sb->s_maxbytes;
 	loff_t end = offset + length;
 	handle_t *handle;
 	unsigned int credits;
@@ -4015,14 +4015,20 @@ int ext4_punch_hole(struct file *file, l
 	trace_ext4_punch_hole(inode, offset, length, 0);
 	WARN_ON_ONCE(!inode_is_locked(inode));
 
+	/*
+	 * For indirect-block based inodes, make sure that the hole within
+	 * one block before last range.
+	 */
+	if (!ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+		max_end = EXT4_SB(sb)->s_bitmap_maxbytes - sb->s_blocksize;
+
 	/* No need to punch hole beyond i_size */
 	if (offset >= inode->i_size || offset >= max_end)
 		return 0;
 
 	/*
 	 * If the hole extends beyond i_size, set the hole to end after
-	 * the page that contains i_size, and also make sure that the hole
-	 * within one block before last range.
+	 * the page that contains i_size.
 	 */
 	if (end > inode->i_size)
 		end = round_up(inode->i_size, PAGE_SIZE);


