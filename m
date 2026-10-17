Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 494F53563E1;
	Sat, 17 Oct 2026 16:05:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253158; cv=none; b=kAq70IALAh8a4DrfzQ3JbwCeS624tSlSqCJop4dHa3S/PciogRJ6qP8CHHb3IaN7R0ois3QTL8yvYagMnP/WIqMVY4fFSbbZaQlCP8nnBbLMJJWJDagfdsxkIGMY9LT7+Fb+WjADDMUso5P05jjgGeysfzAYlg6RsyQgFy+ZiSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253158; c=relaxed/simple;
	bh=YnrqNX8hrJw0yG2s6Lku8moHASNw4Vr9L6QXnuJ1nlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=maJGmuWw8i/8R2edw316hXS+KZ2BTW3BQwkMf1LwMRhKroZHJIxQuhMW0qBOLjBNtqiILsQxmZj2gfvYt4aDQEFHpZkJhiGXqDB9ias/h+kzSf+EBVA0cWA0XqhJy/jm8IMVu0xvZIVBuS5spwoiO9AKmoaaSLhWIC3E/aHmihE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNLYuel4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNLYuel4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937831F000C4;
	Sat, 17 Oct 2026 16:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253157;
	bh=4OnTUG4kDwyCko3IfIS75m+rTr8hNtj4RVZtydSRcag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNLYuel4bM84O6EZUPvV3YB0JAP0vTEMTasjFne3QSpVX0he3kZZZ6vdggD+A8Bsf
	 p9mciILgSkQRcYGNY1I7zGpQA9z5mHSp25E+QAHwr7OQVBHHJZU7HTSbD23Y4GQwxh
	 MXheLwulFwAqkFCxOGq2krpVT/AUDNi1JHi4O3/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/869] namespace: dont inherit MNT_UMOUNT in clone_mnt()
Date: Sat, 17 Oct 2026 17:47:50 +0200
Message-ID: <20261017160037.760990735@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit e2c6d326216642011da318b9edfd5d57ebd5a56f ]

MNT_UMOUNT gets raised on a mount that umount_tree() or umount_one() has
taken out of its namespace. It's never cleared. __detach_mounts()
unhooks a mount that carries it instead of unmounting it.

disconnect_mount() lets an unmounted child stay attached only if its
parent carries it. propagate_umount() takes it as the sign that a mount
is going to be unmounted when it decides what else can be unmounted,
where a chain of locked mounts ends and where a for reparenting an
overmount.

clone_mnt() copies the flags of the source and only masks
MNT_INTERNAL_FLAGS which doesn't include MNT_UMOUNT. A mount that was
lazily unmounted but is kept alive by a file descriptor can still be
copied when its root is an nsfs or pidfs file because may_copy_tree()
accepts those before checking whether the source is mounted at all:

  mount --bind /proc/self/ns/net /tmp/x
  exec 3< /tmp/x
  umount -l /tmp/x
  mount --bind /proc/self/fd/3 /tmp/y

The mount on /tmp/y is attached to the caller's namespace with
MNT_UMOUNT already set and every copy of it inherits the flag again.

That causes a number of bugs:

- Unlink its mountpoint from a mount namespace where it isn't one.
  __detach_mounts() takes it for a mount that was unmounted earlier,
  unhooks it from its parent and drops the reference the namespace
  holds on it. It stays in the namespace with one reference too few
  and as its own parent, so it can't be unmounted through the file
  descriptor anymore and the namespace never finds it again. When the
  namespace goes away it's leaked and points to a freed struct
  mnt_namespace that may_change_propagation() and anon_ns_root() read
  on the next propagation change or mount_setattr() through the file
  descriptor.

- Make it shared and unmount a peer. trace_transfers() follows the
  flag from the peer into it and strips it from its peer group.

- Let a propagated umount reach it. gather_candidates() marks it with
  T_UMOUNT_CANDIDATE but never puts it on the candidate list, so the
  mark is never cleared and every later propagated umount skips it. If
  it's the parent of a locked mount handle_locked() takes it as the
  cutoff and commits the locked child that should have stayed and
  disconnect_mount() leaves that child attached to it, unmounted under
  a mounted parent, which is what disconnect_mount() exists to
  prevent. When the namespace goes away umount_tree() visits the child
  a second time. And once __detach_mounts() has made it its own parent
  reparent() never finds the end of the chain of unmounted parents.

A clone is a new mount that has never been unmounted. Add MNT_UMOUNT
to MNT_INTERNAL_FLAGS so clone_mnt() never copies it. And warn when
umount_tree() reaches a mount that already has it set.

Fixes: 590ce4bcbfb4 ("mnt: Add MNT_UMOUNT flag")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260926-work-mount-fixes-2-v1-3-f357abf3d17b@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: adapted mount flags to macro definitions and an explicit clone_mnt() mask while replacing VFS_WARN_ON_ONCE() with WARN_ON_ONCE(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c        | 4 +++-
 include/linux/mount.h | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index f87bdff661664..11e6ddce877d5 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1311,7 +1311,7 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 	}
 
 	mnt->mnt.mnt_flags = old->mnt.mnt_flags;
-	mnt->mnt.mnt_flags &= ~(MNT_WRITE_HOLD|MNT_MARKED|MNT_INTERNAL);
+	mnt->mnt.mnt_flags &= ~(MNT_WRITE_HOLD|MNT_MARKED|MNT_INTERNAL|MNT_UMOUNT);
 
 	atomic_inc(&sb->s_active);
 	mnt->mnt.mnt_idmap = mnt_idmap_get(mnt_idmap(&old->mnt));
@@ -1778,6 +1778,8 @@ static void umount_tree(struct mount *mnt, enum umount_tree_flags how)
 
 	/* Gather the mounts to umount */
 	for (p = mnt; p; p = next_mnt(p, mnt)) {
+		/* A mount is unmounted once. */
+		WARN_ON_ONCE(p->mnt.mnt_flags & MNT_UMOUNT);
 		p->mnt.mnt_flags |= MNT_UMOUNT;
 		if (mnt_ns_attached(p))
 			move_from_ns(p, &tmp_list);
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 04213d8ef8376..fdc14f5d154d7 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -50,7 +50,8 @@ struct path;
 #define MNT_ATIME_MASK (MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME )
 
 #define MNT_INTERNAL_FLAGS (MNT_SHARED | MNT_WRITE_HOLD | MNT_INTERNAL | \
-			    MNT_DOOMED | MNT_SYNC_UMOUNT | MNT_MARKED)
+			    MNT_DOOMED | MNT_SYNC_UMOUNT | MNT_MARKED | \
+			    MNT_UMOUNT)
 
 #define MNT_INTERNAL	0x4000
 
-- 
2.53.0



