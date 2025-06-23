Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1858E2522B1;
	Mon, 23 Jun 2025 13:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684573; cv=none; b=JRCOVc+lNoEeq4l+hwq1RsDGVlVeMYdmNgRQeZO2fMg+LbkDd70gIdKuzTGlZjVGUbrdyG230m6lEbaRlc5HIZ3CjdGLDXM371Ftv3shBquuHc9HG+b0fPbpOo5WJBeqJekgMb+gtYE4Wg5T8mHTcdfyJAkt0oVAtxibMS6nEDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684573; c=relaxed/simple;
	bh=tFwgEH0UKrzzst9rGE4iMFYT0YAYrkvIW4aZ4NvEd/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRlQClD/kGI5TRQYPNxfsqdCQ4VMifxESkcouwGAm6k+sk0CCyPQiC4O00C5UyG6Uyo49YRl4nfgm1f7cKtNsVfHxkMHeESNDgokPeEnWAetG+kpXTiPdydUqB6jtJW68p7hq5O7RpLG/mFnQsTjXbbGCy+O6hae/70ZtnbCkZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WUj2NBi2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WUj2NBi2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A18C1C4CEF2;
	Mon, 23 Jun 2025 13:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684573;
	bh=tFwgEH0UKrzzst9rGE4iMFYT0YAYrkvIW4aZ4NvEd/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WUj2NBi2BX7T7RfrhJxQCy6K4qzmTEBokE62c7nqexI9TInwSiYZ7plfYaVMh4VJ2
	 vlka2ZA3VtxW1ssrAMiWRudhgfz2S5FqbywS7mM+FUcVwyXRqo8XdAolfsXP05NXP/
	 nfnBx0SoqqqVb4UkWjxWNsa5mWa78nXQxVxhYNNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.15 116/592] ext4: factor out ext4_get_maxbytes()
Date: Mon, 23 Jun 2025 15:01:14 +0200
Message-ID: <20250623130703.031379559@linuxfoundation.org>
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

commit dbe27f06fa38b9bfc598f8864ae1c5d5831d9992 upstream.

There are several locations that get the correct maxbytes value based on
the inode's block type. It would be beneficial to extract a common
helper function to make the code more clear.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Reviewed-by: Baokun Li <libaokun1@huawei.com>
Link: https://patch.msgid.link/20250506012009.3896990-3-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Cc: stable@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ext4/ext4.h    |    7 +++++++
 fs/ext4/extents.c |    7 +------
 fs/ext4/file.c    |    7 +------
 3 files changed, 9 insertions(+), 12 deletions(-)

--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -3378,6 +3378,13 @@ static inline unsigned int ext4_flex_bg_
 	return 1 << sbi->s_log_groups_per_flex;
 }
 
+static inline loff_t ext4_get_maxbytes(struct inode *inode)
+{
+	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
+		return inode->i_sb->s_maxbytes;
+	return EXT4_SB(inode->i_sb)->s_bitmap_maxbytes;
+}
+
 #define ext4_std_error(sb, errno)				\
 do {								\
 	if ((errno))						\
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -4932,12 +4932,7 @@ static const struct iomap_ops ext4_iomap
 
 static int ext4_fiemap_check_ranges(struct inode *inode, u64 start, u64 *len)
 {
-	u64 maxbytes;
-
-	if (ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS))
-		maxbytes = inode->i_sb->s_maxbytes;
-	else
-		maxbytes = EXT4_SB(inode->i_sb)->s_bitmap_maxbytes;
+	u64 maxbytes = ext4_get_maxbytes(inode);
 
 	if (*len == 0)
 		return -EINVAL;
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -929,12 +929,7 @@ static int ext4_file_open(struct inode *
 loff_t ext4_llseek(struct file *file, loff_t offset, int whence)
 {
 	struct inode *inode = file->f_mapping->host;
-	loff_t maxbytes;
-
-	if (!(ext4_test_inode_flag(inode, EXT4_INODE_EXTENTS)))
-		maxbytes = EXT4_SB(inode->i_sb)->s_bitmap_maxbytes;
-	else
-		maxbytes = inode->i_sb->s_maxbytes;
+	loff_t maxbytes = ext4_get_maxbytes(inode);
 
 	switch (whence) {
 	default:


