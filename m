Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB1F15216F;
	Tue, 18 Jun 2024 12:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715135; cv=none; b=uNzowJfTDZ8IfGnywKmGsv8ZKOiSZz/BeSos9ADWNxOut/EzJ3wY3Ev83LR1yNtoMTKnm/UPd3FL0fLN392XpBWczphjFs7qiIC+/YkhdIlMGYfABgZrwlxC8qfxfSwkGCTfvEBi8dtA80RRhs8wqUZhOeN/u0j4uWKLPsa8Qxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715135; c=relaxed/simple;
	bh=U0ew01HOOgG5/ijVIUuzUwNw+LVSP+bMpM5e5OcDpf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aqe+MDtVfIfam8CFko67Cykw3mRI08RCGz1eWd5ypZluJmFuwuClztNfziDkHy5guufb68DdZN4RHwMCQCsgEwm3KGf3Wf21QVu013b7ov301lI75TTGxj7pMIVF0oyw1Uv+MtN+4REhmLIw+aHE1kBKmPQZPNw8RyiosJrT748=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uht2gte1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uht2gte1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2E1C32786;
	Tue, 18 Jun 2024 12:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715135;
	bh=U0ew01HOOgG5/ijVIUuzUwNw+LVSP+bMpM5e5OcDpf8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uht2gte1RRgKkw6A9KYw9M3cQwfy266aR6m6NapE8t5//2Jsqn4fmBHZHkqqjh5BK
	 tYM3czQFVBu9pdJl1WYNrrH/fPoq78W9mESlsxHlS5633HwxAV+wAJnA/ms487Qcjk
	 yvtJgbFNQ5D/28wjoilRHWMM7bol14oXfV/btihg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 205/770] NFSD: Update the NFSv3 CREATE family of encoders to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:30:58 +0200
Message-ID: <20240618123415.190915942@linuxfoundation.org>
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

[ Upstream commit 78315b36781d259dcbdc102ff22c3f2f25712223 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/nfs3xdr.c | 35 ++++++++++++++++++++++++++++-------
 1 file changed, 28 insertions(+), 7 deletions(-)

diff --git a/fs/nfsd/nfs3xdr.c b/fs/nfsd/nfs3xdr.c
index 0191cbfc486b8..052376a65f723 100644
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -121,6 +121,17 @@ svcxdr_encode_nfs_fh3(struct xdr_stream *xdr, const struct svc_fh *fhp)
 	return true;
 }
 
+static bool
+svcxdr_encode_post_op_fh3(struct xdr_stream *xdr, const struct svc_fh *fhp)
+{
+	if (xdr_stream_encode_item_present(xdr) < 0)
+		return false;
+	if (!svcxdr_encode_nfs_fh3(xdr, fhp))
+		return false;
+
+	return true;
+}
+
 static __be32 *
 encode_fh(__be32 *p, struct svc_fh *fhp)
 {
@@ -1079,16 +1090,26 @@ nfs3svc_encode_writeres(struct svc_rqst *rqstp, __be32 *p)
 int
 nfs3svc_encode_createres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nfsd3_diropres *resp = rqstp->rq_resp;
 
-	*p++ = resp->status;
-	if (resp->status == 0) {
-		*p++ = xdr_one;
-		p = encode_fh(p, &resp->fh);
-		p = encode_post_op_attr(rqstp, p, &resp->fh);
+	if (!svcxdr_encode_nfsstat3(xdr, resp->status))
+		return 0;
+	switch (resp->status) {
+	case nfs_ok:
+		if (!svcxdr_encode_post_op_fh3(xdr, &resp->fh))
+			return 0;
+		if (!svcxdr_encode_post_op_attr(rqstp, xdr, &resp->fh))
+			return 0;
+		if (!svcxdr_encode_wcc_data(rqstp, xdr, &resp->dirfh))
+			return 0;
+		break;
+	default:
+		if (!svcxdr_encode_wcc_data(rqstp, xdr, &resp->dirfh))
+			return 0;
 	}
-	p = encode_wcc_data(rqstp, p, &resp->dirfh);
-	return xdr_ressize_check(rqstp, p);
+
+	return 1;
 }
 
 /* RENAME */
-- 
2.43.0



