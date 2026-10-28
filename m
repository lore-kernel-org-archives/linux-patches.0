Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209193;
	b=jOSnAUpkIVmZI/cSU743uct8HGvFDwrgqHUgOtDNwLbAJjSXy7DwmVYjKvfUgDl+gbCV
	 U8Rq7FdbgwNEQfk3FkEZZrNPQxPh+TtVzQc6izWI/9uHxjSRIPTrUwI/GCScGls1Udjrr
	 PWzlcWplZ3Tm31VOCk9t8r3cA372hTSrhv7RHI0vuKpRQGfq3qVeGTfOLoqm80CClk7tn
	 4H9BZR07DT3aBUTPMfJ5O9s6wzSWoHqDW58eOARurXkvIvxMj2IufYqDV5oRdrOrl5rfV
	 Ta+0cwe0EC4RXV2RPcH+e0pggD60TDKmhKObQ8MVWqE2HfdjXeJKDUzwu1fBbYYRBlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZPfEeHZ7nVbOoWXHasRGG3oZW0dyZFN0BXxOcbgACTc=;
	b=05d4dUy2dsnDkNqEJ4+87NE+KDBFARmUg9c3D1hP0q2jYplhCET+a3phPq/HzKV4SlpE
	 BOGGw+s/Imz/EKZUbOFsofs6dyvClQcnRV70YOXB8LCWHUN5VupkEj/huM61mNSuNU4rN
	 4n8orTqJW+iYY6e6Yfl+u6nbizAvBcbiwN/jRTC7nb3W5ghfWM2zgo9PiB14optcXRzJY
	 +HR8gCLGymkOwaCpIXXk47azUykahXOIkyynCoFkK0lXCtSj+QDtPeJQlYafwXtGOe8/P
	 4NuIcTDkSfVdMBrOEB11hXsOtNoV943+FqUK308o8W/9CGdAWme2ID1g7H8RTCnk0YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mTopKI9H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C32C606A325;
	Wed, 28 Oct 2026 17:39:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mTopKI9H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD45F1F031E0;
	Wed, 28 Oct 2026 17:39:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209193;
	bh=ZPfEeHZ7nVbOoWXHasRGG3oZW0dyZFN0BXxOcbgACTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mTopKI9H1Tcj4mHM47sMbu5rHECRnzE5C8s9t/Kl+QnLgEeyMG6n0bSiEsJe+2X5L
	 5HmJt/WRStmveegjDEiAIpurQcs5yaxXpRVV4d8nUFvlO2W8IcwOAeVUA3fz/0Yrho
	 sUIbfYzUMxMvbaMTblhM4DP27ueTw78ht9sd8Dy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 386/516] namespace: check the mounts before reading their parents in pivot_root()
Date: Wed, 28 Oct 2026 17:58:58 +0100
Message-ID: <20261028170012.627317779@linuxfoundation.org>
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
[ sashal: Adapted the checks to the pivot_root syscall implementation using goto out4 instead of return -EINVAL. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index a87eb7fdc9838..9d1d5aa94215e 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3886,14 +3886,15 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
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



