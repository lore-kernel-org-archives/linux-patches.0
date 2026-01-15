Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 032472D541B;
	Thu, 15 Jan 2026 17:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499050; cv=none; b=Zje0Ub9eOjQdfmfqUUs3nNFCcp//OqKONnJbNfcnAfSx7fRphXpPjg3mFPprx+xzxiCT3mm1FqMaKkXC2S/ElNvCqjQVJAiY4nAT2cci/QQ8dDyBX/Qj+l4U5Kz4OZsyCdd9ZFqLcQk5d16It55QMcKA/zQA+TRAE7gPssOlXRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499050; c=relaxed/simple;
	bh=HDxpvgeiC+BOQvL0xgY5jYY/mf4NtGd/hEe13F2STNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oYpbFIB3o2UYQkoec27hrFzfqmu6xfWXwDKYU4QeFDILYsGYNd1nANomdYA89vK5k8sRinv4wMKxiuB+EfbmeQ5nUisrsF1KDs+VAsT3qFggt9tl/9yunK/qLCcIt6AYbNCGkU2V5oeTPzC/JZy9XilwKb6lAd+Ja1CowritZik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ML/7R0YX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ML/7R0YX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834DDC116D0;
	Thu, 15 Jan 2026 17:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499049;
	bh=HDxpvgeiC+BOQvL0xgY5jYY/mf4NtGd/hEe13F2STNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ML/7R0YXwxCYH9ebCGEXfhb2VChA8nYkstUNJ/wX6wxUig/A7xkiEaoyC9Om7Vug4
	 QdSdYrs2h1dqKLsQVgM3yxsJojkBjDdrP8Y3HMPGNoVLOkHzi1lUhnnMbOPemsFZNK
	 mddU3B2Fhg0Ukpx7jV6mITC+EFJ1Vdun/rHa+kcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Whitney <enwlinux@gmail.com>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 057/451] ext4: minor defrag code improvements
Date: Thu, 15 Jan 2026 17:44:18 +0100
Message-ID: <20260115164232.961342225@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Whitney <enwlinux@gmail.com>

[ Upstream commit d412df530f77d0f61c41b83f925997452fc3944c ]

Modify the error returns for two file types that can't be defragged to
more clearly communicate those restrictions to a caller.  When the
defrag code is applied to swap files, return -ETXTBSY, and when applied
to quota files, return -EOPNOTSUPP.  Move an extent tree search whose
results are only occasionally required to the site always requiring them
for improved efficiency.  Address a few typos.

Signed-off-by: Eric Whitney <enwlinux@gmail.com>
Link: https://lore.kernel.org/r/20220722163910.268564-1-enwlinux@gmail.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: a2e5a3cea4b1 ("ext4: correct the checking of quota files before moving extents")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/move_extent.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/fs/ext4/move_extent.c b/fs/ext4/move_extent.c
index 661a8544d7817..4cb1872c9af43 100644
--- a/fs/ext4/move_extent.c
+++ b/fs/ext4/move_extent.c
@@ -466,19 +466,17 @@ mext_check_arguments(struct inode *orig_inode,
 	if (IS_IMMUTABLE(donor_inode) || IS_APPEND(donor_inode))
 		return -EPERM;
 
-	/* Ext4 move extent does not support swapfile */
+	/* Ext4 move extent does not support swap files */
 	if (IS_SWAPFILE(orig_inode) || IS_SWAPFILE(donor_inode)) {
-		ext4_debug("ext4 move extent: The argument files should "
-			"not be swapfile [ino:orig %lu, donor %lu]\n",
+		ext4_debug("ext4 move extent: The argument files should not be swap files [ino:orig %lu, donor %lu]\n",
 			orig_inode->i_ino, donor_inode->i_ino);
-		return -EBUSY;
+		return -ETXTBSY;
 	}
 
 	if (ext4_is_quota_file(orig_inode) && ext4_is_quota_file(donor_inode)) {
-		ext4_debug("ext4 move extent: The argument files should "
-			"not be quota files [ino:orig %lu, donor %lu]\n",
+		ext4_debug("ext4 move extent: The argument files should not be quota files [ino:orig %lu, donor %lu]\n",
 			orig_inode->i_ino, donor_inode->i_ino);
-		return -EBUSY;
+		return -EOPNOTSUPP;
 	}
 
 	/* Ext4 move extent supports only extent based file */
@@ -626,11 +624,11 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 		if (ret)
 			goto out;
 		ex = path[path->p_depth].p_ext;
-		next_blk = ext4_ext_next_allocated_block(path);
 		cur_blk = le32_to_cpu(ex->ee_block);
 		cur_len = ext4_ext_get_actual_len(ex);
 		/* Check hole before the start pos */
 		if (cur_blk + cur_len - 1 < o_start) {
+			next_blk = ext4_ext_next_allocated_block(path);
 			if (next_blk == EXT_MAX_BLOCKS) {
 				o_start = o_end;
 				ret = -ENODATA;
@@ -659,7 +657,7 @@ ext4_move_extents(struct file *o_filp, struct file *d_filp, __u64 orig_blk,
 		donor_page_index = d_start >> (PAGE_SHIFT -
 					       donor_inode->i_blkbits);
 		offset_in_page = o_start % blocks_per_page;
-		if (cur_len > blocks_per_page- offset_in_page)
+		if (cur_len > blocks_per_page - offset_in_page)
 			cur_len = blocks_per_page - offset_in_page;
 		/*
 		 * Up semaphore to avoid following problems:
-- 
2.51.0



