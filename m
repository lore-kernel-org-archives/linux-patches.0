Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F392A28505E;
	Tue, 17 Jun 2025 16:51:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179103; cv=none; b=j0rrr/HPklh0+/RWGMZgPBL+xGcLqGL7PioVdzkJ0diE8qd0p+Lrgolcn/mrq9SnGNCMCm1FT/yEwsKQ09qrMLq0gOtSmjyvtGovz6PYkpo4JGAmTs31i5Ccag9/BWCA+c74bwVIW4vuxcNoIkpLxcK1ak7FndY1esmpNa3YMkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179103; c=relaxed/simple;
	bh=96oCCOnnanvtIN60l39iqSt0gZ3QXoLO1BHNmFVE/7o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f+a7yGQ3/cPqUcVdTXhxGgQRUzDXf/mpCtpdqWeNXM/ZbGsBt/wWfRIX/cfecjlkqFgFPTiia8s6hDzi530NcqmAokcPRil9PxMKDoB4Pi0g3nhiGAv7PJZ9VH7FZ1RgJWYHgh83TvJsXrAWApeu1S1e82/jVZoPiZkVNivcfG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qnqXMFbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qnqXMFbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B18C4CEF0;
	Tue, 17 Jun 2025 16:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179102;
	bh=96oCCOnnanvtIN60l39iqSt0gZ3QXoLO1BHNmFVE/7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnqXMFbbd/VaTdTZuBwJvQTwfMiGApvW+vvRjLg6AUsw5QkwhLIBPiouNjJQfXEsx
	 fjeIbUgwmO0RLSCXtJJRrjRj/maaB0NKaSrxQF+GizFT0jW5cpy32Ne4HTRXf42g4U
	 /6S5cphbDQURCYFzWtnaa3YOslXpcMmkn4Suq8hE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jeff Layton <jlayton@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 649/780] fs/fhandle.c: fix a race in call of has_locked_children()
Date: Tue, 17 Jun 2025 17:25:57 +0200
Message-ID: <20250617152517.909257386@linuxfoundation.org>
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

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 1f282cdc1d219c4a557f7009e81bc792820d9d9a ]

may_decode_fh() is calling has_locked_children() while holding no locks.
That's an oopsable race...

The rest of the callers are safe since they are holding namespace_sem and
are guaranteed a positive refcount on the mount in question.

Rename the current has_locked_children() to __has_locked_children(), make
it static and switch the fs/namespace.c users to it.

Make has_locked_children() a wrapper for __has_locked_children(), calling
the latter under read_seqlock_excl(&mount_lock).

Reviewed-by: Christian Brauner <brauner@kernel.org>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Fixes: 620c266f3949 ("fhandle: relax open_by_handle_at() permission checks")
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1b466c54a357d..216807f772cd2 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2424,7 +2424,7 @@ void drop_collected_mounts(struct vfsmount *mnt)
 	namespace_unlock();
 }
 
-bool has_locked_children(struct mount *mnt, struct dentry *dentry)
+static bool __has_locked_children(struct mount *mnt, struct dentry *dentry)
 {
 	struct mount *child;
 
@@ -2438,6 +2438,16 @@ bool has_locked_children(struct mount *mnt, struct dentry *dentry)
 	return false;
 }
 
+bool has_locked_children(struct mount *mnt, struct dentry *dentry)
+{
+	bool res;
+
+	read_seqlock_excl(&mount_lock);
+	res = __has_locked_children(mnt, dentry);
+	read_sequnlock_excl(&mount_lock);
+	return res;
+}
+
 /*
  * Check that there aren't references to earlier/same mount namespaces in the
  * specified subtree.  Such references can act as pins for mount namespaces
@@ -2498,7 +2508,7 @@ struct vfsmount *clone_private_mount(const struct path *path)
 			return ERR_PTR(-EINVAL);
 	}
 
-	if (has_locked_children(old_mnt, path->dentry))
+	if (__has_locked_children(old_mnt, path->dentry))
 		return ERR_PTR(-EINVAL);
 
 	new_mnt = clone_mnt(old_mnt, path->dentry, CL_PRIVATE);
@@ -3035,7 +3045,7 @@ static struct mount *__do_loopback(struct path *old_path, int recurse)
 	if (!may_copy_tree(old_path))
 		return mnt;
 
-	if (!recurse && has_locked_children(old, old_path->dentry))
+	if (!recurse && __has_locked_children(old, old_path->dentry))
 		return mnt;
 
 	if (recurse)
@@ -3428,7 +3438,7 @@ static int do_set_group(struct path *from_path, struct path *to_path)
 		goto out;
 
 	/* From mount should not have locked children in place of To's root */
-	if (has_locked_children(from, to->mnt.mnt_root))
+	if (__has_locked_children(from, to->mnt.mnt_root))
 		goto out;
 
 	/* Setting sharing groups is only allowed on private mounts */
-- 
2.39.5



