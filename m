Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F3A18659;
	Sat,  3 Feb 2024 04:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933664; cv=none; b=emlNnmfc1Y7o/2eF+VSV1yS2CBaYANCcJ+jM3HZuPYHxZ2gKd1tTEzuy7lJkgWLvXbx3/fEWHTGlci12itOlq3B4G5yduBqoi870zL3/mZelMdRxWU1huSii84lcQEIon6EXfYBPFhrG4Jd4CI+JBM3RU0/TWQiKAUDPO5mBCFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933664; c=relaxed/simple;
	bh=yg62KWeRPOe6b/v3cbPaDIQK4pu4fop+p6Gx9KWhaNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fC2tIiFztJB8PSS9uZ3P/UxvKDDNDyfXWBd+wBJB7wXu1Tq4wrTBLjYd5RwDXqUf6Q5HEDJD/MFjcE1OhhVQDASe7ennjmZi5QCF+ElXYciGh3lvhpTDrfnRKCf3q/hnT80nb6lq1+oYCFI8nJxkqraDqUGL3s8o1sZhsUB3ndI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xaxlsBnb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xaxlsBnb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDAF3C433F1;
	Sat,  3 Feb 2024 04:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933664;
	bh=yg62KWeRPOe6b/v3cbPaDIQK4pu4fop+p6Gx9KWhaNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xaxlsBnb6xllSlYxRaWiNwGX1renQajyGNDDt/MLUE/J29zkRr0h1mTlqWFBiqZ+S
	 8mqP3cvn5w4/ByyiMFZYG7woNJZHFxE3hHlxgboMaD9vLNAFOhJp10iwx9brMTI88Z
	 wtSkgekRDDnnr6xA5L3FDurtivFqUzwf6SEm9FzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenchao Hao <haowenchao2@huawei.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 252/322] ceph: fix invalid pointer access if get_quota_realm return ERR_PTR
Date: Fri,  2 Feb 2024 20:05:49 -0800
Message-ID: <20240203035407.304116735@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
References: <20240203035359.041730947@linuxfoundation.org>
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

From: Wenchao Hao <haowenchao2@huawei.com>

[ Upstream commit 0f4cf64eabc6e16cfc2704f1960e82dc79d91c8d ]

This issue is reported by smatch that get_quota_realm() might return
ERR_PTR but we did not handle it. It's not a immediate bug, while we
still should address it to avoid potential bugs if get_quota_realm()
is changed to return other ERR_PTR in future.

Set ceph_snap_realm's pointer in get_quota_realm()'s to address this
issue, the pointer would be set to NULL if get_quota_realm() failed
to get struct ceph_snap_realm, so no ERR_PTR would happen any more.

[ xiubli: minor code style clean up ]

Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/quota.c | 39 ++++++++++++++++++++++-----------------
 1 file changed, 22 insertions(+), 17 deletions(-)

diff --git a/fs/ceph/quota.c b/fs/ceph/quota.c
index f7fcf7f08ec6..ca4932e6f71b 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -194,10 +194,10 @@ void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc)
 }
 
 /*
- * This function walks through the snaprealm for an inode and returns the
- * ceph_snap_realm for the first snaprealm that has quotas set (max_files,
+ * This function walks through the snaprealm for an inode and set the
+ * realmp with the first snaprealm that has quotas set (max_files,
  * max_bytes, or any, depending on the 'which_quota' argument).  If the root is
- * reached, return the root ceph_snap_realm instead.
+ * reached, set the realmp with the root ceph_snap_realm instead.
  *
  * Note that the caller is responsible for calling ceph_put_snap_realm() on the
  * returned realm.
@@ -208,18 +208,19 @@ void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc)
  * this function will return -EAGAIN; otherwise, the snaprealms walk-through
  * will be restarted.
  */
-static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
-					       struct inode *inode,
-					       enum quota_get_realm which_quota,
-					       bool retry)
+static int get_quota_realm(struct ceph_mds_client *mdsc, struct inode *inode,
+			   enum quota_get_realm which_quota,
+			   struct ceph_snap_realm **realmp, bool retry)
 {
 	struct ceph_inode_info *ci = NULL;
 	struct ceph_snap_realm *realm, *next;
 	struct inode *in;
 	bool has_quota;
 
+	if (realmp)
+		*realmp = NULL;
 	if (ceph_snap(inode) != CEPH_NOSNAP)
-		return NULL;
+		return 0;
 
 restart:
 	realm = ceph_inode(inode)->i_snap_realm;
@@ -245,7 +246,7 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
 				break;
 			ceph_put_snap_realm(mdsc, realm);
 			if (!retry)
-				return ERR_PTR(-EAGAIN);
+				return -EAGAIN;
 			goto restart;
 		}
 
@@ -254,8 +255,11 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
 		iput(in);
 
 		next = realm->parent;
-		if (has_quota || !next)
-		       return realm;
+		if (has_quota || !next) {
+			if (realmp)
+				*realmp = realm;
+			return 0;
+		}
 
 		ceph_get_snap_realm(mdsc, next);
 		ceph_put_snap_realm(mdsc, realm);
@@ -264,7 +268,7 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
 	if (realm)
 		ceph_put_snap_realm(mdsc, realm);
 
-	return NULL;
+	return 0;
 }
 
 bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
@@ -272,6 +276,7 @@ bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(old->i_sb);
 	struct ceph_snap_realm *old_realm, *new_realm;
 	bool is_same;
+	int ret;
 
 restart:
 	/*
@@ -281,9 +286,9 @@ bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
 	 * dropped and we can then restart the whole operation.
 	 */
 	down_read(&mdsc->snap_rwsem);
-	old_realm = get_quota_realm(mdsc, old, QUOTA_GET_ANY, true);
-	new_realm = get_quota_realm(mdsc, new, QUOTA_GET_ANY, false);
-	if (PTR_ERR(new_realm) == -EAGAIN) {
+	get_quota_realm(mdsc, old, QUOTA_GET_ANY, &old_realm, true);
+	ret = get_quota_realm(mdsc, new, QUOTA_GET_ANY, &new_realm, false);
+	if (ret == -EAGAIN) {
 		up_read(&mdsc->snap_rwsem);
 		if (old_realm)
 			ceph_put_snap_realm(mdsc, old_realm);
@@ -485,8 +490,8 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
 	bool is_updated = false;
 
 	down_read(&mdsc->snap_rwsem);
-	realm = get_quota_realm(mdsc, d_inode(fsc->sb->s_root),
-				QUOTA_GET_MAX_BYTES, true);
+	get_quota_realm(mdsc, d_inode(fsc->sb->s_root), QUOTA_GET_MAX_BYTES,
+			&realm, true);
 	up_read(&mdsc->snap_rwsem);
 	if (!realm)
 		return false;
-- 
2.43.0



