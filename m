Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211652;
	b=0Vnc3y5W5eVYmZU6yKslTDjxIqkGyyJnfsJ+MlRd8LyoFc/zH6t1HAPqvRWlr/CyjVsB
	 vKYGAuLUywGRaxMS9Exf+m8gkS9/Vhxz7JPkZQYxzA/Mlo+Gv9av7eI15SE9boFeCZygD
	 Ln4ghNgu2NBSaNNk4uRHe9gse15sUwsx8XevaYk9rCyefd9BQoM2YKucf58hbXsg4C9nL
	 nCDc0D5/EGXMywuOPvyUCm8EvgvD6LiQSM9d+crSx6wY4lxsYHddRgSL44kN/FedR7f4d
	 j6X6skQsSL37Y06sVlqcIk3Z+1788DcrGF2hn8cotMVQ0q9IcrUEe+cZxj0/8Cu3G9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211652;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VZ/keiFsGztNhXoJ8L45zbYRBIS+BRYd1n7ckd6DmGU=;
	b=LpzZMKwf0PD7OzTWlktIGHdge43W+TVoEmibRI6OOtVFe20BfkatUfYogThmQPKIxxwj
	 5cvx6VlIfBveh0jjksJnmdN4pIAutJphXvF1pL1ug2cB0oGa3PisuGVE41SV+Kigw2dfj
	 QeoqNHhScMuEwtACEy2K7enXqMf/R8m5umSGNWJelWUoFqZWGCiWAWZ+/cM3+7C5bSIIj
	 F/sxqE0Ac9Mg4WrxAolvLjjyTg8lzys3j9fdHOOLJUhUWh5UlLs1sdXH3+wPFeolqQslI
	 k2paERtdALfdmhBNaNeilKQum/KXnlvn++FTUuJxZBiavRS1ksZdwSch6CdT6lmtU7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TuVS4c0g;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89E24606A31A;
	Wed, 28 Oct 2026 18:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TuVS4c0g
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8FA01F01828;
	Wed, 28 Oct 2026 18:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211652;
	bh=VZ/keiFsGztNhXoJ8L45zbYRBIS+BRYd1n7ckd6DmGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TuVS4c0grFxDoyEAKvYjHyJnIRmv3oGg/QijQ06NTg1sAkSZHB5Xr6dxjOK6I88WE
	 Snf8OfJ2Wa3g0noHBjuXdRlFZnCfUuvwnHQc2mcHF72CxLTKgpAk/te6/FC5BT6foJ
	 YF7GOsw+LWrpcWMDFN9/OCJvrSDOrIIrhl0vsCmI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 452/571] namespace: handle mount locking for automounts correctly
Date: Wed, 28 Oct 2026 17:59:59 +0100
Message-ID: <20261028170018.752025745@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for attach_recursive_mnt() using separate mount and mountpoint arguments instead of pinned_mountpoint ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 1b79364c27bf5..542ac0d7cc106 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2175,14 +2175,30 @@ static int attach_recursive_mnt(struct mount *source_mnt,
 			struct mountpoint *dest_mp,
 			bool moving)
 {
-	struct user_namespace *user_ns = current->nsproxy->mnt_ns->user_ns;
 	HLIST_HEAD(tree_list);
 	struct mnt_namespace *ns = dest_mnt->mnt_ns;
+	struct user_namespace *user_ns = ns->user_ns;
 	struct mountpoint *smp;
 	struct mount *child, *p;
 	struct hlist_node *n;
 	int err;
 
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
 	/* Preallocate a mountpoint in case the new mounts need
 	 * to be tucked under other mounts.
 	 */
-- 
2.53.0



