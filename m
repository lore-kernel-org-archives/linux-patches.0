Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207301;
	b=gdTvaylQQxnnavz3cz0EGHtUmHFaprJO8gdrrc4ksjAB4MYAd5jX6djwLcXbm+aI1Ujj
	 wBYeh0+myWwx0HPvuVk9DoAMLzb7Hnn89qPCx2i+CAyxQ0LhEM6NeCaa51IeRtdJYW0hD
	 7gX/XoYspweAJC9ElkpZYDbk2nv10IvNxn2JSXNqUI7ohS43gAaNtwQ2R6TGy+kQrpxQX
	 00TTRUIfPdDK0gVU4H1DqgO2VzXkaV0DmrIuXzX6XkhTRmsryVgBw22cm42lm17n0TCOv
	 jJIHSRvIN3kHwICNSC6Q0fwfKncjh7MBi3QY2ipuwa63jPEYpUfJ8seSMVX90jCfNrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207301;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3C0CqhXiizGPsNSaxgkd8xmgbK4YflfWcyPyEPkaZyQ=;
	b=4yOLhD0o0ApnY3omae66MB9Qn0PMDJ1MQFpIxBRvhIUhaYjB0gWvDvq31DVeNki94UC9
	 iKQBSWzVlt0u2qjfayaZpvOR2tdLuib2B0JvUOZNtbAQV3EyFOCBfM3QhmCCPl3NAwuCa
	 Yd3/h5PED5X7jH3BQ132f6BrHRPCVEcmKtHQFtIyUl821O2M13IbmTpyuJk8fhoz98LnA
	 Pbjvat6/NYkEAPEonIY3Tk6D/WrudbyIGmmreGRICVxIk8S0mqJ7vXb33sERKbeX2rzm2
	 4TWCZAi3p4jwmPLDhJyVfiHTZ6NFFLAcNGNnjNrtKw/+tT91Vao9lgxg7FdGxKyR9UA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lCfYSZTH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14407606A31A;
	Wed, 28 Oct 2026 17:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lCfYSZTH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1503E1F01825;
	Wed, 28 Oct 2026 17:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207300;
	bh=3C0CqhXiizGPsNSaxgkd8xmgbK4YflfWcyPyEPkaZyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lCfYSZTHF46YMg8fSvoKz7wRoW+JbaKO8ZUgNy+74zV/LL/v/1F4IlUS5DGY9C5hO
	 5IApdgE0ig24Or23A12/ZudoNtm8IN46iAPX/+Wek5mDFX+VCwFk94NKd4phZ2CywI
	 3RwGNI249Ji+qRV9pPY7ZrEjwCDm8WSr1/UOTH1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 56/88] io_uring/net: dont retry recv on uncommitted buffers
Date: Wed, 28 Oct 2026 18:00:04 +0100
Message-ID: <20261028165943.430544469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -511,6 +511,24 @@ static int io_bundle_nbufs(struct io_asy
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
@@ -1122,7 +1140,8 @@ retry_multishot:
 			io_kbuf_recycle(req, sel.buf_list, issue_flags);
 			return IOU_RETRY;
 		}
-		if (ret > 0 && io_net_retry(sock, flags)) {
+		if (ret > 0 && io_net_retry(sock, flags) &&
+		    io_net_kbuf_can_retry(req, sel.buf_list, kmsg)) {
 			sr->done_io += ret;
 			return io_net_kbuf_recyle(req, sel.buf_list, kmsg, ret);
 		}
@@ -1283,7 +1302,8 @@ retry_multishot:
 			io_kbuf_recycle(req, sel.buf_list, issue_flags);
 			return IOU_RETRY;
 		}
-		if (ret > 0 && io_net_retry(sock, flags)) {
+		if (ret > 0 && io_net_retry(sock, flags) &&
+		    io_net_kbuf_can_retry(req, sel.buf_list, kmsg)) {
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;


