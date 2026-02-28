Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB4B3603EC
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302736; cv=none; b=fLAfTGNkVnOw/Rg/fdBRMtcMfjGU1Sd14ruGjSes4XeeeEpvQ+ZplTGbgu31s5noO9cxCF8A+nVkAJWxWHX2jLfoZOxkCTxZSumYFnmg9p4QWUHXXIvyy84UUXerDVPAG6cMDwejLWskV0Hoxts/lLY3JGP7c6UDXuuXVHoRGcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302736; c=relaxed/simple;
	bh=XqqNWHB2Tjsv/dLLWyOSkjeIM9cY3vNEVjCC3az7YXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IdVeavka1dHsDbHg0Ngu1OU6sGrh6tzgr3+YxJS1lcoKtsc4WN45NC7ddQIwac2oliYifU1MaS4miwDB0N83BZtptzqq5ZUxWmnX97SPb/h0LBS3UAMPI/KWqclJNyJNamgvs8dllcg0U6eOcyDiDmwPOvbj1RYBLHZ4DyXZNMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VE1SB2tg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VE1SB2tg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EAF6C19423;
	Sat, 28 Feb 2026 18:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302736;
	bh=XqqNWHB2Tjsv/dLLWyOSkjeIM9cY3vNEVjCC3az7YXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VE1SB2tgMEKJS1PqvGMMNVrQvvqK8LQyP7pXTfFFlNTHEZ4eRruhNbhiSh9V4/vIr
	 no91z/J+L/h+fps12HG1anopeWvRpQAL/yTbwvdmvZEByow7EJ9pcRcNhOeuXfmxrg
	 yz3Ac6lNwm3blCWflihEmGsuGUjjmv1y0WGGaHKJk7aB+G7UKnGr9kk58Z94dmm1cN
	 Lv52kbf96YFCNJ3So86E8wu8kdZ0ITkEC0h03/OpkIs2hBNdgOgrtl03LTH1PX3vkE
	 wN1Hn/OlWKZsyUA3GPgMjlFQpOYzS7aT7Uu+aWaL1gDK3ulRQ28dCoSJnvWUpJp85f
	 /yTceJJQh3/ug==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 100/147] svcrdma: Add a batch Receive posting mechanism
Date: Sat, 28 Feb 2026 13:16:48 -0500
Message-ID: <20260228181736.1605592-100-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 77f0a2aa5cdde0524eab745f7a117706d3e3014f ]

Introduce a server-side mechanism similar to commit e340c2d6ef2a
("xprtrdma: Reduce the doorbell rate (Receive)") to post Receive
WRs in batch. Its first consumer is svc_rdma_post_recvs(), which
posts the initial set of Receive WRs.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: afcae7d7b8a2 ("RDMA/core: add rdma_rw_max_sge() helper for SQ sizing")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c | 56 ++++++++++++++++++-------
 1 file changed, 42 insertions(+), 14 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index c6ea2903c21a4..4129a2d5cc715 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -252,6 +252,47 @@ void svc_rdma_release_rqst(struct svc_rqst *rqstp)
 		svc_rdma_recv_ctxt_put(rdma, ctxt);
 }
 
+static bool svc_rdma_refresh_recvs(struct svcxprt_rdma *rdma,
+				   unsigned int wanted, bool temp)
+{
+	const struct ib_recv_wr *bad_wr = NULL;
+	struct svc_rdma_recv_ctxt *ctxt;
+	struct ib_recv_wr *recv_chain;
+	int ret;
+
+	if (test_bit(XPT_CLOSE, &rdma->sc_xprt.xpt_flags))
+		return false;
+
+	recv_chain = NULL;
+	while (wanted--) {
+		ctxt = svc_rdma_recv_ctxt_get(rdma);
+		if (!ctxt)
+			break;
+
+		trace_svcrdma_post_recv(ctxt);
+		ctxt->rc_temp = temp;
+		ctxt->rc_recv_wr.next = recv_chain;
+		recv_chain = &ctxt->rc_recv_wr;
+	}
+	if (!recv_chain)
+		return false;
+
+	ret = ib_post_recv(rdma->sc_qp, recv_chain, &bad_wr);
+	if (ret)
+		goto err_free;
+	return true;
+
+err_free:
+	trace_svcrdma_rq_post_err(rdma, ret);
+	while (bad_wr) {
+		ctxt = container_of(bad_wr, struct svc_rdma_recv_ctxt,
+				    rc_recv_wr);
+		bad_wr = bad_wr->next;
+		svc_rdma_recv_ctxt_put(rdma, ctxt);
+	}
+	return false;
+}
+
 static int __svc_rdma_post_recv(struct svcxprt_rdma *rdma,
 				struct svc_rdma_recv_ctxt *ctxt)
 {
@@ -289,20 +330,7 @@ static int svc_rdma_post_recv(struct svcxprt_rdma *rdma)
  */
 bool svc_rdma_post_recvs(struct svcxprt_rdma *rdma)
 {
-	struct svc_rdma_recv_ctxt *ctxt;
-	unsigned int i;
-	int ret;
-
-	for (i = 0; i < rdma->sc_max_requests; i++) {
-		ctxt = svc_rdma_recv_ctxt_get(rdma);
-		if (!ctxt)
-			return false;
-		ctxt->rc_temp = true;
-		ret = __svc_rdma_post_recv(rdma, ctxt);
-		if (ret)
-			return false;
-	}
-	return true;
+	return svc_rdma_refresh_recvs(rdma, rdma->sc_max_requests, true);
 }
 
 /**
-- 
2.51.0

