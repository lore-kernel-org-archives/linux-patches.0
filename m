Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F1E4F3EC1;
	Tue, 13 Oct 2026 11:53:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892396; cv=none; b=upm7iIcVLplltWQMyk7vN5YZFUlFUiHuOQ0vCO7CTTRP1xAbKRBIUIBhYymKnpha5VoMuEewy/AQIr0ociTLtUmz4/KvvqPPL0i8bhjaC/loS3h8QWhX527l0YUfP9bkEdWWi159CZjp36yYDswxJyRhJRcCvLiKDmlpZOlW2PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892396; c=relaxed/simple;
	bh=PW4WKZ4HfrFxiJ7/8g7xpN6cG9U4qFLPkt4c6Pt+c7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LG99h8ZB5G6qTMgVvcyq82eW+oqFyl0XjRxdd/OySDgAe7kWaZBAklp04Q2zodKIDaQYdMYc/kD1T7QjaWZ+TajC7W1BiOZVZ9ueR39l+/iLSPNFVe3TihIXyAv+tREZGMWgp1fZWF8i+tm0Sy+rrSz+pB3/Bl04qQPZS5uAK6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCoDHtfL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCoDHtfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA6521F000FF;
	Tue, 13 Oct 2026 11:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892395;
	bh=Gf1Zfg8cUs4yyFVAifXXmhaxWc2Ft/77u091RpsC4bE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rCoDHtfLC/Q1eNV/zHF38u349HwoUF6+BF+W7ZowPHTJ/MLPfUyxH0mNoJ4UFjOQj
	 OdjSE+jarUV5EACGmIqgKY49KikblUweIJNpkFJ+YInBsmvSO0Z710rD6w+Dl+pITQ
	 6wejMdaUNlMNsoFyRTa9xPV9dUgFjAVMeyGC4h2c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 158/281] namespace: keep covered mounts covered in OPEN_TREE_NAMESPACE
Date: Tue, 13 Oct 2026 13:37:54 +0200
Message-ID: <20261013112858.997799716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 0febe278ec45b1ccdbe9bd5ff1ba365d8fd55e2a upstream.

open_tree(OPEN_TREE_NAMESPACE) creates a new mount namespace from a
copy of the tree at the given path. The caller needs to be privileged
over its current user namespace because the new mount namespace will be
owned by it. It doesn't need to be privileged over the mount namespace
the tree is copied from. An unprivileged user just needs to create a
user namespace first.

The copy follows the rules of a detached bind mount. Without
AT_RECURSIVE only the mount itself is cloned and its children are left
out. With AT_RECURSIVE unbindable mounts are skipped. Both is fine when
the caller has privileges over the source mount namespace because it
could unmount those mounts anyway. Not so for an unprivileged user in
that mount namespace. For them a mount namespace copy is what unshare()
does. copy_mnt_ns() copies everything including unbindable mounts and
lock_mnt_tree() makes sure nothing can be unmounted in the copy. Nothing
that was covered gets revealed.

create_new_namespace() only does the locking and so the covered content
is right there in the new mount namespace:

  # mount -t tmpfs none /tmp/otn; mkdir /tmp/otn/covered
  # echo hidden > /tmp/otn/covered/under.txt
  # mount -t tmpfs none /tmp/otn/covered

  uid 1000, after unshare(CLONE_NEWUSER):
  fd = open_tree(AT_FDCWD, "/tmp/otn", OPEN_TREE_NAMESPACE);
  setns(fd, CLONE_NEWNS);
  open("/covered/under.txt", O_RDONLY)  -> "hidden"

Covering paths with mounts is how container runtimes mask parts of
/proc and /sys and how admins hide things.

When the caller's user namespace doesn't own the source mount namespace
copy the way unshare() does and refuse a non-recursive copy of a mount
that has anything mounted below the requested directory and copy
unbindable mounts in a recursive copy. A caller that is privileged over
the source mount namespace sees no change.

Fixes: 9b8a0ba68246 ("mount: add OPEN_TREE_NAMESPACE")
Cc: stable@vger.kernel.org # v7.0+
Link: https://patch.msgid.link/20260930-work-mount-fixes-3-v1-6-be34c83956ae@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |   30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2354,6 +2354,18 @@ bool has_locked_children(struct mount *m
 	return __has_locked_children(mnt, dentry);
 }
 
+/* locks: namespace_shared && pinned(mnt) || mount_locked_reader */
+static bool __has_children(struct mount *mnt, struct dentry *dentry)
+{
+	struct mount *child;
+
+	list_for_each_entry(child, &mnt->mnt_mounts, mnt_child) {
+		if (is_subdir(child->mnt_mountpoint, dentry))
+			return true;
+	}
+	return false;
+}
+
 /*
  * Check that there aren't references to earlier/same mount namespaces in the
  * specified subtree.  Such references can act as pins for mount namespaces
@@ -3123,12 +3135,18 @@ static struct mnt_namespace *create_new_
 	struct mount *mnt;
 	unsigned int copy_flags = 0;
 	bool locked = false, recurse = flags & MOUNT_COPY_RECURSIVE;
+	bool foreign = user_ns != ns->user_ns;
 
 	if (unlikely(!d_can_lookup(path->dentry)))
 		return ERR_PTR(-ENOTDIR);
 
-	if (user_ns != ns->user_ns)
-		copy_flags |= CL_SLAVE;
+	/*
+	 * Without privileges over the mount namespace the copy is made from
+	 * nothing mounted below @path may be left out. It would reveal what
+	 * it covers. That's what unshare() gives such a caller as well.
+	 */
+	if (foreign)
+		copy_flags |= CL_SLAVE | CL_COPY_UNBINDABLE;
 
 	new_ns = alloc_mnt_ns(user_ns, false);
 	if (IS_ERR(new_ns))
@@ -3162,10 +3180,14 @@ static struct mnt_namespace *create_new_
 	/*
 	 * We don't emulate unshare()ing a mount namespace. We stick to
 	 * the restrictions of creating detached bind-mounts. It has a
-	 * lot saner and simpler semantics.
+	 * lot saner and simpler semantics. A caller without privileges
+	 * over the mount namespace can't leave out any child though.
 	 */
 	if (flags & MOUNT_COPY_NEW)
 		mnt = clone_mnt(real_mount(path->mnt), path->dentry, copy_flags);
+	else if (foreign && !recurse &&
+		 __has_children(real_mount(path->mnt), path->dentry))
+		mnt = ERR_PTR(-EINVAL);
 	else
 		mnt = __do_loopback(path, recurse, copy_flags);
 	scoped_guard(mount_writer) {
@@ -3182,7 +3204,7 @@ static struct mnt_namespace *create_new_
 		 * of the real rootfs we created.
 		 */
 		attach_mnt(mnt, new_ns_root, mp.mp);
-		if (user_ns != ns->user_ns)
+		if (foreign)
 			lock_mnt_tree(new_ns_root);
 	}
 


