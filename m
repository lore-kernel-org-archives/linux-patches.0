Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E5B188733;
	Mon, 23 Dec 2024 16:08:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970099; cv=none; b=m2W7AESZQPbu/A6JcWOcpMx1X5NHh8tyxD1aYkvVk76nu8Q8kNSUDC7nJFZ+fmRQRLCYKWVaRCS1uy+Z7E6fr3Ddv2TsfP1XoZrKA916C48WySOXuQzp1Pkprv6SHnnuBWveYMcBayRgecFKqmxb9BQIXklYknvv0cBE/tRW5lQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970099; c=relaxed/simple;
	bh=Ih4eGGy2V14KKukndQNWdqQ3rt70/qHBOuN8GveacTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fiU4wBuPxg+ScFJ0Xrz7vX3B+Fs4AbBMR38lCqHJWTgfVEhGyknhhn+XD51Qcox6MmFeUMgo3E7ch5gkKPMyGPmhO/8hU4Vql1Gvm7SM9TPygJvSmt+RdwosB36/ExK59+nVTVnywD/zAYCu/cc9x7/5yJerIPErlgo5ASk+c2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EeMy70Xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EeMy70Xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A647AC4CED3;
	Mon, 23 Dec 2024 16:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970099;
	bh=Ih4eGGy2V14KKukndQNWdqQ3rt70/qHBOuN8GveacTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EeMy70XhhsfO9P90+C7tJUZ5wO/+h2vdi5PhqCmtgDNK2ZpiJeIaQzgWTy4wZzmBT
	 D4QPiFSBMEJecvahWv1fTYwrtc7Pl8edmABcSaRGfXdqMhcFfEcYm7UntfdMZNI9hS
	 J/6HSuxExEXGubE2MxqKCYF+wp8p0Y+FBtvpF0H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.12 143/160] nilfs2: fix buffer head leaks in calls to truncate_inode_pages()
Date: Mon, 23 Dec 2024 16:59:14 +0100
Message-ID: <20241223155414.326972501@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 6309b8ce98e9a18390b9fd8f03fc412f3c17aee9 upstream.

When block_invalidatepage was converted to block_invalidate_folio, the
fallback to block_invalidatepage in folio_invalidate() if the
address_space_operations method invalidatepage (currently
invalidate_folio) was not set, was removed.

Unfortunately, some pseudo-inodes in nilfs2 use empty_aops set by
inode_init_always_gfp() as is, or explicitly set it to
address_space_operations.  Therefore, with this change,
block_invalidatepage() is no longer called from folio_invalidate(), and as
a result, the buffer_head structures attached to these pages/folios are no
longer freed via try_to_free_buffers().

Thus, these buffer heads are now leaked by truncate_inode_pages(), which
cleans up the page cache from inode evict(), etc.

Three types of caches use empty_aops: gc inode caches and the DAT shadow
inode used by GC, and b-tree node caches.  Of these, b-tree node caches
explicitly call invalidate_mapping_pages() during cleanup, which involves
calling try_to_free_buffers(), so the leak was not visible during normal
operation but worsened when GC was performed.

Fix this issue by using address_space_operations with invalidate_folio set
to block_invalidate_folio instead of empty_aops, which will ensure the
same behavior as before.

Link: https://lkml.kernel.org/r/20241212164556.21338-1-konishi.ryusuke@gmail.com
Fixes: 7ba13abbd31e ("fs: Turn block_invalidatepage into block_invalidate_folio")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: <stable@vger.kernel.org>	[5.18+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/btnode.c  |    1 +
 fs/nilfs2/gcinode.c |    2 +-
 fs/nilfs2/inode.c   |    5 +++++
 fs/nilfs2/nilfs.h   |    1 +
 4 files changed, 8 insertions(+), 1 deletion(-)

--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -35,6 +35,7 @@ void nilfs_init_btnc_inode(struct inode
 	ii->i_flags = 0;
 	memset(&ii->i_bmap_data, 0, sizeof(struct nilfs_bmap));
 	mapping_set_gfp_mask(btnc_inode->i_mapping, GFP_NOFS);
+	btnc_inode->i_mapping->a_ops = &nilfs_buffer_cache_aops;
 }
 
 void nilfs_btnode_cache_clear(struct address_space *btnc)
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -163,7 +163,7 @@ int nilfs_init_gcinode(struct inode *ino
 
 	inode->i_mode = S_IFREG;
 	mapping_set_gfp_mask(inode->i_mapping, GFP_NOFS);
-	inode->i_mapping->a_ops = &empty_aops;
+	inode->i_mapping->a_ops = &nilfs_buffer_cache_aops;
 
 	ii->i_flags = 0;
 	nilfs_bmap_init_gc(ii->i_bmap);
--- a/fs/nilfs2/inode.c
+++ b/fs/nilfs2/inode.c
@@ -307,6 +307,10 @@ const struct address_space_operations ni
 	.is_partially_uptodate  = block_is_partially_uptodate,
 };
 
+const struct address_space_operations nilfs_buffer_cache_aops = {
+	.invalidate_folio	= block_invalidate_folio,
+};
+
 static int nilfs_insert_inode_locked(struct inode *inode,
 				     struct nilfs_root *root,
 				     unsigned long ino)
@@ -706,6 +710,7 @@ struct inode *nilfs_iget_for_shadow(stru
 	NILFS_I(s_inode)->i_flags = 0;
 	memset(NILFS_I(s_inode)->i_bmap, 0, sizeof(struct nilfs_bmap));
 	mapping_set_gfp_mask(s_inode->i_mapping, GFP_NOFS);
+	s_inode->i_mapping->a_ops = &nilfs_buffer_cache_aops;
 
 	err = nilfs_attach_btree_node_cache(s_inode);
 	if (unlikely(err)) {
--- a/fs/nilfs2/nilfs.h
+++ b/fs/nilfs2/nilfs.h
@@ -401,6 +401,7 @@ extern const struct file_operations nilf
 extern const struct inode_operations nilfs_file_inode_operations;
 extern const struct file_operations nilfs_file_operations;
 extern const struct address_space_operations nilfs_aops;
+extern const struct address_space_operations nilfs_buffer_cache_aops;
 extern const struct inode_operations nilfs_dir_inode_operations;
 extern const struct inode_operations nilfs_special_inode_operations;
 extern const struct inode_operations nilfs_symlink_inode_operations;


