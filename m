Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8434F2DF3C9;
	Tue, 17 Jun 2025 15:41:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174883; cv=none; b=bIBFHfjSvzZbcuLBnzw3aGDba8/aeX6GC6Mpy+7Gc7xHAZEO03Z93q/B0DdJyryJsIieqcF7ooXRAbAizGkvGhVRoee09RWrRMoaJ600nDtQoIpMKzOqUvDMWTxGvaWrPhhWnIl2EKLK7g4R4buY23LbBx1LB7ATAe1KtrbYVMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174883; c=relaxed/simple;
	bh=UaUFw7WU6tDRDLVzLTaoDbuE+K2H7i38fB+c1mzeTsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TRpnb8Kzxd2woZJ/h/ymO0WAgoSO1kzLjLX0h0fwayL9nmM1ZmEZUfHgO3KGCUIASPWZNIWT6MZGsr7MJJaGQqK8K5cBi+ksC7JMYsDbOCkudhbhTyolCcfogvfS1YdDdvrfqDVZ0cHTMyZxtM11f3Mq3MvJ6bGeJW6zAcN/2WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4Qp5RM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4Qp5RM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F882C4CEE3;
	Tue, 17 Jun 2025 15:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174883;
	bh=UaUFw7WU6tDRDLVzLTaoDbuE+K2H7i38fB+c1mzeTsc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4Qp5RM3lAGyYjKMc9n9MNZoAjeRX1/x/xIFnJW+ZsqSZsL15QVByZLoBC4Zpo15T
	 h11yn20bX6PvVlvCuRKE9LAyrHblAKh8fCkowUtk2CmZ0kc6GJgEWbeix+ybXomLJf
	 WG5KWtGtmUqOgpE9AK+ycQq6rnxyam3NW8tQjyS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 015/780] gfs2: Move gfs2_dinode_dealloc
Date: Tue, 17 Jun 2025 17:15:23 +0200
Message-ID: <20250617152452.115567823@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit bcd18105fb34e27c097f222733dba9a3e79f191c ]

Move gfs2_dinode_dealloc() and its helper gfs2_final_release_pages()
from super.c to inode.c.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: 2c63986dd35f ("gfs2: deallocate inodes in gfs2_create_inode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c | 68 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/gfs2/inode.h |  1 +
 fs/gfs2/super.c | 68 -------------------------------------------------
 3 files changed, 69 insertions(+), 68 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 9621680814b80..b2d38d09af7e8 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -439,6 +439,74 @@ static int alloc_dinode(struct gfs2_inode *ip, u32 flags, unsigned *dblocks)
 	return error;
 }
 
+static void gfs2_final_release_pages(struct gfs2_inode *ip)
+{
+	struct inode *inode = &ip->i_inode;
+	struct gfs2_glock *gl = ip->i_gl;
+
+	if (unlikely(!gl)) {
+		/* This can only happen during incomplete inode creation. */
+		BUG_ON(!test_bit(GIF_ALLOC_FAILED, &ip->i_flags));
+		return;
+	}
+
+	truncate_inode_pages(gfs2_glock2aspace(gl), 0);
+	truncate_inode_pages(&inode->i_data, 0);
+
+	if (atomic_read(&gl->gl_revokes) == 0) {
+		clear_bit(GLF_LFLUSH, &gl->gl_flags);
+		clear_bit(GLF_DIRTY, &gl->gl_flags);
+	}
+}
+
+int gfs2_dinode_dealloc(struct gfs2_inode *ip)
+{
+	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
+	struct gfs2_rgrpd *rgd;
+	struct gfs2_holder gh;
+	int error;
+
+	if (gfs2_get_inode_blocks(&ip->i_inode) != 1) {
+		gfs2_consist_inode(ip);
+		return -EIO;
+	}
+
+	gfs2_rindex_update(sdp);
+
+	error = gfs2_quota_hold(ip, NO_UID_QUOTA_CHANGE, NO_GID_QUOTA_CHANGE);
+	if (error)
+		return error;
+
+	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr, 1);
+	if (!rgd) {
+		gfs2_consist_inode(ip);
+		error = -EIO;
+		goto out_qs;
+	}
+
+	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE,
+				   LM_FLAG_NODE_SCOPE, &gh);
+	if (error)
+		goto out_qs;
+
+	error = gfs2_trans_begin(sdp, RES_RG_BIT + RES_STATFS + RES_QUOTA,
+				 sdp->sd_jdesc->jd_blocks);
+	if (error)
+		goto out_rg_gunlock;
+
+	gfs2_free_di(rgd, ip);
+
+	gfs2_final_release_pages(ip);
+
+	gfs2_trans_end(sdp);
+
+out_rg_gunlock:
+	gfs2_glock_dq_uninit(&gh);
+out_qs:
+	gfs2_quota_unhold(ip);
+	return error;
+}
+
 static void gfs2_init_dir(struct buffer_head *dibh,
 			  const struct gfs2_inode *parent)
 {
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 9e5e1622d50a6..eafe123617e69 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -92,6 +92,7 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type,
 struct inode *gfs2_lookup_by_inum(struct gfs2_sbd *sdp, u64 no_addr,
 				  u64 no_formal_ino,
 				  unsigned int blktype);
+int gfs2_dinode_dealloc(struct gfs2_inode *ip);
 
 struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 			   int is_root);
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 4529b7dda8ca2..3f49f848c6b4e 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1173,74 +1173,6 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
 	return 0;
 }
 
-static void gfs2_final_release_pages(struct gfs2_inode *ip)
-{
-	struct inode *inode = &ip->i_inode;
-	struct gfs2_glock *gl = ip->i_gl;
-
-	if (unlikely(!gl)) {
-		/* This can only happen during incomplete inode creation. */
-		BUG_ON(!test_bit(GIF_ALLOC_FAILED, &ip->i_flags));
-		return;
-	}
-
-	truncate_inode_pages(gfs2_glock2aspace(gl), 0);
-	truncate_inode_pages(&inode->i_data, 0);
-
-	if (atomic_read(&gl->gl_revokes) == 0) {
-		clear_bit(GLF_LFLUSH, &gl->gl_flags);
-		clear_bit(GLF_DIRTY, &gl->gl_flags);
-	}
-}
-
-static int gfs2_dinode_dealloc(struct gfs2_inode *ip)
-{
-	struct gfs2_sbd *sdp = GFS2_SB(&ip->i_inode);
-	struct gfs2_rgrpd *rgd;
-	struct gfs2_holder gh;
-	int error;
-
-	if (gfs2_get_inode_blocks(&ip->i_inode) != 1) {
-		gfs2_consist_inode(ip);
-		return -EIO;
-	}
-
-	gfs2_rindex_update(sdp);
-
-	error = gfs2_quota_hold(ip, NO_UID_QUOTA_CHANGE, NO_GID_QUOTA_CHANGE);
-	if (error)
-		return error;
-
-	rgd = gfs2_blk2rgrpd(sdp, ip->i_no_addr, 1);
-	if (!rgd) {
-		gfs2_consist_inode(ip);
-		error = -EIO;
-		goto out_qs;
-	}
-
-	error = gfs2_glock_nq_init(rgd->rd_gl, LM_ST_EXCLUSIVE,
-				   LM_FLAG_NODE_SCOPE, &gh);
-	if (error)
-		goto out_qs;
-
-	error = gfs2_trans_begin(sdp, RES_RG_BIT + RES_STATFS + RES_QUOTA,
-				 sdp->sd_jdesc->jd_blocks);
-	if (error)
-		goto out_rg_gunlock;
-
-	gfs2_free_di(rgd, ip);
-
-	gfs2_final_release_pages(ip);
-
-	gfs2_trans_end(sdp);
-
-out_rg_gunlock:
-	gfs2_glock_dq_uninit(&gh);
-out_qs:
-	gfs2_quota_unhold(ip);
-	return error;
-}
-
 /**
  * gfs2_glock_put_eventually
  * @gl:	The glock to put
-- 
2.39.5



