Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1946F3A7189;
	Sat, 17 Oct 2026 16:07:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253228; cv=none; b=HqRZWWQKP2pvRIxgWxbVEBXRK8Ow6ya3n7RQhZ9eVQM+vsoqECX6C4UqLJ9vyitu1FqhAm2OHRWEVkOTCc5MRIVktEpUAa9yOjGZ9iT8Q8sl0rlzNs4mDqkLTd083vV3jEUai22OHAWepUWVq7+gdpmsE4YIapha56g1BA614EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253228; c=relaxed/simple;
	bh=uQn6nitfyV/4MeAIduQQJ298xe0UpPLavCzF4sM2Nwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PIV8Db+VmizFr+JxI9utEKpc1sC/0CtnYXvrWQRHlD8NS5IB+YHSunK8hJx7YsVC7U3M9OLt0vNLeNBmsExfACxbazeiJ93wOxHehBtHLR/13nwNQGWkLqQ9mLiuYcINj6R+JnCR7U1+b1EmIZj6S93qFN44xaMDMdTLbKRki3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LtcRM+0H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LtcRM+0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C51AF1F000C4;
	Sat, 17 Oct 2026 16:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253223;
	bh=SCI3jYNmGdbQ2nM+Pbo/7L54X02Mg8Lh5yu7VjZgXKg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LtcRM+0HniNYUDM2dZsUELEF0iA6hcHMGu7+SS5TBwhaYXML+SmiaOn42LCmPLaLD
	 K1/N1eJvI1w1MtdfpmgHlypM/WlnzBIbDsSgqh5m5v1BHf9giar+LOlDyEfrYcKus5
	 HIhSsQTePWMVrY3ImvbRGslnES3Ip1yBpWwKsQTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/869] namespace: handle mount locking for automounts correctly
Date: Sat, 17 Oct 2026 17:48:09 +0200
Message-ID: <20261017160038.249226325@linuxfoundation.org>
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

[ Upstream commit 33aadc7c72055fca93cb5a3691d836ebf8b31c9b ]

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
[ sashal: adapted destination namespace access from dest->parent->mnt_ns to the existing top_mnt->mnt_ns. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 808a8e79a4863..036d56df28289 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2494,15 +2494,31 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 				struct mountpoint *dest_mp,
 				enum mnt_tree_flags_t flags)
 {
-	struct user_namespace *user_ns = current->nsproxy->mnt_ns->user_ns;
 	HLIST_HEAD(tree_list);
 	struct mnt_namespace *ns = top_mnt->mnt_ns;
+	struct user_namespace *user_ns = ns->user_ns;
 	struct mountpoint *smp;
 	struct mount *child, *dest_mnt, *p;
 	struct hlist_node *n;
 	int err = 0;
 	bool moving = flags & MNT_TREE_MOVE, beneath = flags & MNT_TREE_BENEATH;
 
+	/*
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
 	/*
 	 * Preallocate a mountpoint in case the new mounts need to be
 	 * mounted beneath mounts on the same mountpoint.
-- 
2.53.0



