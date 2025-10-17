Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FCD533291C;
	Fri, 17 Oct 2025 15:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760715739; cv=none; b=TJ79qGH6Jd9Ot1ZibeCK+ognmWZiO1dJmf4tCY76vcZGScbGsvJb9dsaoKX1Dv5+QYGBi8EukzjtrnAi4whE8IwHEPiPoTNICDaUxlXIvd9/fGxyd7KGHWtC5CIA0xxoEb8Q5RDv5jx3Z2G/W0bjNKgtHh6DXnixh6jIgSJW21Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760715739; c=relaxed/simple;
	bh=EObr8jGvdhvF7lDY78KXHNKiZkk5OXt3Txq2xzcoj78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nobuJ3DIn5nvN3ceFX4Gota/R2Mt6xdgnjyItk7vwEIhj8bqvEpq/7HlMHUlC/WtSYJ9j0Ih0riYgutCoqg2Lj2W0CDu37thS6b4Jlx/GXpcTn7lQT9jhttIXthMuTzQ9RLFZNHBsgW4s7yOLmnvADujutbzLF2ulDQlFh/pRio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQ9Dazzn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQ9Dazzn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A52C116C6;
	Fri, 17 Oct 2025 15:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760715738;
	bh=EObr8jGvdhvF7lDY78KXHNKiZkk5OXt3Txq2xzcoj78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQ9DazznaXtk4ZfpcACaFBjGIt5wfWUbpmB/AP3nCTq8j18SG8httJqcBRkAIC337
	 qn1DFyT14ksCCe7svc9Ebpzq8U1DIpMxf5qs/YmB7DiCIZ+ljc3C/Ori6jJeLLvNUD
	 71oYDsD+oGtIiqHjxzbJXfg/lN8wexjCGI58LpxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Scott Mayhew <smayhew@redhat.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 6.17 321/371] nfsd: decouple the xprtsec policy check from check_nfsd_access()
Date: Fri, 17 Oct 2025 16:54:56 +0200
Message-ID: <20251017145213.691579127@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Scott Mayhew <smayhew@redhat.com>

commit e4f574ca9c6dfa66695bb054ff5df43ecea873ec upstream.

A while back I had reported that an NFSv3 client could successfully
mount using '-o xprtsec=none' an export that had been exported with
'xprtsec=tls:mtls'.  By "successfully" I mean that the mount command
would succeed and the mount would show up in /proc/mount.  Attempting
to do anything futher with the mount would be met with NFS3ERR_ACCES.

This was fixed (albeit accidentally) by commit bb4f07f2409c ("nfsd:
Fix NFSD_MAY_BYPASS_GSS and NFSD_MAY_BYPASS_GSS_ON_ROOT") and was
subsequently re-broken by commit 0813c5f01249 ("nfsd: fix access
checking for NLM under XPRTSEC policies").

Transport Layer Security isn't an RPC security flavor or pseudo-flavor,
so we shouldn't be conflating them when determining whether the access
checks can be bypassed.  Split check_nfsd_access() into two helpers, and
have __fh_verify() call the helpers directly since __fh_verify() has
logic that allows one or both of the checks to be skipped.  All other
sites will continue to call check_nfsd_access().

Link: https://lore.kernel.org/linux-nfs/ZjO3Qwf_G87yNXb2@aion/
Fixes: 9280c5774314 ("NFSD: Handle new xprtsec= export option")
Cc: stable@vger.kernel.org
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/export.c |   82 ++++++++++++++++++++++++++++++++++++++-----------------
 fs/nfsd/export.h |    3 ++
 fs/nfsd/nfsfh.c  |   24 +++++++++++++++-
 3 files changed, 83 insertions(+), 26 deletions(-)

--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1082,50 +1082,62 @@ static struct svc_export *exp_find(struc
 }
 
 /**
- * check_nfsd_access - check if access to export is allowed.
+ * check_xprtsec_policy - check if access to export is allowed by the
+ *			  xprtsec policy
  * @exp: svc_export that is being accessed.
- * @rqstp: svc_rqst attempting to access @exp (will be NULL for LOCALIO).
- * @may_bypass_gss: reduce strictness of authorization check
+ * @rqstp: svc_rqst attempting to access @exp.
+ *
+ * Helper function for check_nfsd_access().  Note that callers should be
+ * using check_nfsd_access() instead of calling this function directly.  The
+ * one exception is __fh_verify() since it has logic that may result in one
+ * or both of the helpers being skipped.
  *
  * Return values:
  *   %nfs_ok if access is granted, or
  *   %nfserr_wrongsec if access is denied
  */
-__be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp,
-			 bool may_bypass_gss)
+__be32 check_xprtsec_policy(struct svc_export *exp, struct svc_rqst *rqstp)
 {
-	struct exp_flavor_info *f, *end = exp->ex_flavors + exp->ex_nflavors;
-	struct svc_xprt *xprt;
-
-	/*
-	 * If rqstp is NULL, this is a LOCALIO request which will only
-	 * ever use a filehandle/credential pair for which access has
-	 * been affirmed (by ACCESS or OPEN NFS requests) over the
-	 * wire. So there is no need for further checks here.
-	 */
-	if (!rqstp)
-		return nfs_ok;
-
-	xprt = rqstp->rq_xprt;
+	struct svc_xprt *xprt = rqstp->rq_xprt;
 
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
-	if (!may_bypass_gss)
-		goto denied;
+	return nfserr_wrongsec;
+}
+
+/**
+ * check_security_flavor - check if access to export is allowed by the
+ *			   security flavor
+ * @exp: svc_export that is being accessed.
+ * @rqstp: svc_rqst attempting to access @exp.
+ * @may_bypass_gss: reduce strictness of authorization check
+ *
+ * Helper function for check_nfsd_access().  Note that callers should be
+ * using check_nfsd_access() instead of calling this function directly.  The
+ * one exception is __fh_verify() since it has logic that may result in one
+ * or both of the helpers being skipped.
+ *
+ * Return values:
+ *   %nfs_ok if access is granted, or
+ *   %nfserr_wrongsec if access is denied
+ */
+__be32 check_security_flavor(struct svc_export *exp, struct svc_rqst *rqstp,
+			     bool may_bypass_gss)
+{
+	struct exp_flavor_info *f, *end = exp->ex_flavors + exp->ex_nflavors;
 
-ok:
 	/* legacy gss-only clients are always OK: */
 	if (exp->ex_client == rqstp->rq_gssclient)
 		return nfs_ok;
@@ -1167,10 +1179,30 @@ ok:
 		}
 	}
 
-denied:
 	return nfserr_wrongsec;
 }
 
+/**
+ * check_nfsd_access - check if access to export is allowed.
+ * @exp: svc_export that is being accessed.
+ * @rqstp: svc_rqst attempting to access @exp.
+ * @may_bypass_gss: reduce strictness of authorization check
+ *
+ * Return values:
+ *   %nfs_ok if access is granted, or
+ *   %nfserr_wrongsec if access is denied
+ */
+__be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp,
+			 bool may_bypass_gss)
+{
+	__be32 status;
+
+	status = check_xprtsec_policy(exp, rqstp);
+	if (status != nfs_ok)
+		return status;
+	return check_security_flavor(exp, rqstp, may_bypass_gss);
+}
+
 /*
  * Uses rq_client and rq_gssclient to find an export; uses rq_client (an
  * auth_unix client) if it's available and has secinfo information;
--- a/fs/nfsd/export.h
+++ b/fs/nfsd/export.h
@@ -101,6 +101,9 @@ struct svc_expkey {
 
 struct svc_cred;
 int nfsexp_flags(struct svc_cred *cred, struct svc_export *exp);
+__be32 check_xprtsec_policy(struct svc_export *exp, struct svc_rqst *rqstp);
+__be32 check_security_flavor(struct svc_export *exp, struct svc_rqst *rqstp,
+			     bool may_bypass_gss);
 __be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp,
 			 bool may_bypass_gss);
 
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -364,10 +364,30 @@ __fh_verify(struct svc_rqst *rqstp,
 	if (error)
 		goto out;
 
+	/*
+	 * If rqstp is NULL, this is a LOCALIO request which will only
+	 * ever use a filehandle/credential pair for which access has
+	 * been affirmed (by ACCESS or OPEN NFS requests) over the
+	 * wire.  Skip both the xprtsec policy and the security flavor
+	 * checks.
+	 */
+	if (!rqstp)
+		goto check_permissions;
+
 	if ((access & NFSD_MAY_NLM) && (exp->ex_flags & NFSEXP_NOAUTHNLM))
 		/* NLM is allowed to fully bypass authentication */
 		goto out;
 
+	/*
+	 * NLM is allowed to bypass the xprtsec policy check because lockd
+	 * doesn't support xprtsec.
+	 */
+	if (!(access & NFSD_MAY_NLM)) {
+		error = check_xprtsec_policy(exp, rqstp);
+		if (error)
+			goto out;
+	}
+
 	if (access & NFSD_MAY_BYPASS_GSS)
 		may_bypass_gss = true;
 	/*
@@ -379,13 +399,15 @@ __fh_verify(struct svc_rqst *rqstp,
 			&& exp->ex_path.dentry == dentry)
 		may_bypass_gss = true;
 
-	error = check_nfsd_access(exp, rqstp, may_bypass_gss);
+	error = check_security_flavor(exp, rqstp, may_bypass_gss);
 	if (error)
 		goto out;
+
 	/* During LOCALIO call to fh_verify will be called with a NULL rqstp */
 	if (rqstp)
 		svc_xprt_set_valid(rqstp->rq_xprt);
 
+check_permissions:
 	/* Finally, check access permissions. */
 	error = nfsd_permission(cred, exp, dentry, access);
 out:


