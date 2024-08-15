Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D47C219AA53;
	Thu, 15 Aug 2024 13:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730107; cv=none; b=lkIaF4tuhlnuZxB+H3155yXhWVN1UREauLpEROzIewneIyPs/eItnTiBnqbj0QQ7rfjqedIAan3b5F6Ap6lF6C/H72KcIg5Klf+LztTDFxTy7FVKoPEgIcLD2POA0QmNNsGBlHh63yqhRdV9VYRajPJkNjVLM+ABLoPoODgL0Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730107; c=relaxed/simple;
	bh=Z/gHYIchP9Qc4TsK567dQydv4kTfn5KEg3Ki2YNs1j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5yne3YiI417h82rVXPeiLKBJRoQ6tsT0NW0bglZnE2VOPxP5CzMnKw41q5emrpAiKzuTFmAAc61aV68SJa2w7zI/zWIaffa2gZ1RERK/Lhvg1tlP2rBqTx/Xv1Nt16dWLLlxP9ZM5AZb9ttK0SapEzSlA+554qBzbuSjUxWcdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QMH21UYN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QMH21UYN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5781EC32786;
	Thu, 15 Aug 2024 13:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730107;
	bh=Z/gHYIchP9Qc4TsK567dQydv4kTfn5KEg3Ki2YNs1j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QMH21UYNlccukb92NnuKa/09ASM4sV5bBqbdKci4b5ev3lBl0m1rutYsjodsvoTMZ
	 WJOdlSy7CcK+88svfDbyPw5wzykkrc+nhp7uOiATXBCPDQ1TGQRjAuRFFllaWnVm0L
	 ZDZGRBW/get6Z4R3zTKDAENGAnOspBrFEz787OGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 306/484] ext4: refactor ext4_da_map_blocks()
Date: Thu, 15 Aug 2024 15:22:44 +0200
Message-ID: <20240815131953.227924456@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Yi <yi.zhang@huawei.com>

[ Upstream commit 3fcc2b887a1ba4c1f45319cd8c54daa263ecbc36 ]

Refactor and cleanup ext4_da_map_blocks(), reduce some unnecessary
parameters and branches, no logic changes.

Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240127015825.1608160-2-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 0ea6560abb3b ("ext4: check the extent status again before inserting delalloc block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 39 +++++++++++++++++----------------------
 1 file changed, 17 insertions(+), 22 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 7ad37c807147b..bfd81ff29afcf 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1713,7 +1713,6 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, iblock, NULL, &es)) {
 		if (ext4_es_is_hole(&es)) {
-			retval = 0;
 			down_read(&EXT4_I(inode)->i_data_sem);
 			goto add_delayed;
 		}
@@ -1758,26 +1757,9 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 		retval = ext4_ext_map_blocks(NULL, inode, map, 0);
 	else
 		retval = ext4_ind_map_blocks(NULL, inode, map, 0);
-
-add_delayed:
-	if (retval == 0) {
-		int ret;
-
-		/*
-		 * XXX: __block_prepare_write() unmaps passed block,
-		 * is it OK?
-		 */
-
-		ret = ext4_insert_delayed_block(inode, map->m_lblk);
-		if (ret != 0) {
-			retval = ret;
-			goto out_unlock;
-		}
-
-		map_bh(bh, inode->i_sb, invalid_block);
-		set_buffer_new(bh);
-		set_buffer_delay(bh);
-	} else if (retval > 0) {
+	if (retval < 0)
+		goto out_unlock;
+	if (retval > 0) {
 		unsigned int status;
 
 		if (unlikely(retval != map->m_len)) {
@@ -1792,11 +1774,24 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
 		ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
 				      map->m_pblk, status);
+		goto out_unlock;
 	}
 
+add_delayed:
+	/*
+	 * XXX: __block_prepare_write() unmaps passed block,
+	 * is it OK?
+	 */
+	retval = ext4_insert_delayed_block(inode, map->m_lblk);
+	if (retval)
+		goto out_unlock;
+
+	map_bh(bh, inode->i_sb, invalid_block);
+	set_buffer_new(bh);
+	set_buffer_delay(bh);
+
 out_unlock:
 	up_read((&EXT4_I(inode)->i_data_sem));
-
 	return retval;
 }
 
-- 
2.43.0



