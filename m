Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59E5D177986;
	Tue, 18 Jun 2024 12:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715479; cv=none; b=OrYPE77JV8ihdinPgTJfWmsi8U9iTTehCaKwc4VLVlD6Hbw0CZeWzIQ+kPq0iKEL1doxaHFQpol0AR7/OCbaztKXoDYRCW1auvGMi5j/rCDeP0LcsPafhrTPSBM3MP/l5DtvDwqhhsL9q+EnJWmvsovVzMXSviSZFTqcj/rVXog=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715479; c=relaxed/simple;
	bh=iU2vqvKq3++4wx/mLAzaN6rYuFTvv+RJMnVTrl4+Zw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chHreVfY6IKhqltpPkFmjzoNnX6r/qn3HAWtmBp5r90h1KxNUuNSBWE++4ndGxvWRLKUlW7PFYNRXW5L9wAMkDA+FY+uTku2JnZXAwgXoXjN22qEO+LuI47KHI9jMPPnT/ybzpjQqga+0O8cbEzqW+6p+B59KAoRpi8UKDQd/ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yqCBq+qW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yqCBq+qW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C971DC3277B;
	Tue, 18 Jun 2024 12:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715479;
	bh=iU2vqvKq3++4wx/mLAzaN6rYuFTvv+RJMnVTrl4+Zw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yqCBq+qW9Tk0+o2Sa7dFfuxxRMXkPMFvEXQ9A+KVC6viOqdCf/PXHprCmpn/9vQM8
	 6/axbckMrpNswtFet+d1iF/nsYyp3NfUESUTtbKGg85HcDH63xjIpo/qi2MzGiX6EF
	 0l7K+6hTmz6MEYEHkANFpVW8nnTYmNN2nREqxtBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 323/770] lockd: Update the NLMv4 FREE_ALL arguments decoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:56 +0200
Message-ID: <20240618123419.724943920@linuxfoundation.org>
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

[ Upstream commit 3049e974a7c7cfa0c15fb807f4a3e75b2ab8517a ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr4.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index e6bab1d1e41fb..6c5383bef2bf7 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -309,6 +309,21 @@ nlm4svc_decode_shareargs(struct svc_rqst *rqstp, __be32 *p)
 	return 1;
 }
 
+int
+nlm4svc_decode_notify(struct svc_rqst *rqstp, __be32 *p)
+{
+	struct xdr_stream *xdr = &rqstp->rq_arg_stream;
+	struct nlm_args *argp = rqstp->rq_argp;
+	struct nlm_lock	*lock = &argp->lock;
+
+	if (!svcxdr_decode_string(xdr, &lock->caller, &lock->len))
+		return 0;
+	if (xdr_stream_decode_u32(xdr, &argp->state) < 0)
+		return 0;
+
+	return 1;
+}
+
 int
 nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
@@ -342,19 +357,6 @@ nlm4svc_encode_res(struct svc_rqst *rqstp, __be32 *p)
 	return xdr_ressize_check(rqstp, p);
 }
 
-int
-nlm4svc_decode_notify(struct svc_rqst *rqstp, __be32 *p)
-{
-	struct nlm_args *argp = rqstp->rq_argp;
-	struct nlm_lock	*lock = &argp->lock;
-
-	if (!(p = xdr_decode_string_inplace(p, &lock->caller,
-					    &lock->len, NLM_MAXSTRLEN)))
-		return 0;
-	argp->state = ntohl(*p++);
-	return xdr_argsize_check(rqstp, p);
-}
-
 int
 nlm4svc_encode_void(struct svc_rqst *rqstp, __be32 *p)
 {
-- 
2.43.0



