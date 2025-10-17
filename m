Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777153370FB;
	Fri, 17 Oct 2025 15:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714771; cv=none; b=AmBIyE8FCMZgdR6eAprAahp6N8GQ5oosWMQbmx9fP6Tfc1I6pJP93zNBiVl1beeIxd5RalneVgx2JuE3FhZ4Vu+M1hOZbWyU+Nv/hFV7aK4vJQSa6hh+HcN1cbePbJ4WRiyMU6GKRV5fBTh8jWVK7yom1DxikfwG03uYPNn5iiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714771; c=relaxed/simple;
	bh=EvbPkAKtNth04i8mVyKqS01f7wE0SdnkIYWNyFxeuAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ugvo1QiD131/htGkpLkPbsufTsOXLPD0G+YcXYUYh+V0OZVGOvBkcY/IagItAbQdO9Vkj3domEowUcN7UM83eLpmo4kpGmJmxjyiB306gt6QgjGR80tqKMAIqp1ll8B8x3qK7Jr17lSZ9xujwTyImwmdCPAJglZFNw1sSJ415Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hgckip5a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hgckip5a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01265C4CEFE;
	Fri, 17 Oct 2025 15:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714771;
	bh=EvbPkAKtNth04i8mVyKqS01f7wE0SdnkIYWNyFxeuAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hgckip5autjf2jH89DV1SFqXUi5SiOHmUUV4SEC/f2GSkfY/ITAMCOJz/H+KYkORC
	 cCZNvvcDXw59gR2Gq3KjXGX6AWRMyYt2E7KtkYKSw/WE8kN0J707JIuqePnl6yv5Cq
	 YW69v84UrlKE3Eyf7ZzhjmcaAP+UjrpTCrLdzKgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 243/277] nfsd: Fix NFSD_MAY_BYPASS_GSS and NFSD_MAY_BYPASS_GSS_ON_ROOT
Date: Fri, 17 Oct 2025 16:54:10 +0200
Message-ID: <20251017145156.017494561@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145147.138822285@linuxfoundation.org>
References: <20251017145147.138822285@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pali Rohár <pali@kernel.org>

[ Upstream commit bb4f07f2409c26c01e97e6f9b432545f353e3b66 ]

Currently NFSD_MAY_BYPASS_GSS and NFSD_MAY_BYPASS_GSS_ON_ROOT do not bypass
only GSS, but bypass any method. This is a problem specially for NFS3
AUTH_NULL-only exports.

The purpose of NFSD_MAY_BYPASS_GSS_ON_ROOT is described in RFC 2623,
section 2.3.2, to allow mounting NFS2/3 GSS-only export without
authentication. So few procedures which do not expose security risk used
during mount time can be called also with AUTH_NONE or AUTH_SYS, to allow
client mount operation to finish successfully.

The problem with current implementation is that for AUTH_NULL-only exports,
the NFSD_MAY_BYPASS_GSS_ON_ROOT is active also for NFS3 AUTH_UNIX mount
attempts which confuse NFS3 clients, and make them think that AUTH_UNIX is
enabled and is working. Linux NFS3 client never switches from AUTH_UNIX to
AUTH_NONE on active mount, which makes the mount inaccessible.

Fix the NFSD_MAY_BYPASS_GSS and NFSD_MAY_BYPASS_GSS_ON_ROOT implementation
and really allow to bypass only exports which have enabled some real
authentication (GSS, TLS, or any other).

The result would be: For AUTH_NULL-only export if client attempts to do
mount with AUTH_UNIX flavor then it will receive access errors, which
instruct client that AUTH_UNIX flavor is not usable and will either try
other auth flavor (AUTH_NULL if enabled) or fails mount procedure.
Similarly if client attempt to do mount with AUTH_NULL flavor and only
AUTH_UNIX flavor is enabled then the client will receive access error.

This should fix problems with AUTH_NULL-only or AUTH_UNIX-only exports if
client attempts to mount it with other auth flavor (e.g. with AUTH_NULL for
AUTH_UNIX-only export, or with AUTH_UNIX for AUTH_NULL-only export).

Signed-off-by: Pali Rohár <pali@kernel.org>
Reviewed-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 898374fdd7f0 ("nfsd: unregister with rpcbind when deleting a transport")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/export.c   |   21 ++++++++++++++++++++-
 fs/nfsd/export.h   |    3 ++-
 fs/nfsd/nfs4proc.c |    2 +-
 fs/nfsd/nfs4xdr.c  |    2 +-
 fs/nfsd/nfsfh.c    |    9 ++++++---
 fs/nfsd/vfs.c      |    2 +-
 6 files changed, 31 insertions(+), 8 deletions(-)

--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -1078,12 +1078,14 @@ static struct svc_export *exp_find(struc
  * check_nfsd_access - check if access to export is allowed.
  * @exp: svc_export that is being accessed.
  * @rqstp: svc_rqst attempting to access @exp (will be NULL for LOCALIO).
+ * @may_bypass_gss: reduce strictness of authorization check
  *
  * Return values:
  *   %nfs_ok if access is granted, or
  *   %nfserr_wrongsec if access is denied
  */
-__be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp)
+__be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp,
+			 bool may_bypass_gss)
 {
 	struct exp_flavor_info *f, *end = exp->ex_flavors + exp->ex_nflavors;
 	struct svc_xprt *xprt;
@@ -1140,6 +1142,23 @@ ok:
 	if (nfsd4_spo_must_allow(rqstp))
 		return nfs_ok;
 
+	/* Some calls may be processed without authentication
+	 * on GSS exports. For example NFS2/3 calls on root
+	 * directory, see section 2.3.2 of rfc 2623.
+	 * For "may_bypass_gss" check that export has really
+	 * enabled some flavor with authentication (GSS or any
+	 * other) and also check that the used auth flavor is
+	 * without authentication (none or sys).
+	 */
+	if (may_bypass_gss && (
+	     rqstp->rq_cred.cr_flavor == RPC_AUTH_NULL ||
+	     rqstp->rq_cred.cr_flavor == RPC_AUTH_UNIX)) {
+		for (f = exp->ex_flavors; f < end; f++) {
+			if (f->pseudoflavor >= RPC_AUTH_DES)
+				return 0;
+		}
+	}
+
 denied:
 	return nfserr_wrongsec;
 }
--- a/fs/nfsd/export.h
+++ b/fs/nfsd/export.h
@@ -101,7 +101,8 @@ struct svc_expkey {
 
 struct svc_cred;
 int nfsexp_flags(struct svc_cred *cred, struct svc_export *exp);
-__be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp);
+__be32 check_nfsd_access(struct svc_export *exp, struct svc_rqst *rqstp,
+			 bool may_bypass_gss);
 
 /*
  * Function declarations
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -2799,7 +2799,7 @@ nfsd4_proc_compound(struct svc_rqst *rqs
 
 			if (current_fh->fh_export &&
 					need_wrongsec_check(rqstp))
-				op->status = check_nfsd_access(current_fh->fh_export, rqstp);
+				op->status = check_nfsd_access(current_fh->fh_export, rqstp, false);
 		}
 encode_op:
 		if (op->status == nfserr_replay_me) {
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -3784,7 +3784,7 @@ nfsd4_encode_entry4_fattr(struct nfsd4_r
 			nfserr = nfserrno(err);
 			goto out_put;
 		}
-		nfserr = check_nfsd_access(exp, cd->rd_rqstp);
+		nfserr = check_nfsd_access(exp, cd->rd_rqstp, false);
 		if (nfserr)
 			goto out_put;
 
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -320,6 +320,7 @@ __fh_verify(struct svc_rqst *rqstp,
 {
 	struct nfsd_net *nn = net_generic(net, nfsd_net_id);
 	struct svc_export *exp = NULL;
+	bool may_bypass_gss = false;
 	struct dentry	*dentry;
 	__be32		error;
 
@@ -367,8 +368,10 @@ __fh_verify(struct svc_rqst *rqstp,
 	 * which clients virtually always use auth_sys for,
 	 * even while using RPCSEC_GSS for NFS.
 	 */
-	if (access & NFSD_MAY_LOCK || access & NFSD_MAY_BYPASS_GSS)
+	if (access & NFSD_MAY_LOCK)
 		goto skip_pseudoflavor_check;
+	if (access & NFSD_MAY_BYPASS_GSS)
+		may_bypass_gss = true;
 	/*
 	 * Clients may expect to be able to use auth_sys during mount,
 	 * even if they use gss for everything else; see section 2.3.2
@@ -376,9 +379,9 @@ __fh_verify(struct svc_rqst *rqstp,
 	 */
 	if (access & NFSD_MAY_BYPASS_GSS_ON_ROOT
 			&& exp->ex_path.dentry == dentry)
-		goto skip_pseudoflavor_check;
+		may_bypass_gss = true;
 
-	error = check_nfsd_access(exp, rqstp);
+	error = check_nfsd_access(exp, rqstp, may_bypass_gss);
 	if (error)
 		goto out;
 
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -321,7 +321,7 @@ nfsd_lookup(struct svc_rqst *rqstp, stru
 	err = nfsd_lookup_dentry(rqstp, fhp, name, len, &exp, &dentry);
 	if (err)
 		return err;
-	err = check_nfsd_access(exp, rqstp);
+	err = check_nfsd_access(exp, rqstp, false);
 	if (err)
 		goto out;
 	/*


