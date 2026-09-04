Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9235C38E8DD;
	Fri,  4 Sep 2026 05:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498813; cv=none; b=tInaB07lv4BpnTEg5gBN28eI/ddam2OeSudssyJA+jrTPJrTOJ7gGLiWom+0m9vS7bJrAphO+6o5n3YOMbW7MKaf3vEi9LYjuC2pFaGYDP2bQiz+Ccknd6CP1xgxtJ/iBVdN5In4ErFc9wfuRSaGQ/CNc7RQRck8IblgX5LK030=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498813; c=relaxed/simple;
	bh=bjrKAoYxCqed5b3SbXkIiUIbm6RBlQ0tP4iULNANPOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIyO+XKROU5Lh6nzAPMgfKTyHkVc5HdEgkqZAqVwXlLaaehWh+9disTwR3dS8eJF16BpBBIwGSQgW39cT0s1W6fkFp1oMd3KC2nyyg9mahyAS6Ex6nFkYOXmKn1czyj/Ss076s61qCtQh4jBDYwQlrg42v01QcoOuFOPMGJ/04A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KRRs/rF8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KRRs/rF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEBAC1F00A3D;
	Fri,  4 Sep 2026 05:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498812;
	bh=scMY630ITiwN1ES049Xe0OJ+Vz+huMEtCZmDPUgDrnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KRRs/rF8044UohvKo8U8zfFhbXQpLEE7EptXq/91zOD0KPtTbRw25iAc9tYTwGhJc
	 RgGaJRgiQVbfWjmSxnYXwKR36yCOytrqwPpPIk5CMYw/vKcmjDDNtoJUJh3jpUl+EE
	 eGA3WyGWnIGNPXE6Sr6Gufat8O4/vuHrN7NQLNV4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.2 196/713] nfsd: gate nfs3 setacl by argp->mask
Date: Fri,  4 Sep 2026 06:52:44 +0200
Message-ID: <20260904045808.205700084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Chris Mason <clm@meta.com>

commit 453d7198a0ab07a12d46e0575861ac7b932da17e upstream.

nfsd3_proc_setacl() calls set_posix_acl() unconditionally for both
ACL_TYPE_ACCESS and ACL_TYPE_DEFAULT, passing argp->acl_access and
argp->acl_default verbatim. The NFSv3 ACL decoder only populates
those pointers when the corresponding mask bit is set:

    nfs3svc_decode_setaclargs()
      if (args->mask & NFS_ACL)    decode into acl_access
      if (args->mask & NFS_DFACL)  decode into acl_default
      /* otherwise the pointer stays NULL (pc_argzero) */

    nfsd3_proc_setacl()
      set_posix_acl(.., ACL_TYPE_ACCESS,  argp->acl_access)
      set_posix_acl(.., ACL_TYPE_DEFAULT, argp->acl_default)

set_posix_acl(idmap, dentry, type, NULL) is the VFS "remove this
ACL type" operation. A NULL pointer that means "the client did not
send this arm" is therefore indistinguishable from "the client
asked to remove this ACL". A SETACL with mask=NFS_ACL silently
drops the directory's default ACL; mask=0 drops both.

The sibling nfsd3_proc_getacl() already consults argp->mask before
touching each arm; mirror that in setacl.

Fix by wrapping each set_posix_acl() call in the matching mask bit
check and initializing error to 0 before inode_lock so that a
request with neither bit set leaves the on-disk ACLs untouched and
returns nfs_ok. The out_drop_lock path and the unconditional
posix_acl_release() at out: are preserved; both NULL-tolerate the
skipped arms.

Fixes: a257cdd0e217 ("[PATCH] NFSD: Add server support for NFSv3 ACLs.")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-7
Reported-by: Chris Mason <clm@meta.com>
Signed-off-by: Chris Mason <clm@meta.com>
Link: https://patch.msgid.link/20260530-nfsd-fixes-v2-5-f27e8eb4d974@kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs3acl.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/fs/nfsd/nfs3acl.c
+++ b/fs/nfsd/nfs3acl.c
@@ -105,12 +105,17 @@ static __be32 nfsd3_proc_setacl(struct s
 
 	inode_lock(inode);
 
-	error = set_posix_acl(&nop_mnt_idmap, fh->fh_dentry, ACL_TYPE_ACCESS,
-			      argp->acl_access);
-	if (error)
-		goto out_drop_lock;
-	error = set_posix_acl(&nop_mnt_idmap, fh->fh_dentry, ACL_TYPE_DEFAULT,
-			      argp->acl_default);
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
+	}
 
 out_drop_lock:
 	inode_unlock(inode);


