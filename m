Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD5311CFEA9;
	Tue, 15 Oct 2024 13:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997546; cv=none; b=cOQvZqJwFkIq5G6c+blG/w/JQE7Ntyz/b+uNhiyodL5rVxL5PopMt24U/38F5O5Tr+WyAhGhiSTK/Ve6KKslMU4RGIQjFbX6d6dfTupz17R+Jm+mPtRG7XHrNIHf9pV7OH1kE/kuS+xWqQTz2cIGEd/qoaDjog57itI76YETlT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997546; c=relaxed/simple;
	bh=CWiBa/ohtmYg6T42YhHzjvbwxt8DWR+J+2GEcGwUJRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XY4u0dRg75dJyA3O1S2eiUx7lBzqSmJtB2W4tqOrNuOf7g4BISwMbSEUHHEz8wSGaRn1oAZMJfzi+rqy5v9jmsmPo9Mh9DVa5zlPvesYNhyOv0tVm0SH+9IZXZVq2BdxDpqQzO+vJq/ENW0dePuQ3Qv8f64v7ktMnnB7TCQiR7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N/Zn1VBL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/Zn1VBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02566C4CECE;
	Tue, 15 Oct 2024 13:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997546;
	bh=CWiBa/ohtmYg6T42YhHzjvbwxt8DWR+J+2GEcGwUJRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/Zn1VBLRUZ2J99LND531Z+AAoBMgLKd17JHToK81WKrojg5TVHA2kIU2SAw+P+g2
	 Erv5LZypHxzeMloZJjzD8q+JWHdhrtAshQ/WP2P5oO9XcSqMFKFaqiN9vuuMqjJoSr
	 CT0NvHKEQ13l4OdJGLStgFGL2qIZvvo9aIaa7hyw=
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
Subject: [PATCH 5.10 215/518] selinux,smack: dont bypass permissions check in inode_setsecctx hook
Date: Tue, 15 Oct 2024 14:41:59 +0200
Message-ID: <20241015123925.292367471@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[Shivani: Modified to apply on v5.10.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/selinux/hooks.c   |    3 ++-
 security/smack/smack_lsm.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -6570,7 +6570,8 @@ static int selinux_inode_notifysecctx(st
  */
 static int selinux_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
 {
-	return __vfs_setxattr_noperm(dentry, XATTR_NAME_SELINUX, ctx, ctxlen, 0);
+	return __vfs_setxattr_locked(dentry, XATTR_NAME_SELINUX, ctx, ctxlen, 0,
+				     NULL);
 }
 
 static int selinux_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4651,7 +4651,8 @@ static int smack_inode_notifysecctx(stru
 
 static int smack_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen)
 {
-	return __vfs_setxattr_noperm(dentry, XATTR_NAME_SMACK, ctx, ctxlen, 0);
+	return __vfs_setxattr_locked(dentry, XATTR_NAME_SMACK, ctx, ctxlen, 0,
+				     NULL);
 }
 
 static int smack_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen)


