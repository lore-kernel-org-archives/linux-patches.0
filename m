Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208018;
	b=Ng0QGCHk3WysHSWCki8zaBpSqH/CyRhBnaQZcDAGcDFqPHCwfrrT/E1G8kgyTVBsAeia
	 ZtglC9JkesIUFMDYHeBVIMFRR+7DRVmBdweXg082S/Jsejk7cNOY7NrQu1UvqX+ZEIfel
	 dttz3YY0VuGLGZvTmBOgBjbi+AJGe7ZI5cQltu3XQqs0ibefI2Pm+Esjqh5dNhhezBk5b
	 XLWh6pcYHwqhThhLzyomp3xRTT2AOtutL92YmomPyx1nuphEgBywYLXBJ/6pw+ot0AWkI
	 HXIdoUIqq6Icp3GJ5y2ejk/ifTb0NezIP8kix2Cmh26Gs89PO//EDIKa/gU2UDwYJ4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208018;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=a04TRe4CiP2P+c9CVK5LPZ/13Jk5P+qtp/hEmWOBtV8=;
	b=BLMjk6mx8givcCRj+rKQigRBd/jMye1CeNYnhnnp5bZqbS8GrVhr+tZRy2SoW3Vs9+aj
	 SLVvCSU4S58ctFFOqqasSGswlkpv9WFQ8CG3b/k5bvdrLvfWYFc5L7xpKeNodSK0vqehB
	 XUt94fsNRabSVIvRUENhj8dHtUpjtDteI2BIRUBLGp4pQa6h92BpZhaGYv3ieuEb94buk
	 ovYl+2lRy8hIsUv1a8won0oB5F/uzdTwBeD8YZBNwEHSbkWLVBM6/N934XHRXBDFVqXR5
	 LuArh6WZmoTDXit/QBwEhlWCm/dpi1tDcYkNy5GHpSGqLpY6A0Cb2DsxIiqHxk19GRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ahfl1GuE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61A0606A31A;
	Wed, 28 Oct 2026 17:20:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ahfl1GuE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 335621F01825;
	Wed, 28 Oct 2026 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208017;
	bh=a04TRe4CiP2P+c9CVK5LPZ/13Jk5P+qtp/hEmWOBtV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ahfl1GuEYJnfTZrN/iGoxCz/t80SjMtwHZkplyIVBkWKnVljwqPmbm8OxALPlowcL
	 MP6eYLeJGWOb5pCRin+NfVfH/Lvby6WkekupY+dJUNcxysTqAaaMtLBIDu3XhnmGNB
	 WZeBdy7wRy5cv9VM+MInpx8t0mf9sq8NaQGqZDww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 218/247] io_uring/net: dont retry recv on uncommitted buffers
Date: Wed, 28 Oct 2026 18:00:21 +0100
Message-ID: <20261028165952.585140888@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
@@ -500,6 +500,24 @@ static int io_bundle_nbufs(struct io_asy
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
@@ -1086,7 +1104,8 @@ retry_multishot:
 				return IOU_ISSUE_SKIP_COMPLETE;
 			return -EAGAIN;
 		}
-		if (ret > 0 && io_net_retry(sock, flags)) {
+		if (ret > 0 && io_net_retry(sock, flags) &&
+		    io_net_kbuf_can_retry(req, sel.buf_list, kmsg)) {
 			sr->done_io += ret;
 			return io_net_kbuf_recyle(req, sel.buf_list, kmsg, ret);
 		}
@@ -1233,7 +1252,8 @@ retry_multishot:
 				return IOU_ISSUE_SKIP_COMPLETE;
 			return -EAGAIN;
 		}
-		if (ret > 0 && io_net_retry(sock, flags)) {
+		if (ret > 0 && io_net_retry(sock, flags) &&
+		    io_net_kbuf_can_retry(req, sel.buf_list, kmsg)) {
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;


