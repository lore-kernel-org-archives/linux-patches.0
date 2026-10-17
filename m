Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB643A257A;
	Sat, 17 Oct 2026 17:57:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259844; cv=none; b=Mjoi7UYBabVRtolDID4G+XWuXBz7oRFmiuR3PIl6NG2R9/o7niGCNp8sxWdoQYCsplIGiQWhay8TUqTJRZgo5SL2GB0GS1gGFYOgczGhKp31+Mx4XfiyqNwvA6gv4RwVaJTK4VLGPx7k4guf9oaOdR/ngl1k84joG+AvN76cUh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259844; c=relaxed/simple;
	bh=FM6QmF42k/HEVJfw5xLa27oV1nExJwNfoz+XBWmHcIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tll8bsLiNvlURpAnD293ooNRbcY1lioB8rw+dhM7BlCJI3kkQ4GSo+szooWIYOgbl1UlWJ+mAAP2nwud5YRLbRZoxl6bYAhtGccJxJt9Mg51hu0JLLpDiIkKXq0RIbRsgD7Y3qgnxFBKyy5Dbzz1JRiJrjgX2w5TlheoBFm+iqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vPpy4Uzx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vPpy4Uzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED41A1F000C4;
	Sat, 17 Oct 2026 17:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259843;
	bh=pCUGZ1QzddGNlqRY2XO+KjXFXVpwQRA1XAqjVNbHnQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPpy4Uzx87NUVWfzjKGcHEb4lubCWJgedUDZ7A2T9DVLM8UINJN1n0FYsTtDBmBpt
	 rO6M+n8dP+XqZ8cJ1ttmypwC6kDAUWEMchKeleqlpISquUmaLe0A95+Aizqne1xfwS
	 kKsgWeEBWTdXuDAcyd0f/ZtmHTkPCnCD0i8M4VGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1322/1674] NFSD: Clean up nfsd4_encode_layoutreturn()
Date: Sat, 17 Oct 2026 17:59:54 +0200
Message-ID: <20261017160505.080597502@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 85dbc978b33be6f5e2e06e34b5219d730d5f9aa4 ]

Adopt the use of conventional XDR utility functions. Restructure
the encoder to better align with the XDR definition of the result.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: ca94ba361720 ("nfsd: fix BUG_ON in nfsd4_alloc_layout_stateid on racing delegation revoke")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs4layouts.c |  6 +++---
 fs/nfsd/nfs4xdr.c     | 12 ++++++------
 fs/nfsd/xdr4.h        |  2 +-
 3 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/fs/nfsd/nfs4layouts.c b/fs/nfsd/nfs4layouts.c
index 84bb200e24ade..cf4149567d5c8 100644
--- a/fs/nfsd/nfs4layouts.c
+++ b/fs/nfsd/nfs4layouts.c
@@ -512,11 +512,11 @@ nfsd4_return_file_layouts(struct svc_rqst *rqstp,
 	if (!list_empty(&ls->ls_layouts)) {
 		if (found)
 			nfs4_inc_and_copy_stateid(&lrp->lr_sid, &ls->ls_stid);
-		lrp->lrs_present = 1;
+		lrp->lrs_present = true;
 	} else {
 		trace_nfsd_layoutstate_unhash(&ls->ls_stid.sc_stateid);
 		nfs4_unhash_stid(&ls->ls_stid);
-		lrp->lrs_present = 0;
+		lrp->lrs_present = false;
 	}
 	spin_unlock(&ls->ls_lock);
 
@@ -536,7 +536,7 @@ nfsd4_return_client_layouts(struct svc_rqst *rqstp,
 	struct nfs4_layout *lp, *t;
 	LIST_HEAD(reaplist);
 
-	lrp->lrs_present = 0;
+	lrp->lrs_present = false;
 
 	spin_lock(&clp->cl_lock);
 	list_for_each_entry_safe(ls, n, &clp->cl_lo_states, ls_perclnt) {
diff --git a/fs/nfsd/nfs4xdr.c b/fs/nfsd/nfs4xdr.c
index 5b7c944fa1297..f01abd874cf54 100644
--- a/fs/nfsd/nfs4xdr.c
+++ b/fs/nfsd/nfs4xdr.c
@@ -4787,15 +4787,15 @@ nfsd4_encode_layoutreturn(struct nfsd4_compoundres *resp, __be32 nfserr,
 {
 	struct nfsd4_layoutreturn *lrp = &u->layoutreturn;
 	struct xdr_stream *xdr = resp->xdr;
-	__be32 *p;
 
-	p = xdr_reserve_space(xdr, 4);
-	if (!p)
-		return nfserr_resource;
-	*p++ = cpu_to_be32(lrp->lrs_present);
+	/* lrs_present */
+	nfserr = nfsd4_encode_bool(xdr, lrp->lrs_present);
+	if (nfserr != nfs_ok)
+		return nfserr;
 	if (lrp->lrs_present)
+		/* lrs_stateid */
 		return nfsd4_encode_stateid4(xdr, &lrp->lr_sid);
-	return 0;
+	return nfs_ok;
 }
 #endif /* CONFIG_NFSD_PNFS */
 
diff --git a/fs/nfsd/xdr4.h b/fs/nfsd/xdr4.h
index c2bc10051b228..74ba476002b5d 100644
--- a/fs/nfsd/xdr4.h
+++ b/fs/nfsd/xdr4.h
@@ -653,7 +653,7 @@ struct nfsd4_layoutreturn {
 	u32			lrf_body_len;	/* request */
 	void			*lrf_body;	/* request */
 	stateid_t		lr_sid;		/* request/response */
-	u32			lrs_present;	/* response */
+	bool			lrs_present;	/* response */
 };
 
 struct nfsd4_fallocate {
-- 
2.53.0



