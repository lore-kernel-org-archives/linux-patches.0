Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794972C11DF;
	Tue, 13 Oct 2026 12:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895750; cv=none; b=ncrVVeAM9S9FnZq2f0gQsNJNUrv6Kxdk6/qEznUWHSwIVitNbw/HuNyIxNJ3eiA4YGixIFgwXKQECuAXCSeshuSycXOC9OD/aukwjZeeT2F0xC6TXVzPbXscvdLeHRwZhrv5SWwnW9zceXsmpTuScFZjhuG9MVZHV8BOEDSEhZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895750; c=relaxed/simple;
	bh=v38yUxLsTGT++BShbElDLZRqJWsfdK70bppJJrok1a8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JFXhrQhEgVKtWjRcNyDfwTyElyPBN6k0xS3RYQ11qJ8asquZPyEOPC8SVKJOGD/RlLY+WKkvLD/PtXY3r711c6xGLiJD/Ff2tWu9ebOmbC0GO56Z+zwNmyYv1IgOkPWJkTVbpXDrbXVUyhPewFKpI3ZY4amqhm1fYuaYr65STrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zYgeA5Z8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zYgeA5Z8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6A41F000FF;
	Tue, 13 Oct 2026 12:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895749;
	bh=qhMGhMoa3iRBFk+1kVs5mS5mXNalTHe53W2bVwqwcas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zYgeA5Z8pTCXVyhS2rDirBFMeHkgtAd+fB+LviTXFrIt88cKfpCefDkEkUgXY+9/p
	 8yENo5fTvQK686Fx3CI+nbWme0b0yo2Zx9L5TIstYl3EA32ncsJM5OCG1BpRyRZtgo
	 uCLD9TPss3/uMGO4jqTUe0c1KmLcTZC4XYDke93Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.12 381/497] selinux: preserve NATIVE_LABELS on already-initialized sb in set_mnt_opts
Date: Tue, 13 Oct 2026 13:39:08 +0200
Message-ID: <20261013112916.940247716@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -677,8 +677,12 @@ static int selinux_set_mnt_opts(struct s
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
 
@@ -722,6 +726,9 @@ static int selinux_set_mnt_opts(struct s
 		/* previously mounted with options, but not on this attempt? */
 		if ((sbsec->flags & SE_MNTMASK) && !opts)
 			goto out_double_mount;
+		if ((kern_flags & SECURITY_LSM_NATIVE_LABELS) &&
+		    sbsec->behavior == SECURITY_FS_USE_NATIVE)
+			*set_kern_flags |= SECURITY_LSM_NATIVE_LABELS;
 		rc = 0;
 		goto out;
 	}


