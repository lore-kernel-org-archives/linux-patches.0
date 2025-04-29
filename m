Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22D2A19F424;
	Tue, 29 Apr 2025 18:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950321; cv=none; b=hXCoqk+PNa+qYoyvshIuT3bF7qZmFr0aSO5blftwq2ZFuvNIPp3NrKqbmbgdTng7qsjr8LNaC565mVjzdRB8ToVD+j3eHSa6Fu5YLF2AK9sFx2WNHUfp2Ff4GlkJWNkStIZizCqfLO3+9EDBIyoooVDy8ybtk7KwXpg0vn83pjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950321; c=relaxed/simple;
	bh=vzCAPXk0AYGhrB/qwXw3Wow+BHGSxFoOVEyMkClqUg8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMDqu1Pv9Fvk7tw0KoBRkDGgqIfRQYgRevEify8bo2cwvhwUAcbd00Z0mOxP3mxKQSBxiv0sQFu7690C+B4CJ7Q6VKECC779ecu6Gs+Oh9xsTunumDh06vNjNEaKwFYF8HdV9TmCJqSRMEnC5x8srdj0iF4JEZXyqab+GbuUoJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C8+UXrxb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C8+UXrxb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7B9C4CEE3;
	Tue, 29 Apr 2025 18:12:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950321;
	bh=vzCAPXk0AYGhrB/qwXw3Wow+BHGSxFoOVEyMkClqUg8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C8+UXrxbKqxkTVfDAHXKLNYRl2Ax/7InRSvuRW8NBHWglyV/BmQqKnl1jQ7mGyYXm
	 KalmKQzB5Aorkt80rumWnUNbYMFr7uqIqmMvb2Mveqg4UNqs2mZkYADcBh21qrOlNt
	 J3kVLliSVokSHOX4vfUvgucfh4W9/hGhCB51qHMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Al Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 058/204] fix a couple of races in MNT_TREE_BENEATH handling by do_move_mount()
Date: Tue, 29 Apr 2025 18:42:26 +0200
Message-ID: <20250429161101.807801796@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 0d039eac6e5950f9d1ecc9e410c2fd1feaeab3b6 ]

Normally do_lock_mount(path, _) is locking a mountpoint pinned by
*path and at the time when matching unlock_mount() unlocks that
location it is still pinned by the same thing.

Unfortunately, for 'beneath' case it's no longer that simple -
the object being locked is not the one *path points to.  It's the
mountpoint of path->mnt.  The thing is, without sufficient locking
->mnt_parent may change under us and none of the locks are held
at that point.  The rules are
	* mount_lock stabilizes m->mnt_parent for any mount m.
	* namespace_sem stabilizes m->mnt_parent, provided that
m is mounted.
	* if either of the above holds and refcount of m is positive,
we are guaranteed the same for refcount of m->mnt_parent.

namespace_sem nests inside inode_lock(), so do_lock_mount() has
to take inode_lock() before grabbing namespace_sem.  It does
recheck that path->mnt is still mounted in the same place after
getting namespace_sem, and it does take care to pin the dentry.
It is needed, since otherwise we might end up with racing mount --move
(or umount) happening while we were getting locks; in that case
dentry would no longer be a mountpoint and could've been evicted
on memory pressure along with its inode - not something you want
when grabbing lock on that inode.

However, pinning a dentry is not enough - the matching mount is
also pinned only by the fact that path->mnt is mounted on top it
and at that point we are not holding any locks whatsoever, so
the same kind of races could end up with all references to
that mount gone just as we are about to enter inode_lock().
If that happens, we are left with filesystem being shut down while
we are holding a dentry reference on it; results are not pretty.

What we need to do is grab both dentry and mount at the same time;
that makes inode_lock() safe *and* avoids the problem with fs getting
shut down under us.  After taking namespace_sem we verify that
path->mnt is still mounted (which stabilizes its ->mnt_parent) and
check that it's still mounted at the same place.  From that point
on to the matching namespace_unlock() we are guaranteed that
mount/dentry pair we'd grabbed are also pinned by being the mountpoint
of path->mnt, so we can quietly drop both the dentry reference (as
the current code does) and mnt one - it's OK to do under namespace_sem,
since we are not dropping the final refs.

That solves the problem on do_lock_mount() side; unlock_mount()
also has one, since dentry is guaranteed to stay pinned only until
the namespace_unlock().  That's easy to fix - just have inode_unlock()
done earlier, while it's still pinned by mp->m_dentry.

Fixes: 6ac392815628 "fs: allow to mount beneath top mount" # v6.5+
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 69 ++++++++++++++++++++++++++------------------------
 1 file changed, 36 insertions(+), 33 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 671e266b8fc5d..5a885d35efe93 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2439,56 +2439,62 @@ static struct mountpoint *do_lock_mount(struct path *path, bool beneath)
 	struct vfsmount *mnt = path->mnt;
 	struct dentry *dentry;
 	struct mountpoint *mp = ERR_PTR(-ENOENT);
+	struct path under = {};
 
 	for (;;) {
-		struct mount *m;
+		struct mount *m = real_mount(mnt);
 
 		if (beneath) {
-			m = real_mount(mnt);
+			path_put(&under);
 			read_seqlock_excl(&mount_lock);
-			dentry = dget(m->mnt_mountpoint);
+			under.mnt = mntget(&m->mnt_parent->mnt);
+			under.dentry = dget(m->mnt_mountpoint);
 			read_sequnlock_excl(&mount_lock);
+			dentry = under.dentry;
 		} else {
 			dentry = path->dentry;
 		}
 
 		inode_lock(dentry->d_inode);
-		if (unlikely(cant_mount(dentry))) {
-			inode_unlock(dentry->d_inode);
-			goto out;
-		}
-
 		namespace_lock();
 
-		if (beneath && (!is_mounted(mnt) || m->mnt_mountpoint != dentry)) {
+		if (unlikely(cant_mount(dentry) || !is_mounted(mnt)))
+			break;		// not to be mounted on
+
+		if (beneath && unlikely(m->mnt_mountpoint != dentry ||
+				        &m->mnt_parent->mnt != under.mnt)) {
 			namespace_unlock();
 			inode_unlock(dentry->d_inode);
-			goto out;
+			continue;	// got moved
 		}
 
 		mnt = lookup_mnt(path);
-		if (likely(!mnt))
+		if (unlikely(mnt)) {
+			namespace_unlock();
+			inode_unlock(dentry->d_inode);
+			path_put(path);
+			path->mnt = mnt;
+			path->dentry = dget(mnt->mnt_root);
+			continue;	// got overmounted
+		}
+		mp = get_mountpoint(dentry);
+		if (IS_ERR(mp))
 			break;
-
-		namespace_unlock();
-		inode_unlock(dentry->d_inode);
-		if (beneath)
-			dput(dentry);
-		path_put(path);
-		path->mnt = mnt;
-		path->dentry = dget(mnt->mnt_root);
-	}
-
-	mp = get_mountpoint(dentry);
-	if (IS_ERR(mp)) {
-		namespace_unlock();
-		inode_unlock(dentry->d_inode);
+		if (beneath) {
+			/*
+			 * @under duplicates the references that will stay
+			 * at least until namespace_unlock(), so the path_put()
+			 * below is safe (and OK to do under namespace_lock -
+			 * we are not dropping the final references here).
+			 */
+			path_put(&under);
+		}
+		return mp;
 	}
-
-out:
+	namespace_unlock();
+	inode_unlock(dentry->d_inode);
 	if (beneath)
-		dput(dentry);
-
+		path_put(&under);
 	return mp;
 }
 
@@ -2499,14 +2505,11 @@ static inline struct mountpoint *lock_mount(struct path *path)
 
 static void unlock_mount(struct mountpoint *where)
 {
-	struct dentry *dentry = where->m_dentry;
-
+	inode_unlock(where->m_dentry->d_inode);
 	read_seqlock_excl(&mount_lock);
 	put_mountpoint(where);
 	read_sequnlock_excl(&mount_lock);
-
 	namespace_unlock();
-	inode_unlock(dentry->d_inode);
 }
 
 static int graft_tree(struct mount *mnt, struct mount *p, struct mountpoint *mp)
-- 
2.39.5



