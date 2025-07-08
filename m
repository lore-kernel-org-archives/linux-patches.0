Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1BB92E542C;
	Tue,  8 Jul 2025 16:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992866; cv=none; b=M2mePswtO6+CsSFolRqu7A6oDlfP3HEqkjBU0Tlh5YLt6JwFivYyltGJN4PRxoEq7wY37myzcfvwrR7jZawZ3Nw/XLSPmfoJlvJ/Zlt7y5m+S8t40lbiRcVtCy6cPTAAwV8zIw3OImmEaDKml17KXz1S/R5LrG9XRjq+b+q4Tvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992866; c=relaxed/simple;
	bh=W4MXJ4H6qwkrDc04AaZrD5KYURjIqe1HlycvQvs/0Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pBQG652/3YVOsYlIO9TjWqXPXBPxinPd38uq7D7Yd5XJCUag2PCKJ2f+9vqXwsz9TDc4ViroRG9GBvbqY4spxhF1Ued96mzaK3Gvax0+lElVZCPVII//q6KOMIrHhDsLg7nHk4K3ylxy6LBMCXTf/CpRXUSW0g3Vucli5goF7VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LSjNRd8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LSjNRd8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736ACC4CEF5;
	Tue,  8 Jul 2025 16:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992865;
	bh=W4MXJ4H6qwkrDc04AaZrD5KYURjIqe1HlycvQvs/0Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LSjNRd8dYO2Pv68CFoya0cTo6Z+sGsoR0IL9wLfMfCIJ3Wtr0S2b7o/k9VamhRI4k
	 GnfpTgy4h2utZkm4gLONTkMNhVyi4WCTnjbYMqGbEJ8XzJgbTBa+zUbFbYpajoqbP9
	 +zRarIYBpN2+2/ivoOXTc2COgpK3MmujwKJwaJ3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 108/232] gfs2: Move gfs2_dinode_dealloc
Date: Tue,  8 Jul 2025 18:21:44 +0200
Message-ID: <20250708162244.266242050@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2d2f7646440f5..e59fde1bae7b7 100644
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
index fd15d1c6b6fb1..225b9d0038cd0 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -92,6 +92,7 @@ struct inode *gfs2_inode_lookup(struct super_block *sb, unsigned type,
 struct inode *gfs2_lookup_by_inum(struct gfs2_sbd *sdp, u64 no_addr,
 				  u64 no_formal_ino,
 				  unsigned int blktype);
+int gfs2_dinode_dealloc(struct gfs2_inode *ip);
 
 int gfs2_inode_refresh(struct gfs2_inode *ip);
 
diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index d982db129b2b4..aad6d5d2816e3 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -1175,74 +1175,6 @@ static int gfs2_show_options(struct seq_file *s, struct dentry *root)
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



