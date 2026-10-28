Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209025;
	b=aTBg8PzNGsOnIrKUUTPiJyRSbctoCIbzfELZyOUmBqWnVcNGHk5xQcboPd7HykHiJfWd
	 peWI03C1ZhSng50SFBN7U2GTsQUfJi63Ws1CXe2/Ce+KWQEIWXByFaz546i9pu+gqTmDU
	 dn5Zo0M+DfeX8QkSf/dS6JKUCqVkLWV8pL9tUvhRh6KbYWjPD3eVTtTXFp2tF2fMTLV0Q
	 kLuS95mfHvMxE9BD9Nomjrda9eu0C+uL5oMSJAcB1dpXS0oRILZRYxSGeU+SCcOH7uGj0
	 9xzSvVvpVxSmGYN802JEzZpUYsZn8Ahw2vKm5eQhXkKHy0F/UxG7P1gQkXacOn/9pdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s7uaoYeR2/hnKLQTChjpVKwKbq6Lx7trGZhP52ZkS58=;
	b=flyAukNJvJlukocYY8Np28onv85HmcPEIQ+5wJ2rWkEIms4w/smqIm0CA+8dZ78osGSD
	 ekyV9xZeU4NK63uYM1YohTkysoGLfrzlNsKh24XAOmTEAp8TuYZfr873iujZetvxZPT9X
	 Nd3zzc2rJK4bNGHj7B/yctk/t3+S6HNR9KuY/q4F1bvb6SLJytBBpG+ehXrUGYrJZHLN8
	 bJPYfLk291vltHjF9EqBNx4hIP3SF8qdP8ELpsSg0eKHpsT3G2beKOxv45lLQSFqgGqm0
	 XrxhE2CjSC2opARPEMLWtmQZZllN8i97+Bc1QoonkdslPWGBHLQ/BJKQf2jgDFj4IPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jz5nbGgV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 618C8606A31F;
	Wed, 28 Oct 2026 17:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jz5nbGgV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE891F01829;
	Wed, 28 Oct 2026 17:37:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209025;
	bh=s7uaoYeR2/hnKLQTChjpVKwKbq6Lx7trGZhP52ZkS58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jz5nbGgVOzhgNiknbtr8DrQfS10CNAdlK1gYGtbhSjefG7fEW/Y45qlNFZ0spr8s3
	 YwDKN+R7rvIh9HG3klNvdPOi5PjK+IOSvFVYnu33Ma9dImfHQoZyz2IaA+Nzc4dF6P
	 6M9G8Krlw/XkrfTb4C4AZcdTpbZiDwTgIcP0wCfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 5.10 324/516] selinux: preserve NATIVE_LABELS on already-initialized sb in set_mnt_opts
Date: Wed, 28 Oct 2026 17:57:56 +0100
Message-ID: <20261028170011.162974859@linuxfoundation.org>
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
@@ -640,8 +640,12 @@ static int selinux_set_mnt_opts(struct s
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
 
@@ -693,6 +697,9 @@ static int selinux_set_mnt_opts(struct s
 		/* previously mounted with options, but not on this attempt? */
 		if ((sbsec->flags & SE_MNTMASK) && !opts)
 			goto out_double_mount;
+		if ((kern_flags & SECURITY_LSM_NATIVE_LABELS) &&
+		    sbsec->behavior == SECURITY_FS_USE_NATIVE)
+			*set_kern_flags |= SECURITY_LSM_NATIVE_LABELS;
 		rc = 0;
 		goto out;
 	}


