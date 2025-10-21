Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1EE350A2A;
	Tue, 21 Oct 2025 19:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076690; cv=none; b=p4KO+dkay5/l7VC/t4R0SIZC95+9hw70RRnf0tVnBkx0VzKtsEZ35NaTRolCTd2WNg0eI/A31dDPqShhCLqCWpQGoHIHlKVJX0TlpU4NSqFqNENuUBWgBCbtdCl3fLbxryTajcgRDNPrFbekQqpFHx8aZZtMiKcB1RtWZwqTdyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076690; c=relaxed/simple;
	bh=fCv3RlD/BtvkgOeL6/zXEvNzoI8q9VJmW/ND8RSpSHU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQmG5aQkMceE/USqc9Se2++82yY+R/3lfq9uPTkJ05HMSYrnUIsFe6CMRQdn/n5jQIq6TjpNI1SoB2GYSFamUnULugcDgZ6ad7djdcqN9iN7Qqn6CRxvL83vqYem1GIa7FMDQFsXrPyoturH+8NWfUD1F3qiSm3qw75Gl7mpXsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3W9vTaW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3W9vTaW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1E8C4CEF1;
	Tue, 21 Oct 2025 19:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076689;
	bh=fCv3RlD/BtvkgOeL6/zXEvNzoI8q9VJmW/ND8RSpSHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3W9vTaWycyyJry4svmckl4Grlhte0j+NeNqKL6ZqsVk13eaN9aIHnJVxAw/gKu4M
	 e9TqFLCySx2H8NZGmD0Ppr+t2UjF2UGw9r/Iq+kjEwj9DRK2ry+aA1nFIoKNEAFESj
	 171QmeXfiRha6e49+2+gJ9+WfVlmu/GDJ9PqXOuI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	chuck.lever@oracle.com,
	Scott Mayhew <smayhew@redhat.com>
Subject: [PATCH 6.6 099/105] nfsd: decouple the xprtsec policy check from check_nfsd_access()
Date: Tue, 21 Oct 2025 21:51:48 +0200
Message-ID: <20251021195024.004492578@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195021.492915002@linuxfoundation.org>
References: <20251021195021.492915002@linuxfoundation.org>
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

From: Scott Mayhew <smayhew@redhat.com>

[ Upstream commit e4f574ca9c6dfa66695bb054ff5df43ecea873ec ]

This is a backport of e4f574ca9c6d specifically for the 6.6-stable
kernel.  It differs from the upstream version mainly in that it's
working around the absence of some 6.12-era commits:
- 1459ad57673b nfsd: Move error code mapping to per-version proc code.
- 0a183f24a7ae NFSD: Handle @rqstp == NULL in check_nfsd_access()
- 5e66d2d92a1c nfsd: factor out __fh_verify to allow NULL rqstp to be
  passed

A while back I had reported that an NFSv3 client could successfully
mount using '-o xprtsec=none' an export that had been exported with
'xprtsec=tls:mtls'.  By "successfully" I mean that the mount command
would succeed and the mount would show up in /proc/mount.  Attempting
to do anything futher with the mount would be met with NFS3ERR_ACCES.

Transport Layer Security isn't an RPC security flavor or pseudo-flavor,
so we shouldn't be conflating them when determining whether the access
checks can be bypassed.  Split check_nfsd_access() into two helpers, and
have fh_verify() call the helpers directly since fh_verify() has
logic that allows one or both of the checks to be skipped.  All other
sites will continue to call check_nfsd_access().

Link: https://lore.kernel.org/linux-nfs/ZjO3Qwf_G87yNXb2@aion/
Fixes: 9280c5774314 ("NFSD: Handle new xprtsec= export option")
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Acked-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/export.c |   60 +++++++++++++++++++++++++++++++++++++++++++++++--------
 fs/nfsd/export.h |    2 +
 fs/nfsd/nfsfh.c  |   12 ++++++++++-
 3 files changed, 65 insertions(+), 9 deletions(-)

--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1071,28 +1071,62 @@ static struct svc_export *exp_find(struc
 	return exp;
 }
 
-__be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp)
+/**
+ * check_xprtsec_policy - check if access to export is allowed by the
+ * 			  xprtsec policy
+ * @exp: svc_export that is being accessed.
+ * @rqstp: svc_rqst attempting to access @exp.
+ *
+ * Helper function for check_nfsd_access().  Note that callers should be
+ * using check_nfsd_access() instead of calling this function directly.  The
+ * one exception is fh_verify() since it has logic that may result in one
+ * or both of the helpers being skipped.
+ *
+ * Return values:
+ *   %nfs_ok if access is granted, or
+ *   %nfserr_acces or %nfserr_wrongsec if access is denied
+ */
+__be32 check_xprtsec_policy(struct svc_export *exp, struct svc_rqst *rqstp)
 {
-	struct exp_flavor_info *f, *end = exp->ex_flavors + exp->ex_nflavors;
 	struct svc_xprt *xprt = rqstp->rq_xprt;
 
 	if (exp->ex_xprtsec_modes & NFSEXP_XPRTSEC_NONE) {
 		if (!test_bit(XPT_TLS_SESSION, &xprt->xpt_flags))
-			goto ok;
+			return nfs_ok;
 	}
 	if (exp->ex_xprtsec_modes & NFSEXP_XPRTSEC_TLS) {
 		if (test_bit(XPT_TLS_SESSION, &xprt->xpt_flags) &&
 		    !test_bit(XPT_PEER_AUTH, &xprt->xpt_flags))
-			goto ok;
+			return nfs_ok;
 	}
 	if (exp->ex_xprtsec_modes & NFSEXP_XPRTSEC_MTLS) {
 		if (test_bit(XPT_TLS_SESSION, &xprt->xpt_flags) &&
 		    test_bit(XPT_PEER_AUTH, &xprt->xpt_flags))
-			goto ok;
+			return nfs_ok;
 	}
-	goto denied;
 
-ok:
+	return rqstp->rq_vers < 4 ? nfserr_acces : nfserr_wrongsec;
+}
+
+/**
+ * check_security_flavor - check if access to export is allowed by the
+ * 			  xprtsec policy
+ * @exp: svc_export that is being accessed.
+ * @rqstp: svc_rqst attempting to access @exp.
+ *
+ * Helper function for check_nfsd_access().  Note that callers should be
+ * using check_nfsd_access() instead of calling this function directly.  The
+ * one exception is fh_verify() since it has logic that may result in one
+ * or both of the helpers being skipped.
+ *
+ * Return values:
+ *   %nfs_ok if access is granted, or
+ *   %nfserr_acces or %nfserr_wrongsec if access is denied
+ */
+__be32 check_security_flavor(struct svc_export *exp, struct svc_rqst *rqstp)
+{
+	struct exp_flavor_info *f, *end = exp->ex_flavors + exp->ex_nflavors;
+
 	/* legacy gss-only clients are always OK: */
 	if (exp->ex_client == rqstp->rq_gssclient)
 		return 0;
@@ -1117,10 +1151,20 @@ ok:
 	if (nfsd4_spo_must_allow(rqstp))
 		return 0;
 
-denied:
 	return rqstp->rq_vers < 4 ? nfserr_acces : nfserr_wrongsec;
 }
 
+__be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp)
+{
+	__be32 status;
+
+	status = check_xprtsec_policy(exp, rqstp);
+	if (status != nfs_ok)
+		return status;
+
+	return check_security_flavor(exp, rqstp);
+}
+
 /*
  * Uses rq_client and rq_gssclient to find an export; uses rq_client (an
  * auth_unix client) if it's available and has secinfo information;
--- a/fs/nfsd/export.h
+++ b/fs/nfsd/export.h
@@ -100,6 +100,8 @@ struct svc_expkey {
 #define EX_WGATHER(exp)		((exp)->ex_flags & NFSEXP_GATHERED_WRITES)
 
 int nfsexp_flags(struct svc_rqst *rqstp, struct svc_export *exp);
+__be32 check_xprtsec_policy(struct svc_export *exp, struct svc_rqst *rqstp);
+__be32 check_security_flavor(struct svc_export *exp, struct svc_rqst *rqstp);
 __be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp);
 
 /*
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -371,6 +371,16 @@ fh_verify(struct svc_rqst *rqstp, struct
 		goto out;
 
 	/*
+	 * NLM is allowed to bypass the xprtsec policy check because lockd
+	 * doesn't support xprtsec.
+	 */
+	if (!(access & NFSD_MAY_LOCK)) {
+		error = check_xprtsec_policy(exp, rqstp);
+		if (error)
+			goto out;
+	}
+
+	/*
 	 * pseudoflavor restrictions are not enforced on NLM,
 	 * which clients virtually always use auth_sys for,
 	 * even while using RPCSEC_GSS for NFS.
@@ -386,7 +396,7 @@ fh_verify(struct svc_rqst *rqstp, struct
 			&& exp->ex_path.dentry == dentry)
 		goto skip_pseudoflavor_check;
 
-	error = check_nfsd_access(exp, rqstp);
+	error = check_security_flavor(exp, rqstp);
 	if (error)
 		goto out;
 


