Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E532C382F2F;
	Sat, 17 Oct 2026 17:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259769; cv=none; b=mw4Kie+NevgfyMeOuemJNpzqlN7lrP0g1R+an0mpCcNMLrdXXCx1B0bpH99vv+rZHiYP1hxu67Jvl4+UxZiuq39FZtD/ismywBe3jUlQMxsN60IfsmDZdbt6WZXjCNuvNsll6MB5lSBfXv6C1pNDInPPz5Mg7ove+dwTl/hfD9w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259769; c=relaxed/simple;
	bh=keJbLUx4Or08IdWK0D8dekfb2FU9bV6wkdSUuAnnT9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kF4mR5lvQ8gamfbccaguolOn9nYnS09kIXQvObeWRC8sVuHfuYi+RF2ExLWGg3kcqzby+HUcsRUEgWeLUIZCYpAqD1BnaO7s3ub+TnORvyPUi1enbApCUfMfW444wkXoM/i13SL6NRXU6ytNYIRRJrp+b6b556y2vUkLCjB2akw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00dUxSHD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00dUxSHD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49F311F000C4;
	Sat, 17 Oct 2026 17:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259768;
	bh=pV7ldt8m1asJLb9evvj826ssNPjKzmrFWkv4enW0K+w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=00dUxSHDlSeiiJa17ZyWyNEP9tok5j8kC3qp2pMKWNFJFUAONmKVH48pX4Bq5dcaM
	 DUnF+4tcD/Hz/9tPjMB2U+dEaiGzQo0UU88CpIa1jM99Uf01poG/IeM8VHg3uPH8Z0
	 RKFjtYVnvGHMhBINmGoL9BpgUu9H0dTLT//0usXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1284/1674] svcrdma: Reject Read lists that exceed the page budget
Date: Sat, 17 Oct 2026 17:59:16 +0200
Message-ID: <20261017160504.099392194@linuxfoundation.org>
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

[ Upstream commit 0ca487abb3bdf581851664b5db21f364caf57682 ]

Individual Read segment lengths are validated at decode time, but
nothing prevents a requester from sending multiple segments whose
cumulative length exceeds the rq_pages array budget. When one
segment fills the page array exactly, the runtime guard in
svc_rdma_build_read_segment() is bypassed because len reaches zero.
A subsequent segment then accesses the NULL sentinel slot at
rq_pages[rq_maxpages], resulting in a NULL pointer dereference during
DMA mapping.

Accumulate pages across all Read segments and reject the message at
decode time when the total would overflow the page budget.

Fixes: 026d958b38c6 ("svcrdma: Add recvfrom helpers to svc_rdma_rw.c")
Cc: stable@vger.kernel.org
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sunrpc/svc_rdma.h         |  1 +
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c | 13 +++++++++++--
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/sunrpc/svc_rdma.h b/include/linux/sunrpc/svc_rdma.h
index a5ee0af2a3103..7f7605867778c 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -137,6 +137,7 @@ struct svc_rdma_recv_ctxt {
 	struct xdr_stream	rc_stream;
 	u32			rc_byte_len;
 	unsigned int		rc_page_count;
+	unsigned int		rc_maxpages;
 	u32			rc_inv_rkey;
 	__be32			rc_msgtype;
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 9cec7bcb8a976..9d60faf3de45d 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -411,11 +411,14 @@ static void svc_rdma_build_arg_xdr(struct svc_rqst *rqstp,
  *	    to the first byte past the Read list. rc_read_pcl and
  *	    rc_call_pcl cl_count fields are set to the number of
  *	    Read segments in the list.
- *  %false: Read list is corrupt. @rctxt's xdr_stream is left in an
- *	    unknown state.
+ *  %false: Read list is corrupt or exceeds the page budget. @rctxt's
+ *	    xdr_stream is left in an unknown state.
  */
 static bool xdr_count_read_segments(struct svc_rdma_recv_ctxt *rctxt, __be32 *p)
 {
+	unsigned int maxlen = rctxt->rc_maxpages << PAGE_SHIFT;
+	unsigned int total_len = 0;
+
 	rctxt->rc_call_pcl.cl_count = 0;
 	rctxt->rc_read_pcl.cl_count = 0;
 	while (xdr_item_is_present(p)) {
@@ -429,6 +432,11 @@ static bool xdr_count_read_segments(struct svc_rdma_recv_ctxt *rctxt, __be32 *p)
 
 		xdr_decode_read_segment(p, &position, &handle,
 					    &length, &offset);
+		if (length > maxlen)
+			return false;
+		total_len += length;
+		if (PAGE_ALIGN(total_len) > maxlen)
+			return false;
 		if (position) {
 			if (position & 3)
 				return false;
@@ -824,6 +832,7 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 				   ctxt->rc_recv_sge.addr, ctxt->rc_byte_len,
 				   DMA_FROM_DEVICE);
 	svc_rdma_build_arg_xdr(rqstp, ctxt);
+	ctxt->rc_maxpages = rqstp->rq_page_end - rqstp->rq_pages;
 
 	ret = svc_rdma_xdr_decode_req(&rqstp->rq_arg, ctxt);
 	if (ret < 0)
-- 
2.53.0



