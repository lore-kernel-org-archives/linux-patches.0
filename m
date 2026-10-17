Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4891F3B2FCA;
	Sat, 17 Oct 2026 17:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259007; cv=none; b=Z4n1KukqjMEIekAeNQ3VazmGZaGtet5UDS6ArR0VuEWcVvwMTbHdmExlt5u7f1qOFmpWO8RFd0fWSlEaKn+NJRgm8csDrT1sHznFXcbGHKjoBhXDh8izFRJX4MEkZT9hk5QmItncwaDJjAjpUPXPsKZAhxDftLKwmQIUXvAxP3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259007; c=relaxed/simple;
	bh=w+edmrfKiapngus5OQMEDBWaWYYtU5roZs/zHv8vyyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rzUXK4Qc0WFrWOo/hiIrgnEAobDB/8NJBDrU2pgWk+dAVFEGFCzK7op2pLFZzmYAGw3efo+NKOSSv7k7kmq54vI1FALWdR5BzFt37hT4c9AlDB5PPtvAbKSNJaR1dnnMnUwbGPOqNAFCbjf5zPl8IHGF9HCnnLHuoqNEuJ4Idis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fwSBARmK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fwSBARmK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5EEC1F000C4;
	Sat, 17 Oct 2026 17:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259006;
	bh=AuDNRerr0WflxbYSwGKd5oAdCUAj5u3JYJMLnQB9l5g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fwSBARmKX4WbGQHF0UD7mXF/bBYU4IOF0UvBecKF9+/Wp/an+CnKAD7IpQf0X+GdV
	 e7az95uDjSjBkNjyI17ujhjKySnZr0eKgthhJuUJm5oH4Oapt3N5t/BJFCPNENq/IM
	 nnJixXXl+QRMsIvLcsNuCh3xSAD6v9jZHLdIl16k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jori Koolstra <jkoolstra@xs4all.nl>,
	Amir Goldstein <amir73il@gmail.com>,
	NeilBrown <neil@brown.name>,
	Namjae Jeon <linkinjeon@kernel.org>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1072/1674] vfs: make LAST_XXX private to fs/namei.c
Date: Sat, 17 Oct 2026 17:55:44 +0200
Message-ID: <20261017160458.635518434@linuxfoundation.org>
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

From: Jori Koolstra <jkoolstra@xs4all.nl>

[ Upstream commit f2f1dddccae50f7a1d088285c53c376e26cedf67 ]

The only user of LAST_XXX outside of fs/namei.c is fs/smb/server/vfs.c;
ksmbd_vfs_path_lookup() calls vfs_path_parent_lookup() and expects a
LAST_NORM last type (or it will be ENOENT). ksmbd_vfs_rename() also calls
vfs_path_parent_lookup() but forgets the LAST_NORM check.

It does not really make sense to have vfs_path_parent_lookup() expose
the last_type because it is only needed to ensure it is LAST_NORM. So
let's do this check in vfs_path_parent_lookup() instead and keep the
LAST_XXX internal to fs/namei.c. This changes the ENOENT errno in
ksmbd_vfs_path_lookup() to EINVAL, which matches better with how this is
handled by callers of filename_parentat().

Signed-off-by: Jori Koolstra <jkoolstra@xs4all.nl>
Link: https://patch.msgid.link/20260528175854.57626-1-jkoolstra@xs4all.nl
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: NeilBrown <neil@brown.name>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Stable-dep-of: 1c8951963d8e ("ksmbd: fix path resolution in ksmbd_vfs_kern_path_create")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namei.c            | 20 ++++++++++++++++----
 fs/smb/server/vfs.c   | 14 +++-----------
 include/linux/namei.h |  7 +------
 3 files changed, 20 insertions(+), 21 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 4d54a19dd3f60..fab0274219d19 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -126,6 +126,11 @@
 
 #define EMBEDDED_NAME_MAX	(PATH_MAX - offsetof(struct filename, iname))
 
+/*
+ * Type of the last component on LOOKUP_PARENT
+ */
+enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
+
 struct filename *
 getname_flags(const char __user *filename, int flags, int *empty)
 {
@@ -2701,15 +2706,22 @@ EXPORT_SYMBOL(kern_path);
  * @flags: lookup flags
  * @parent: pointer to struct path to fill
  * @last: last component
- * @type: type of the last component
  * @root: pointer to struct path of the base directory
  */
 int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
-			   struct path *parent, struct qstr *last, int *type,
+			   struct path *parent, struct qstr *last,
 			   const struct path *root)
 {
-	return  __filename_parentat(AT_FDCWD, filename, flags, parent, last,
-				    type, root);
+	int type;
+	int err =  __filename_parentat(AT_FDCWD, filename, flags, parent, last,
+				       &type, root);
+	if (err)
+		return err;
+	if (unlikely(type != LAST_NORM)) {
+		path_put(parent);
+		return -EINVAL;
+	}
+	return 0;
 }
 EXPORT_SYMBOL(vfs_path_parent_lookup);
 
diff --git a/fs/smb/server/vfs.c b/fs/smb/server/vfs.c
index fc49bb9aa8261..642323a6aff6f 100644
--- a/fs/smb/server/vfs.c
+++ b/fs/smb/server/vfs.c
@@ -73,7 +73,7 @@ static int ksmbd_vfs_path_lookup_locked(struct ksmbd_share_config *share_conf,
 	struct qstr last;
 	struct filename *filename;
 	struct path *root_share_path = &share_conf->vfs_path;
-	int err, type;
+	int err;
 	struct dentry *d;
 
 	if (pathname[0] == '\0') {
@@ -88,19 +88,13 @@ static int ksmbd_vfs_path_lookup_locked(struct ksmbd_share_config *share_conf,
 		return PTR_ERR(filename);
 
 	err = vfs_path_parent_lookup(filename, flags,
-				     parent_path, &last, &type,
+				     parent_path, &last,
 				     root_share_path);
 	if (err) {
 		putname(filename);
 		return err;
 	}
 
-	if (unlikely(type != LAST_NORM)) {
-		path_put(parent_path);
-		putname(filename);
-		return -ENOENT;
-	}
-
 	err = mnt_want_write(parent_path->mnt);
 	if (err) {
 		path_put(parent_path);
@@ -705,7 +699,6 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 	struct filename *to;
 	struct ksmbd_share_config *share_conf = work->tcon->share_conf;
 	struct ksmbd_file *parent_fp;
-	int new_type;
 	int err, lookup_flags = LOOKUP_NO_SYMLINKS;
 
 	if (ksmbd_override_fsids(work))
@@ -715,8 +708,7 @@ int ksmbd_vfs_rename(struct ksmbd_work *work, const struct path *old_path,
 
 retry:
 	err = vfs_path_parent_lookup(to, lookup_flags | LOOKUP_BENEATH,
-				     &new_path, &new_last, &new_type,
-				     &share_conf->vfs_path);
+				     &new_path, &new_last, &share_conf->vfs_path);
 	if (err)
 		goto out1;
 
diff --git a/include/linux/namei.h b/include/linux/namei.h
index c1ff032607dd6..e95663f1e0481 100644
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -12,11 +12,6 @@ enum { MAX_NESTED_LINKS = 8 };
 
 #define MAXSYMLINKS 40
 
-/*
- * Type of the last component on LOOKUP_PARENT
- */
-enum {LAST_NORM, LAST_ROOT, LAST_DOT, LAST_DOTDOT};
-
 /* pathwalk mode */
 #define LOOKUP_FOLLOW		0x0001	/* follow links at the end */
 #define LOOKUP_DIRECTORY	0x0002	/* require a directory */
@@ -68,7 +63,7 @@ extern struct dentry *user_path_create(int, const char __user *, struct path *,
 extern void done_path_create(struct path *, struct dentry *);
 extern struct dentry *kern_path_locked(const char *, struct path *);
 int vfs_path_parent_lookup(struct filename *filename, unsigned int flags,
-			   struct path *parent, struct qstr *last, int *type,
+			   struct path *parent, struct qstr *last,
 			   const struct path *root);
 int vfs_path_lookup(struct dentry *, struct vfsmount *, const char *,
 		    unsigned int, struct path *);
-- 
2.53.0



