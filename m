Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766E311705;
	Sat,  3 Feb 2024 04:18:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933924; cv=none; b=OYAMSZXul428cst6UBPKruPyWB5MwSrlE7y7suuceZVm7D0NeeoqMjRGchs35VRYRbYGaWqaCLbq41BSxIQqxXWZIhwsGu71ZXWqErtsikhjRMrM9UIjqjpORpkKtMCCDhzomuksG3Ij9JeX+2GgBQvA5L3p/KKd6UwZq2iFxug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933924; c=relaxed/simple;
	bh=brJRFVkEndT2QClkYnvRuloQ44gxPqLw3bHbWY3oa54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYCRbbf8SZBDDbHB1uFUR+WlXf9NxNtzXp+BfIADyrx3JW85q9XBEUmApmmeUAsKq2/flyut034qMWvHj2XUotmCxIIwGhVOsIsqzZNL8PjeMNOfJanCVOWQ4gfI1VeamSgOpZL0cG53zZdHqOjBaFPfH1kYkz7/kWB3W6jL5nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzKYAyo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzKYAyo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F4B7C433C7;
	Sat,  3 Feb 2024 04:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933924;
	bh=brJRFVkEndT2QClkYnvRuloQ44gxPqLw3bHbWY3oa54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzKYAyo60oul/+9Z2/vG8SeIODFBbdvhQt0LdnWpR8/DcKFkoA7IgSikB+AZKlM6o
	 VEpY+Zr8v3HXzbwHuy1alKA1AxSOn4ZCvoB8Ie7J2T1n1KlMCP5GAkFZaq4LO0rsto
	 wDwy7wDY3HpMrBZ2zooggc4tcg+sprQuh3QBErOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenchao Hao <haowenchao2@huawei.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 280/353] ceph: fix invalid pointer access if get_quota_realm return ERR_PTR
Date: Fri,  2 Feb 2024 20:06:38 -0800
Message-ID: <20240203035412.629851993@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 9d36c3532de1..06ee397e0c3a 100644
--- a/fs/ceph/quota.c
+++ b/fs/ceph/quota.c
@@ -197,10 +197,10 @@ void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc)
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
@@ -211,10 +211,9 @@ void ceph_cleanup_quotarealms_inodes(struct ceph_mds_client *mdsc)
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
 	struct ceph_client *cl = mdsc->fsc->client;
 	struct ceph_inode_info *ci = NULL;
@@ -222,8 +221,10 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
 	struct inode *in;
 	bool has_quota;
 
+	if (realmp)
+		*realmp = NULL;
 	if (ceph_snap(inode) != CEPH_NOSNAP)
-		return NULL;
+		return 0;
 
 restart:
 	realm = ceph_inode(inode)->i_snap_realm;
@@ -250,7 +251,7 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
 				break;
 			ceph_put_snap_realm(mdsc, realm);
 			if (!retry)
-				return ERR_PTR(-EAGAIN);
+				return -EAGAIN;
 			goto restart;
 		}
 
@@ -259,8 +260,11 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
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
@@ -269,7 +273,7 @@ static struct ceph_snap_realm *get_quota_realm(struct ceph_mds_client *mdsc,
 	if (realm)
 		ceph_put_snap_realm(mdsc, realm);
 
-	return NULL;
+	return 0;
 }
 
 bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
@@ -277,6 +281,7 @@ bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
 	struct ceph_mds_client *mdsc = ceph_sb_to_mdsc(old->i_sb);
 	struct ceph_snap_realm *old_realm, *new_realm;
 	bool is_same;
+	int ret;
 
 restart:
 	/*
@@ -286,9 +291,9 @@ bool ceph_quota_is_same_realm(struct inode *old, struct inode *new)
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
@@ -492,8 +497,8 @@ bool ceph_quota_update_statfs(struct ceph_fs_client *fsc, struct kstatfs *buf)
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



