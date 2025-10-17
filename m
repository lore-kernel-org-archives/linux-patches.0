Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C7D20C00A;
	Fri, 17 Oct 2025 15:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714822; cv=none; b=bXeQeo5DiwEyHNwyIjGae/fFwcbP1BeNlg04asp5sSJVBwfmC9BS3MwzoEh7JudQViyJRc5aDBONCVhuG85Jyf2jBOIrPx/lpBjOJB5N8he1GcSkYya1elQoFV7knuvF1BkY22AvqXuzGJ1/qfxRYL3SMuEkfH/UccjetYvuee4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714822; c=relaxed/simple;
	bh=Nrn0LGqikKAlqXAAm1b3bguqk/6L2Ex6KYjGP4uRJog=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+NwpC/51r1v+djSXweLF127IM93hPmrOp3XdbpJZxCcB9l5F+96SHlK1iKcSi5ewnecl5USWNYhZn1i/eMOpTSXVL/QkvvLGe3rpCVxIxdSHFbq2FGMMo/goZgM0v++u4D7Ls9O5cv99U7usDVivbNdnEnX2rhjfoWRzYH6GzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4XaTUyx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4XaTUyx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9D15C4CEE7;
	Fri, 17 Oct 2025 15:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714822;
	bh=Nrn0LGqikKAlqXAAm1b3bguqk/6L2Ex6KYjGP4uRJog=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4XaTUyxboGVXV4Y/0WJM6aXmJ5PPQOBnn1u7HJHAom6NmuXvu+3SBasMplVovTan
	 fQ/j5oxp6ezTYLUnOj9RVYGVFooxKaiCoGNhDbiyDlyCpSIVWfi+jVKqomahnTIUTA
	 zVycy/IYP20qE447Gk+oJRmhcCoGtdO/F1E4CsOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 245/277] nfsd: refine and rename NFSD_MAY_LOCK
Date: Fri, 17 Oct 2025 16:54:12 +0200
Message-ID: <20251017145156.092358763@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit 4cc9b9f2bf4dfe13fe573da978e626e2248df388 ]

NFSD_MAY_LOCK means a few different things.
- it means that GSS is not required.
- it means that with NFSEXP_NOAUTHNLM, authentication is not required
- it means that OWNER_OVERRIDE is allowed.

None of these are specific to locking, they are specific to the NLM
protocol.
So:
 - rename to NFSD_MAY_NLM
 - set NFSD_MAY_OWNER_OVERRIDE and NFSD_MAY_BYPASS_GSS in nlm_fopen()
   so that NFSD_MAY_NLM doesn't need to imply these.
 - move the test on NFSEXP_NOAUTHNLM out of nfsd_permission() and
   into fh_verify where other special-case tests on the MAY flags
   happen.  nfsd_permission() can be called from other places than
   fh_verify(), but none of these will have NFSD_MAY_NLM.

Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: 898374fdd7f0 ("nfsd: unregister with rpcbind when deleting a transport")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfsd/lockd.c |   13 +++++++++++--
 fs/nfsd/nfsfh.c |   12 ++++--------
 fs/nfsd/trace.h |    2 +-
 fs/nfsd/vfs.c   |   12 +-----------
 fs/nfsd/vfs.h   |    2 +-
 5 files changed, 18 insertions(+), 23 deletions(-)

--- a/fs/nfsd/lockd.c
+++ b/fs/nfsd/lockd.c
@@ -38,11 +38,20 @@ nlm_fopen(struct svc_rqst *rqstp, struct
 	memcpy(&fh.fh_handle.fh_raw, f->data, f->size);
 	fh.fh_export = NULL;
 
+	/*
+	 * Allow BYPASS_GSS as some client implementations use AUTH_SYS
+	 * for NLM even when GSS is used for NFS.
+	 * Allow OWNER_OVERRIDE as permission might have been changed
+	 * after the file was opened.
+	 * Pass MAY_NLM so that authentication can be completely bypassed
+	 * if NFSEXP_NOAUTHNLM is set.  Some older clients use AUTH_NULL
+	 * for NLM requests.
+	 */
 	access = (mode == O_WRONLY) ? NFSD_MAY_WRITE : NFSD_MAY_READ;
-	access |= NFSD_MAY_LOCK;
+	access |= NFSD_MAY_NLM | NFSD_MAY_OWNER_OVERRIDE | NFSD_MAY_BYPASS_GSS;
 	nfserr = nfsd_open(rqstp, &fh, S_IFREG, access, filp);
 	fh_put(&fh);
- 	/* We return nlm error codes as nlm doesn't know
+	/* We return nlm error codes as nlm doesn't know
 	 * about nfsd, but nfsd does know about nlm..
 	 */
 	switch (nfserr) {
--- a/fs/nfsd/nfsfh.c
+++ b/fs/nfsd/nfsfh.c
@@ -363,13 +363,10 @@ __fh_verify(struct svc_rqst *rqstp,
 	if (error)
 		goto out;
 
-	/*
-	 * pseudoflavor restrictions are not enforced on NLM,
-	 * which clients virtually always use auth_sys for,
-	 * even while using RPCSEC_GSS for NFS.
-	 */
-	if (access & NFSD_MAY_LOCK)
-		goto skip_pseudoflavor_check;
+	if ((access & NFSD_MAY_NLM) && (exp->ex_flags & NFSEXP_NOAUTHNLM))
+		/* NLM is allowed to fully bypass authentication */
+		goto out;
+
 	if (access & NFSD_MAY_BYPASS_GSS)
 		may_bypass_gss = true;
 	/*
@@ -385,7 +382,6 @@ __fh_verify(struct svc_rqst *rqstp,
 	if (error)
 		goto out;
 
-skip_pseudoflavor_check:
 	/* Finally, check access permissions. */
 	error = nfsd_permission(cred, exp, dentry, access);
 out:
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -79,7 +79,7 @@ DEFINE_NFSD_XDR_ERR_EVENT(cant_encode);
 		{ NFSD_MAY_READ,		"READ" },		\
 		{ NFSD_MAY_SATTR,		"SATTR" },		\
 		{ NFSD_MAY_TRUNC,		"TRUNC" },		\
-		{ NFSD_MAY_LOCK,		"LOCK" },		\
+		{ NFSD_MAY_NLM,			"NLM" },		\
 		{ NFSD_MAY_OWNER_OVERRIDE,	"OWNER_OVERRIDE" },	\
 		{ NFSD_MAY_LOCAL_ACCESS,	"LOCAL_ACCESS" },	\
 		{ NFSD_MAY_BYPASS_GSS_ON_ROOT,	"BYPASS_GSS_ON_ROOT" },	\
--- a/fs/nfsd/vfs.c
+++ b/fs/nfsd/vfs.c
@@ -2519,7 +2519,7 @@ nfsd_permission(struct svc_cred *cred, s
 		(acc & NFSD_MAY_EXEC)?	" exec"  : "",
 		(acc & NFSD_MAY_SATTR)?	" sattr" : "",
 		(acc & NFSD_MAY_TRUNC)?	" trunc" : "",
-		(acc & NFSD_MAY_LOCK)?	" lock"  : "",
+		(acc & NFSD_MAY_NLM)?	" nlm"  : "",
 		(acc & NFSD_MAY_OWNER_OVERRIDE)? " owneroverride" : "",
 		inode->i_mode,
 		IS_IMMUTABLE(inode)?	" immut" : "",
@@ -2544,16 +2544,6 @@ nfsd_permission(struct svc_cred *cred, s
 	if ((acc & NFSD_MAY_TRUNC) && IS_APPEND(inode))
 		return nfserr_perm;
 
-	if (acc & NFSD_MAY_LOCK) {
-		/* If we cannot rely on authentication in NLM requests,
-		 * just allow locks, otherwise require read permission, or
-		 * ownership
-		 */
-		if (exp->ex_flags & NFSEXP_NOAUTHNLM)
-			return 0;
-		else
-			acc = NFSD_MAY_READ | NFSD_MAY_OWNER_OVERRIDE;
-	}
 	/*
 	 * The file owner always gets access permission for accesses that
 	 * would normally be checked at open time. This is to make
--- a/fs/nfsd/vfs.h
+++ b/fs/nfsd/vfs.h
@@ -20,7 +20,7 @@
 #define NFSD_MAY_READ			0x004 /* == MAY_READ */
 #define NFSD_MAY_SATTR			0x008
 #define NFSD_MAY_TRUNC			0x010
-#define NFSD_MAY_LOCK			0x020
+#define NFSD_MAY_NLM			0x020 /* request is from lockd */
 #define NFSD_MAY_MASK			0x03f
 
 /* extra hints to permission and open routines: */


