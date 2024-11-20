Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 540761AA7B1;
	Wed, 20 Nov 2024 12:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107536; cv=none; b=pIwlo6NkrmXs7SIawbcahJniH45o3AnlipMfZraKMfU4TncgPp3gicGh1X5Ny57rmG5sbWFYAdZodqbas3HeJsi1R/mB3I/DgvRdtizVbU+LOd6QlJMNM2QR/eGoIRvEUfX8qyd49UrSGE1r7vZed8lbQVbd9X7+XwqdkwyTLrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107536; c=relaxed/simple;
	bh=+TdOmpcQCoxWdjYjSd9qjPDHVvAWj9mMzJ95uViqUKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S0g/ATcge1jx/EDxWMcRcKLtdPPKKTrk+9HHDJAkfDZPBCIlxC0wu6lxcKMWKT+50N5FnDHLFwlDiIdYIQr8KJJrGpxQUfnWuULgdBeJ+3vXoHFI5RCJtUNdEw59pnkKvhfwOs085TkdSZHtK2DeDM9qADis//TXAI1Djo5h9RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sdHp6ObT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sdHp6ObT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25770C4CED1;
	Wed, 20 Nov 2024 12:58:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107536;
	bh=+TdOmpcQCoxWdjYjSd9qjPDHVvAWj9mMzJ95uViqUKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sdHp6ObT9rIB0w2Mh/CoWfVf+3cF6cewdqWw96GgwaE4O0LhGDvvHwcqgvgRfmuPq
	 OcfXLNd78qggN++SvclZX9aX4bLDPvvJ86c8U8RnEQxG6FSVp1kq+srPOfkqcMTD9R
	 MiLeUrnY84h2cuZscvCnp1uJPXTFMCQtwSD/a5Ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Ubisectech Sirius <bugreport@valiantsec.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 069/107] nilfs2: fix null-ptr-deref in block_dirty_buffer tracepoint
Date: Wed, 20 Nov 2024 13:56:44 +0100
Message-ID: <20241120125631.237183211@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryusuke Konishi <konishi.ryusuke@gmail.com>

commit 2026559a6c4ce34db117d2db8f710fe2a9420d5a upstream.

When using the "block:block_dirty_buffer" tracepoint, mark_buffer_dirty()
may cause a NULL pointer dereference, or a general protection fault when
KASAN is enabled.

This happens because, since the tracepoint was added in
mark_buffer_dirty(), it references the dev_t member bh->b_bdev->bd_dev
regardless of whether the buffer head has a pointer to a block_device
structure.

In the current implementation, nilfs_grab_buffer(), which grabs a buffer
to read (or create) a block of metadata, including b-tree node blocks,
does not set the block device, but instead does so only if the buffer is
not in the "uptodate" state for each of its caller block reading
functions.  However, if the uptodate flag is set on a folio/page, and the
buffer heads are detached from it by try_to_free_buffers(), and new buffer
heads are then attached by create_empty_buffers(), the uptodate flag may
be restored to each buffer without the block device being set to
bh->b_bdev, and mark_buffer_dirty() may be called later in that state,
resulting in the bug mentioned above.

Fix this issue by making nilfs_grab_buffer() always set the block device
of the super block structure to the buffer head, regardless of the state
of the buffer's uptodate flag.

Link: https://lkml.kernel.org/r/20241106160811.3316-3-konishi.ryusuke@gmail.com
Fixes: 5305cb830834 ("block: add block_{touch|dirty}_buffer tracepoint")
Signed-off-by: Ryusuke Konishi <konishi.ryusuke@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ubisectech Sirius <bugreport@valiantsec.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nilfs2/btnode.c  |    2 --
 fs/nilfs2/gcinode.c |    4 +---
 fs/nilfs2/mdt.c     |    1 -
 fs/nilfs2/page.c    |    1 +
 4 files changed, 2 insertions(+), 6 deletions(-)

--- a/fs/nilfs2/btnode.c
+++ b/fs/nilfs2/btnode.c
@@ -68,7 +68,6 @@ nilfs_btnode_create_block(struct address
 		goto failed;
 	}
 	memset(bh->b_data, 0, i_blocksize(inode));
-	bh->b_bdev = inode->i_sb->s_bdev;
 	bh->b_blocknr = blocknr;
 	set_buffer_mapped(bh);
 	set_buffer_uptodate(bh);
@@ -133,7 +132,6 @@ int nilfs_btnode_submit_block(struct add
 		goto found;
 	}
 	set_buffer_mapped(bh);
-	bh->b_bdev = inode->i_sb->s_bdev;
 	bh->b_blocknr = pblocknr; /* set block address for read */
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
--- a/fs/nilfs2/gcinode.c
+++ b/fs/nilfs2/gcinode.c
@@ -83,10 +83,8 @@ int nilfs_gccache_submit_read_data(struc
 		goto out;
 	}
 
-	if (!buffer_mapped(bh)) {
-		bh->b_bdev = inode->i_sb->s_bdev;
+	if (!buffer_mapped(bh))
 		set_buffer_mapped(bh);
-	}
 	bh->b_blocknr = pbn;
 	bh->b_end_io = end_buffer_read_sync;
 	get_bh(bh);
--- a/fs/nilfs2/mdt.c
+++ b/fs/nilfs2/mdt.c
@@ -89,7 +89,6 @@ static int nilfs_mdt_create_block(struct
 	if (buffer_uptodate(bh))
 		goto failed_bh;
 
-	bh->b_bdev = sb->s_bdev;
 	err = nilfs_mdt_insert_new_block(inode, block, bh, init_block);
 	if (likely(!err)) {
 		get_bh(bh);
--- a/fs/nilfs2/page.c
+++ b/fs/nilfs2/page.c
@@ -63,6 +63,7 @@ struct buffer_head *nilfs_grab_buffer(st
 		folio_put(folio);
 		return NULL;
 	}
+	bh->b_bdev = inode->i_sb->s_bdev;
 	return bh;
 }
 


