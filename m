Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209233;
	b=yFOaAa0FF+3CyqkmoycILm5DpLlfk9V3VC+tAejZ3zI3R5xPsfp0nJxp72QZor7mRjEI
	 x4OxgUygZ9Lf777wqTUp2mMkgFmNEsb1PnVMgN7GmIMhBzwarQSKN2weahzo5pLM55HQV
	 y9GEYQu/sOgpUpKqhczojpm1yYcfa0cNHFX5Cndexiu+iMIGfvlA9TkINrUzqlub4P3CD
	 kubsStE4Vw4ZacBF/RHFaZfJHR1l0uFYgXizH210LPE7ThH8EymojBmfSEaOPTjs8yl+1
	 ExFnsLv0GcKUBuMH3AvLzYtumLOgfuly9ylQLplIFoRI4B197ZhpHhuOVS5/bx3uSzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CRPR2RINObmWn5UFYfPcG4E3l+GE7S0GBKgNORuPHrM=;
	b=hng52o+OM8VVZ3UboGgoTYz0vJwA7CeRYqGMAlKoBgHgDineHmfmNORT34kxZ82lYJSZ
	 tdGnQxIXqXE00h7OKzETZJ+OgtHCykM0DCfA3XuGw9wv7BkEo8pN9iPTocWQyAT5YqBOL
	 nCA85d8kXEPZaXEdCvjOVbvdyn4AM6o7iim9bIdO0ZPUUwF7GR/+NYqk4WdYcVF843fb7
	 iZd6wmeY5oTOByVy5VpnWZ1LPgrE3wUT5U7I5Zk0W+nrg88Nfc2S+p/uQ/Sg6Fxu7iWhZ
	 73hlZaFTBl/gRihBGkphf30tgI02SekF1K7dbq1MAmJkwyWz2FysdpLTlr/CXt5YEtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k49Htu8m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25E7F606A31C;
	Wed, 28 Oct 2026 17:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k49Htu8m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 763071F01825;
	Wed, 28 Oct 2026 17:40:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209233;
	bh=CRPR2RINObmWn5UFYfPcG4E3l+GE7S0GBKgNORuPHrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k49Htu8mampfmeTmsTpX4XCn5COgmmCpNZQ8KJ4vVEumkvm8GxAKhdxQgQvZkhHhb
	 IL5wBFa/7QO+048ZxriSmv/D4dGjQCUTuX5Fbl/cZSHkPt/QtABjjH/3+hUWe0xFgd
	 iqDNlsOZjWOiE6su1E/UvBwMCoL+uM5+tl5dPpIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 399/516] namespace: handle mount locking for automounts correctly
Date: Wed, 28 Oct 2026 17:59:11 +0100
Message-ID: <20261028170012.933398426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context for attach_recursive_mnt() using separate destination arguments instead of a pinned_mountpoint ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index ebf345754da94..fe908cf52986e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2151,14 +2151,30 @@ static int attach_recursive_mnt(struct mount *source_mnt,
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



