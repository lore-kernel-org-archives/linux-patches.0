Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69EE331A5D;
	Wed,  3 Dec 2025 15:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777159; cv=none; b=X89Bp0QH6yLACYWgKVAS5GzkTifcRBDsk7+druRU8kqJPaeH8PcM6FMt9Xh/iuYJLilw8b3P2zp8l25YpqEdBQqmhj95kdnj8M2WA6ZNkgPPNxO8wxzuTlXrXkB0ouHrL/P/hWFVdzzdsUn6DFaLZEBNku286ue4ULYJ0ecCyak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777159; c=relaxed/simple;
	bh=biI4essHFq69P31FG9BGcNCemj/jxu9dEoIZf0uyga0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L9O0nUrz1Ib5wYH7h5hLCoWuMQg8usAyRIlxRXmwuWbIQAjwngJtOU2YKNMldDPb6+3sLgsSopmJesrx0EqNcvOX9y/0PD+nOhv+Z30flFv9v2hLr4iGBCqZpse38p+43/9KKdJ/EyOoJWDsyz3LbCIT27qVJUBDP8NVmquelYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ucD4Lv6R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ucD4Lv6R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE6EC4CEF5;
	Wed,  3 Dec 2025 15:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777159;
	bh=biI4essHFq69P31FG9BGcNCemj/jxu9dEoIZf0uyga0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ucD4Lv6R/ydsq824A7pFFxyDSnQUbMHUeZIv+Ncd1xsRlXAKfupChn8jDFjCxoWyR
	 M4GPMCDqQFyvC+zdfOnhPsBDqyMgwQJKyR6OJ9VBXNnJCFCxmd6FXTLdRW7QXU2pvx
	 xiOhW2va2kpGSHfLJH3tGEoyPet2fBGPQg3afw/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 073/146] vhost: rewind next_avail_head while discarding descriptors
Date: Wed,  3 Dec 2025 16:27:31 +0100
Message-ID: <20251203152349.138986657@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152346.456176474@linuxfoundation.org>
References: <20251203152346.456176474@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

commit 779bcdd4b9ae6566f309043c53c946e8ac0015fd upstream.

When discarding descriptors with IN_ORDER, we should rewind
next_avail_head otherwise it would run out of sync with
last_avail_idx. This would cause driver to report
"id X is not a head".

Fixing this by returning the number of descriptors that is used for
each buffer via vhost_get_vq_desc_n() so caller can use the value
while discarding descriptors.

Fixes: 67a873df0c41 ("vhost: basic in order support")
Cc: stable@vger.kernel.org
Signed-off-by: Jason Wang <jasowang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20251120022950.10117-1-jasowang@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/net.c   | 53 ++++++++++++++++++------------
 drivers/vhost/vhost.c | 76 +++++++++++++++++++++++++++++++++++--------
 drivers/vhost/vhost.h | 10 +++++-
 3 files changed, 103 insertions(+), 36 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 35ded4330431..8f7f50acb6d6 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -592,14 +592,15 @@ static void vhost_net_busy_poll(struct vhost_net *net,
 static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
 				    struct vhost_net_virtqueue *tnvq,
 				    unsigned int *out_num, unsigned int *in_num,
-				    struct msghdr *msghdr, bool *busyloop_intr)
+				    struct msghdr *msghdr, bool *busyloop_intr,
+				    unsigned int *ndesc)
 {
 	struct vhost_net_virtqueue *rnvq = &net->vqs[VHOST_NET_VQ_RX];
 	struct vhost_virtqueue *rvq = &rnvq->vq;
 	struct vhost_virtqueue *tvq = &tnvq->vq;
 
-	int r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
-				  out_num, in_num, NULL, NULL);
+	int r = vhost_get_vq_desc_n(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
+				    out_num, in_num, NULL, NULL, ndesc);
 
 	if (r == tvq->num && tvq->busyloop_timeout) {
 		/* Flush batched packets first */
@@ -610,8 +611,8 @@ static int vhost_net_tx_get_vq_desc(struct vhost_net *net,
 
 		vhost_net_busy_poll(net, rvq, tvq, busyloop_intr, false);
 
-		r = vhost_get_vq_desc(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
-				      out_num, in_num, NULL, NULL);
+		r = vhost_get_vq_desc_n(tvq, tvq->iov, ARRAY_SIZE(tvq->iov),
+					out_num, in_num, NULL, NULL, ndesc);
 	}
 
 	return r;
@@ -642,12 +643,14 @@ static int get_tx_bufs(struct vhost_net *net,
 		       struct vhost_net_virtqueue *nvq,
 		       struct msghdr *msg,
 		       unsigned int *out, unsigned int *in,
-		       size_t *len, bool *busyloop_intr)
+		       size_t *len, bool *busyloop_intr,
+		       unsigned int *ndesc)
 {
 	struct vhost_virtqueue *vq = &nvq->vq;
 	int ret;
 
-	ret = vhost_net_tx_get_vq_desc(net, nvq, out, in, msg, busyloop_intr);
+	ret = vhost_net_tx_get_vq_desc(net, nvq, out, in, msg,
+				       busyloop_intr, ndesc);
 
 	if (ret < 0 || ret == vq->num)
 		return ret;
@@ -766,6 +769,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 	int sent_pkts = 0;
 	bool sock_can_batch = (sock->sk->sk_sndbuf == INT_MAX);
 	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
+	unsigned int ndesc = 0;
 
 	do {
 		bool busyloop_intr = false;
@@ -774,7 +778,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 			vhost_tx_batch(net, nvq, sock, &msg);
 
 		head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
-				   &busyloop_intr);
+				   &busyloop_intr, &ndesc);
 		/* On error, stop handling until the next kick. */
 		if (unlikely(head < 0))
 			break;
@@ -806,7 +810,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 				goto done;
 			} else if (unlikely(err != -ENOSPC)) {
 				vhost_tx_batch(net, nvq, sock, &msg);
-				vhost_discard_vq_desc(vq, 1);
+				vhost_discard_vq_desc(vq, 1, ndesc);
 				vhost_net_enable_vq(net, vq);
 				break;
 			}
@@ -829,7 +833,7 @@ static void handle_tx_copy(struct vhost_net *net, struct socket *sock)
 		err = sock->ops->sendmsg(sock, &msg, len);
 		if (unlikely(err < 0)) {
 			if (err == -EAGAIN || err == -ENOMEM || err == -ENOBUFS) {
-				vhost_discard_vq_desc(vq, 1);
+				vhost_discard_vq_desc(vq, 1, ndesc);
 				vhost_net_enable_vq(net, vq);
 				break;
 			}
@@ -868,6 +872,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 	int err;
 	struct vhost_net_ubuf_ref *ubufs;
 	struct ubuf_info_msgzc *ubuf;
+	unsigned int ndesc = 0;
 	bool zcopy_used;
 	int sent_pkts = 0;
 
@@ -879,7 +884,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 
 		busyloop_intr = false;
 		head = get_tx_bufs(net, nvq, &msg, &out, &in, &len,
-				   &busyloop_intr);
+				   &busyloop_intr, &ndesc);
 		/* On error, stop handling until the next kick. */
 		if (unlikely(head < 0))
 			break;
@@ -941,7 +946,7 @@ static void handle_tx_zerocopy(struct vhost_net *net, struct socket *sock)
 					vq->heads[ubuf->desc].len = VHOST_DMA_DONE_LEN;
 			}
 			if (retry) {
-				vhost_discard_vq_desc(vq, 1);
+				vhost_discard_vq_desc(vq, 1, ndesc);
 				vhost_net_enable_vq(net, vq);
 				break;
 			}
@@ -1045,11 +1050,12 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
 		       unsigned *iovcount,
 		       struct vhost_log *log,
 		       unsigned *log_num,
-		       unsigned int quota)
+		       unsigned int quota,
+		       unsigned int *ndesc)
 {
 	struct vhost_virtqueue *vq = &nvq->vq;
 	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
-	unsigned int out, in;
+	unsigned int out, in, desc_num, n = 0;
 	int seg = 0;
 	int headcount = 0;
 	unsigned d;
@@ -1064,9 +1070,9 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
 			r = -ENOBUFS;
 			goto err;
 		}
-		r = vhost_get_vq_desc(vq, vq->iov + seg,
-				      ARRAY_SIZE(vq->iov) - seg, &out,
-				      &in, log, log_num);
+		r = vhost_get_vq_desc_n(vq, vq->iov + seg,
+					ARRAY_SIZE(vq->iov) - seg, &out,
+					&in, log, log_num, &desc_num);
 		if (unlikely(r < 0))
 			goto err;
 
@@ -1093,6 +1099,7 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
 		++headcount;
 		datalen -= len;
 		seg += in;
+		n += desc_num;
 	}
 
 	*iovcount = seg;
@@ -1113,9 +1120,11 @@ static int get_rx_bufs(struct vhost_net_virtqueue *nvq,
 		nheads[0] = headcount;
 	}
 
+	*ndesc = n;
+
 	return headcount;
 err:
-	vhost_discard_vq_desc(vq, headcount);
+	vhost_discard_vq_desc(vq, headcount, n);
 	return r;
 }
 
@@ -1151,6 +1160,7 @@ static void handle_rx(struct vhost_net *net)
 	struct iov_iter fixup;
 	__virtio16 num_buffers;
 	int recv_pkts = 0;
+	unsigned int ndesc;
 
 	mutex_lock_nested(&vq->mutex, VHOST_NET_VQ_RX);
 	sock = vhost_vq_get_backend(vq);
@@ -1182,7 +1192,8 @@ static void handle_rx(struct vhost_net *net)
 		headcount = get_rx_bufs(nvq, vq->heads + count,
 					vq->nheads + count,
 					vhost_len, &in, vq_log, &log,
-					likely(mergeable) ? UIO_MAXIOV : 1);
+					likely(mergeable) ? UIO_MAXIOV : 1,
+					&ndesc);
 		/* On error, stop handling until the next kick. */
 		if (unlikely(headcount < 0))
 			goto out;
@@ -1228,7 +1239,7 @@ static void handle_rx(struct vhost_net *net)
 		if (unlikely(err != sock_len)) {
 			pr_debug("Discarded rx packet: "
 				 " len %d, expected %zd\n", err, sock_len);
-			vhost_discard_vq_desc(vq, headcount);
+			vhost_discard_vq_desc(vq, headcount, ndesc);
 			continue;
 		}
 		/* Supply virtio_net_hdr if VHOST_NET_F_VIRTIO_NET_HDR */
@@ -1252,7 +1263,7 @@ static void handle_rx(struct vhost_net *net)
 		    copy_to_iter(&num_buffers, sizeof num_buffers,
 				 &fixup) != sizeof num_buffers) {
 			vq_err(vq, "Failed num_buffers write");
-			vhost_discard_vq_desc(vq, headcount);
+			vhost_discard_vq_desc(vq, headcount, ndesc);
 			goto out;
 		}
 		nvq->done_idx += headcount;
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 8570fdf2e14a..a78226b37739 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -2792,18 +2792,34 @@ static int get_indirect(struct vhost_virtqueue *vq,
 	return 0;
 }
 
-/* This looks in the virtqueue and for the first available buffer, and converts
- * it to an iovec for convenient access.  Since descriptors consist of some
- * number of output then some number of input descriptors, it's actually two
- * iovecs, but we pack them into one and note how many of each there were.
+/**
+ * vhost_get_vq_desc_n - Fetch the next available descriptor chain and build iovecs
+ * @vq: target virtqueue
+ * @iov: array that receives the scatter/gather segments
+ * @iov_size: capacity of @iov in elements
+ * @out_num: the number of output segments
+ * @in_num: the number of input segments
+ * @log: optional array to record addr/len for each writable segment; NULL if unused
+ * @log_num: optional output; number of entries written to @log when provided
+ * @ndesc: optional output; number of descriptors consumed from the available ring
+ *         (useful for rollback via vhost_discard_vq_desc)
  *
- * This function returns the descriptor number found, or vq->num (which is
- * never a valid descriptor number) if none was found.  A negative code is
- * returned on error. */
-int vhost_get_vq_desc(struct vhost_virtqueue *vq,
-		      struct iovec iov[], unsigned int iov_size,
-		      unsigned int *out_num, unsigned int *in_num,
-		      struct vhost_log *log, unsigned int *log_num)
+ * Extracts one available descriptor chain from @vq and translates guest addresses
+ * into host iovecs.
+ *
+ * On success, advances @vq->last_avail_idx by 1 and @vq->next_avail_head by the
+ * number of descriptors consumed (also stored via @ndesc when non-NULL).
+ *
+ * Return:
+ * - head index in [0, @vq->num) on success;
+ * - @vq->num if no descriptor is currently available;
+ * - negative errno on failure
+ */
+int vhost_get_vq_desc_n(struct vhost_virtqueue *vq,
+			struct iovec iov[], unsigned int iov_size,
+			unsigned int *out_num, unsigned int *in_num,
+			struct vhost_log *log, unsigned int *log_num,
+			unsigned int *ndesc)
 {
 	bool in_order = vhost_has_feature(vq, VIRTIO_F_IN_ORDER);
 	struct vring_desc desc;
@@ -2921,17 +2937,49 @@ int vhost_get_vq_desc(struct vhost_virtqueue *vq,
 	vq->last_avail_idx++;
 	vq->next_avail_head += c;
 
+	if (ndesc)
+		*ndesc = c;
+
 	/* Assume notifications from guest are disabled at this point,
 	 * if they aren't we would need to update avail_event index. */
 	BUG_ON(!(vq->used_flags & VRING_USED_F_NO_NOTIFY));
 	return head;
 }
+EXPORT_SYMBOL_GPL(vhost_get_vq_desc_n);
+
+/* This looks in the virtqueue and for the first available buffer, and converts
+ * it to an iovec for convenient access.  Since descriptors consist of some
+ * number of output then some number of input descriptors, it's actually two
+ * iovecs, but we pack them into one and note how many of each there were.
+ *
+ * This function returns the descriptor number found, or vq->num (which is
+ * never a valid descriptor number) if none was found.  A negative code is
+ * returned on error.
+ */
+int vhost_get_vq_desc(struct vhost_virtqueue *vq,
+		      struct iovec iov[], unsigned int iov_size,
+		      unsigned int *out_num, unsigned int *in_num,
+		      struct vhost_log *log, unsigned int *log_num)
+{
+	return vhost_get_vq_desc_n(vq, iov, iov_size, out_num, in_num,
+				   log, log_num, NULL);
+}
 EXPORT_SYMBOL_GPL(vhost_get_vq_desc);
 
-/* Reverse the effect of vhost_get_vq_desc. Useful for error handling. */
-void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int n)
+/**
+ * vhost_discard_vq_desc - Reverse the effect of vhost_get_vq_desc_n()
+ * @vq: target virtqueue
+ * @nbufs: number of buffers to roll back
+ * @ndesc: number of descriptors to roll back
+ *
+ * Rewinds the internal consumer cursors after a failed attempt to use buffers
+ * returned by vhost_get_vq_desc_n().
+ */
+void vhost_discard_vq_desc(struct vhost_virtqueue *vq, int nbufs,
+			   unsigned int ndesc)
 {
-	vq->last_avail_idx -= n;
+	vq->next_avail_head -= ndesc;
+	vq->last_avail_idx -= nbufs;
 }
 EXPORT_SYMBOL_GPL(vhost_discard_vq_desc);
 
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 621a6d9a8791..b49f08e4a1b4 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -230,7 +230,15 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
 		      struct iovec iov[], unsigned int iov_size,
 		      unsigned int *out_num, unsigned int *in_num,
 		      struct vhost_log *log, unsigned int *log_num);
-void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
+
+int vhost_get_vq_desc_n(struct vhost_virtqueue *vq,
+			struct iovec iov[], unsigned int iov_size,
+			unsigned int *out_num, unsigned int *in_num,
+			struct vhost_log *log, unsigned int *log_num,
+			unsigned int *ndesc);
+
+void vhost_discard_vq_desc(struct vhost_virtqueue *, int nbuf,
+			   unsigned int ndesc);
 
 bool vhost_vq_work_queue(struct vhost_virtqueue *vq, struct vhost_work *work);
 bool vhost_vq_has_work(struct vhost_virtqueue *vq);
-- 
2.52.0



