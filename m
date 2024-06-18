Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FCB216191B;
	Tue, 18 Jun 2024 12:52:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715120; cv=none; b=fe2IycH0Q/AIw2/45TmrBlkbZh/R3E8d5gHtSDgaP/lMc2KYEl3Cz3yeHSsCh5dwSGUppSh6aPx0l5iW9UumOzT9jC04i7/YxOea8VmZ3WmtqoH1K8g/np64cQNd7UMp1z26hKEwXfOsL13drxmfNaUBCwhKd18tNbZJdEc3QBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715120; c=relaxed/simple;
	bh=B2TY7xWM3ye4ZfScBhld/aKsM86TtYyIT6blI4TFeoY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FwEHumFafJ5j7Fb+duOxwQxenOgCukH9uRFacPxtGlavy1Vjaso6Wubw3kxvnNBBYsWAO4JH3CBVDA0KJilur97UJGbZU4tsi+3LmfZxIWbevbgcf0Y5Vz/MQG3OY1bx7HVryfHpvFe/1p/3OCD4Y1WRQ7I+h3opDKSggRfYL00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qHhV3W29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qHhV3W29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15D7CC3277B;
	Tue, 18 Jun 2024 12:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715120;
	bh=B2TY7xWM3ye4ZfScBhld/aKsM86TtYyIT6blI4TFeoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qHhV3W29nBnMiLSj+uAsK/2YTcSEZC6atp4Zy51n+zHvK1UiUNrSMwhgiGx08F+fT
	 VkYEXTZaEFhi/LQVapt22FxnZYcJ9ce+fhjKHvY7tYt4up2rqNFmvrcrrUr7pphTyJ
	 nf7xh8kioLsuB2ZyfKevnWdznln2lSKHa8s/8TNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 201/770] NFSD: Update the NFSv3 wccstat result encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:54 +0200
Message-ID: <20240618123415.036320737@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 70f8e839859a994e324e1d18889f8319bbd5bff9 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 68 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 65 insertions(+), 3 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 2bb998b3834bf..29b923a497f48 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -400,6 +400,35 @@ encode_saved_post_attr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
 	return encode_fattr3(rqstp, p, fhp, &fhp->fh_post_attr);
 }
 
+static bool
+svcxdr_encode_wcc_attr(struct xdr_stream *xdr, const struct svc_fh *fhp)
+{
+	__be32 *p;
+
+	p = xdr_reserve_space(xdr, XDR_UNIT * 6);
+	if (!p)
+		return false;
+	p = xdr_encode_hyper(p, (u64)fhp->fh_pre_size);
+	p = encode_nfstime3(p, &fhp->fh_pre_mtime);
+	encode_nfstime3(p, &fhp->fh_pre_ctime);
+
+	return true;
+}
+
+static bool
+svcxdr_encode_pre_op_attr(struct xdr_stream *xdr, const struct svc_fh *fhp)
+{
+	if (!fhp->fh_pre_saved) {
+		if (xdr_stream_encode_item_absent(xdr) < 0)
+			return false;
+		return true;
+	}
+
+	if (xdr_stream_encode_item_present(xdr) < 0)
+		return false;
+	return svcxdr_encode_wcc_attr(xdr, fhp);
+}
+
 static bool
 svcxdr_encode_post_op_attr(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 			   const struct svc_fh *fhp)
@@ -460,6 +489,39 @@ nfs3svc_encode_post_op_attr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fh
 	return encode_post_op_attr(rqstp, p, fhp);
 }
 
+/*
+ * Encode weak cache consistency data
+ */
+static bool
+svcxdr_encode_wcc_data(struct svc_rqst *rqstp, struct xdr_stream *xdr,
+		       const struct svc_fh *fhp)
+{
+	struct dentry *dentry = fhp->fh_dentry;
+
+	if (!dentry || !d_really_is_positive(dentry) || !fhp->fh_post_saved)
+		goto neither;
+
+	/* before */
+	if (!svcxdr_encode_pre_op_attr(xdr, fhp))
+		return false;
+
+	/* after */
+	if (xdr_stream_encode_item_present(xdr) < 0)
+		return false;
+	if (!svcxdr_encode_fattr3(rqstp, xdr, fhp, &fhp->fh_post_attr))
+		return false;
+
+	return true;
+
+neither:
+	if (xdr_stream_encode_item_absent(xdr) < 0)
+		return false;
+	if (!svcxdr_encode_post_op_attr(rqstp, xdr, fhp))
+		return false;
+
+	return true;
+}
+
 /*
  * Enocde weak cache consistency data
  */
@@ -855,11 +917,11 @@ nfs3svc_encode_getattrres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_encode_wccstat(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_attrstat *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	p = encode_wcc_data(rqstp, p, &resp->fh);
-	return xdr_ressize_check(rqstp, p);
+	return svcxdr_encode_nfsstat3(xdr, resp->status) &&
+		svcxdr_encode_wcc_data(rqstp, xdr, &resp->fh);
 }
 
 /* LOOKUP */
-- 
2.43.0



