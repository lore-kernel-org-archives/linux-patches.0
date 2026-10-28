Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215974;
	b=bs8cryS3ht69xut+hp06c4HIQYm3wVWe/NEiQlhOTwuN8MGd2B2eas3aGhTSBoijN8gu
	 tiifC8JTV2YMTI9ra34u8v3izlRJLqV83Mo8z2UnINe3gkTM99ALvy5osOWV/3Zgmfuf9
	 Hmc/2xEDAZ7e/yyt7gubZaD6WckX0SSGiZRsQlNRsMVhrXykV70r7+Mr4beGj/dG/nunM
	 NzxqqXMPUdP7I8PWLkhmcMU6gvx+uDcOZWaIri/ZPcMDHazxKI7ksD52TLhp+eduVUsgD
	 HjENJ3bEH2zrKt7AxTn5GqT1xOKaWyHC3rU1Wf9rWkK1eDQySnGOgkXtgy+5RZw1+Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Zmb2WeA8fVZ3nSd6A9VeewKQVR5v4gHaUW0DcviTn98=;
	b=hy1M6kncSDCCYwbXTgDBL8JgTEMNcg1HzkEN8wosvtZV7L5kIVLCCdvSb4Wpim23GTMU
	 KTh1zykB2BUyzDDemWupK4QZQ01mOSH5Csp5tuzQ1JNTjSqcZO4SHDr0u2+khwOnV93Se
	 4TCBbgubly8CPWGh+HqVlWNIj6tI/2bySIpxH6NDYPqt500jwsqWv1vjiMxvkcUMXNEoO
	 u5LCN2C4FeFkVS0yD+ODLSweThuq3HvjPDIdvrWiEDKknUeCAVTjp/AdNRoMh6WwuZycQ
	 FBk9lkTyatQtcPiXQZLrqe29I966NRpev9tuOLVTsgTRPTSc8VPaI0WrCuTy31u7YTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CbW4XxKU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3D0606A323;
	Wed, 28 Oct 2026 19:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CbW4XxKU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E9321F01825;
	Wed, 28 Oct 2026 19:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215973;
	bh=Zmb2WeA8fVZ3nSd6A9VeewKQVR5v4gHaUW0DcviTn98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CbW4XxKUqle0eyAB/+jHQ4hF8t308VeZZBEIS4nRTW0NGZ5+Y9IgOR5+ggPA9Bpns
	 JXJW+l+QF/OiiDcl/LhZQRoRpo7FfCYFAyj9SvE9kVC1v8Qx/469mZ5aMzCOQ/anBk
	 erqIHZpdLqtID9Pyyr0VFXKoZC97d+DrI+Fus4WI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1396/1887] svcrdma: Reject inline replies that overflow the pull-up buffer
Date: Wed, 28 Oct 2026 17:58:12 +0100
Message-ID: <20261028170531.217182558@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 0fbe20dfe74b783d255bf389a6ea77aa25dc7860 ]

An RPC-over-RDMA client can request a reply, such as an NFS READ
payload, without providing a Write list or a Reply chunk to carry
it. When such a reply needs more scatter/gather entries than the
device's Send Queue supports, svc_rdma_pull_up_needed() selects
pull-up and svc_rdma_pull_up_reply_msg() linearizes the whole
reply into sctxt->sc_xprt_buf. That buffer is only sc_max_req_size
bytes, while the reply on this path is bounded only by the client's
request, so svc_rdma_xb_linearize() copies past the end of the
buffer and corrupts adjacent slab memory. The oversized length is
then stored in sc_sges[0].length and posted, so the device also
reads beyond the mapped region.

The SGE-exhaustion branch is the only pull-up path that can exceed
the buffer: the threshold branch pulls up only replies smaller
than RPCRDMA_PULLUP_THRESH, and replies that fit the device's SGE
budget are sent directly without linearization. Make
svc_rdma_pull_up_needed() report -E2BIG when the reply it would
pull up cannot fit sc_max_req_size, and fail the request with
ERR_CHUNK as RFC 8166 Section 4.5.3 directs rather than dropping
the connection.

The helper no longer answers a simple yes/no question: it now
reports pull-up, no pull-up, or -E2BIG for a reply too large to
linearize. Rename svc_rdma_pull_up_needed() to
svc_rdma_check_pull_up() so its name no longer implies a boolean
predicate.

Fixes: e248aa7be86e ("svcrdma: Remove max_sge check at connect time")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <clm@meta.com>
Assisted-by: kres:claude-opus-4-7
Link: https://patch.msgid.link/20260623014728.826032-1-cel@kernel.org
Signed-off-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_sendto.c | 47 ++++++++++++++++++---------
 1 file changed, 32 insertions(+), 15 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_sendto.c b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
index 22a871e6fe4dc..fd6ed6901c7c7 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -645,20 +645,21 @@ static int svc_rdma_xb_count_sges(const struct xdr_buf *xdr,
 }
 
 /**
- * svc_rdma_pull_up_needed - Determine whether to use pull-up
+ * svc_rdma_check_pull_up - Determine whether to use pull-up
  * @rdma: controlling transport
  * @sctxt: send_ctxt for the Send WR
  * @rctxt: Write and Reply chunks provided by client
  * @xdr: xdr_buf containing RPC message to transmit
  *
  * Returns:
- *   %true if pull-up must be used
- *   %false otherwise
+ *   %1 if pull-up must be used
+ *   %0 if pull-up is not needed
+ *   %-E2BIG if the reply is too large to be pulled up
  */
-static bool svc_rdma_pull_up_needed(const struct svcxprt_rdma *rdma,
-				    const struct svc_rdma_send_ctxt *sctxt,
-				    const struct svc_rdma_recv_ctxt *rctxt,
-				    const struct xdr_buf *xdr)
+static int svc_rdma_check_pull_up(const struct svcxprt_rdma *rdma,
+				   const struct svc_rdma_send_ctxt *sctxt,
+				   const struct svc_rdma_recv_ctxt *rctxt,
+				   const struct xdr_buf *xdr)
 {
 	/* Resources needed for the transport header */
 	struct svc_rdma_pullup_data args = {
@@ -670,11 +671,22 @@ static bool svc_rdma_pull_up_needed(const struct svcxprt_rdma *rdma,
 	ret = pcl_process_nonpayloads(&rctxt->rc_write_pcl, xdr,
 				      svc_rdma_xb_count_sges, &args);
 	if (ret < 0)
-		return false;
+		return 0;
 
 	if (args.pd_length < RPCRDMA_PULLUP_THRESH)
-		return true;
-	return args.pd_num_sges >= rdma->sc_max_send_sges;
+		return 1;
+	if (args.pd_num_sges < rdma->sc_max_send_sges)
+		return 0;
+
+	/*
+	 * The reply has too many SGEs to Send inline, so it has to be
+	 * linearized into sc_xprt_buf. That buffer holds only
+	 * sc_max_req_size bytes, so a larger reply cannot be pulled up.
+	 * RFC 8166 Section 4.5.3 requires responding with ERR_CHUNK.
+	 */
+	if (args.pd_length > rdma->sc_max_req_size)
+		return -E2BIG;
+	return 1;
 }
 
 /**
@@ -730,7 +742,7 @@ static int svc_rdma_xb_linearize(const struct xdr_buf *xdr,
  * Assemble the elements of @xdr into the transport header buffer.
  *
  * Assumptions:
- *  pull_up_needed has determined that @xdr will fit in the buffer.
+ *  check_pull_up has determined that @xdr will fit in the buffer.
  *
  * Returns:
  *   %0 if pull-up was successful
@@ -764,6 +776,7 @@ static int svc_rdma_pull_up_reply_msg(const struct svcxprt_rdma *rdma,
  *
  * Returns:
  *   %0 if DMA mapping was successful.
+ *   %-E2BIG if the reply is too large to be pulled up
  *   %-EMSGSIZE if a buffer manipulation problem occurred
  *   %-EIO if DMA mapping failed
  *
@@ -778,6 +791,7 @@ int svc_rdma_map_reply_msg(struct svcxprt_rdma *rdma,
 		.md_rdma	= rdma,
 		.md_ctxt	= sctxt,
 	};
+	int ret;
 
 	/* Set up the (persistently-mapped) transport header SGE. */
 	sctxt->sc_send_wr.num_sge = 1;
@@ -792,7 +806,10 @@ int svc_rdma_map_reply_msg(struct svcxprt_rdma *rdma,
 	/* For pull-up, svc_rdma_send() will sync the transport header.
 	 * No additional DMA mapping is necessary.
 	 */
-	if (svc_rdma_pull_up_needed(rdma, sctxt, rctxt, xdr))
+	ret = svc_rdma_check_pull_up(rdma, sctxt, rctxt, xdr);
+	if (ret < 0)
+		return ret;
+	if (ret)
 		return svc_rdma_pull_up_reply_msg(rdma, sctxt, rctxt, xdr);
 
 	return pcl_process_nonpayloads(&rctxt->rc_write_pcl, xdr,
@@ -955,7 +972,7 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 
 	ret = svc_rdma_send_reply_chunk(rdma, rctxt, &rqstp->rq_res);
 	if (ret < 0)
-		goto reply_chunk;
+		goto send_err;
 	rc_size = ret;
 
 	*p++ = *rdma_argp;
@@ -975,7 +992,7 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 
 	ret = svc_rdma_send_reply_msg(rdma, sctxt, rctxt, rqstp);
 	if (ret < 0)
-		goto put_ctxt;
+		goto send_err;
 
 	/* Prevent svc_xprt_release() from releasing the page backing
 	 * rq_res.head[0].iov_base. It's no longer being accessed by
@@ -983,7 +1000,7 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 	rqstp->rq_respages++;
 	return 0;
 
-reply_chunk:
+send_err:
 	if (ret != -E2BIG && ret != -EINVAL)
 		goto put_ctxt;
 
-- 
2.53.0



