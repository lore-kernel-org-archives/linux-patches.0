Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997944D8D93;
	Tue, 13 Oct 2026 11:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892065; cv=none; b=axw4Jvntlxwr3tk5+cs8xK9CEP5RNfpfD6vtowrM+xJ6hgLLOwXE5JidXAjjlwSLpLHrFBU2ChFMXz6Z90dp5yL9BwOItWc8bKLcYMhEjAp+dqrJ1BrHZsNQrdetSPUjLfLqrivcPtj2hbaGyJ2pXibW4mqMhCdDAWvzuaPUtD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892065; c=relaxed/simple;
	bh=tYVAdOWyK0TqZEK8k2yJkPR71I9Q5uktqPvyCjfhwVI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a/1GgtBke4MP1dQ0+Ufzj/4Iecbk28FRPNn52IY0G6+0IGV6Xn6MpjiEDyVP/Ull4A9X5ZuJZyM8uj1U0HtYpP52DhtE5fW7KULeJIgOqiJGTLkrCu2yeQH8PgQOj3WJawhHUDac2i/GDcrBOaU+q+ayOeZ82ag148zriIudQvI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nBm0Ujkx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nBm0Ujkx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E46DA1F00893;
	Tue, 13 Oct 2026 11:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892063;
	bh=nFUukWc7EF20XsMR45D7MActQDF1FiSuy19O+JJUxiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nBm0Ujkx3SzSoN39gclM3tMIpKysRmSuclBFYgr56dvVUv1lEKUjHpYsx8uHnogDw
	 h5cJfi3bT9KZtjnFhHdjZ562kRFuPrMxElqMFHvbq+Wh2VXBYsH9xapp3A8pyKeeEB
	 E8WMixygcoA0pqAgVH8zivnoSfYBAdwGgmTu7fGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 7.2 048/281] selinux: preserve NATIVE_LABELS on already-initialized sb in set_mnt_opts
Date: Tue, 13 Oct 2026 13:36:04 +0200
Message-ID: <20261013112856.217426264@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen Smalley <stephen.smalley.work@gmail.com>

commit 28b7260548af3d35773477993ad4e4de41578dd7 upstream.

When an NFSv4 filesystem exported with security_label is mounted a
second time, sget_fc() returns the existing superblock and
nfs_get_root() calls security_sb_set_mnt_opts() again on it. Since the
superblock is already SB_INITIALIZED, selinux_set_mnt_opts() takes an
early exit without setting SECURITY_LSM_NATIVE_LABELS in
*set_kern_flags. nfs_get_root() then sees kflags without
SECURITY_LSM_NATIVE_LABELS set and clears NFS_CAP_SECURITY_LABEL on
the shared nfs_server, silently disabling per-file labeling for both
the new and the original mount.

Commit 3815a245b501 ("security/selinux: fix SECURITY_LSM_NATIVE_LABELS
on reused superblock") fixed the same problem in
selinux_sb_clone_mnt_opts().  The reused-superblock path for a plain
second mount now goes through sb_set_mnt_opts rather than
sb_clone_mnt_opts, so it needs the same treatment: on both
SE_SBINITIALIZED early exits, set SECURITY_LSM_NATIVE_LABELS in
*set_kern_flags when the superblock was already using
SECURITY_FS_USE_NATVE.

Cc: stable@vger.kernel.org
Closes: https://github.com/SELinuxProject/selinux-kernel/issues/69
Closes: https://github.com/SELinuxProject/selinux-kernel/issues/70
Closes: https://github.com/SELinuxProject/selinux-testsuite/issues/91
Closes: https://github.com/SELinuxProject/selinux-testsuite/issues/92
Fixes: eb9ae686507b ("SELinux: Add new labeling type native labels")
Signed-off-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -688,8 +688,12 @@ static int selinux_set_mnt_opts(struct s
 	 * will be used for both mounts)
 	 */
 	if ((sbsec->flags & SE_SBINITIALIZED) && (sb->s_type->fs_flags & FS_BINARY_MOUNTDATA)
-	    && !opts)
+		&& !opts) {
+		if ((kern_flags & SECURITY_LSM_NATIVE_LABELS) &&
+		    sbsec->behavior == SECURITY_FS_USE_NATIVE)
+			*set_kern_flags |= SECURITY_LSM_NATIVE_LABELS;
 		goto out;
+	}
 
 	root_isec = backing_inode_security_novalidate(root);
 
@@ -733,6 +737,9 @@ static int selinux_set_mnt_opts(struct s
 		/* previously mounted with options, but not on this attempt? */
 		if ((sbsec->flags & SE_MNTMASK) && !opts)
 			goto out_double_mount;
+		if ((kern_flags & SECURITY_LSM_NATIVE_LABELS) &&
+		    sbsec->behavior == SECURITY_FS_USE_NATIVE)
+			*set_kern_flags |= SECURITY_LSM_NATIVE_LABELS;
 		rc = 0;
 		goto out;
 	}


