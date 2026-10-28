Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211385;
	b=MGAVdFVfXPzoR7jCQ2EVYXC8Ncqfr+gYFpqPaay5S47wTX6nl947q8kJ221eTEHg3DnW
	 Z+Ujqr0CHSQTTM2DiSSXNbHXirK8rAt9S7IIoQmuQnmA9BNWZr6e3FiuxZ/Z27Yp1DEuU
	 fVarzI4LgsJt8WhiY5jeFlVJF1euuNE4RuBkcjx3CIFkFfuTVmZE4eGxfGMqn/28hLp4X
	 r6xivgUpJ37jVb4OyWX7hth5FG+v2fbbrLwIqMnn+O4lILx9JBN3lBYg3ho7RwZM1DqjV
	 N8JDqCvK9u7PAxCpj7D+iDGTZYITYjSOYsA4kJIidmgd7nbtINdGW4kD78F4/89v9dQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ourxh922c3rrI9o3+lu3jfcb95A+/lf5P3qgcWMaAgg=;
	b=nOQ9kOr9ZemhBJopoIDMazgv8pXIQScYTX+GBaFYBebTqZQlgZo4OfIEniFB9vSzUiUN
	 /XoUW5BGKKaJMhTceKAYE8pJ2OEB+vsgZveyLkf+6hTlGCFUQtqOAkIZFsN5fY5vVcqTk
	 Lipcdtp4X1h5LsTJUAC3S/kE0DBvN79SdO44V4g8dZrNZlUwdCt3+2u+84kOVHPGJK7Vq
	 rrehBXA3wUv2AaYvEkbNDrJ2gSZckiO5mZ5W4ErCxKQ7/PJtxM0oLvzk3OTqKy51wc4nB
	 gI6TPfhBoXI4mO5AW7yZ3cFEHBq9wzkeHVG8dK5Cs0X4CfSo12us9EQl6HFiX3/drgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yslJIWS9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC82606A325;
	Wed, 28 Oct 2026 18:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yslJIWS9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADFB1F01825;
	Wed, 28 Oct 2026 18:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211384;
	bh=ourxh922c3rrI9o3+lu3jfcb95A+/lf5P3qgcWMaAgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yslJIWS9p2rswNDYSmqMdWUUBFssFaWpvTNmTSOq54DZW/lvCs+T0m8SbmAfoe81u
	 H7KcZbV1M6IZ9Rl68mNuFZUSxgOZcNdfEmSDB7fm20eUOiBItL35MqHU+tc1REU2uL
	 emenpDqnPxLtiD1j0x5TFnuybYT5UkW3YAujPdHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.15 357/571] selinux: preserve NATIVE_LABELS on already-initialized sb in set_mnt_opts
Date: Wed, 28 Oct 2026 17:58:24 +0100
Message-ID: <20261028170016.487937903@linuxfoundation.org>
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
 
@@ -730,6 +734,9 @@ static int selinux_set_mnt_opts(struct s
 		/* previously mounted with options, but not on this attempt? */
 		if ((sbsec->flags & SE_MNTMASK) && !opts)
 			goto out_double_mount;
+		if ((kern_flags & SECURITY_LSM_NATIVE_LABELS) &&
+		    sbsec->behavior == SECURITY_FS_USE_NATIVE)
+			*set_kern_flags |= SECURITY_LSM_NATIVE_LABELS;
 		rc = 0;
 		goto out;
 	}


