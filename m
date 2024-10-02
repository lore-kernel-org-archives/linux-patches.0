Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E791CFECF;
	Wed,  2 Oct 2024 13:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876489; cv=none; b=VkBvl98oubR2RDe3icPbUO4Lmvi8qUBZa388l+crXx9b2dWc0C52JsxcP0fNKFcvY34xCgppC5PtgeGJx+/zToKM5US2e374P31dtFbAlT4BKMU2JtofL7JfuD7DrrMXKCs9eItP+9uxBtsojjaFWFbAgjqcjpsNSqsLQE0rHT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876489; c=relaxed/simple;
	bh=G9Om6Y7wm/7gpvpTU0yHWUwUudqluByLoeJhsFVjrbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SueCr99ur2rcmexSYpPNCQytB7rhvErafE//tcAk6OTc2f1U3d5o/WPG/gInB+8pUOo+zvS+MThgEhIla8phckq5lAZ6fMyM8/zTql4ekLhvqdlv+JRSEhrT5tY0zugjZXqpjWafcKSu+ZK1QfrnoJlOM5DoxHXSqB0k40V6G+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NEoakV8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NEoakV8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77CC8C4CEC5;
	Wed,  2 Oct 2024 13:41:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876489;
	bh=G9Om6Y7wm/7gpvpTU0yHWUwUudqluByLoeJhsFVjrbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NEoakV8ZI6j7wqBcXQMB/Jg4bj/THKwAvtzLsjsq4IfTGvn+CsPA9s6qHoVJUj4CI
	 AzNlOuE1NwoF1L3KPnUk5cJrzUJvfIiR4DAWeHk+WTK97PcOsIeeFIDJI+2JYK07uR
	 wb7/maW2/l/6VG9U7fcBWIZf/d7vfi/Kt7bf//Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	NeilBrown <neilb@suse.de>,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 430/695] nfsd: untangle code in nfsd4_deleg_getattr_conflict()
Date: Wed,  2 Oct 2024 14:57:08 +0200
Message-ID: <20241002125839.627168239@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

[ Upstream commit a078a7dc0eaa9db288ae45319f7f7503968af546 ]

The code in nfsd4_deleg_getattr_conflict() is convoluted and buggy.

With this patch we:
 - properly handle non-nfsd leases.  We must not assume flc_owner is a
    delegation unless fl_lmops == &nfsd_lease_mng_ops
 - move the main code out of the for loop
 - have a single exit which calls nfs4_put_stid()
   (and other exits which don't need to call that)

[ jlayton: refactored on top of Neil's other patch: nfsd: fix
	   nfsd4_deleg_getattr_conflict in presence of third party lease ]

Fixes: c5967721e106 ("NFSD: handle GETATTR conflict with write delegation")
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 131 +++++++++++++++++++++-----------------------
 1 file changed, 62 insertions(+), 69 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index a366fb1c1b9b4..29c11714ac3db 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8836,6 +8836,7 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct dentry *dentry,
 	__be32 status;
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	struct file_lock_context *ctx;
+	struct nfs4_delegation *dp = NULL;
 	struct file_lease *fl;
 	struct iattr attrs;
 	struct nfs4_cb_fattr *ncf;
@@ -8845,84 +8846,76 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct dentry *dentry,
 	ctx = locks_inode_context(inode);
 	if (!ctx)
 		return 0;
+
+#define NON_NFSD_LEASE ((void *)1)
+
 	spin_lock(&ctx->flc_lock);
 	for_each_file_lock(fl, &ctx->flc_lease) {
-		unsigned char type = fl->c.flc_type;
-
 		if (fl->c.flc_flags == FL_LAYOUT)
 			continue;
-		if (fl->fl_lmops != &nfsd_lease_mng_ops) {
-			/*
-			 * non-nfs lease, if it's a lease with F_RDLCK then
-			 * we are done; there isn't any write delegation
-			 * on this inode
-			 */
-			if (type == F_RDLCK)
-				break;
-
-			nfsd_stats_wdeleg_getattr_inc(nn);
-			spin_unlock(&ctx->flc_lock);
-
-			status = nfserrno(nfsd_open_break_lease(inode, NFSD_MAY_READ));
+		if (fl->c.flc_type == F_WRLCK) {
+			if (fl->fl_lmops == &nfsd_lease_mng_ops)
+				dp = fl->c.flc_owner;
+			else
+				dp = NON_NFSD_LEASE;
+		}
+		break;
+	}
+	if (dp == NULL || dp == NON_NFSD_LEASE ||
+	    dp->dl_recall.cb_clp == *(rqstp->rq_lease_breaker)) {
+		spin_unlock(&ctx->flc_lock);
+		if (dp == NON_NFSD_LEASE) {
+			status = nfserrno(nfsd_open_break_lease(inode,
+								NFSD_MAY_READ));
 			if (status != nfserr_jukebox ||
 			    !nfsd_wait_for_delegreturn(rqstp, inode))
 				return status;
-			return 0;
 		}
-		if (type == F_WRLCK) {
-			struct nfs4_delegation *dp = fl->c.flc_owner;
+		return 0;
+	}
 
-			if (dp->dl_recall.cb_clp == *(rqstp->rq_lease_breaker)) {
-				spin_unlock(&ctx->flc_lock);
-				return 0;
-			}
-			nfsd_stats_wdeleg_getattr_inc(nn);
-			dp = fl->c.flc_owner;
-			refcount_inc(&dp->dl_stid.sc_count);
-			ncf = &dp->dl_cb_fattr;
-			nfs4_cb_getattr(&dp->dl_cb_fattr);
-			spin_unlock(&ctx->flc_lock);
-			wait_on_bit_timeout(&ncf->ncf_cb_flags, CB_GETATTR_BUSY,
-					TASK_INTERRUPTIBLE, NFSD_CB_GETATTR_TIMEOUT);
-			if (ncf->ncf_cb_status) {
-				/* Recall delegation only if client didn't respond */
-				status = nfserrno(nfsd_open_break_lease(inode, NFSD_MAY_READ));
-				if (status != nfserr_jukebox ||
-						!nfsd_wait_for_delegreturn(rqstp, inode)) {
-					nfs4_put_stid(&dp->dl_stid);
-					return status;
-				}
-			}
-			if (!ncf->ncf_file_modified &&
-					(ncf->ncf_initial_cinfo != ncf->ncf_cb_change ||
-					ncf->ncf_cur_fsize != ncf->ncf_cb_fsize))
-				ncf->ncf_file_modified = true;
-			if (ncf->ncf_file_modified) {
-				int err;
-
-				/*
-				 * Per section 10.4.3 of RFC 8881, the server would
-				 * not update the file's metadata with the client's
-				 * modified size
-				 */
-				attrs.ia_mtime = attrs.ia_ctime = current_time(inode);
-				attrs.ia_valid = ATTR_MTIME | ATTR_CTIME | ATTR_DELEG;
-				inode_lock(inode);
-				err = notify_change(&nop_mnt_idmap, dentry, &attrs, NULL);
-				inode_unlock(inode);
-				if (err) {
-					nfs4_put_stid(&dp->dl_stid);
-					return nfserrno(err);
-				}
-				ncf->ncf_cur_fsize = ncf->ncf_cb_fsize;
-				*size = ncf->ncf_cur_fsize;
-				*modified = true;
-			}
-			nfs4_put_stid(&dp->dl_stid);
-			return 0;
+	nfsd_stats_wdeleg_getattr_inc(nn);
+	refcount_inc(&dp->dl_stid.sc_count);
+	ncf = &dp->dl_cb_fattr;
+	nfs4_cb_getattr(&dp->dl_cb_fattr);
+	spin_unlock(&ctx->flc_lock);
+
+	wait_on_bit_timeout(&ncf->ncf_cb_flags, CB_GETATTR_BUSY,
+			    TASK_INTERRUPTIBLE, NFSD_CB_GETATTR_TIMEOUT);
+	if (ncf->ncf_cb_status) {
+		/* Recall delegation only if client didn't respond */
+		status = nfserrno(nfsd_open_break_lease(inode, NFSD_MAY_READ));
+		if (status != nfserr_jukebox ||
+		    !nfsd_wait_for_delegreturn(rqstp, inode))
+			goto out_status;
+	}
+	if (!ncf->ncf_file_modified &&
+	    (ncf->ncf_initial_cinfo != ncf->ncf_cb_change ||
+	     ncf->ncf_cur_fsize != ncf->ncf_cb_fsize))
+		ncf->ncf_file_modified = true;
+	if (ncf->ncf_file_modified) {
+		int err;
+
+		/*
+		 * Per section 10.4.3 of RFC 8881, the server would
+		 * not update the file's metadata with the client's
+		 * modified size
+		 */
+		attrs.ia_mtime = attrs.ia_ctime = current_time(inode);
+		attrs.ia_valid = ATTR_MTIME | ATTR_CTIME | ATTR_DELEG;
+		inode_lock(inode);
+		err = notify_change(&nop_mnt_idmap, dentry, &attrs, NULL);
+		inode_unlock(inode);
+		if (err) {
+			status = nfserrno(err);
+			goto out_status;
 		}
-		break;
+		ncf->ncf_cur_fsize = ncf->ncf_cb_fsize;
+		*size = ncf->ncf_cur_fsize;
+		*modified = true;
 	}
-	spin_unlock(&ctx->flc_lock);
-	return 0;
+	status = 0;
+out_status:
+	nfs4_put_stid(&dp->dl_stid);
+	return status;
 }
-- 
2.43.0



