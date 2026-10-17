Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB6A3B7770;
	Sat, 17 Oct 2026 17:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258269; cv=none; b=WIP53IV373/znEzN+3k68kMKRMIrKMkvOt3CxyfKICebiuaejaOSTLKdPDL9+ee92ruutvmZh8j1TJeAEShCgxuzOygHzoWGG8ykD8FPAqASQAB0d6xfVKqyOcBjAVI+1YP89P9qGP6n1Kxkv6qFwg8grMHY+jkmGfHYWJyzQZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258269; c=relaxed/simple;
	bh=659oUN9lkIKHmLc2nx/7kt4vyB9MqpKptbBTmJ9OV8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Megh2TxRkL8H3rAwT8P93iULDCnzYM7NWpTXdStPYJJ+gTNwz7KvOKHyapRYNYYXUguwTq0iHY8oWfd5dtKi3MI88bEzyWab2sns23YZ61FfkYA4o8D8A8pBefyqKtG/fhP1BjMgQoCRvw2KnZC66j229GanNXOVXura9kc5RdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S4WopU28; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S4WopU28"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8ABD1F000C4;
	Sat, 17 Oct 2026 17:31:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258268;
	bh=E5EaHeqssAQ3SzwYpMh+FMhsn6zhAbj2UrZgnAOnOF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S4WopU28KLcMJB8NF3ik/u9j+LKYjCag6CAEs+ySvhlHU6M5vzMQBF7jL259nqkRr
	 x/Eg1M7CRK+OBNmCx5h35EwZXACyo3f41gNmp3gj9a8tykxkqzyO0Ailmu8Jrwyg7l
	 Ss8l2w6tAqOanqYkSw7xLGAZMWrcbAmqgnGVOJ4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Price <anprice@redhat.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0827/1674] gfs2: Prevent recursive memory reclaim
Date: Sat, 17 Oct 2026 17:51:39 +0200
Message-ID: <20261017160452.356086065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 fs/gfs2/inode.c | 15 +++++++++++++++
 fs/gfs2/inode.h |  1 +
 2 files changed, 16 insertions(+)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 18f75beea0890..4eb5716ad0284 100644
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
@@ -684,6 +698,7 @@ static int gfs2_create_inode(struct inode *dir, struct dentry *dentry,
 	error = -ENOMEM;
 	if (!inode)
 		goto fail_gunlock;
+	gfs2_setup_inode(inode);
 	ip = GFS2_I(inode);
 
 	error = posix_acl_create(dir, &mode, &default_acl, &acl);
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index ce70cf26b497d..6f7c9ec21bbfa 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -88,6 +88,7 @@ static inline int gfs2_check_internal_file_size(struct inode *inode,
 	return -EIO;
 }
 
+void gfs2_setup_inode(struct inode *inode);
 struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type,
 			        u64 no_addr, u64 no_formal_ino,
 			        unsigned int blktype);
-- 
2.53.0



