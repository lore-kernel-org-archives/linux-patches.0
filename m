Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3B7319E7D7;
	Tue, 18 Jun 2024 13:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715988; cv=none; b=Y/jkGPz9Tiq3wb5GlbyGauQRrmglSfmHLa8CZcz33SN5gyZNrmlUxCe+xHODYDjfIWPMM76omINf3XWbCEqXrXEVN6G3TElvEHEMayk4BWiHStm21KudgtvFaV1z/Mb7F9mP+f7CLpw6rcKSMRkGYL1n64R4O7kivszG+kPLAMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715988; c=relaxed/simple;
	bh=jobrDX/kdlGlh/y8np5cy+cxjmqFbXmzElmTjjjeP/I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mlo5jz9Hrb1rOkiWUK/Wk0ZdQ/p7sawNSUVr0UqImimNBCajHXZ9SCAnUo+9vPqdKiCi64HstDF5GVOMiWBtp1UgjwD62nt85F+VvufLRQ3aRd3e/5vrztTNrqORa/bI5cskJhOWPbYvhiombhk/mgBHm6p5fWR9ElsqMgntKvk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpElRs41; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpElRs41"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C096C4AF49;
	Tue, 18 Jun 2024 13:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715988;
	bh=jobrDX/kdlGlh/y8np5cy+cxjmqFbXmzElmTjjjeP/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpElRs41u9KmrFNJvy0vhRqnah7IkNTYyyhR8LbOaX09CGzjDUbgRMK0QM+2+SWSq
	 6j9UJhhFax/ENpDM66h3D3yR/0bnIsIG3DrS1O8/fSGMizzx4NP5JcwVfoyyDDi6ii
	 2Hy0C7vqscOeMRHoBdmXNmWnFk7XpfaobvW7TKMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jan Kara <jack@suse.cz>,
	Amir Goldstein <amir73il@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 495/770] fsnotify: make allow_dups a property of the group
Date: Tue, 18 Jun 2024 14:35:48 +0200
Message-ID: <20240618123426.422481505@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

[ Upstream commit f3010343d9e119da35ee864b3a28993bb5c78ed7 ]

Instead of passing the allow_dups argument to fsnotify_add_mark()
as an argument, define the group flag FSNOTIFY_GROUP_DUPS to express
the allow_dups behavior and set this behavior at group creation time
for all calls of fsnotify_add_mark().

Rename the allow_dups argument to generic add_flags argument for future
use.

Link: https://lore.kernel.org/r/20220422120327.3459282-6-amir73il@gmail.com
Suggested-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/notify/mark.c                 | 12 ++++++------
 include/linux/fsnotify_backend.h | 13 +++++++------
 kernel/audit_fsnotify.c          |  4 ++--
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/fs/notify/mark.c b/fs/notify/mark.c
index c86982be2d505..1fb246ea61752 100644
--- a/fs/notify/mark.c
+++ b/fs/notify/mark.c
@@ -574,7 +574,7 @@ static struct fsnotify_mark_connector *fsnotify_grab_connector(
 static int fsnotify_add_mark_list(struct fsnotify_mark *mark,
 				  fsnotify_connp_t *connp,
 				  unsigned int obj_type,
-				  int allow_dups, __kernel_fsid_t *fsid)
+				  int add_flags, __kernel_fsid_t *fsid)
 {
 	struct fsnotify_mark *lmark, *last = NULL;
 	struct fsnotify_mark_connector *conn;
@@ -633,7 +633,7 @@ static int fsnotify_add_mark_list(struct fsnotify_mark *mark,
 
 		if ((lmark->group == mark->group) &&
 		    (lmark->flags & FSNOTIFY_MARK_FLAG_ATTACHED) &&
-		    !allow_dups) {
+		    !(mark->group->flags & FSNOTIFY_GROUP_DUPS)) {
 			err = -EEXIST;
 			goto out_err;
 		}
@@ -668,7 +668,7 @@ static int fsnotify_add_mark_list(struct fsnotify_mark *mark,
  */
 int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 			     fsnotify_connp_t *connp, unsigned int obj_type,
-			     int allow_dups, __kernel_fsid_t *fsid)
+			     int add_flags, __kernel_fsid_t *fsid)
 {
 	struct fsnotify_group *group = mark->group;
 	int ret = 0;
@@ -688,7 +688,7 @@ int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 	fsnotify_get_mark(mark); /* for g_list */
 	spin_unlock(&mark->lock);
 
-	ret = fsnotify_add_mark_list(mark, connp, obj_type, allow_dups, fsid);
+	ret = fsnotify_add_mark_list(mark, connp, obj_type, add_flags, fsid);
 	if (ret)
 		goto err;
 
@@ -708,14 +708,14 @@ int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 }
 
 int fsnotify_add_mark(struct fsnotify_mark *mark, fsnotify_connp_t *connp,
-		      unsigned int obj_type, int allow_dups,
+		      unsigned int obj_type, int add_flags,
 		      __kernel_fsid_t *fsid)
 {
 	int ret;
 	struct fsnotify_group *group = mark->group;
 
 	mutex_lock(&group->mark_mutex);
-	ret = fsnotify_add_mark_locked(mark, connp, obj_type, allow_dups, fsid);
+	ret = fsnotify_add_mark_locked(mark, connp, obj_type, add_flags, fsid);
 	mutex_unlock(&group->mark_mutex);
 	return ret;
 }
diff --git a/include/linux/fsnotify_backend.h b/include/linux/fsnotify_backend.h
index f0bf557af0091..dd440e6ff5285 100644
--- a/include/linux/fsnotify_backend.h
+++ b/include/linux/fsnotify_backend.h
@@ -211,6 +211,7 @@ struct fsnotify_group {
 	bool shutdown;		/* group is being shut down, don't queue more events */
 
 #define FSNOTIFY_GROUP_USER	0x01 /* user allocated group */
+#define FSNOTIFY_GROUP_DUPS	0x02 /* allow multiple marks per object */
 	int flags;
 
 	/* stores all fastpath marks assoc with this group so they can be cleaned on unregister */
@@ -641,26 +642,26 @@ extern int fsnotify_get_conn_fsid(const struct fsnotify_mark_connector *conn,
 /* attach the mark to the object */
 extern int fsnotify_add_mark(struct fsnotify_mark *mark,
 			     fsnotify_connp_t *connp, unsigned int obj_type,
-			     int allow_dups, __kernel_fsid_t *fsid);
+			     int add_flags, __kernel_fsid_t *fsid);
 extern int fsnotify_add_mark_locked(struct fsnotify_mark *mark,
 				    fsnotify_connp_t *connp,
-				    unsigned int obj_type, int allow_dups,
+				    unsigned int obj_type, int add_flags,
 				    __kernel_fsid_t *fsid);
 
 /* attach the mark to the inode */
 static inline int fsnotify_add_inode_mark(struct fsnotify_mark *mark,
 					  struct inode *inode,
-					  int allow_dups)
+					  int add_flags)
 {
 	return fsnotify_add_mark(mark, &inode->i_fsnotify_marks,
-				 FSNOTIFY_OBJ_TYPE_INODE, allow_dups, NULL);
+				 FSNOTIFY_OBJ_TYPE_INODE, add_flags, NULL);
 }
 static inline int fsnotify_add_inode_mark_locked(struct fsnotify_mark *mark,
 						 struct inode *inode,
-						 int allow_dups)
+						 int add_flags)
 {
 	return fsnotify_add_mark_locked(mark, &inode->i_fsnotify_marks,
-					FSNOTIFY_OBJ_TYPE_INODE, allow_dups,
+					FSNOTIFY_OBJ_TYPE_INODE, add_flags,
 					NULL);
 }
 
diff --git a/kernel/audit_fsnotify.c b/kernel/audit_fsnotify.c
index 31f43b1475404..691f90dd09d25 100644
--- a/kernel/audit_fsnotify.c
+++ b/kernel/audit_fsnotify.c
@@ -100,7 +100,7 @@ struct audit_fsnotify_mark *audit_alloc_mark(struct audit_krule *krule, char *pa
 	audit_update_mark(audit_mark, dentry->d_inode);
 	audit_mark->rule = krule;
 
-	ret = fsnotify_add_inode_mark(&audit_mark->mark, inode, true);
+	ret = fsnotify_add_inode_mark(&audit_mark->mark, inode, 0);
 	if (ret < 0) {
 		audit_mark->path = NULL;
 		fsnotify_put_mark(&audit_mark->mark);
@@ -183,7 +183,7 @@ static const struct fsnotify_ops audit_mark_fsnotify_ops = {
 static int __init audit_fsnotify_init(void)
 {
 	audit_fsnotify_group = fsnotify_alloc_group(&audit_mark_fsnotify_ops,
-						    0);
+						    FSNOTIFY_GROUP_DUPS);
 	if (IS_ERR(audit_fsnotify_group)) {
 		audit_fsnotify_group = NULL;
 		audit_panic("cannot create audit fsnotify group");
-- 
2.43.0



