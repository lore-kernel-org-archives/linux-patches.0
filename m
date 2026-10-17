Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF33390C8A;
	Sat, 17 Oct 2026 16:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254922; cv=none; b=ITXPK7ypXktslEjVpEeucCIUT8OppjVb5ifZxCjZSFcoTLqUakng8uou4mF6z03s7GXIiEvviZDMRKxOrdyXSZTanjlHoZAp+sLXJl+r1f9zQsogg9mNXdoR1o3idotf9+MHIAwk0yc8xTLtZwzqYSNhd7ijjT5LhN6NrZ4cOk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254922; c=relaxed/simple;
	bh=vTBDld3SiJKu651lKuFcM6S6O5kvJD/EhyjHU26vAbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JrVl/MwU3MEfMk+2S5tWRB8RoJ7tVq1cZ+x45OIZ1e1B2ajRdJ7f/kbVweRwHcSXIF/XP9/yUz8csvGK4+H+9uO6sTVpT0A9tHTRPRpaX38RDNNrflZu9dynOxc2If42EGWTJxqXAwgFFyI2m6yckig5VtimnyGHOiRajKyyPm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rlk3jhw4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rlk3jhw4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16AC1F000C4;
	Sat, 17 Oct 2026 16:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254921;
	bh=ENFrTjt91W+rEaPLQSFtk/m2YEfjG/JuXBi8Ki0r1ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rlk3jhw4rAFXL8GyDiz0//qYKzEg2MzT6pipVbOQS+Y7KZsk/5WHQ+35ZNavg5FqE
	 Zk65z+bCmTDtJW9szR8H7KNrPnF4eNDbbiv3lbL+Zio+6O2HybgLY9cO18kjx+xrwT
	 b7AxyzCh5ZI8q8BTjbt8Nh6/nMLRP2zp03GhNdJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 563/869] svcrdma: Reject Read lists that exceed the page budget
Date: Sat, 17 Oct 2026 17:56:44 +0200
Message-ID: <20261017160051.510268253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 68a0aa627455d..1588363f76ac3 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -430,11 +430,14 @@ static void svc_rdma_build_arg_xdr(struct svc_rqst *rqstp,
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
+	unsigned int maxlen = (rctxt->rc_maxpages - 2) << PAGE_SHIFT;
+	unsigned int total_len = 0;
+
 	rctxt->rc_call_pcl.cl_count = 0;
 	rctxt->rc_read_pcl.cl_count = 0;
 	while (xdr_item_is_present(p)) {
@@ -448,6 +451,12 @@ static bool xdr_count_read_segments(struct svc_rdma_recv_ctxt *rctxt, __be32 *p)
 
 		xdr_decode_read_segment(p, &position, &handle,
 					    &length, &offset);
+		if (length > maxlen)
+			return false;
+		total_len += length;
+		if (PAGE_ALIGN(total_len + rctxt->rc_byte_len -
+			       xdr_stream_pos(&rctxt->rc_stream)) > maxlen)
+			return false;
 		if (position) {
 			if (position & 3)
 				return false;
-- 
2.53.0



