Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 360112FA622;
	Tue, 17 Jun 2025 16:51:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179118; cv=none; b=L2nj3TftRFJDMWWG8JJsh/SKGMYGXuv3AznWyUc6svCa+736mzqFtNERoCO7dndTzd228tbHlz+oP4c2Jxwt5hoaR4GOH2IixzD2nF/L//1C7HGrSDBJuypgCNtp11+M0LLKwLL0Q7W84D6aSEXvtPsH3Bp/XwyGzw9kiPs3ZI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179118; c=relaxed/simple;
	bh=KHZlFHKIW1MoQoJN6y34/ZPz90Wa2rj29vX4kzkN44g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l0yenW2t308PPdN8QhlVKzfJyVJRrd9yFfx5hFxxtFTjmwU+/Dduuar5dJiInBkyYQ0pIMmNQPRoXPTHnv+Fo2/2xyTlFD92saYUn4GZOCURuBrH6x2VcNkzh5+bmG5fVVMJ9APi38u/r8wyUDqPVokWCB16zNvB+/TknuY5yT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OYOkPwkb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OYOkPwkb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1789C4CEE3;
	Tue, 17 Jun 2025 16:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179118;
	bh=KHZlFHKIW1MoQoJN6y34/ZPz90Wa2rj29vX4kzkN44g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OYOkPwkbsrjpnV6eClmIbVjuKkI9rEpI3Q3zTlXi0KhPrymM4Po0Oi9zta4ybbw2E
	 lrD4zzM8yZ4jeVcZ8mbKV0j72paOlmS0prqxvGgbgi9zo28stzKWjKbGvCJ6Mqvi8C
	 hjH2kmBB2UJ7QuchX8ZbG+MJJRBpbliXttIlH8Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Kazuma Kondo <kazuma-kondo@nec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 654/780] fs: allow clone_private_mount() for a path on real rootfs
Date: Tue, 17 Jun 2025 17:26:02 +0200
Message-ID: <20250617152518.106661152@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: KONDO KAZUMA(近藤　和真) <kazuma-kondo@nec.com>

[ Upstream commit 4954346d80fb047cb78776d9f2ebd6a050f80c5f ]

Mounting overlayfs with a directory on real rootfs (initramfs)
as upperdir has failed with following message since commit
db04662e2f4f ("fs: allow detached mounts in clone_private_mount()").

  [    4.080134] overlayfs: failed to clone upperpath

Overlayfs mount uses clone_private_mount() to create internal mount
for the underlying layers.

The commit made clone_private_mount() reject real rootfs because
it does not have a parent mount and is in the initial mount namespace,
that is not an anonymous mount namespace.

This issue can be fixed by modifying the permission check
of clone_private_mount() following [1].

Reviewed-by: Christian Brauner <brauner@kernel.org>
Fixes: db04662e2f4f ("fs: allow detached mounts in clone_private_mount()")
Link: https://lore.kernel.org/all/20250514190252.GQ2023217@ZenIV/ [1]
Link: https://lore.kernel.org/all/20250506194849.GT2023217@ZenIV/
Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Kazuma Kondo <kazuma-kondo@nec.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/namespace.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index e2780f413a2e0..07bc500a248ec 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2492,18 +2492,19 @@ struct vfsmount *clone_private_mount(const struct path *path)
 	if (IS_MNT_UNBINDABLE(old_mnt))
 		return ERR_PTR(-EINVAL);
 
-	if (mnt_has_parent(old_mnt)) {
-		if (!check_mnt(old_mnt))
-			return ERR_PTR(-EINVAL);
-	} else {
-		if (!is_mounted(&old_mnt->mnt))
-			return ERR_PTR(-EINVAL);
-
-		/* Make sure this isn't something purely kernel internal. */
-		if (!is_anon_ns(old_mnt->mnt_ns))
+	/*
+	 * Make sure the source mount is acceptable.
+	 * Anything mounted in our mount namespace is allowed.
+	 * Otherwise, it must be the root of an anonymous mount
+	 * namespace, and we need to make sure no namespace
+	 * loops get created.
+	 */
+	if (!check_mnt(old_mnt)) {
+		if (!is_mounted(&old_mnt->mnt) ||
+			!is_anon_ns(old_mnt->mnt_ns) ||
+			mnt_has_parent(old_mnt))
 			return ERR_PTR(-EINVAL);
 
-		/* Make sure we don't create mount namespace loops. */
 		if (!check_for_nsfs_mounts(old_mnt))
 			return ERR_PTR(-EINVAL);
 	}
-- 
2.39.5



