Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C60455622;
	Sat, 12 Sep 2026 13:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219894; cv=none; b=QkdDJngkTO5PiA/HOy/5lDvobYvz8l0rvREXpbP4p+syv8A0TxCylaZg9mUS9AlU+Tlxoy0/yL7VGPVg7MZ31vy4baGhofj21ujge7jHJDUAm8x7nV6gkRBrZUMjyZZfkRNxDh8M1Hf3TLg2hOvKDry+bqpuDoe+hDpWzbsORD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219894; c=relaxed/simple;
	bh=izwfuLFQFdrhA9XB30Y93VHqMzxn3mKMkJx1aWsIjyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pXgmKUqCJfaFb8vr3jeJgSWaabwdeMjrv7vMYkd2anCLe7qheVVov/y1yq7JQwa7OB9XSp0E/sMABUOrt+dYy71knfNQSRadwuA0UJRjzBaB/WMlP5lUvev4yDX8n8lmB5kzzv/xDvz0muU/u4U1YMKlwt0ZlPQ7QrjCHGWib3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AWG+2ZYa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AWG+2ZYa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48991F000FF;
	Sat, 12 Sep 2026 13:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219893;
	bh=59bVnq5HbACPLTsy0p/G541sMO212QrFB66jff5+nDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AWG+2ZYaW9rRTULb8/X37t37isfA3KQSRONi/QcGs9RdgWCbQK3mpFK9IFGy8myWq
	 MefGyxPiQufg6gRj6Ft/n2nArZiW1qTStCPmRa/ne5BDl+4FeK/9v1ooPBNz4Fx7D0
	 N0DWlnJ+mFgXHtrsiP7IMcAZXILDqSrZq+r8hsDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.6 0064/1424] nfsd: gate nfs2 setacl by argp->mask
Date: Sat, 12 Sep 2026 08:41:36 +0200
Message-ID: <20260912065608.739741863@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

commit a3a7e20ed66d3f04d37883c398da8a113b430769 upstream.

The NFSACL v2 SETACL path shares the decoder convention used by its
v3 sibling: nfsaclsvc_decode_setaclargs() fills in argp->acl_access
only when NFS_ACL is set in the request mask and argp->acl_default
only when NFS_DFACL is set, leaving the other pointer NULL because
the argument buffer is zeroed up to pc_argzero before decode.

nfsacld_proc_setacl() then hands both pointers to set_posix_acl()
unconditionally. set_posix_acl(idmap, dentry, type, NULL) is the VFS
"remove this ACL type" operation, so an omitted arm is
indistinguishable from an explicit request to delete that ACL. A
SETACL carrying only NFS_ACL silently strips the directory's default
ACL; mask=0 strips both.

This is the same defect just fixed in nfsd3_proc_setacl(); apply the
same remedy. Gate each set_posix_acl() call on its mask bit and
initialize error to 0 so that a request with neither bit set leaves
the on-disk ACLs untouched and returns success. The out_drop_lock
path and the unconditional posix_acl_release() in
nfsaclsvc_release_setacl() already tolerate the skipped arms.

Fixes: a257cdd0e217 ("[PATCH] NFSD: Add server support for NFSv3 ACLs.")
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs2acl.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/fs/nfsd/nfs2acl.c
+++ b/fs/nfsd/nfs2acl.c
@@ -115,14 +115,19 @@ static __be32 nfsacld_proc_setacl(struct
 
 	inode_lock(inode);
 
-	error = set_posix_acl(&nop_mnt_idmap, fh->fh_dentry, ACL_TYPE_ACCESS,
-			      argp->acl_access);
-	if (error)
-		goto out_drop_lock;
-	error = set_posix_acl(&nop_mnt_idmap, fh->fh_dentry, ACL_TYPE_DEFAULT,
-			      argp->acl_default);
-	if (error)
-		goto out_drop_lock;
+	error = 0;
+	if (argp->mask & NFS_ACL) {
+		error = set_posix_acl(&nop_mnt_idmap, fh->fh_dentry,
+				      ACL_TYPE_ACCESS, argp->acl_access);
+		if (error)
+			goto out_drop_lock;
+	}
+	if (argp->mask & NFS_DFACL) {
+		error = set_posix_acl(&nop_mnt_idmap, fh->fh_dentry,
+				      ACL_TYPE_DEFAULT, argp->acl_default);
+		if (error)
+			goto out_drop_lock;
+	}
 
 	inode_unlock(inode);
 


