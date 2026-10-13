Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C899A4F4CF9;
	Tue, 13 Oct 2026 11:52:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892373; cv=none; b=L8drZjDf5P3h4hVyVJqmVNtbTtWU962oiQic1VFSYeit8D2zIz4+C/45gpGc/+JMhOoE03ucL3PuMd9XheI7GEMUmAuPVqfNn2oCUqAxxdrTdaNjCZdKf0nD5Dxaci94QKq8Nb3G7XoVHDHZfQxPsvc8juLQm/LrTw9o0yV3lP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892373; c=relaxed/simple;
	bh=52eZhyJoU0Nfd/eHLEI2m6rWcSSFsEaeCI+BLgc62Kc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uo3Brvlo7mp84DpzTDoxIXPgV6mh4UObrCcDCXtqcjPBLfVhXx9PAFibeRptp3Z+8xtpjXxyjbwFbtr8SHZXjnTRy9hvq0W1NVkTfe10Qsq4LqrbHv6G5wSXTZuvRcsCqvyUS+NmV3q9OoMuujm7aZtS9vc5yLeNQ/ho2FBeBk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eyE/Rabf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eyE/Rabf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264D01F000FF;
	Tue, 13 Oct 2026 11:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892371;
	bh=Lzs+rD7SIA20z+fxxtbvC8NV1Bj7y4132qQ4liPJI9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eyE/Rabf1VWwwhp4NMEEDxc38Un9U6xPFA69J8coCHD74qlAupAbxMqWvIuenV/bS
	 69nzFpL6KZC7HtpK0oGqwN5gMzekbdtoZkH30i/thrXGoC95AyJj+gG8OhCh3Pys+X
	 k2U9RBg5poLqU9hInEgQ7A6lnpd2lte8CeIfXZt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 151/281] namespace: dont inherit MNT_UMOUNT in clone_mnt()
Date: Tue, 13 Oct 2026 13:37:47 +0200
Message-ID: <20261013112858.824688339@linuxfoundation.org>
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

commit e2c6d326216642011da318b9edfd5d57ebd5a56f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c        |    2 ++
 include/linux/mount.h |    2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -1787,6 +1787,8 @@ static void umount_tree(struct mount *mn
 
 	/* Gather the mounts to umount */
 	for (p = mnt; p; p = next_mnt(p, mnt)) {
+		/* A mount is unmounted once. */
+		VFS_WARN_ON_ONCE(p->mnt.mnt_flags & MNT_UMOUNT);
 		p->mnt.mnt_flags |= MNT_UMOUNT;
 		if (mnt_ns_attached(p))
 			move_from_ns(p);
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -52,7 +52,7 @@ enum mount_flags {
 	MNT_ATIME_MASK = MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME,
 
 	MNT_INTERNAL_FLAGS = MNT_INTERNAL | MNT_DOOMED |
-			     MNT_SYNC_UMOUNT | MNT_LOCKED
+			     MNT_SYNC_UMOUNT | MNT_LOCKED | MNT_UMOUNT
 };
 
 struct vfsmount {


