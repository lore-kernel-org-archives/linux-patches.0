Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D7C1C68C;
	Sun,  1 Sep 2024 16:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208405; cv=none; b=mNB8l++j8EPu4cwssMepd8Ykq76VH249wODW417r0RmhTDd4KMZTzj9TVArIShzb4bU9sz0aRo7qH+bJFrON2AdBRrxSGjsBTLTIeKDQMJdQrJ33m9QP2y0F6BQ8GlZMRo46SkH8OGFC2jSwK96ZVy2ZRQhSp6hWReUcaHFqQRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208405; c=relaxed/simple;
	bh=oa9A7DBGZmTBqq9I6fxPrF5sbiH9qR4UD4HrxEYimSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrgGR4scMyGuKKYygyr6Z1hGR+xhPlfjE9Bmc1cj6nY7/GZeJGtbKBtZ+Io0L8Q5tZiK2r1l9ynaI4i/1R6qCdMv51cTjwfleinTH4YxlHzbYp8YVrhEN7eT++w99aFNVgMkqCY1cm5I93cHznOk42bbHiibXLxdaeSXOROcu7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X7PldnEe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X7PldnEe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44390C4CEC3;
	Sun,  1 Sep 2024 16:33:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208405;
	bh=oa9A7DBGZmTBqq9I6fxPrF5sbiH9qR4UD4HrxEYimSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X7PldnEesyh7VtttE1Eu5J5B7ZblgkKp783JPewAD6ojsuPw7H+qUaE/vg71YRjYw
	 yKQnQnuz1R0avJDK5o65hMaCKige9zTpvfYzSquKzHfgt0O0286OlnPgH672E5OzAq
	 qa1F+Cuz+p/3jUhwHkd7CS7lRXNJiefTXaAAuBZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 073/149] nfsd: hold reference to delegation when updating it for cb_getattr
Date: Sun,  1 Sep 2024 18:16:24 +0200
Message-ID: <20240901160820.211219947@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit da05ba23d4c8d3e8a45846b952e53dd76c4b5e36 ]

Once we've dropped the flc_lock, there is nothing that ensures that the
delegation that was found will still be around later. Take a reference
to it while holding the lock and then drop it when we've finished with
the delegation.

Fixes: c5967721e106 ("NFSD: handle GETATTR conflict with write delegation")
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4state.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs4state.c b/fs/nfsd/nfs4state.c
index dafff707e23a4..19d39872be325 100644
--- a/fs/nfsd/nfs4state.c
+++ b/fs/nfsd/nfs4state.c
@@ -8837,7 +8837,6 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct inode *inode,
 	struct nfsd_net *nn = net_generic(SVC_NET(rqstp), nfsd_net_id);
 	struct file_lock_context *ctx;
 	struct file_lease *fl;
-	struct nfs4_delegation *dp;
 	struct iattr attrs;
 	struct nfs4_cb_fattr *ncf;
 
@@ -8862,7 +8861,8 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct inode *inode,
 			goto break_lease;
 		}
 		if (type == F_WRLCK) {
-			dp = fl->c.flc_owner;
+			struct nfs4_delegation *dp = fl->c.flc_owner;
+
 			if (dp->dl_recall.cb_clp == *(rqstp->rq_lease_breaker)) {
 				spin_unlock(&ctx->flc_lock);
 				return 0;
@@ -8870,6 +8870,7 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct inode *inode,
 break_lease:
 			nfsd_stats_wdeleg_getattr_inc(nn);
 			dp = fl->c.flc_owner;
+			refcount_inc(&dp->dl_stid.sc_count);
 			ncf = &dp->dl_cb_fattr;
 			nfs4_cb_getattr(&dp->dl_cb_fattr);
 			spin_unlock(&ctx->flc_lock);
@@ -8879,8 +8880,10 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct inode *inode,
 				/* Recall delegation only if client didn't respond */
 				status = nfserrno(nfsd_open_break_lease(inode, NFSD_MAY_READ));
 				if (status != nfserr_jukebox ||
-						!nfsd_wait_for_delegreturn(rqstp, inode))
+						!nfsd_wait_for_delegreturn(rqstp, inode)) {
+					nfs4_put_stid(&dp->dl_stid);
 					return status;
+				}
 			}
 			if (!ncf->ncf_file_modified &&
 					(ncf->ncf_initial_cinfo != ncf->ncf_cb_change ||
@@ -8900,6 +8903,7 @@ nfsd4_deleg_getattr_conflict(struct svc_rqst *rqstp, struct inode *inode,
 				*size = ncf->ncf_cur_fsize;
 				*modified = true;
 			}
+			nfs4_put_stid(&dp->dl_stid);
 			return 0;
 		}
 		break;
-- 
2.43.0



