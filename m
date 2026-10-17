Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE6E21FF23;
	Sat, 17 Oct 2026 17:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259772; cv=none; b=vDAsxP3GovO4xV+4+LwF1Ia/T2KlnSS8SxNmqHZlyKMmScPEWwyh72EFR7S6IwxiZkcE6lzsShkzu8kjFo3h/YPM95qJ4YHYOH6jEN3BgFFN/hx2SpaIxYT2MwpA53hkm9e6O6B2UdX5jZ6W/BPw63pQgvtrz0xG2GMOFn9sqs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259772; c=relaxed/simple;
	bh=46VjdIcGoPxXajZAKC6rQuWO1TvJd17gL0UvqLMSyyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIcAervwcwYJXezirHw8lfbgvmpdad1AH09AfvHkO0Jipo3NMBtZkgmf/uc05vCKCy3W+UZYXrW7D2Di0Ue3rBoviWyi11GYIyF1SYPNL9SdfybLPEXRJIxoqyqV06zT5VyUrgxWlkOa30Ks9pSUDrex7FzFOXsSckkRi/k5SrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J3vzoOZC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J3vzoOZC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301EC1F000C4;
	Sat, 17 Oct 2026 17:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259771;
	bh=QRAE57V5Em1MfhcBuF/Z9Lh1zQMC89wHaSL5Ru5oohc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J3vzoOZCyCETYiGNUT9Dx6ViyNTIWyv1WC1XgmKcAd5GcFwVf3Mgd8JnJommsC0PA
	 zsa/zztSo0X0jmeReWxaW54ngyoFlK21816WQvVn0sr3ug/RvGvCR+/Sd/8bqT5fgd
	 Gzl18dT8ENH3jeERq+ruLkOTeeufQa9U9ZAInY/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@meta.com>,
	Chuck Lever <cel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1285/1674] svcrdma: Reject inline replies that overflow the pull-up buffer
Date: Sat, 17 Oct 2026 17:59:17 +0200
Message-ID: <20261017160504.124446574@linuxfoundation.org>
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
index c6644cca52c57..c7800779ac937 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_sendto.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_sendto.c
@@ -650,20 +650,21 @@ static int svc_rdma_xb_count_sges(const struct xdr_buf *xdr,
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
@@ -675,11 +676,22 @@ static bool svc_rdma_pull_up_needed(const struct svcxprt_rdma *rdma,
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
@@ -735,7 +747,7 @@ static int svc_rdma_xb_linearize(const struct xdr_buf *xdr,
  * Assemble the elements of @xdr into the transport header buffer.
  *
  * Assumptions:
- *  pull_up_needed has determined that @xdr will fit in the buffer.
+ *  check_pull_up has determined that @xdr will fit in the buffer.
  *
  * Returns:
  *   %0 if pull-up was successful
@@ -769,6 +781,7 @@ static int svc_rdma_pull_up_reply_msg(const struct svcxprt_rdma *rdma,
  *
  * Returns:
  *   %0 if DMA mapping was successful.
+ *   %-E2BIG if the reply is too large to be pulled up
  *   %-EMSGSIZE if a buffer manipulation problem occurred
  *   %-EIO if DMA mapping failed
  *
@@ -783,6 +796,7 @@ int svc_rdma_map_reply_msg(struct svcxprt_rdma *rdma,
 		.md_rdma	= rdma,
 		.md_ctxt	= sctxt,
 	};
+	int ret;
 
 	/* Set up the (persistently-mapped) transport header SGE. */
 	sctxt->sc_send_wr.num_sge = 1;
@@ -797,7 +811,10 @@ int svc_rdma_map_reply_msg(struct svcxprt_rdma *rdma,
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
@@ -974,7 +991,7 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 
 	ret = svc_rdma_send_reply_chunk(rdma, rctxt, &rqstp->rq_res);
 	if (ret < 0)
-		goto reply_chunk;
+		goto send_err;
 	rc_size = ret;
 
 	*p++ = *rdma_argp;
@@ -994,10 +1011,10 @@ int svc_rdma_sendto(struct svc_rqst *rqstp)
 
 	ret = svc_rdma_send_reply_msg(rdma, sctxt, rctxt, rqstp);
 	if (ret < 0)
-		goto put_ctxt;
+		goto send_err;
 	return 0;
 
-reply_chunk:
+send_err:
 	if (ret != -E2BIG && ret != -EINVAL)
 		goto put_ctxt;
 
-- 
2.53.0



