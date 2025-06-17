Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22BEC2FA623;
	Tue, 17 Jun 2025 16:58:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179499; cv=none; b=rFxV8WImByp0fCxc02Lc/ypnrogtRM4m2F7VvnhIWtKhneiWpoMj/aogZ/KiHGJdU99SO12qFPXoMNFl7RAWSm7NC+BHSjizsGifhGTMAcnYrzXdF43kVmeUhr0yZV7XQfFHGbwe2kTZ/k50LY8RuEGmHPDpx/P2QAwi17Obk4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179499; c=relaxed/simple;
	bh=qrX32344hNXTxO6sjI6ijmL5yqMv5SD7rjrbj8fUPCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QYGzy2V98OB1qPG3m1O53bTN0pm4zVJ0tK7a4P2grSBJbZDZBUvINkSIPMbIuzu2o793yXXRzxn97txzUvREX7gMPET4Qf9MjdAzHH7opNPQAMVuIUGLvAwn4XQ9fsF6HrHgR6jRkLVP4PzrgMhvKwSVTshqUZMe8yKXyTb1LkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q/2NpI0L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q/2NpI0L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39F15C4CEE3;
	Tue, 17 Jun 2025 16:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179496;
	bh=qrX32344hNXTxO6sjI6ijmL5yqMv5SD7rjrbj8fUPCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q/2NpI0LNDRf14yteBb0nKrjwnfLMKnjUOS3JEXDWDSig42WPTB6VAu4U+hNEv4Mn
	 30A5T3Z1OAMBEbazm9/341iQTM90K+Ln1BpSgY5glAIBFHYxlCm7NiVjg6YJSrX0k3
	 U2P+Jro0tHcWUNOPqyA2PUJnqN4ibeWk71Ak8vAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Allison Karlitskaya <lis@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 6.15 763/780] Dont propagate mounts into detached trees
Date: Tue, 17 Jun 2025 17:27:51 +0200
Message-ID: <20250617152522.582231332@linuxfoundation.org>
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

commit 3b5260d12b1fe76b566fe182de8abc586b827ed0 upstream.

All versions up to 6.14 did not propagate mount events into detached
tree.  Shortly after 6.14 a merge of vfs-6.15-rc1.mount.namespace
(130e696aa68b) has changed that.

Unfortunately, that has caused userland regressions (reported in
https://lore.kernel.org/all/CAOYeF9WQhFDe+BGW=Dp5fK8oRy5AgZ6zokVyTj1Wp4EUiYgt4w@mail.gmail.com/)

Straight revert wouldn't be an option - in particular, the variant in 6.14
had a bug that got fixed in d1ddc6f1d9f0 ("fix IS_MNT_PROPAGATING uses")
and we don't want to bring the bug back.

This is a modification of manual revert posted by Christian, with changes
needed to avoid reintroducing the breakage in scenario described in
d1ddc6f1d9f0.

Cc: stable@vger.kernel.org
Reported-by: Allison Karlitskaya <lis@redhat.com>
Tested-by: Allison Karlitskaya <lis@redhat.com>
Acked-by: Christian Brauner <brauner@kernel.org>
Co-developed-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/mount.h     |    5 -----
 fs/namespace.c |   15 ++-------------
 fs/pnode.c     |    4 ++--
 3 files changed, 4 insertions(+), 20 deletions(-)

--- a/fs/mount.h
+++ b/fs/mount.h
@@ -7,10 +7,6 @@
 
 extern struct list_head notify_list;
 
-typedef __u32 __bitwise mntns_flags_t;
-
-#define MNTNS_PROPAGATING	((__force mntns_flags_t)(1 << 0))
-
 struct mnt_namespace {
 	struct ns_common	ns;
 	struct mount *	root;
@@ -37,7 +33,6 @@ struct mnt_namespace {
 	struct rb_node		mnt_ns_tree_node; /* node in the mnt_ns_tree */
 	struct list_head	mnt_ns_list; /* entry in the sequential list of mounts namespace */
 	refcount_t		passive; /* number references not pinning @mounts */
-	mntns_flags_t		mntns_flags;
 } __randomize_layout;
 
 struct mnt_pcp {
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3673,7 +3673,7 @@ static int do_move_mount(struct path *ol
 	if (!(attached ? check_mnt(old) : is_anon_ns(ns)))
 		goto out;
 
-	if (is_anon_ns(ns)) {
+	if (is_anon_ns(ns) && ns == p->mnt_ns) {
 		/*
 		 * Ending up with two files referring to the root of the
 		 * same anonymous mount namespace would cause an error
@@ -3681,16 +3681,7 @@ static int do_move_mount(struct path *ol
 		 * twice into the mount tree which would be rejected
 		 * later. But be explicit about it right here.
 		 */
-		if ((is_anon_ns(p->mnt_ns) && ns == p->mnt_ns))
-			goto out;
-
-		/*
-		 * If this is an anonymous mount tree ensure that mount
-		 * propagation can detect mounts that were just
-		 * propagated to the target mount tree so we don't
-		 * propagate onto them.
-		 */
-		ns->mntns_flags |= MNTNS_PROPAGATING;
+		goto out;
 	} else if (is_anon_ns(p->mnt_ns)) {
 		/*
 		 * Don't allow moving an attached mount tree to an
@@ -3747,8 +3738,6 @@ static int do_move_mount(struct path *ol
 	if (attached)
 		put_mountpoint(old_mp);
 out:
-	if (is_anon_ns(ns))
-		ns->mntns_flags &= ~MNTNS_PROPAGATING;
 	unlock_mount(mp);
 	if (!err) {
 		if (attached) {
--- a/fs/pnode.c
+++ b/fs/pnode.c
@@ -231,8 +231,8 @@ static int propagate_one(struct mount *m
 	/* skip if mountpoint isn't visible in m */
 	if (!is_subdir(dest_mp->m_dentry, m->mnt.mnt_root))
 		return 0;
-	/* skip if m is in the anon_ns we are emptying */
-	if (m->mnt_ns->mntns_flags & MNTNS_PROPAGATING)
+	/* skip if m is in the anon_ns */
+	if (is_anon_ns(m->mnt_ns))
 		return 0;
 
 	if (peers(m, last_dest)) {


