Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60291714A1;
	Thu, 15 Aug 2024 13:55:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730111; cv=none; b=ssAWiAndHkcu8OzjMxTFSD6OM6Ajx3VMJok7zN+HGNJV2vagp/bSSAXR5zYfCLR679+8FjRWuLCfN1QTjxo+zrKHcysZiJoF4pBR+INlQdc9ULXViw654s7fj0FHiPkatRPmuSczEfv1+i6wcXIUx5vcp/0Fs21AUOSVAx9wXns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730111; c=relaxed/simple;
	bh=DlEpbDrxMEjWUtMDXK4q8JFv6HXWpW+6jqkFgSo8F9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EMBLGDicKImpbyTlA9ptrC6n9/4Yxj6KaNNS1vDUNXhFs03c7kT9UC3uOlidMBnnA+pfj3vPZQivr88qVK0RfZokesV8+WOVcnYnDsIzBV9Nv/W5WOiYYmPMb67tl5q/xtFLfDWM44mDdjALDAniGd+KrpbnRPpyo5F+Vgw8Q7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xsQbCefz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xsQbCefz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D28C32786;
	Thu, 15 Aug 2024 13:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730110;
	bh=DlEpbDrxMEjWUtMDXK4q8JFv6HXWpW+6jqkFgSo8F9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xsQbCefz2MglOEFm7KMiL6ElwYNp2jZqawwA+ndXhJUESeLfZCH/qh9jk86gz7RzS
	 CQp0JghTJvG0ziz5IVcUJJUZlna/FZzh+h/hQmruTUrnliCLPwn2Y27eH/5cLnr2LG
	 KWMZo9ivlDobgAOsiBZsc4sjJuLsi4bPujVjWPvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Yi <yi.zhang@huawei.com>,
	Jan Kara <jack@suse.cz>,
	Theodore Tso <tytso@mit.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 307/484] ext4: convert to exclusive lock while inserting delalloc extents
Date: Thu, 15 Aug 2024 15:22:45 +0200
Message-ID: <20240815131953.268601015@linuxfoundation.org>
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

[ Upstream commit acf795dc161f3cf481db20f05db4250714e375e5 ]

ext4_da_map_blocks() only hold i_data_sem in shared mode and i_rwsem
when inserting delalloc extents, it could be raced by another querying
path of ext4_map_blocks() without i_rwsem, .e.g buffered read path.
Suppose we buffered read a file containing just a hole, and without any
cached extents tree, then it is raced by another delayed buffered write
to the same area or the near area belongs to the same hole, and the new
delalloc extent could be overwritten to a hole extent.

 pread()                           pwrite()
  filemap_read_folio()
   ext4_mpage_readpages()
    ext4_map_blocks()
     down_read(i_data_sem)
     ext4_ext_determine_hole()
     //find hole
     ext4_ext_put_gap_in_cache()
      ext4_es_find_extent_range()
      //no delalloc extent
                                    ext4_da_map_blocks()
                                     down_read(i_data_sem)
                                     ext4_insert_delayed_block()
                                     //insert delalloc extent
      ext4_es_insert_extent()
      //overwrite delalloc extent to hole

This race could lead to inconsistent delalloc extents tree and
incorrect reserved space counter. Fix this by converting to hold
i_data_sem in exclusive mode when adding a new delalloc extent in
ext4_da_map_blocks().

Cc: stable@vger.kernel.org
Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
Suggested-by: Jan Kara <jack@suse.cz>
Reviewed-by: Jan Kara <jack@suse.cz>
Link: https://lore.kernel.org/r/20240127015825.1608160-3-yi.zhang@huaweicloud.com
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Stable-dep-of: 0ea6560abb3b ("ext4: check the extent status again before inserting delalloc block")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ext4/inode.c | 25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index bfd81ff29afcf..329e3dc9cb32c 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -1712,10 +1712,8 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 
 	/* Lookup extent status tree firstly */
 	if (ext4_es_lookup_extent(inode, iblock, NULL, &es)) {
-		if (ext4_es_is_hole(&es)) {
-			down_read(&EXT4_I(inode)->i_data_sem);
+		if (ext4_es_is_hole(&es))
 			goto add_delayed;
-		}
 
 		/*
 		 * Delayed extent could be allocated by fallocate.
@@ -1757,8 +1755,10 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 		retval = ext4_ext_map_blocks(NULL, inode, map, 0);
 	else
 		retval = ext4_ind_map_blocks(NULL, inode, map, 0);
-	if (retval < 0)
-		goto out_unlock;
+	if (retval < 0) {
+		up_read(&EXT4_I(inode)->i_data_sem);
+		return retval;
+	}
 	if (retval > 0) {
 		unsigned int status;
 
@@ -1774,24 +1774,21 @@ static int ext4_da_map_blocks(struct inode *inode, sector_t iblock,
 				EXTENT_STATUS_UNWRITTEN : EXTENT_STATUS_WRITTEN;
 		ext4_es_insert_extent(inode, map->m_lblk, map->m_len,
 				      map->m_pblk, status);
-		goto out_unlock;
+		up_read(&EXT4_I(inode)->i_data_sem);
+		return retval;
 	}
+	up_read(&EXT4_I(inode)->i_data_sem);
 
 add_delayed:
-	/*
-	 * XXX: __block_prepare_write() unmaps passed block,
-	 * is it OK?
-	 */
+	down_write(&EXT4_I(inode)->i_data_sem);
 	retval = ext4_insert_delayed_block(inode, map->m_lblk);
+	up_write(&EXT4_I(inode)->i_data_sem);
 	if (retval)
-		goto out_unlock;
+		return retval;
 
 	map_bh(bh, inode->i_sb, invalid_block);
 	set_buffer_new(bh);
 	set_buffer_delay(bh);
-
-out_unlock:
-	up_read((&EXT4_I(inode)->i_data_sem));
 	return retval;
 }
 
-- 
2.43.0



