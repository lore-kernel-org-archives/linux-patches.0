Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6955D224D6;
	Sat, 17 Oct 2026 16:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253161; cv=none; b=chwJ+OudNlaTa4wxj3bqDHaj9lmam9unmituwaDWbNOxbqxqbIxIuDPoSTiQskJAlJSLNbMl4rH8PdhUjYMwkiVVFPCw1GPDmbGjhdTxfAFAZfRwUU9LG35jNr3d8s/0yfa8yxNErZdyzpr750PRo9v0ZiWroOz8uLzDbD3mfpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253161; c=relaxed/simple;
	bh=GIk5+Kntnjm7M+2gy4Fox+WjPfYOM6+G1fAPtjd7tHQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VMZQJtH9TXtns8q+nkoIHYdjVHF7EINYwpNtbISBSv6ZFUEkE+HR2SPD1zEUXFaldW+oxcRvhu8XfQ3gczyIMvcfz8SDFnkNyhIua/JTBgCbfB+vgcQSpGiTywjMxi5n+iVkU5oHTfOwETHpOx70RWKP49zSyHSkRLiZZNZo7bE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zpCNRoD/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpCNRoD/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B622A1F000C4;
	Sat, 17 Oct 2026 16:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253160;
	bh=zGEYEmPjyi58Td2dJGzOYUS6BJAwJ0RMHF6M20kvL8Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zpCNRoD/+Ig2q7m0yvmaBbD939uqbzL9oKLA+SO4CHmJmb3IW6ocEbecLLmHyEzEh
	 XfYSrWADu7n9TMlbyq5w7kgUjr9V1OwXgQfard7psaAGTOTKNOjh3ak1+Hk+7Z7fNa
	 SSBRFu2ZHf4W6tX4Ls7NeXLq7Z5zLeSG2vyOBt9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 030/869] namespace: check the mounts before reading their parents in pivot_root()
Date: Sat, 17 Oct 2026 17:47:51 +0200
Message-ID: <20261017160037.787018876@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced `return -EINVAL` with `goto out4` to preserve the syscall’s explicit cleanup path. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 11e6ddce877d5..2c23537a17d19 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4469,14 +4469,15 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
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



