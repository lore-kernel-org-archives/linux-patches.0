Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2CF2628C;
	Mon, 23 Jun 2025 21:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713363; cv=none; b=EjVkI6L5r/DOBIhKuAiP5siskjADtxCm1KPz6lMIFokzek74iCMa2K7bhiDyg6HAp2roDC7GAvvYdljp2oCtECzQjj2uXwTmXlGRnAPcNYz5ZqSj2IE4DcEXBmzLGvCkRyb5AmLGqWWX+ItSTJPcu1sAk1jLWZ/o86xdSMlPjl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713363; c=relaxed/simple;
	bh=wDOjEp4ShBDsxnjTPeD6K+oHRmvtc8eyiZHTJRKYunw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aY/UNdrAEpqOpIN+srY1LMJ+C7VixSxy/hxxJTMn6blZlfEeid6x+0eEm6Veqbzd+7P03L5qkgZ+ogbbtJ9mKtyKTVECnWard8KYDeMWpFyPt08kGATf3JevftupbAzibu/iouK7IADBKikqj8QDD/HqJVcNO0byhWIafJkRelc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0xOO1d2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0xOO1d2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03734C4CEED;
	Mon, 23 Jun 2025 21:16:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713363;
	bh=wDOjEp4ShBDsxnjTPeD6K+oHRmvtc8eyiZHTJRKYunw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0xOO1d2mWr2jBW4WNRpMz/MryaxrPEpdgRjMV3VpSAebeuXHiZzKxQ6zMhjOYpPpS
	 VbmP31oOQjS5LXHZtxRWrVc/i4b+erTWudsUGkIXVjFzwqZpPncsJcaLCXqfRmw4eL
	 NSDEs4sGEcB6uR0yDOw65NWic8JsUXnMzlHAy8PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Baokun Li <libaokun1@huawei.com>,
	Theodore Tso <tytso@mit.edu>,
	stable@kernel.org
Subject: [PATCH 6.6 062/290] ext4: factor out ext4_get_maxbytes()
Date: Mon, 23 Jun 2025 15:05:23 +0200
Message-ID: <20250623130628.870031309@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3351,6 +3351,13 @@ static inline unsigned int ext4_flex_bg_
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
@@ -4970,12 +4970,7 @@ static const struct iomap_ops ext4_iomap
 
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
@@ -898,12 +898,7 @@ static int ext4_file_open(struct inode *
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


