Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECC914F130;
	Tue, 18 Jun 2024 12:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715242; cv=none; b=DP1zabY54GoNwvWMkJbr5w8XAfPg70wq/Z68Rwqd8St02fNiQwj0d8b8nOrY8t+QYlon6A+fPpQG+cwmgsoifdW1KuUgakkN73OWmsV++FqVoPVxrSlYZkykAg+d+68EARZLCa/Y3PTIINBIic4p12hLY5jw+Skc8FgzXDczUBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715242; c=relaxed/simple;
	bh=KTaBXpfa6VDnRgp5chh98Yq9A6AxDntSkFwSDGQrAjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqvXwxcgubRQ6hbDWYVmmueDh/NsB5s4s1vTAst9Sq4kpnaHXVuyP8rQzUJ8MfgMpK0GgrBfc0k/zErwM5K1WZ8Js/7QEWAY8wAMnGhnIHB4DIBk+MCrNtXu6h/I0IoT+ijrh5Sor4cNwqSy2sbABlbnrDAx00e50kSlt2KTuXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jMwBQkEv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jMwBQkEv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7208BC3277B;
	Tue, 18 Jun 2024 12:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715241;
	bh=KTaBXpfa6VDnRgp5chh98Yq9A6AxDntSkFwSDGQrAjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jMwBQkEvKAC6HrChF1OIoNNhMyARWEf26Qp5VDRQfKbIFormFhpkYkFO5z1To3/6v
	 goPjvx8/pD0W4iJAGEMM6iVuiBBiPJEJtnq5XdIt8k6SrBpEbL10pyFqoO8pk4UkvZ
	 KK2KNgy3SbEx4dy7Q+Vly26KkjITfN6gIfpF7NIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 211/770] NFSD: Update the NFSv3 COMMIT3res encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:31:04 +0200
Message-ID: <20240618123415.419764681@linuxfoundation.org>
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

[ Upstream commit 5ef2826c761079e27904c85034df34e601b82d94 ]

As an additional clean up, encode_wcc_data() is removed because it
is now no longer used.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 54 +++++++++++++----------------------------------
 1 file changed, 15 insertions(+), 39 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 1467bba02e180..eab14b52db202 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -432,14 +432,6 @@ encode_fattr3(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp,
 	return p;
 }
 
-static __be32 *
-encode_saved_post_attr(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
-{
-	/* Attributes to follow */
-	*p++ = xdr_one;
-	return encode_fattr3(rqstp, p, fhp, &fhp->fh_post_attr);
-}
-
 static bool
 svcxdr_encode_wcc_attr(struct xdr_stream *xdr, const struct svc_fh *fhp)
 {
@@ -562,30 +554,6 @@ svcxdr_encode_wcc_data(struct svc_rqst *rqstp, struct xdr_stream *xdr,
 	return true;
 }
 
-/*
- * Enocde weak cache consistency data
- */
-static __be32 *
-encode_wcc_data(struct svc_rqst *rqstp, __be32 *p, struct svc_fh *fhp)
-{
-	struct dentry	*dentry = fhp->fh_dentry;
-
-	if (dentry && d_really_is_positive(dentry) && fhp->fh_post_saved) {
-		if (fhp->fh_pre_saved) {
-			*p++ = xdr_one;
-			p = xdr_encode_hyper(p, (u64) fhp->fh_pre_size);
-			p = encode_time3(p, &fhp->fh_pre_mtime);
-			p = encode_time3(p, &fhp->fh_pre_ctime);
-		} else {
-			*p++ = xdr_zero;
-		}
-		return encode_saved_post_attr(rqstp, p, fhp);
-	}
-	/* no pre- or post-attrs */
-	*p++ = xdr_zero;
-	return encode_post_op_attr(rqstp, p, fhp);
-}
-
 static bool fs_supports_change_attribute(struct super_block *sb)
 {
 	return sb->s_flags & SB_I_VERSION || sb->s_export_op->fetch_iversion;
@@ -1548,16 +1516,24 @@ nfs3svc_encode_pathconfres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_encode_commitres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_commitres *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	p = encode_wcc_data(rqstp, p, &resp->fh);
-	/* Write verifier */
-	if (resp->status == 0) {
-		*p++ = resp->verf[0];
-		*p++ = resp->verf[1];
+	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_wcc_data(rqstp, xdr, &resp->fh))
+			return 0;
+		if (!svcxdr_encode_writeverf3(xdr, resp->verf))
+			return 0;
+		break;
+	default:
+		if (!svcxdr_encode_wcc_data(rqstp, xdr, &resp->fh))
+			return 0;
 	}
-	return xdr_ressize_check(rqstp, p);
+
+	return 1;
 }
 
 /*
-- 
2.43.0



