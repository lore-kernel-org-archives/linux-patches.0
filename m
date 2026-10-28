Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211610;
	b=Fzu0Fa+Py5fGAETBbu2iaIWx7FOZ4kPXr37X4HkIQEQCw/EL/0k3oZPGF983Vc5C3nWE
	 I1kpJgr+QxA+3DEFuOu2631YspjnQq4KzoL1e3F/NJYarGuyP9m8LwwDNlrCT5PqE6vH2
	 XlO0TXD7IFEEXV1EJIkvTD0vHQ/StdfsWzbxBOsOHXHH0h0TYglcnhnWoP1OSE3LFpPGZ
	 8ZSN77i1X2xNGqn//R9qtHSSXX2FsZc+VIq/r5FfMJaHE279lJ+18P1vBKIV+2HLaHMUf
	 MkLeqWB0k5FGUq6VRl2yj7+wFnqLJtmCi36/SMaHRHCyj82Kl/AimAaze2neD8qmUuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rG2Bsf4cXFAbG+5cmAiE0g01XIlkXhzOgSrsOZ0JGhU=;
	b=RNaYjZXQ9ryo0Hax/I0WkQqtU7PPU0QvvBo4sjIiFT/TMjWfQifBNhJBUp5sjSbp7KHH
	 5srq/eEQPhvXO2opattaWkXqlIUimMk8tF+ASEQKyyCaz5rcvUxuib3ADZP/voEA2242O
	 dB3IMP6SXcYkbDgDD1+0pR/5exf+8HvhTCEywWBXufa329Lu+EAo8i+3WDR6+MJHZJQX2
	 N/3vjyGkGoEQKHdEOco0AJVMgSXOoMPn3fdDGVtmogKxYLlt7E6/3BYk6+k1eO6JzVLA4
	 1QatheAQqoj2gv0EdSMNLvngd0HsKyRiPWOZWKkNKvDEW6TfDNMk9/ETq89+4eW99Uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CpeCxpgi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED25F606A31C;
	Wed, 28 Oct 2026 18:20:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CpeCxpgi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46CF31F01825;
	Wed, 28 Oct 2026 18:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211609;
	bh=rG2Bsf4cXFAbG+5cmAiE0g01XIlkXhzOgSrsOZ0JGhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CpeCxpgiamsvv1uMrNQ+7slhov7qj+GW+JNu1xYUEJp5R1iTSmblHcwN1jYleGPyf
	 4+HMIpqGd5+Vz6Z2x+hADxR2BpSTZhKJBB59uTD/4M62wXTGtCxHiVF8VWhM6+8hDI
	 OITtJoQKmeBwx9jY1stZM+kXcvq1CS8u179CFfc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 438/571] namespace: check the mounts before reading their parents in pivot_root()
Date: Wed, 28 Oct 2026 17:59:45 +0100
Message-ID: <20261028170018.415481866@linuxfoundation.org>
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
[ sashal: Adapted the checks to the pivot_root syscall using goto out4 instead of returning -EINVAL. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 956283c52d365..d54306fa9ee57 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -3929,14 +3929,15 @@ SYSCALL_DEFINE2(pivot_root, const char __user *, new_root,
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



