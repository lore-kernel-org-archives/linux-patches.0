Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09E921A3BCF;
	Thu,  6 Jun 2024 14:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683244; cv=none; b=AqvKP6lf5YOKlbVDIuymdKNW+FalhbbmO/jgTDx3esJ85olL+OFQ/wp4+0O0IAv2sVd/qcIi2mATAjaRwJS+0eU9F2Iy90LbI/MEfUmF7SAlXMPn5WOvAKnbdVJOP4H09yuUXAfkFaD+jWB0kA59cT7d6n4Md8Jd5i7Kspz6Zjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683244; c=relaxed/simple;
	bh=0Rp8XTnqiUtByU3evNnNFj2y5QAFQrW6ZdnhpSG3PgA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M5ZDmIZjP1skPglBZnXdiaiYrqDBFe4rBr3UYH0eM6Y5yELVEpni64tdIoCQgKDtzEsvpB+sKLN1iq2nBzu+7Miz5XoslrLsbkXF3x6X1saNZQwsEQmHLZlZ/2rtlqR2djJBcYufdeKOzhRkgmNba9SjbWl8Ctul3lwpRXYyoLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UU4mzyDB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UU4mzyDB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB26C2BD10;
	Thu,  6 Jun 2024 14:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683243;
	bh=0Rp8XTnqiUtByU3evNnNFj2y5QAFQrW6ZdnhpSG3PgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UU4mzyDBRWqBWmLLsrTAyOG8QJ3obBXU1ftEW1PTmNAkwpvs9eNRIA98hvK1AUfp5
	 bb43RpSZ5ClfGwoH7xKpHXqWmqEBDHmze3adDGsOqN6sDH8ljAaNZyQUi1D/0G+ZhW
	 lt/ZFNRb33+yyDYt1d8wa5bGgaPdR9Rd5yO68a5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 188/744] gfs2: Rename gfs2_lookup_{ simple => meta }
Date: Thu,  6 Jun 2024 15:57:40 +0200
Message-ID: <20240606131738.461566092@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 062fb903895a035ed382a0d3f9b9d459b2718217 ]

Function gfs2_lookup_simple() is used for looking up inodes in the
metadata directory tree, so rename it to gfs2_lookup_meta() to closer
match its purpose.  Clean the function up a little on the way.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Stable-dep-of: d98779e68772 ("gfs2: Fix potential glock use-after-free on unmount")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/gfs2/inode.c      | 13 +++++++------
 fs/gfs2/inode.h      |  2 +-
 fs/gfs2/ops_fstype.c | 16 ++++++++--------
 3 files changed, 16 insertions(+), 15 deletions(-)

diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 587e5bf885c1b..3de0d8ab42eaf 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -265,17 +265,18 @@ struct inode *gfs2_lookup_by_inum(struct gfs2_sbd *sdp, u64 no_addr,
 }
 
 
-struct inode *gfs2_lookup_simple(struct inode *dip, const char *name)
+/**
+ * gfs2_lookup_meta - Look up an inode in a metadata directory
+ * @dip: The directory
+ * @name: The name of the inode
+ */
+struct inode *gfs2_lookup_meta(struct inode *dip, const char *name)
 {
 	struct qstr qstr;
 	struct inode *inode;
+
 	gfs2_str2qstr(&qstr, name);
 	inode = gfs2_lookupi(dip, &qstr, 1);
-	/* gfs2_lookupi has inconsistent callers: vfs
-	 * related routines expect NULL for no entry found,
-	 * gfs2_lookup_simple callers expect ENOENT
-	 * and do not check for NULL.
-	 */
 	if (IS_ERR_OR_NULL(inode))
 		return inode ? inode : ERR_PTR(-ENOENT);
 
diff --git a/fs/gfs2/inode.h b/fs/gfs2/inode.h
index 75e662949f04d..1b291b58d4d23 100644
--- a/fs/gfs2/inode.h
+++ b/fs/gfs2/inode.h
@@ -101,7 +101,7 @@ extern struct inode *gfs2_lookupi(struct inode *dir, const struct qstr *name,
 				  int is_root);
 extern int gfs2_permission(struct mnt_idmap *idmap,
 			   struct inode *inode, int mask);
-extern struct inode *gfs2_lookup_simple(struct inode *dip, const char *name);
+extern struct inode *gfs2_lookup_meta(struct inode *dip, const char *name);
 extern void gfs2_dinode_out(const struct gfs2_inode *ip, void *buf);
 extern int gfs2_open_common(struct inode *inode, struct file *file);
 extern loff_t gfs2_seek_data(struct file *file, loff_t offset);
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index dd64140ae6d7b..547e279f5f9e6 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -648,7 +648,7 @@ static int init_statfs(struct gfs2_sbd *sdp)
 	struct gfs2_jdesc *jd;
 	struct gfs2_inode *ip;
 
-	sdp->sd_statfs_inode = gfs2_lookup_simple(master, "statfs");
+	sdp->sd_statfs_inode = gfs2_lookup_meta(master, "statfs");
 	if (IS_ERR(sdp->sd_statfs_inode)) {
 		error = PTR_ERR(sdp->sd_statfs_inode);
 		fs_err(sdp, "can't read in statfs inode: %d\n", error);
@@ -657,7 +657,7 @@ static int init_statfs(struct gfs2_sbd *sdp)
 	if (sdp->sd_args.ar_spectator)
 		goto out;
 
-	pn = gfs2_lookup_simple(master, "per_node");
+	pn = gfs2_lookup_meta(master, "per_node");
 	if (IS_ERR(pn)) {
 		error = PTR_ERR(pn);
 		fs_err(sdp, "can't find per_node directory: %d\n", error);
@@ -674,7 +674,7 @@ static int init_statfs(struct gfs2_sbd *sdp)
 			goto free_local;
 		}
 		sprintf(buf, "statfs_change%u", jd->jd_jid);
-		lsi->si_sc_inode = gfs2_lookup_simple(pn, buf);
+		lsi->si_sc_inode = gfs2_lookup_meta(pn, buf);
 		if (IS_ERR(lsi->si_sc_inode)) {
 			error = PTR_ERR(lsi->si_sc_inode);
 			fs_err(sdp, "can't find local \"sc\" file#%u: %d\n",
@@ -739,7 +739,7 @@ static int init_journal(struct gfs2_sbd *sdp, int undo)
 	if (undo)
 		goto fail_statfs;
 
-	sdp->sd_jindex = gfs2_lookup_simple(master, "jindex");
+	sdp->sd_jindex = gfs2_lookup_meta(master, "jindex");
 	if (IS_ERR(sdp->sd_jindex)) {
 		fs_err(sdp, "can't lookup journal index: %d\n", error);
 		return PTR_ERR(sdp->sd_jindex);
@@ -888,7 +888,7 @@ static int init_inodes(struct gfs2_sbd *sdp, int undo)
 		goto fail;
 
 	/* Read in the resource index inode */
-	sdp->sd_rindex = gfs2_lookup_simple(master, "rindex");
+	sdp->sd_rindex = gfs2_lookup_meta(master, "rindex");
 	if (IS_ERR(sdp->sd_rindex)) {
 		error = PTR_ERR(sdp->sd_rindex);
 		fs_err(sdp, "can't get resource index inode: %d\n", error);
@@ -897,7 +897,7 @@ static int init_inodes(struct gfs2_sbd *sdp, int undo)
 	sdp->sd_rindex_uptodate = 0;
 
 	/* Read in the quota inode */
-	sdp->sd_quota_inode = gfs2_lookup_simple(master, "quota");
+	sdp->sd_quota_inode = gfs2_lookup_meta(master, "quota");
 	if (IS_ERR(sdp->sd_quota_inode)) {
 		error = PTR_ERR(sdp->sd_quota_inode);
 		fs_err(sdp, "can't get quota file inode: %d\n", error);
@@ -941,7 +941,7 @@ static int init_per_node(struct gfs2_sbd *sdp, int undo)
 	if (undo)
 		goto fail_qc_gh;
 
-	pn = gfs2_lookup_simple(master, "per_node");
+	pn = gfs2_lookup_meta(master, "per_node");
 	if (IS_ERR(pn)) {
 		error = PTR_ERR(pn);
 		fs_err(sdp, "can't find per_node directory: %d\n", error);
@@ -949,7 +949,7 @@ static int init_per_node(struct gfs2_sbd *sdp, int undo)
 	}
 
 	sprintf(buf, "quota_change%u", sdp->sd_jdesc->jd_jid);
-	sdp->sd_qc_inode = gfs2_lookup_simple(pn, buf);
+	sdp->sd_qc_inode = gfs2_lookup_meta(pn, buf);
 	if (IS_ERR(sdp->sd_qc_inode)) {
 		error = PTR_ERR(sdp->sd_qc_inode);
 		fs_err(sdp, "can't find local \"qc\" file: %d\n", error);
-- 
2.43.0



