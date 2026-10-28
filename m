Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216299;
	b=hPQo7EqsnBQCAIiMybHQJ/lfNzTYmmlmdhz1ESj9lmzJDDXmuaIgcHgnjTmqduu9Tvz/
	 YZwMiWffkpl+3/eBn9NgzXJpwOPjZuHoa5pBraNuSJNI1ugt8bMYMzxz2Qt4TlEDf9hkF
	 y0uINcVWTwKTK+YN/8vuxgbzB1jgfXVgdpBKqjTjtwsbr/pbJhRL6ZEb/rC+QvjuF5HaA
	 G1JAqSp7r7oBJu8RhLsK2IgUmw61glupP6JpBZA5FjD19ZdnWkHKIoTrgPI5a5DWpeWX0
	 nD0e5P2PUqr9/nMtslseFOrLQkSXNYFnJjYXUHowUJXmr0BVlYBmudDRBRfpTrI7qmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216299;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1eS+uKxw5rsIW7LJ1QojxaRHMwdWoqhedb4h0fEg/Pg=;
	b=wsHNacDXaYmEd7emHm66i5qpWcw/wrcRsKvB1vp7J2pUl9cFu9BMGBxXpvULSuFAQIk6
	 6o+F7BJGsQSCQDpk6ClE8ZT89DAaWN3tKQnHiSry3Wngp1hKRA5XKrFvU/00UjRx4PlAQ
	 4hB3Ibe7f/sKy+6JEZ1xx6Z1aA5dZjA50dzy9UwZo2bId7mJJZE5QY3n0G5idUl8XIOlu
	 /pfN7kQljbnUw3P/crCkYCq3gjLxRM7mUOesfWdO6TGZn9XjDsYk/cnBHWZJA6iVSjPIo
	 f4L29NMRDR192//jXJakg0fj8JumeLnwv2kCjpFS5DwHMdAMjBru0B85uOLQUxDuh1w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oCJ3WfF3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F6A660A2606;
	Wed, 28 Oct 2026 19:38:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oCJ3WfF3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0B2E1F01828;
	Wed, 28 Oct 2026 19:38:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216299;
	bh=1eS+uKxw5rsIW7LJ1QojxaRHMwdWoqhedb4h0fEg/Pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oCJ3WfF3ZNVtQpCEj95SWQ4cULIExM595QNap7JhQe2ZMbjl50fGU7m4n/FjV2Y5v
	 8z857EmHsEWHj0dI6ysZpeQWspguIQPm1fFhZ5mOwI8ZNn8Z79cR9AOLb4AT7XCsKc
	 V7lS/eINa2KGmXuUosJNNgvzv8XFNpJ3JPoRmeYM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1466/1887] svcrdma: Reject Read lists that exceed the page budget
Date: Wed, 28 Oct 2026 17:59:22 +0100
Message-ID: <20261028170532.816133105@linuxfoundation.org>
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
index fbc4bd423b355..3ac3307ce28d0 100644
--- a/include/linux/sunrpc/svc_rdma.h
+++ b/include/linux/sunrpc/svc_rdma.h
@@ -138,6 +138,7 @@ struct svc_rdma_recv_ctxt {
 	bool			rc_temp;
 	u32			rc_byte_len;
 	unsigned int		rc_page_count;
+	unsigned int		rc_maxpages;
 	u32			rc_inv_rkey;
 	__be32			rc_msgtype;
 
diff --git a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
index 186c9c12432b1..b66ded5b039a8 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_recvfrom.c
@@ -415,11 +415,14 @@ static void svc_rdma_build_arg_xdr(struct svc_rqst *rqstp,
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
@@ -433,6 +436,11 @@ static bool xdr_count_read_segments(struct svc_rdma_recv_ctxt *rctxt, __be32 *p)
 
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
@@ -830,6 +838,7 @@ int svc_rdma_recvfrom(struct svc_rqst *rqstp)
 				   ctxt->rc_recv_sge.addr, ctxt->rc_byte_len,
 				   DMA_FROM_DEVICE);
 	svc_rdma_build_arg_xdr(rqstp, ctxt);
+	ctxt->rc_maxpages = rqstp->rq_page_end - rqstp->rq_pages;
 
 	ret = svc_rdma_xdr_decode_req(&rqstp->rq_arg, ctxt);
 	if (ret < 0)
-- 
2.53.0



