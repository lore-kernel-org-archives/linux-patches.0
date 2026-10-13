Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B674F30E3;
	Tue, 13 Oct 2026 12:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893211; cv=none; b=F6d+UU74Cqc9PFcKkHBXmNMTkY+vCSFNJPPFfnyj48DfaIZ2+fZUdwo0C8N4/Vvs8Em7baw76VBg19z/HJpNf6swM7C/Kp8CarKbtiFUw6w8E6Vjq70dkMenNKT6Q+d8Wg7NfmznaEMolXwA1wE0A12AzmAAuvgvc7FV3Vced0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893211; c=relaxed/simple;
	bh=6wGwNj3Y1bbRdAsjRuSUgjk1WEf4Bnr8sRopd9uFSYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N/wTS9zms7gv15NqYtACAvJSF4yXMYgsmJCTrU7yL3Q0BMvdGbHAkdopUdqd8h2ZXTOLiq9vsNlQc6wESpTnEHNWeG7NBLi+igriNeKScCetzzKG4qcWhwLiswh3r3/YS5ya+xwUrdrAZmQrI5CWTQIDDEXu6IrraYLwRELLZ98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y47pczkW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y47pczkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 952B21F008A2;
	Tue, 13 Oct 2026 12:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893210;
	bh=N2GxG0+NqjmuCi8/R86aopJ4keHjZIDIrLR1sI8WK10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y47pczkW86Ll1blf8kDws4CfjJVpm5AZQU/brG1LPLiuGnLsq5Gll/VELAuRE5pfQ
	 LPFWpv/9sHwrif0KZYwjywAUENt/DiGcvGyFR0RKo3MoeeVG/jmJnjcm7EmhFOd3/m
	 sKxtRH0m7W/oH/FYtK5d5ue1Gtsmzp2wYJ9ymvy0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 148/621] namespace: handle mount locking for automounts correctly
Date: Tue, 13 Oct 2026 13:32:23 +0200
Message-ID: <20261013112924.366360671@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

commit 33aadc7c72055fca93cb5a3691d836ebf8b31c9b upstream.

If mounts are propagated across user namespaces, attach_recursive_mnt()
locks every copy of the source mount to protect overmounts from
vanishing and revealing the underlying files or directories.

The user namespace is taken from the caller's mount namespaces since
this is where the mounts end up. Except, that's not always true.
Automounts may legitimately get popped in by tasks located in a
different mount and user namespace during path lookup.

Then check doesn't make sense at that point. The copy in the namespace
of the parent - which may be the host's - is now locked and the host
cannot change the flags of its own mounts anymore.

Here's the reproducer:

- host has debugfs mounted nosuid,nodev,noexec and shared
- tracefs automount below it is not yet active
- hand a child process a directory descriptor on that mount
- child process enters auser and mount namespace
- child process' namespace now holds a locked copy of the host's debugfs
  mount that receives propagation from it
- child process stats "tracing/." through the descriptor
- lookup runs on the host's mount so the automount lands below the host's mount
- propagation puts a copy below the child's copy
- both try to clear the flags on the mount they got, with a bind remount:

    host, on its own automount:            MS_REMOUNT|MS_BIND = EPERM
    child, on the copy in its namespace:   MS_REMOUNT|MS_BIND = 0

So the lock landed on the host's mount instead of the child's copy.
Congrats. So we need to compare with the owner of the namespace the
mount actually gets mounted on. For all regular cases that is the
caller's mount namespace and so nothing changes.

Detached trees in anonymous mount namespaces by be handed over via
SCM_RIGHTS or inherited in other ways on purpose so the attaching task's
mount namespace is authoritative, not the creator of the detached tree.

Fixes: 132c94e31b8b ("vfs: Carefully propogate mounts across user namespaces")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261002-work-mount-fixes-4-v1-6-dd44b89d44ce@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |   18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2572,11 +2572,11 @@ enum mnt_tree_flags_t {
 static int attach_recursive_mnt(struct mount *source_mnt,
 				const struct pinned_mountpoint *dest)
 {
-	struct user_namespace *user_ns = current->nsproxy->mnt_ns->user_ns;
 	struct mount *dest_mnt = dest->parent;
 	struct mountpoint *dest_mp = dest->mp;
 	HLIST_HEAD(tree_list);
 	struct mnt_namespace *ns = dest_mnt->mnt_ns;
+	struct user_namespace *user_ns = ns->user_ns;
 	struct pinned_mountpoint root = {};
 	struct mountpoint *shorter = NULL;
 	struct mount *child, *p;
@@ -2586,6 +2586,22 @@ static int attach_recursive_mnt(struct m
 	bool moving = mnt_has_parent(source_mnt);
 
 	/*
+	 * A caller in an unprivileged mount namespaces may trigger an
+	 * automount and propagate locked mounts into privileged mount
+	 * namespaces. Take ownership from the target mount namespace.
+	 * It's equivalent for everything but the automount case.
+	 *
+	 * Detached trees in anonymous mount namespaces by be handed
+	 * over via SCM_RIGHTS or inherited in other ways on purpose
+	 * the attaching task's mount namespace is authoritative, not
+	 * the creator of the detached tree.
+	 */
+	if (is_anon_ns(ns))
+		user_ns = current->nsproxy->mnt_ns->user_ns;
+	else
+		user_ns = ns->user_ns;
+
+	/*
 	 * Preallocate a mountpoint in case the new mounts need to be
 	 * mounted beneath mounts on the same mountpoint.
 	 */


