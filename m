Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209791;
	b=QXpVblq/d+Rf4i/mEAPSkuIE9dF3HhAGp3gnC/IdeX2yzh5ajKE4z2uULE/TwtHr/qyR
	 nC25okx5ohx7umwYsuEcfE/kfCdBxxrSZO+v5HijV+GkmaWEaL/2NphY5aHQ4ZTOAt+gM
	 bGZipfg4mjawr1GXh6F+5RqBhB6H7vsLmmbLezn38iaWbcZbw3QioISV19Q8ZRQDeLNSu
	 9sIwpOBbT2qyNkM6LjbplGDjQeSC7YFxRcE3z0fJyojZF9Hl7wWCPB+DPRQ/H9ODwjnqV
	 pZcJRFzb/QuJnYy8DtNvTD1ovDf7qZ9nNgt+KWqsehqXcJvt/QR9odGYdXBb0jj0BDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209791;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3MCe6zDlGQ3fvAXOVml2r3MN1QTxmOay9ojVBuNuj2M=;
	b=VTG7CwZMZBNu6bmbxKjCen3YRZwFOlnj+fp9d/fUcMyzc+VGbV4ivB56gPXTglWU/MtG
	 a7BVFx7qnmtTXF1n/Oys4e7A2aYk5M6oc6OAR40pfaPH/gJ/dhrWrkoowzakKqud1bMZr
	 UKctiz8TSxpjn80P9jVxb+d80NlQFmN4lICsg5PSZvGE237SNvx9cEiF8nrOvoC2S7fkj
	 bMfFn5aptZ1Fijl1KCN2j2WQ2cAuUb5Dxpwjhw8tgK4JOwdNpHZbQ+mWNpedjuKbrsPFm
	 dGI0WlhctUqkzHpLjoerHU0tdjwB2RVMKr4Wlp6ayc+VzJvjFdHR5rLnY4kg2L1uuAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0YT4vGX3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27CAB606A31D;
	Wed, 28 Oct 2026 17:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0YT4vGX3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 794C71F01825;
	Wed, 28 Oct 2026 17:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209791;
	bh=3MCe6zDlGQ3fvAXOVml2r3MN1QTxmOay9ojVBuNuj2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0YT4vGX3aZM6CmN8YwYHDU3EWOW9tUB7I776PMseVFrQcMoZoxBJc73WSilXJsqLN
	 CB3/cPPWHl/zwmWaj5ZuL+T988BN4orMf2DWxSd1SatWJrXvCymoPF8ILsSQ+KtFp0
	 JtznBTBtGwN0ZP1axg3gcT3ooNMwSw7GvYX4n4LM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 077/109] io_uring/net: dont retry recv on uncommitted buffers
Date: Wed, 28 Oct 2026 18:01:01 +0100
Message-ID: <20261028165944.170012350@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit 8444de681a179e41a4eb92d5bbe770a0677074a6 upstream.

Commit 41b70df5b38b ("io_uring/net: commit partial buffers on retry")
commits ring provided buffers when a receive is going to be retried after
a partial transfer, so that another request using the same buffer group
can't be handed the memory the first one keeps receiving into. It commits
the number of bytes received so far. That does the job for a single
buffer which is consumed as a whole, but the request hangs on to all it
has mapped:

- For a buffer ring with IOU_PBUF_RING_INC only these bytes are consumed.
  The rest of the buffer stays at the head of the ring.
- For a bundle only the buffers which hold these bytes are consumed, the
  others that were peeked stay in the ring.

In both cases the next receive with that buffer group gets memory that
the retried request is still going to write to, and whoever comes last
overwrites the data of the other. What the retry fills isn't committed at
all, as the buffer list isn't known any more at that point. So the kernel
hands it out again later on, while the CQE tells the application that it
was used, and for an incremental buffer that it is done with.

The remainder can't be committed in advance: if the request ends up
receiving less, there is no way to tell the application that more was
consumed than the CQE accounts for. Complete the request with what it has
got instead of retrying it. MSG_WAITALL is no longer honoured for
receives into incremental buffers or multi buffer bundles, they can
return a short count, with the request marked as failed like for other
short MSG_WAITALL transfers.

Fixes: 41b70df5b38b ("io_uring/net: commit partial buffers on retry")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-40-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/net.c |   24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -498,6 +498,24 @@ static int io_bundle_nbufs(struct io_asy
 	return nbufs;
 }
 
+/*
+ * A receive that is retried after a partial transfer keeps writing to what it
+ * has mapped. io_net_kbuf_recyle() only commits what was filled so far, which
+ * takes a buffer out of circulation if it's a single one that is consumed as a
+ * whole. The tail of an incrementally consumed buffer, or the yet unused
+ * buffers of a bundle, would be up for grabs. They can't be committed in
+ * advance either, the CQE has no way to tell if they end up not being used.
+ */
+static bool io_net_kbuf_can_retry(struct io_kiocb *req,
+				  struct io_buffer_list *bl,
+				  struct io_async_msghdr *kmsg)
+{
+	/* not ring provided, or committed at selection time */
+	if (!(req->flags & REQ_F_BUFFERS_COMMIT))
+		return true;
+	return !(bl->flags & IOBL_INC) && iter_is_ubuf(&kmsg->msg.msg_iter);
+}
+
 static int io_net_kbuf_recyle(struct io_kiocb *req, struct io_buffer_list *bl,
 			      struct io_async_msghdr *kmsg, int len)
 {
@@ -1089,7 +1107,8 @@ retry_multishot:
 			io_kbuf_recycle(req, sel.buf_list, issue_flags);
 			return IOU_RETRY;
 		}
-		if (ret > 0 && io_net_retry(sock, flags)) {
+		if (ret > 0 && io_net_retry(sock, flags) &&
+		    io_net_kbuf_can_retry(req, sel.buf_list, kmsg)) {
 			sr->done_io += ret;
 			return io_net_kbuf_recyle(req, sel.buf_list, kmsg, ret);
 		}
@@ -1238,7 +1257,8 @@ retry_multishot:
 			io_kbuf_recycle(req, sel.buf_list, issue_flags);
 			return IOU_RETRY;
 		}
-		if (ret > 0 && io_net_retry(sock, flags)) {
+		if (ret > 0 && io_net_retry(sock, flags) &&
+		    io_net_kbuf_can_retry(req, sel.buf_list, kmsg)) {
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;


