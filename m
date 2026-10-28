Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213524;
	b=Vo7usf4EEBR28KRmfGUYnC9PPerZrqIPJh5NAB1X3pBdX5k6AjQ2d3mninUyawP5ZH+a
	 Ln82rgV1OJShb4/CAUogJH89K5Eeo1bhAt8GUHKePgfYQdZuPxVQ+ZUxUkJxPSqwbYtQo
	 8VPFlsQCRwkEj/h0RXzvIrsQSo8Q5yJljrRxIdh7rnb1PK9dmVlwSh6Y5tyRq4P/5FSCX
	 FwT0XrtskkVjInFqNsnZ/OrJniju3+y197AFFJv55r4j5bFRoT7hzg8OkvH9MOrA9di8g
	 ii5cCJ7w304v+n2N4tsNmeaWyZd+wJ6dG9hJyf6BYHwpwDowYMf/2woe4EsLQyAOfJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213524;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fBG/qjWhNll4+yeIwSFciKSun3ikLdS0cC4/fY/+i08=;
	b=Kc730oL3ncuMw/ozmua4TbdMXoCTBtHbbFXx0raJE63sOeLxprgit6sOtQYXgkVJq4wL
	 LcogWREPg9YKod13VhsegmH4EWNbsOpD64W+qrt14cJcYeuxo0zY20QrcjXQsvYPADlVG
	 ySfXkxeMmSqY2jchXReo6VyzJ576eZw8xDX42+gk1ebNJ0q2Zdfh/vln3J8vV8Y5rvgRM
	 7AEleweznxvOlC7dqS9Q1Xzr4PVclborcCTyVga/CkxIwXHsN5gPxypbkyZ6KZ0O3fQ83
	 6aJDNP6eCM1qsklX84y1D5iEXrrk+wD5JiilDw2dkVTJlNDHdH2oWmNjYsoXcy/BbgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bgTwtXob;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFD8B606A31A;
	Wed, 28 Oct 2026 18:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bgTwtXob
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB111F01825;
	Wed, 28 Oct 2026 18:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213523;
	bh=fBG/qjWhNll4+yeIwSFciKSun3ikLdS0cC4/fY/+i08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bgTwtXobisdi3QBdV7bkST37/zpkoZs5jEEvEjWEmOI1cQV27fteH1vu5JVHL8XqK
	 o1hZzQSzuUG7sSXM/iBWn8fvRq/De3VdSJoigefU7KamPlvEApGKAmfHQ+YavPeJqm
	 dJEytZgieuvK2gibiG9oOkmyJq8jby17VGrnolxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0529/1887] namespace: check the mounts before reading their parents in pivot_root()
Date: Wed, 28 Oct 2026 17:43:45 +0100
Message-ID: <20261028170511.376346105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 6b7c001eb5857fa09041f47673666060a2e5fc1c ]

path_pivot_root() reads the parents of new_root and of the caller's root
and checks whether they are shared before it checks that either mount is
in the caller's mount namespace. Only namespace_sem is held. That's fine
for a mount that is in the caller's mount namespace.

But new_root can be a file descriptor to a mount that has been unmounted
and that only the file descriptor keeps alive. If that mount stayed
attached to its parent when it was unmounted nothing pins the parent for
it. The final mntput() of the parent unhooks the children under
mount_lock alone and frees the parent afterwards:

  pivot_root()                     close(fd), last ref on the parent
  ------------                     ---------------------------------
  ex_parent = new_mnt->mnt_parent
                                   mntput_no_expire_slowpath()
                                     __umount_mnt(new_mnt)
                                   cleanup_mnt()
                                     call_rcu()
  IS_MNT_SHARED(ex_parent)

  BUG: KASAN: slab-use-after-free in path_pivot_root+0xf1a/0x1840
  Read of size 4 at addr ffff8881047382f8 by task pivot_widen/157
   path_pivot_root+0xf1a/0x1840
   __x64_sys_pivot_root+0x165/0x190

The same goes for the caller's root via chroot(). Both outcomes of the
check end in EINVAL so nothing but the read itself goes wrong. It's the
same thing commit bb4609405752 ("statmount: read the parent of an
unmounted mount under mount_lock") fixed for statmount().

Check that both mounts are in the caller's namespace before their
parents are read. Every path returns EINVAL either way.

Fixes: e0c9c0afd2fc ("mnt: Update detach_mounts to leave mounts connected")
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260930-work-mount-fixes-3-v1-10-be34c83956ae@kernel.org
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
[ sashal: adapted the check to the inline pivot_root() syscall using goto out4 instead of returning -EINVAL. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 2492d5286cef6..f9c3f91277244 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3973,14 +3973,15 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
 	new_mnt = real_mount(new.mnt);
 	root_mnt = real_mount(root.mnt);
 	old_mnt = real_mount(old.mnt);
+	/* only a mounted mount has a parent that namespace_sem pins */
+	if (!check_mnt(root_mnt) || !check_mnt(new_mnt))
+		goto out4;
 	ex_parent = new_mnt->mnt_parent;
 	root_parent = root_mnt->mnt_parent;
 	if (IS_MNT_SHARED(old_mnt) ||
 		IS_MNT_SHARED(ex_parent) ||
 		IS_MNT_SHARED(root_parent))
 		goto out4;
-	if (!check_mnt(root_mnt) || !check_mnt(new_mnt))
-		goto out4;
 	if (new_mnt->mnt.mnt_flags & MNT_LOCKED)
 		goto out4;
 	error = -ENOENT;
-- 
2.53.0



