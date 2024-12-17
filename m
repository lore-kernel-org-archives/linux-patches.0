Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFFD21F8F01;
	Tue, 17 Dec 2024 17:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456317; cv=none; b=nP7Rch+Mppo5AvZJwGSfiD/+2fQuVfOWFul0WciVQ06bfsJgOexdRYrRrTuWOZh3M6PncumwS38zWE/FChhTx537u3CdCrcoMZl5H39d4QsNM7Oeb+XmQrDD5QvY63CC4xXNtCIDba4ZBHpBemvg43uBagOCRchYLSPcIb0QYak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456317; c=relaxed/simple;
	bh=LERhelHl9LCBWi/p6QCO9+cYCOUDeTUcI2AHvVnbCKE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nDZZR+8Ml/M8SlvIdW/NYRrfWyKnjeRQnj1/psTEve7/US/YOZ5ceizih4RqZ3TJ4qV7yk43GKotbf8/5it3PoKSW53ZTCUx23nRpo7mZ5lC5etKPieisrblAxc/1KxjElbrhI+RiCJf+9+agAcaq03WZfMrQt3bLL5GWwjNupw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atb+PxC4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atb+PxC4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FADC4CED3;
	Tue, 17 Dec 2024 17:25:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456316;
	bh=LERhelHl9LCBWi/p6QCO9+cYCOUDeTUcI2AHvVnbCKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atb+PxC4CmdJG9WLtP3+i1rIKoTXJiDEBjohep43aSaBmkdGX3cPzslH8FybTo6Hq
	 Prq5KGIT1Ku2v8fBYXOiNyscSnbT+XLpccvI2n0Se8WVOy6+EQQMcwCbu0Ku3zCZWg
	 WEMTp1ya9JyEvqKQUHO8DO53A0Z5RAvQFCxfJptI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <koichiro.den@canonical.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 013/172] virtio_net: ensure netdev_tx_reset_queue is called on tx ring resize
Date: Tue, 17 Dec 2024 18:06:09 +0100
Message-ID: <20241217170546.800796677@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Koichiro Den <koichiro.den@canonical.com>

commit 1480f0f61b675567ca5d0943d6ef2e39172dcafd upstream.

virtnet_tx_resize() flushes remaining tx skbs, requiring DQL counters to
be reset when flushing has actually occurred. Add
virtnet_sq_free_unused_buf_done() as a callback for virtqueue_reset() to
handle this.

Fixes: c8bd1f7f3e61 ("virtio_net: add support for Byte Queue Limits")
Cc: <stable@vger.kernel.org> # v6.11+
Signed-off-by: Koichiro Den <koichiro.den@canonical.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -502,6 +502,7 @@ struct virtio_net_common_hdr {
 };
 
 static void virtnet_sq_free_unused_buf(struct virtqueue *vq, void *buf);
+static void virtnet_sq_free_unused_buf_done(struct virtqueue *vq);
 static int virtnet_xdp_handler(struct bpf_prog *xdp_prog, struct xdp_buff *xdp,
 			       struct net_device *dev,
 			       unsigned int *xdp_xmit,
@@ -3228,7 +3229,8 @@ static int virtnet_tx_resize(struct virt
 
 	virtnet_tx_pause(vi, sq);
 
-	err = virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf, NULL);
+	err = virtqueue_resize(sq->vq, ring_num, virtnet_sq_free_unused_buf,
+			       virtnet_sq_free_unused_buf_done);
 	if (err)
 		netdev_err(vi->dev, "resize tx fail: tx queue index: %d err: %d\n", qindex, err);
 
@@ -5996,6 +5998,14 @@ static void virtnet_sq_free_unused_buf(s
 		xdp_return_frame(ptr_to_xdp(buf));
 }
 
+static void virtnet_sq_free_unused_buf_done(struct virtqueue *vq)
+{
+	struct virtnet_info *vi = vq->vdev->priv;
+	int i = vq2txq(vq);
+
+	netdev_tx_reset_queue(netdev_get_tx_queue(vi->dev, i));
+}
+
 static void free_unused_bufs(struct virtnet_info *vi)
 {
 	void *buf;


