Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33E64D5AB;
	Mon,  8 Apr 2024 13:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584333; cv=none; b=LJM+MT5FJ1DLqs1u+TRhSj5lnGjriIE02B9GF9K0+bPfwk55Qk5MoVkIamzxZ1a/V4cW7itvRXkSlWmrpCIzKI344HIkMSGiv/SFWna1/ZGSXcqd3S8+JsiZXW+QS1xz5FHuHOl3mBavFII2rT6ylMdjQ1RRVmuI85/xEgh02QY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584333; c=relaxed/simple;
	bh=3TeYdXBt/OjwGxp0W9U8rk77n4dVwpAjfbBdjVnBF1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dKvdXgFgY9uWn0sAVfK82jTI2vMFxUTZLAxfbV82vmA1aepninGMvoIh0PEWTnBCYASFGtJCTnueNqhJqu9lTPTULVWaiGzoVE3DwlfRLAPRLMo6hmlMMEseIsqXwsOadQkHLVQVoD+gYNW/SO+N+9LUzIe2pVyYNwm5Naw2Mdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeY5SrKw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeY5SrKw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55AF0C433C7;
	Mon,  8 Apr 2024 13:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584333;
	bh=3TeYdXBt/OjwGxp0W9U8rk77n4dVwpAjfbBdjVnBF1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JeY5SrKwgCuFXV2sBXqXQrKtfAXqYKEkMzyV0f/0iMttgV67F+k1oNvwu1GGaTL9l
	 7bOeU/pK5qF4jSLeG1ipQ3Ziv7U1PRiGOaUwRDl9pXoCiEsXfLWaXqduSh3RzOiMBm
	 Z8OyeNzvktp10Bfyd/7UMO4fc978vRc/5ohZgeaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	NeilBrown <neilb@suse.de>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 402/690] NFSD: verify the opened dentry after setting a delegation
Date: Mon,  8 Apr 2024 14:54:28 +0200
Message-ID: <20240408125414.119713762@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 876c553cb41026cb6ad3cef970a35e5f69c42a25 ]

Between opening a file and setting a delegation on it, someone could
rename or unlink the dentry. If this happens, we do not want to grant a
delegation on the open.

On a CLAIM_NULL open, we're opening by filename, and we may (in the
non-create case) or may not (in the create case) be holding i_rwsem
when attempting to set a delegation.  The latter case allows a
race.

After getting a lease, redo the lookup of the file being opened and
validate that the resulting dentry matches the one in the open file
description.

To properly redo the lookup we need an rqst pointer to pass to
nfsd_lookup_dentry(), so make sure that is available.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/nfs4proc.c  |  1 +
 fs/nfsd/nfs4state.c | 54 ++++++++++++++++++++++++++++++++++++++++-----
 fs/nfsd/xdr4.h      |  1 +
 3 files changed, 51 insertions(+), 5 deletions(-)

diff --git a/fs/nfsd/nfs4proc.c b/fs/nfsd/nfs4proc.c
index 46ec66f4ec9e7..ae0948271da9c 100644
--- a/fs/nfsd/nfs4proc.c
+++ b/fs/nfsd/nfs4proc.c
@@ -547,6 +547,7 @@ nfsd4_open(struct svc_rqst *rqstp, struct nfsd4_compound_state *cstate,
 		open->op_openowner);
 
 	open->op_filp = NULL;
+	open->op_rqstp = rqstp;
 
 	/* This check required by spec. */
 	if (open->op_create && open->op_claim_type != NFS4_OPEN_CLAIM_NULL)
diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index 2b333f9259a03..7122ebc50a035 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -5305,11 +5305,44 @@ static int nfsd4_check_conflicting_opens(struct nfs4_client *clp,
 	return 0;
 }
 
+/*
+ * It's possible that between opening the dentry and setting the delegation,
+ * that it has been renamed or unlinked. Redo the lookup to verify that this
+ * hasn't happened.
+ */
+static int
+nfsd4_verify_deleg_dentry(struct nfsd4_open *open, struct nfs4_file *fp,
+			  struct svc_fh *parent)
+{
+	struct svc_export *exp;
+	struct dentry *child;
+	__be32 err;
+
+	/* parent may already be locked, and it may get unlocked by
+	 * this call, but that is safe.
+	 */
+	err = nfsd_lookup_dentry(open->op_rqstp, parent,
+				 open->op_fname, open->op_fnamelen,
+				 &exp, &child);
+
+	if (err)
+		return -EAGAIN;
+
+	dput(child);
+	if (child != file_dentry(fp->fi_deleg_file->nf_file))
+		return -EAGAIN;
+
+	return 0;
+}
+
 static struct nfs4_delegation *
-nfs4_set_delegation(struct nfs4_client *clp,
-		    struct nfs4_file *fp, struct nfs4_clnt_odstate *odstate)
+nfs4_set_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
+		    struct svc_fh *parent)
 {
 	int status = 0;
+	struct nfs4_client *clp = stp->st_stid.sc_client;
+	struct nfs4_file *fp = stp->st_stid.sc_file;
+	struct nfs4_clnt_odstate *odstate = stp->st_clnt_odstate;
 	struct nfs4_delegation *dp;
 	struct nfsd_file *nf;
 	struct file_lock *fl;
@@ -5364,6 +5397,13 @@ nfs4_set_delegation(struct nfs4_client *clp,
 		locks_free_lock(fl);
 	if (status)
 		goto out_clnt_odstate;
+
+	if (parent) {
+		status = nfsd4_verify_deleg_dentry(open, fp, parent);
+		if (status)
+			goto out_unlock;
+	}
+
 	status = nfsd4_check_conflicting_opens(clp, fp);
 	if (status)
 		goto out_unlock;
@@ -5419,11 +5459,13 @@ static void nfsd4_open_deleg_none_ext(struct nfsd4_open *open, int status)
  * proper support for them.
  */
 static void
-nfs4_open_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp)
+nfs4_open_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp,
+		     struct svc_fh *currentfh)
 {
 	struct nfs4_delegation *dp;
 	struct nfs4_openowner *oo = openowner(stp->st_stateowner);
 	struct nfs4_client *clp = stp->st_stid.sc_client;
+	struct svc_fh *parent = NULL;
 	int cb_up;
 	int status = 0;
 
@@ -5437,6 +5479,8 @@ nfs4_open_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp)
 				goto out_no_deleg;
 			break;
 		case NFS4_OPEN_CLAIM_NULL:
+			parent = currentfh;
+			fallthrough;
 		case NFS4_OPEN_CLAIM_FH:
 			/*
 			 * Let's not give out any delegations till everyone's
@@ -5451,7 +5495,7 @@ nfs4_open_delegation(struct nfsd4_open *open, struct nfs4_ol_stateid *stp)
 		default:
 			goto out_no_deleg;
 	}
-	dp = nfs4_set_delegation(clp, stp->st_stid.sc_file, stp->st_clnt_odstate);
+	dp = nfs4_set_delegation(open, stp, parent);
 	if (IS_ERR(dp))
 		goto out_no_deleg;
 
@@ -5583,7 +5627,7 @@ nfsd4_process_open2(struct svc_rqst *rqstp, struct svc_fh *current_fh, struct nf
 	* Attempt to hand out a delegation. No error return, because the
 	* OPEN succeeds even if we fail.
 	*/
-	nfs4_open_delegation(open, stp);
+	nfs4_open_delegation(open, stp, &resp->cstate.current_fh);
 nodeleg:
 	status = nfs_ok;
 	trace_nfsd_open(&stp->st_stid.sc_stateid);
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index adb9aef26d7f1..466e2786fc976 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -279,6 +279,7 @@ struct nfsd4_open {
 	struct nfs4_clnt_odstate *op_odstate; /* used during processing */
 	struct nfs4_acl *op_acl;
 	struct xdr_netobj op_label;
+	struct svc_rqst *op_rqstp;
 };
 
 struct nfsd4_open_confirm {
-- 
2.43.0



