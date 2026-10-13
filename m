Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5C854F93C0;
	Tue, 13 Oct 2026 12:06:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893185; cv=none; b=n2kD2KGh/fqtXATnuRGII1/8jLU52mAVzIQdePdCE31Tjp4+OjFL8gVIQC7h+VHxq6kBgZxMkg9xNx4S5QPzi7K70jrFkOO9vEIt34EwbrODSUNtUdBW+vFkriLY609QXw26fPihEzaL31iAHxu3Zk25h+OArh4luiwNxxGPITk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893185; c=relaxed/simple;
	bh=0lmTwFps8WdJ2QGLgOZAYKHLkkwYZf7Qg+ZD1hUvyaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cr7ZSx/Crev8CHPWJj1rIyERmQOy4Iidyd/diCFlO2E32wibgBObHIVMrzFmjYBudthoJkYR3jiGNd/N45v2msNhcqSac8+UG0ciCyU/sTNrluWU0Onm9x+y1bVMRNEy2CYkWt2bZf0SL5wIFn42a4yDzt1B/wnnqwgitRv/VJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPyZc9XY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPyZc9XY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAB801F000FF;
	Tue, 13 Oct 2026 12:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893183;
	bh=/c5StEwhTnX86SrlPR65SgMlp0cMQF08sKD1BKroMF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JPyZc9XYynR3zjMflyGJkva7Jg0SIkhC5JIzGVRnI0ni0UlCfTJCIReNlc4qyIuzP
	 TJ4UfKhfg9Z2PMJCax7lWb32nMLicVCtLloV9PUA5W+3T1ggLBDQ+47eRaJuu0zEYj
	 fjhYanFgKvdOwOr1y1LxAzokk4ewE4nVQMkzivPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 6.18 140/621] namespace: check the mounts before reading their parents in pivot_root()
Date: Tue, 13 Oct 2026 13:32:15 +0200
Message-ID: <20261013112924.178441819@linuxfoundation.org>
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

commit 6b7c001eb5857fa09041f47673666060a2e5fc1c upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/namespace.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -4635,14 +4635,15 @@ SYSCALL_DEFINE2(pivot_root, const char _
 
 	new_mnt = real_mount(new.mnt);
 	root_mnt = real_mount(root.mnt);
+	/* only a mounted mount has a parent that namespace_sem pins */
+	if (!check_mnt(root_mnt) || !check_mnt(new_mnt))
+		return -EINVAL;
 	ex_parent = new_mnt->mnt_parent;
 	root_parent = root_mnt->mnt_parent;
 	if (IS_MNT_SHARED(old_mnt) ||
 		IS_MNT_SHARED(ex_parent) ||
 		IS_MNT_SHARED(root_parent))
 		return -EINVAL;
-	if (!check_mnt(root_mnt) || !check_mnt(new_mnt))
-		return -EINVAL;
 	if (new_mnt->mnt.mnt_flags & MNT_LOCKED)
 		return -EINVAL;
 	if (d_unlinked(new.dentry))


