Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6473B155737;
	Tue, 18 Jun 2024 12:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715485; cv=none; b=WeAC3pD7TAA4SAyCTiySi6ryu2p7ETMcGdxEZYLfMvZq5r4TvDhW38SuP9zTx5B/bkRmB1ybbjAtXEsfS7x0x3X1l2fIAv8HMc0ifKoa8ftsOUzeVUx+4QFihII6NkLL5xMcClTjufK056/7KSqD7HTV+3vzeuxVBq+C2zB5/r0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715485; c=relaxed/simple;
	bh=gOmFKFIO/mPpkXpwc5DOI8C/O2Z03QO29TmLvJU4eN4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifxo7CPCpcEyOSTFvx1C0C5PU37muDClRVAIPKg6doB4/taH3PWs9kOH6VfcNLaNEiYPt9y1UJKhdlNDB/NQ8+SAQ2riwUo7i53gz7Eu6ND4MTa2Q+dR9d5+7dg+qFwS2SyGlLhqa9VC9eYv1IlsUs/hLiwUdzxFbtT6jLyTQzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smXMPiEL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smXMPiEL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCC4C3277B;
	Tue, 18 Jun 2024 12:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715485;
	bh=gOmFKFIO/mPpkXpwc5DOI8C/O2Z03QO29TmLvJU4eN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=smXMPiELOOZNijLF3kUv6DQDjvwxV0EvEz+9xbjTkwK5G+bx5qWhFZi9u0cQX84AZ
	 QvvCYDtyDUVR3Fnn8oq3i+E0Rob8e/I3Osw++XErzopthQeagPMN6GBPQr22+DfYhV
	 QUDtmtLcOzSMtZurrtoGi/hlOEbMF6KAQx/9EMEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	"J. Bruce Fields" <bfields@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 325/770] lockd: Update the NLMv4 TEST results encoder to use struct xdr_stream
Date: Tue, 18 Jun 2024 14:32:58 +0200
Message-ID: <20240618123419.803494396@linuxfoundation.org>
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

[ Upstream commit 1beef1473ccaa70a2d54f9e76fba5f534931ea23 ]

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/xdr4.c | 74 ++++++++++++++++++++++++-------------------------
 1 file changed, 36 insertions(+), 38 deletions(-)

diff --git a/fs/lockd/xdr4.c b/fs/lockd/xdr4.c
index 0db142e203d2b..9b8a7afb935ca 100644
--- a/fs/lockd/xdr4.c
+++ b/fs/lockd/xdr4.c
@@ -20,8 +20,6 @@
 
 #include "svcxdr.h"
 
-#define NLMDBG_FACILITY		NLMDBG_XDR
-
 static inline loff_t
 s64_to_loff_t(__s64 offset)
 {
@@ -110,44 +108,44 @@ svcxdr_decode_lock(struct xdr_stream *xdr, struct nlm_lock *lock)
 	return true;
 }
 
-/*
- * Encode result of a TEST/TEST_MSG call
- */
-static __be32 *
-nlm4_encode_testres(__be32 *p, struct nlm_res *resp)
+static bool
+svcxdr_encode_holder(struct xdr_stream *xdr, const struct nlm_lock *lock)
 {
-	s64		start, len;
+	const struct file_lock *fl = &lock->fl;
+	s64 start, len;
 
-	dprintk("xdr: before encode_testres (p %p resp %p)\n", p, resp);
-	if (!(p = nlm4_encode_cookie(p, &resp->cookie)))
-		return NULL;
-	*p++ = resp->status;
+	/* exclusive */
+	if (xdr_stream_encode_bool(xdr, fl->fl_type != F_RDLCK) < 0)
+		return false;
+	if (xdr_stream_encode_u32(xdr, lock->svid) < 0)
+		return false;
+	if (!svcxdr_encode_owner(xdr, &lock->oh))
+		return false;
+	start = loff_t_to_s64(fl->fl_start);
+	if (fl->fl_end == OFFSET_MAX)
+		len = 0;
+	else
+		len = loff_t_to_s64(fl->fl_end - fl->fl_start + 1);
+	if (xdr_stream_encode_u64(xdr, start) < 0)
+		return false;
+	if (xdr_stream_encode_u64(xdr, len) < 0)
+		return false;
+
+	return true;
+}
 
-	if (resp->status == nlm_lck_denied) {
-		struct file_lock	*fl = &resp->lock.fl;
-
-		*p++ = (fl->fl_type == F_RDLCK)? xdr_zero : xdr_one;
-		*p++ = htonl(resp->lock.svid);
-
-		/* Encode owner handle. */
-		if (!(p = xdr_encode_netobj(p, &resp->lock.oh)))
-			return NULL;
-
-		start = loff_t_to_s64(fl->fl_start);
-		if (fl->fl_end == OFFSET_MAX)
-			len = 0;
-		else
-			len = loff_t_to_s64(fl->fl_end - fl->fl_start + 1);
-		
-		p = xdr_encode_hyper(p, start);
-		p = xdr_encode_hyper(p, len);
-		dprintk("xdr: encode_testres (status %u pid %d type %d start %Ld end %Ld)\n",
-			resp->status, (int)resp->lock.svid, fl->fl_type,
-			(long long)fl->fl_start,  (long long)fl->fl_end);
+static bool
+svcxdr_encode_testrply(struct xdr_stream *xdr, const struct nlm_res *resp)
+{
+	if (!svcxdr_encode_stats(xdr, resp->status))
+		return false;
+	switch (resp->status) {
+	case nlm_lck_denied:
+		if (!svcxdr_encode_holder(xdr, &resp->lock))
+			return false;
 	}
 
-	dprintk("xdr: after encode_testres (p %p resp %p)\n", p, resp);
-	return p;
+	return true;
 }
 
 
@@ -338,11 +336,11 @@ nlm4svc_encode_void(struct svc_rqst *rqstp, __be32 *p)
 int
 nlm4svc_encode_testres(struct svc_rqst *rqstp, __be32 *p)
 {
+	struct xdr_stream *xdr = &rqstp->rq_res_stream;
 	struct nlm_res *resp = rqstp->rq_resp;
 
-	if (!(p = nlm4_encode_testres(p, resp)))
-		return 0;
-	return xdr_ressize_check(rqstp, p);
+	return svcxdr_encode_cookie(xdr, &resp->cookie) &&
+		svcxdr_encode_testrply(xdr, resp);
 }
 
 int
-- 
2.43.0



