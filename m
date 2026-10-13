Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFCE4F4CFF;
	Tue, 13 Oct 2026 11:53:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892388; cv=none; b=FeqnHjpG/PNqlQmzUxaHQV6WBRO6BjdLE/IMp29x8hB0MJIfJRUWWkqo5WkXGhYQhN3rXO4U4JhHNSYwyXi1bYh/5DeHkj9jMPHwATv1/BZTYAZRHE2WX72QpXmmEQi8xqPanR2YL7Eb7O887aeejVuW7Pq8xINCCLvWF2WtlFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892388; c=relaxed/simple;
	bh=WoN+6rkYoLkxSrhd/Is5ES5CnMZsikAMFoVgj6CzMC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+RLeC2rEOE38KKgltEF0FVIE+hjxLc6cpg9kc7maaQSkJivjXFOKVDYrcvQdth4EuLvUoNpSFnqeK7eigJ9WQfZ8IT+qgBCEEkF8xlUp92pmgHkr5bAjARZ/wLqNttwpZfCJfvvd8LiAyc5XC8VJutlneNMK+dYRVhU5JsXkmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCWOUd9W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCWOUd9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75D61F000FF;
	Tue, 13 Oct 2026 11:53:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892386;
	bh=U/n9uGNBSKcacYKLur6h1TDk9aqzdl3EY7+rmPdG64A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCWOUd9WAqAPKolKF2l12yejOswPQU7wBuTS/zKreY/RIPDGAM23WF/JGmN5e7ze0
	 aEIxVgSzNoV4W7+q0Fh0YnYF2ZAwSuGMbTeypqyDaH2YwHHPUPAXGcKV7S5IjmcOXa
	 EMBxHgUetlOOLzJPuht8ZEauDYJtLda6wbqxht1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 7.2 155/281] namespace: queue a mount only once for mount notifications
Date: Tue, 13 Oct 2026 13:37:51 +0200
Message-ID: <20261013112858.924905524@linuxfoundation.org>
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

commit bd2feb7796b6585938a4241e7b7c4148a6f7b762 upstream.

mnt_notify_add() puts a mount on notify_list. It doesn't check whether
the mount is on the list already. That's fine as long as every mount is
queued at most once per namespace_sem hold. It isn't.

propagate_umount() moves a surviving overmount off a stack of mounts
that are going away and queues it as moved. shrink_submounts() and
mark_mounts_for_expiry() call umount_tree() for several mounts under a
single namespace_sem hold. So the second umount_tree() can take down
exactly the mount the first one reparented, reparent it once more and so
end up queueing it a second time.

The second list_add_tail() cuts the mounts queued in between out of the
list while the head still points at the last of them. notify_mnt_list()
then only visits that one mount and the others are freed after the grace
period with notify_list still pointing at them. Every later mount
operation on the host walks freed memory:

  BUG: KASAN: slab-use-after-free in __list_add_valid_or_report
  Read of size 8 at addr ffff8881003d57e0 by task notify_dq/162
   __list_add_valid_or_report+0x15c/0x1a0
   mnt_add_to_ns+0x322/0x890
   attach_recursive_mnt.isra.0+0xf2a/0x1a00
   path_mount+0x139c/0x1d40

This needs a mount with MNT_SHRINKABLE to bind from. That's what
finish_automount() creates (submounts of NFS, AFS and CIFS and the
tracefs mount below debugfs). Bind mounts inherit the flag. A mount
namespace with a FAN_MARK_MNTNS mark does the rest and root in a user
namespace can have both.

Initialize to_notify in alloc_vfsmnt() and leave a mount alone that is
queued already. mnt_notify() looks at the state the mount has when the
list is drained so a single entry per mount is enough. The move event
for a mount that is unmounted under the same hold is lost. That's fine.
The detach is what matters.

Fixes: bf630c401641 ("vfs: add notifications for mount attach and detach")
Cc: stable@vger.kernel.org # v6.15+
Link: https://patch.msgid.link/20260930-work-mount-fixes-3-v1-1-be34c83956ae@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/mount.h     |    3 +++
 fs/namespace.c |    3 +++
 2 files changed, 6 insertions(+)

--- a/fs/mount.h
+++ b/fs/mount.h
@@ -233,6 +233,9 @@ static inline struct mnt_namespace *to_m
 #ifdef CONFIG_FSNOTIFY
 static inline void mnt_notify_add(struct mount *m)
 {
+	/* queued already under this namespace_sem hold */
+	if (!list_empty(&m->to_notify))
+		return;
 	/* Optimize the case where there are no watches */
 	if ((m->mnt_ns && m->mnt_ns->n_fsnotify_marks) ||
 	    (m->prev_ns && m->prev_ns->n_fsnotify_marks))
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -322,6 +322,9 @@ static struct mount *alloc_vfsmnt(const
 		INIT_HLIST_NODE(&mnt->mnt_mp_list);
 		INIT_HLIST_HEAD(&mnt->mnt_stuck_children);
 		INIT_HLIST_NODE(&mnt->mnt_ns_visible);
+#ifdef CONFIG_FSNOTIFY
+		INIT_LIST_HEAD(&mnt->to_notify);
+#endif
 		RB_CLEAR_NODE(&mnt->mnt_node);
 		mnt->mnt.mnt_idmap = &nop_mnt_idmap;
 	}


