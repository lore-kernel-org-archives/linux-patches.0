Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7338635CB7C;
	Fri,  4 Sep 2026 06:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502129; cv=none; b=MmZI5aQcpLSolNm6qdoJBOPFC+4/Te1MmJ+XpVF+QS1dGqvE6tsSm1F60OiXYXtV+BNrDZ7Jtt3NHGOP2Zgmi9Fi3im/ETtOJT7e+Wns0jk48O3dLnUVkkT2ZTu72d8G9HkaWXXhRLdEpM03l/P3YwcxUDXoYnLEJwGdUSA0slA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502129; c=relaxed/simple;
	bh=LX7yp+oLVclbIEK/T5oTNh1DqfJGcTTT3seRyheUasY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tOzHumTaGVY0uM3WWCh+ChA5f72KUyctLvzHRdmDAqQ2E8OQksNk0qff7IqYBwOBSTAUg+VjtGf8sGQ4Za1DMoRu01SMh/T3wzBQaDjSA3P9LGgJFH9lQnom19jVkki8pwkDxlIM5P9wm4a/P4NM7vjJTNTJ2IyK5hHqip8vclg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2Z0kda0K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2Z0kda0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C14591F00A3D;
	Fri,  4 Sep 2026 06:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502128;
	bh=PRaB7AE/b1J71bh13fWxt7Ews9UrzUrjkjSfZW0CA98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2Z0kda0K0EoK6627UMtmestyvF8SzY0ByxVw2xTd0/5uMOQ6fe7vdNjT6OWEaGMOr
	 autMN7MjW4Tbi3KcBI4sQ+V25n6I8LliMI73dN0d1HQfeTu3FmqDXViCNRI5vZq/Dp
	 Kizv0y1PC4sTz61TNiUB06r23o9ALRevNoiD4PAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.12 100/403] nfsd: gate nfs3 setacl by argp->mask
Date: Fri,  4 Sep 2026 06:58:23 +0200
Message-ID: <20260904045737.107685114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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


