Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC5939FD9;
	Tue, 16 Dec 2025 11:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884578; cv=none; b=XBdbnDklZeaLK1Ihp0n7domGXSI2W4/FiH1nPi1+crFteIQt1Kb1NyqtY5Ze5ZqUseU9F2qfM/h2lonOeNVEZnj4ATUfNUIjfa7M91ETzJmylYkSfiyGgtUxhzdYWszmZ1HwyWq9Lz3QdQVtHRBzwRPIQ4b5x15QRQztTPsqeE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884578; c=relaxed/simple;
	bh=ck24+z6apC/1UVYKTnQr7F+LkcGcrA/4uGDhKhSAIKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TMmea1pLh5Dw+IusvNBl7aaiGb0hdjVcyQllrqQZcNb7j8aeZ8BPtfXrN1MsVqKZpCZt0aI+fTqkxK+kMlEfdrPzF1BbHyxnhEjUhvMhkyrPopb0P/fIceN8Pp3+/bPKwGAqtGvYUMRY6wjb+kLIq0LPRziy4j12hch1aqLucE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPAfKtcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPAfKtcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A7F9C4CEF1;
	Tue, 16 Dec 2025 11:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884578;
	bh=ck24+z6apC/1UVYKTnQr7F+LkcGcrA/4uGDhKhSAIKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FPAfKtcfgLIHWM28IuVWSqSfCgtD6pZSdXpzdxRYOnnwytLyQmo7gC/b5GLG91klW
	 I3/mlFV5Rrrins110Tu5xh8i01GLM2sUSObUaO5cRStrVR1iPep8Y5u8mScSC0v+MS
	 JbMFnHWzTTSd4/gvcckpl1dYzs2eHRmIM0DeLcdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/354] gfs2: Prevent recursive memory reclaim
Date: Tue, 16 Dec 2025 12:13:23 +0100
Message-ID: <20251216111329.465881478@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 2c5f4a53476e3cab70adc77b38942c066bd2c17c ]

Function new_inode() returns a new inode with inode->i_mapping->gfp_mask
set to GFP_HIGHUSER_MOVABLE.  This value includes the __GFP_FS flag, so
allocations in that address space can recurse into filesystem memory
reclaim.  We don't want that to happen because it can consume a
significant amount of stack memory.

Worse than that is that it can also deadlock: for example, in several
places, gfs2_unstuff_dinode() is called inside filesystem transactions.
This calls filemap_grab_folio(), which can allocate a new folio, which
can trigger memory reclaim.  If memory reclaim recurses into the
filesystem and starts another transaction, a deadlock will ensue.

To fix these kinds of problems, prevent memory reclaim from recursing
into filesystem code by making sure that the gfp_mask of inode address
spaces doesn't include __GFP_FS.

The "meta" and resource group address spaces were already using GFP_NOFS
as their gfp_mask (which doesn't include __GFP_FS).  The default value
of GFP_HIGHUSER_MOVABLE is less restrictive than GFP_NOFS, though.  To
avoid being overly limiting, use the default value and only knock off
the __GFP_FS flag.  I'm not sure if this will actually make a
difference, but it also shouldn't hurt.

This patch is loosely based on commit ad22c7a043c2 ("xfs: prevent stack
overflows from page cache allocation").

Fixes xfstest generic/273.

Fixes: dc0b9435238c ("gfs: Don't use GFP_NOFS in gfs2_unstuff_dinode")
Reviewed-by: Andrew Price <anprice@redhat.com>
Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/glock.c      |  5 ++++-
 fs/gfs2/inode.c      | 15 +++++++++++++++
 fs/gfs2/inode.h      |  1 +
 fs/gfs2/ops_fstype.c |  2 +-
 4 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index e5558e63e2cba..54d0eee24e10b 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1250,10 +1250,13 @@ int gfs2_glock_get(struct gfs2_sbd *sdp, u64 number,
 
 	mapping = gfs2_glock2aspace(gl);
 	if (mapping) {
+		gfp_t gfp_mask;
+
                 mapping->a_ops = &gfs2_meta_aops;
 		mapping->host = sdp->sd_inode;
 		mapping->flags = 0;
-		mapping_set_gfp_mask(mapping, GFP_NOFS);
+		gfp_mask = mapping_gfp_mask(sdp->sd_inode->i_mapping);
+		mapping_set_gfp_mask(mapping, gfp_mask);
 		mapping->i_private_data = NULL;
 		mapping->writeback_index = 0;
 	}
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 0b546024f5ef7..90c7a795112d6 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -89,6 +89,19 @@ static int iget_set(struct inode *inode, void *opaque)
 	return 0;
 }
 
+void gfs2_setup_inode(struct inode *inode)
+{
+	gfp_t gfp_mask;
+
+	/*
+	 * Ensure all page cache allocations are done from GFP_NOFS context to
+	 * prevent direct reclaim recursion back into the filesystem and blowing
+	 * stacks or deadlocking.
+	 */
+	gfp_mask = mapping_gfp_mask(inode->i_mapping);
+	mapping_set_gfp_mask(inode->i_mapping, gfp_mask & ~__GFP_FS);
+}
+
 /**
  * gfs2_inode_lookup - Lookup an inode
  * @sb: The super block
@@ -132,6 +145,7 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned int type,
 		struct gfs2_glock *io_gl;
 		int extra_flags = 0;
 
+		gfs2_setup_inode(inode);
 		error = gfs2_glock_get(sdp, no_addr, &gfs2_inode_glops, CREATE,
 				       &ip->i_gl);
 		if (unlikely(error))
@@ -754,6 +768,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	error = -ENOMEM;
 	if (!inode)
 		goto fail_gunlock;
+	gfs2_setup_inode(inode);
 	ip = GFS2_I(inode);
 
 	error = posix_acl_create(dir, &mode, &default_acl, &acl);
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 225b9d0038cd0..136b231a17f8d 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -86,6 +86,7 @@ static inline int gfs2_check_internal_file_size(struct inode *inode,
 	return -EIO;
 }
 
+void gfs2_setup_inode(struct inode *inode);
 struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type,
 			        u64 no_addr, u64 no_formal_ino,
 			        unsigned int blktype);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 4a0f7de41b2b2..4c6d1f15a6a84 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -1185,7 +1185,7 @@ static int gfs2_fill_super(struct super_block *sb, struct fs_context *fc)
 
 	mapping = gfs2_aspace(sdp);
 	mapping->a_ops = &gfs2_rgrp_aops;
-	mapping_set_gfp_mask(mapping, GFP_NOFS);
+	gfs2_setup_inode(sdp->sd_inode);
 
 	error = init_names(sdp, silent);
 	if (error)
-- 
2.51.0



