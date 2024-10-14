Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7384D1BDC3;
	Mon, 14 Oct 2024 15:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918284; cv=none; b=lj3zUyjC7LkSi50yxXEZOCaH6DuU+YEoQs7g/ETe+IhkrPZm7rR4UPYaNyFaZYTgXhsfkxcXGRX9fLs4NPFQsTq9QZpgvnO3ff7Py7hWu3zFzZJUar54+XeE8AnkJvSVD08q2pefRFkTTfJ+huOjvToMQy4crb0TmlultetSCK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918284; c=relaxed/simple;
	bh=JF1ZLDEBHLWR6WkKmMVfgGsxnNfSDy3Y17xPhxx/lBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HQJ8r3W07w8ZSvyRB76/9X2H2usB/UoA9GMDCfBMc61394BNBFesKUK8zGZqR+t6LWyXMCL/jBp8c0kOyjjP+Q/vQ/pK1fMvV18OSyxBlZj3JRJaPtWx348QYn1D2583iyC1pbmMpHxBk25wY81pH69tgd50rVnh/71IdmevOUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o8m7mtCC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o8m7mtCC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D986BC4CEC3;
	Mon, 14 Oct 2024 15:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918284;
	bh=JF1ZLDEBHLWR6WkKmMVfgGsxnNfSDy3Y17xPhxx/lBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o8m7mtCCf0vh3QaG7MsSMZnLIyk3jSMRsIjvV13nX5x60w+wZAh8V8WA+8p36psWe
	 3dUgiezAWkA/2hsdC+HK14QxFVR3PqVh5G7cc8jQHEZGjTBi2MMREgxJrFimqd4LHs
	 +aWvsp7RFI7EOmApE9s4AZyiE7AUpHFSD/OGGnZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Marek Gresko <marek.gresko@protonmail.com>,
	Scott Mayhew <smayhew@redhat.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Paul Moore <paul@paul-moore.com>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 6.1 277/798] selinux,smack: dont bypass permissions check in inode_setsecctx hook
Date: Mon, 14 Oct 2024 16:13:51 +0200
Message-ID: <20241014141228.826708909@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

commit 76a0e79bc84f466999fa501fce5bf7a07641b8a7 upstream.

Marek Gresko reports that the root user on an NFS client is able to
change the security labels on files on an NFS filesystem that is
exported with root squashing enabled.

The end of the kerneldoc comment for __vfs_setxattr_noperm() states:

 *  This function requires the caller to lock the inode's i_mutex before it
 *  is executed. It also assumes that the caller will make the appropriate
 *  permission checks.

nfsd_setattr() does do permissions checking via fh_verify() and
nfsd_permission(), but those don't do all the same permissions checks
that are done by security_inode_setxattr() and its related LSM hooks do.

Since nfsd_setattr() is the only consumer of security_inode_setsecctx(),
simplest solution appears to be to replace the call to
__vfs_setxattr_noperm() with a call to __vfs_setxattr_locked().  This
fixes the above issue and has the added benefit of causing nfsd to
recall conflicting delegations on a file when a client tries to change
its security label.

Cc: stable@kernel.org
Reported-by: Marek Gresko <marek.gresko@protonmail.com>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=218809
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Tested-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reviewed-by: Stephen Smalley <stephen.smalley.work@gmail.com>
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Reviewed-by: Jeff Layton <jlayton@kernel.org>
Acked-by: Casey Schaufler <casey@schaufler-ca.com>
Signed-off-by: Paul Moore <paul@paul-moore.com>
[Shivani: Modified to apply on v5.15.y-v6.1.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c   |    4 ++--
 security/smack/smack_lsm.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6631,8 +6631,8 @@ static int selinux_inode_notifysecctx(st
  */
 static int selinux_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
 {
-	return __vfs_setxattr_noperm(&init_user_ns, dentry, XATTR_NAME_SELINUX,
-				     ctx, ctxlen, 0);
+	return __vfs_setxattr_locked(&init_user_ns, dentry, XATTR_NAME_SELINUX,
+				       ctx, ctxlen, 0, NULL);
 }
 
 static int selinux_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4714,8 +4714,8 @@ static int smack_inode_notifysecctx(stru
 
 static int smack_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
 {
-	return __vfs_setxattr_noperm(&init_user_ns, dentry, XATTR_NAME_SMACK,
-				     ctx, ctxlen, 0);
+	return __vfs_setxattr_locked(&init_user_ns, dentry, XATTR_NAME_SMACK,
+				     ctx, ctxlen, 0, NULL);
 }
 
 static int smack_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)


