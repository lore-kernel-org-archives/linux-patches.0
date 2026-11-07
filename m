Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062357;
	b=k6dXh9a/f8Z/hv+3OD8guZeGGjCQxpze1jEvsw/py5R0W9EgMzRRWOdY4TQL302mSubk
	 E8LR8Dw64584p+QaQ9S8SFjgVoaf4ehpqJEoSBV9icybdfzWOqQUYXP1CArN1IYqD9C8Y
	 l28RV2khlYuWxKbqe4EvbxNYJiydjNZJKM0jgLbai41DmdzvlOi9KsfIaYD0KTBfqo93w
	 /F8+/8DajHxOEyEqKUFYrZWn5bMq6+gIIELn8TdAlUINeNvmq+1bs65p52ecgiDPveClh
	 AaNN0Wzcyuq82fnjt3+2l6pDJ+SnsRViodouwgZKXFLW23UT1Z6ORQaHcJav+Mac5Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062357;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ApIAxycnC8zrk02eLZt4f1d1Z5W/rnFTGAhiRXQeU5Y=;
	b=JflGqqgkmVvit+Itm47HvwR6HTfFXxSbEx1sg6MYMPWl4N8N9S8FCgizEUlb515WKtdJ
	 AZ4Q4uVtTyz/WxsePHMoJrrRgr2dUUKIYQfPrrosd6MUKSkyR5O0j46KEsCvguh2G+7jB
	 KwXdQMdmM990nm6rKwQFi623tXl/reLiBHpYmdSwUCPpXBEUNZhm4vNnecgGdpAeeuLUG
	 cMxbvrBm7iEf9FQ9FNMxfC/RL6LfKUCwKfCjy9uviOBsIQxbgX85RYoSC/ClBExKChahu
	 jMUgH7xdOrswL39/AV6jMzbwityZ7ko3XKasK7iTTJEm7du7oA74+B8b7nuxJnpfsVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=snEJDOGx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115FA606A32E;
	Sat,  7 Nov 2026 14:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=snEJDOGx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04671F0089F;
	Sat,  7 Nov 2026 14:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062356;
	bh=ApIAxycnC8zrk02eLZt4f1d1Z5W/rnFTGAhiRXQeU5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=snEJDOGxah2zejhKmZu5LPUyCcmFMi0lwYrTuX9VPM4Uewndlcx0lOma7HoCBIoOG
	 sD2KZ4ggWCaVHOEaFHLFTeNgrXfukquERFngpBveBNaoZ2IxZs2EiK3Nw+tuyS18bU
	 hx5xpYQhGu7KlhnLX9c8lQ4K6sRFQ1FYCs/7cdf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongjian Mu <ymu@everpuredata.com>,
	Chuck Lever <cel@kernel.org>,
	Tim Menninger <tmenninger@everpuredata.com>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1235/1536] xprtrdma: trim head iovec when the payload arrives via a Write chunk
Date: Sat,  7 Nov 2026 08:54:11 -0500
Message-ID: <20261107135032.444448280@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongjian Mu <ymu@everpuredata.com>

[ Upstream commit 9ee534a75912361308b1f956bc3e7895a082a422 ]

The upper layer sets rq_rcv_buf.head[0].iov_len from its estimate of the
reply header size. For RPCSEC_GSS that estimate includes
auth->au_ralign, which gss_create_new() initializes to GSS_VERF_SLACK >>
2 (25 XDR words, or 100 bytes) and which is corrected to the real
verifier size only after the first reply on that rpc_auth has been
unwrapped. In this case, the krb5 MIC verifier is 36 bytes, so every
request encoded before the first reply completes has a head that is 64
bytes too long.

On TCP this is harmless: xdr_realign_pages() moves the excess head
bytes, which are genuine reply data, into the page list. With
RPC-over-RDMA and a Write chunk (sec=krb5, i.e. RPC_GSS_SVC_NONE, where
DDP is allowed), the payload has already been placed directly into the
page list, and the receive buffer holds only the inline part of the
reply. rpcrdma_inline_fixup() clamps its local copy of the head length
to the inline length but leaves head.iov_len untouched, so
xdr_realign_pages() still sees iov_len > cur and shifts whatever lies
past the inline reply in the receive buffer into the front of the
directly-placed payload:

  rpc_xdr_recvfrom:  head=[...,196] page=524288 tail=[...,64]
  rpc_xdr_alignment: nfsv4 READ offset=132 copied=64

The first 64 bytes returned by each such READ are incorrect (zeroed, or
shifted right by 64 bytes depending on the kernel's xdr_shrink_bufhead()
implementation). This is readily hit with pNFS flexfiles over RDMA and
sec=krb5: the per-DS rpc_clnt gets a fresh rpc_auth whose first RPC is a
large READ. Reads following the first completed reply return the
expected data.

Commit cb0ae1fbb2f5 ("xprtrdma: Do not update {head, tail}.iov_len in
rpcrdma_inline_fixup()") removed the head-length correction while fixing
the handling of pure-inline krb5p replies.

When a Write chunk conveyed the payload, trim head.iov_len (in both
rq_rcv_buf and rq_private_buf, which call_decode() expects to match) to
the inline length actually received so that the XDR layer does not
realign the page list. These READ replies have no trailing inline
fields, and the payload is already in the page list, so the upper
layer's head estimate can be safely reduced. Reduce buflen by the same
amount to avoid treating unused head capacity as additional tail
capacity. Pure inline replies and Reply chunk replies are unchanged.

Tested on Linux 6.8.0 and 7.3-rc4 with NFSv4.1 pNFS flexfiles over
RPC/RDMA and sec=krb5.

Fixes: cb0ae1fbb2f5 ("xprtrdma: Do not update {head, tail}.iov_len in rpcrdma_inline_fixup()")
Cc: stable@vger.kernel.org
Signed-off-by: Yongjian Mu <ymu@everpuredata.com>
Reviewed-by: Chuck Lever <cel@kernel.org>
Signed-off-by: Tim Menninger <tmenninger@everpuredata.com>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/rpc_rdma.c | 27 +++++++++++++++++++++++----
 1 file changed, 23 insertions(+), 4 deletions(-)

diff --git a/net/sunrpc/xprtrdma/rpc_rdma.c b/net/sunrpc/xprtrdma/rpc_rdma.c
index aa57e057ff451..11b9c2032f3fc 100644
--- a/net/sunrpc/xprtrdma/rpc_rdma.c
+++ b/net/sunrpc/xprtrdma/rpc_rdma.c
@@ -1033,12 +1033,16 @@ void rpcrdma_reset_cwnd(struct rpcrdma_xprt *r_xprt)
  * @rqst: controlling RPC request
  * @srcp: points to RPC message payload in receive buffer
  * @copy_len: remaining length of receive buffer content
- * @pad: Write chunk pad bytes needed (zero for pure inline)
+ * @writelist: bytes conveyed by the Write chunk (zero for pure inline)
  *
  * The upper layer has set the maximum number of bytes it can
  * receive in each component of rq_rcv_buf. These values are set in
  * the head.iov_len, page_len, tail.iov_len, and buflen fields.
  *
+ * For READ replies with a Write chunk, the payload is already in
+ * the page list. An overestimated head length and buflen can be
+ * reduced without moving reply data.
+ *
  * Unlike the TCP equivalent (xdr_partial_copy_from_skb), in
  * many cases this function simply updates iov_base pointers in
  * rq_rcv_buf to point directly to the received reply data, to
@@ -1047,13 +1051,16 @@ void rpcrdma_reset_cwnd(struct rpcrdma_xprt *r_xprt)
  * Returns the count of bytes which had to be memcopied.
  */
 static unsigned long
-rpcrdma_inline_fixup(struct rpc_rqst *rqst, char *srcp, int copy_len, int pad)
+rpcrdma_inline_fixup(struct rpc_rqst *rqst, char *srcp, int copy_len,
+		     u32 writelist)
 {
 	unsigned long fixup_copy_count;
 	int i, npages, curlen;
 	char *destp;
 	struct page **ppages;
 	int page_base;
+	int pad = writelist & 3;
+	unsigned int delta;
 
 	/* The head iovec is redirected to the RPC reply message
 	 * in the receive buffer, to avoid a memcopy.
@@ -1065,8 +1072,20 @@ rpcrdma_inline_fixup(struct rpc_rqst *rqst, char *srcp, int copy_len, int pad)
 	 * head.iov_len bytes are copied into the page list.
 	 */
 	curlen = rqst->rq_rcv_buf.head[0].iov_len;
-	if (curlen > copy_len)
+	if (curlen > copy_len) {
+		/* These READ replies have no inline fields after the payload.
+		 * Trim the head without moving the directly-placed data.
+		 */
+		if (writelist) {
+			delta = curlen - copy_len;
+
+			rqst->rq_rcv_buf.head[0].iov_len = copy_len;
+			rqst->rq_private_buf.head[0].iov_len = copy_len;
+			rqst->rq_rcv_buf.buflen -= delta;
+			rqst->rq_private_buf.buflen -= delta;
+		}
 		curlen = copy_len;
+	}
 	srcp += curlen;
 	copy_len -= curlen;
 
@@ -1294,7 +1313,7 @@ rpcrdma_decode_msg(struct rpcrdma_xprt *r_xprt, struct rpcrdma_rep *rep,
 	base = (char *)xdr_inline_decode(xdr, 0);
 	rpclen = xdr_stream_remaining(xdr);
 	r_xprt->rx_stats.fixup_copy_count +=
-		rpcrdma_inline_fixup(rqst, base, rpclen, writelist & 3);
+		rpcrdma_inline_fixup(rqst, base, rpclen, writelist);
 
 	r_xprt->rx_stats.total_rdma_reply += writelist;
 	return rpclen + xdr_align_size(writelist);
-- 
2.53.0



