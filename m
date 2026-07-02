Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E0CE3093DD;
	Thu,  2 Jul 2026 17:02:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011723; cv=none; b=bLXJ2X7os1hxYFXVBs4PobpmXlWu8TYBDxw5+lfIRj8UfZ1JirOjnQCMKURVF2Ra4rMu7gJD8uFMxE8KYx80u1rdqxJmR0sVe/YU5bOdHGvpyp5F892x7CPshTcd76F/U7WuCindcVMtSdXIDxRULh+GmDd7auVylh+qBrlhkVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011723; c=relaxed/simple;
	bh=bsO6mVGAdXWjUkXENMAU/w6BvjdMMG9PFPX2VBOOb7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0s45fvTh973kWzzKXlbC3dUdYyqq5b2Y8fA6PWDxdMzwOvuzzmclYwGiW4zK1NG8fN1/2FcFYZfbZcOyFndcykznGFdDG+QnvEHI7pCSyJsLSTW2YswjHBaAjEfM0KRzNmt+V8D6apnlJlwwNlz/mAUx/6ELl9ly6wGC2qs1Bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kfle8sEM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kfle8sEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4EED1F000E9;
	Thu,  2 Jul 2026 17:02:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011722;
	bh=B27vaD92WwIphFNkjsu3/pg54s3eEq3xLlKrF6A4fUQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kfle8sEMY1JcuU//8yx9sHlhUaKpER4yreZnN1e8pBYscEZEdCm1hPLKD+GTZ1IW9
	 LoTcnyp2CsUL5YgDptqTP1BLbWqTTZcd5slOFWcdzON1o1/W4vffPO2203w4ylCtkc
	 GcXbIUFWXd6uCMboegyfYOiIO7AiEFHvX0aVepeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 7.1 109/120] nfsd: fix posix_acl leak and ignored error in nfsd4_create_file
Date: Thu,  2 Jul 2026 18:21:45 +0200
Message-ID: <20260702155115.214081808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
References: <20260702155112.964534952@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 24c975bbdd564d7d0ad90294bfa69729830345de upstream.

nfsd4_create_file() has two bugs in its ACL handling:

The return value of nfsd4_acl_to_attr() is silently discarded.  When
the NFSv4-to-POSIX ACL conversion fails (e.g., -EINVAL for
unsupported ACE types), the file is created without any ACL and the
client receives NFS4_OK.  This violates RFC 7530/8881 which require
the server to reject unsupported attributes on CREATE.

When start_creating() fails after ACL attributes have been populated
in attrs (either via nfsd4_acl_to_attr or via ownership transfer from
open->op_dpacl/op_pacl), the function jumps to out_write which skips
nfsd_attrs_free().  The posix_acl allocations are leaked.  A client
can trigger this repeatedly with OPEN(CREATE), ACL attributes, and an
invalid filename (e.g., longer than NAME_MAX).

Fix both by capturing the nfsd4_acl_to_attr() return value and by
changing the early error paths to jump to out instead of out_write.
Initialize child to ERR_PTR(-EINVAL) so that end_creating() is safe
to call even if start_creating() was never reached.

Reported-by: Chris Mason <clm@meta.com>
Fixes: 7ab96df840e6 ("VFS/nfsd/cachefiles/ovl: add start_creating() and end_creating()")
Cc: stable@vger.kernel.org
Assisted-by: kres:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/nfs4proc.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -253,7 +253,7 @@ nfsd4_create_file(struct svc_rqst *rqstp
 		.na_iattr	= iap,
 		.na_seclabel	= &open->op_label,
 	};
-	struct dentry *parent, *child;
+	struct dentry *parent, *child = ERR_PTR(-EINVAL);
 	__u32 v_mtime, v_atime;
 	struct inode *inode;
 	__be32 status;
@@ -277,10 +277,14 @@ nfsd4_create_file(struct svc_rqst *rqstp
 	if (open->op_acl) {
 		if (open->op_dpacl || open->op_pacl) {
 			status = nfserr_inval;
-			goto out_write;
+			goto out;
+		}
+		if (is_create_with_attrs(open)) {
+			status = nfsd4_acl_to_attr(NF4REG, open->op_acl,
+						   &attrs);
+			if (status)
+				goto out;
 		}
-		if (is_create_with_attrs(open))
-			nfsd4_acl_to_attr(NF4REG, open->op_acl, &attrs);
 	} else if (is_create_with_attrs(open)) {
 		/* The dpacl and pacl will get released by nfsd_attrs_free(). */
 		attrs.na_dpacl = open->op_dpacl;
@@ -293,7 +297,7 @@ nfsd4_create_file(struct svc_rqst *rqstp
 			       &QSTR_LEN(open->op_fname, open->op_fnamelen));
 	if (IS_ERR(child)) {
 		status = nfserrno(PTR_ERR(child));
-		goto out_write;
+		goto out;
 	}
 
 	if (d_really_is_negative(child)) {
@@ -407,7 +411,6 @@ set_attr:
 out:
 	end_creating(child);
 	nfsd_attrs_free(&attrs);
-out_write:
 	fh_drop_write(fhp);
 	return status;
 }


