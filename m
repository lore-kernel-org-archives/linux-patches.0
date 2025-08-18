Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8BB931E0E8;
	Mon, 18 Aug 2025 13:04:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522283; cv=none; b=NeBSClOu+V2B5v/MBHx0B4dczU1+DNG2Hz/TFsf3Rk0gLSrXAqNrA2eiW+zqxVc+CKRcVFyXmEcLNccVEHVJryfHItMIURcrZQQdHRQYWyNbD0vge5raEj6O0jg3Bxh0Yj3tJ8DJYcYZh3LIqIUXQiGjdI0ImTRo18LscTqU0mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522283; c=relaxed/simple;
	bh=jisjdfoyz6Vv77jNtp9ta4MfH/IBhjDqFrHiCM81EhI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gi0QY0cQCVAwCLNWDvRDEuTseXGaz5jeGraMB3jwNSgw3KOySHzyxcVQUD63dCUWbbN0mueBk0BXsDoqOHagq02Vtli3vCcynP5/Rkiryv41g+3hvvZ9fIwFlZ/+JiwXsRzPOCc+jjG3UrdbMhsZhlu4Z1FqFKPZO210Y/UUdNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkoO/Gct; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkoO/Gct"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 172A8C4CEEB;
	Mon, 18 Aug 2025 13:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522283;
	bh=jisjdfoyz6Vv77jNtp9ta4MfH/IBhjDqFrHiCM81EhI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XkoO/Gctg5C4YX4PKMlqx9oVIzlXtts1DYLCKF/Al/eNm3JkPqvQ5QhrhUUIJZFjh
	 jGDAoWCmMIehhAx27Qfbp3PlyE5xfLvH1lgL4LCcOtjjsouzO4JTx3PeyJw/nTtooi
	 /ZCptwnEWSMARGveAwIkpj8nmYATnwCoFz48q4Sk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 271/444] vsock/virtio: Resize receive buffers so that each SKB fits in a 4K page
Date: Mon, 18 Aug 2025 14:44:57 +0200
Message-ID: <20250818124458.985291969@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Will Deacon <will@kernel.org>

[ Upstream commit 03a92f036a04fed2b00d69f5f46f1a486e70dc5c ]

When allocating receive buffers for the vsock virtio RX virtqueue, an
SKB is allocated with a 4140 data payload (the 44-byte packet header +
VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE). Even when factoring in the SKB
overhead, the resulting 8KiB allocation thanks to the rounding in
kmalloc_reserve() is wasteful (~3700 unusable bytes) and results in a
higher-order page allocation on systems with 4KiB pages just for the
sake of a few hundred bytes of packet data.

Limit the vsock virtio RX buffers to 4KiB per SKB, resulting in much
better memory utilisation and removing the need to allocate higher-order
pages entirely.

Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20250717090116.11987-5-will@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/virtio_vsock.h     | 7 ++++++-
 net/vmw_vsock/virtio_transport.c | 2 +-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/linux/virtio_vsock.h b/include/linux/virtio_vsock.h
index 36fb3edfa403..6c00687539cf 100644
--- a/include/linux/virtio_vsock.h
+++ b/include/linux/virtio_vsock.h
@@ -111,7 +111,12 @@ static inline size_t virtio_vsock_skb_len(struct sk_buff *skb)
 	return (size_t)(skb_end_pointer(skb) - skb->head);
 }
 
-#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	(1024 * 4)
+/* Dimension the RX SKB so that the entire thing fits exactly into
+ * a single 4KiB page. This avoids wasting memory due to alloc_skb()
+ * rounding up to the next page order and also means that we
+ * don't leave higher-order pages sitting around in the RX queue.
+ */
+#define VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE	SKB_WITH_OVERHEAD(1024 * 4)
 #define VIRTIO_VSOCK_MAX_BUF_SIZE		0xFFFFFFFFUL
 #define VIRTIO_VSOCK_MAX_PKT_BUF_SIZE		(1024 * 64)
 
diff --git a/net/vmw_vsock/virtio_transport.c b/net/vmw_vsock/virtio_transport.c
index f0e48e6911fc..f01f9e878106 100644
--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -307,7 +307,7 @@ virtio_transport_cancel_pkt(struct vsock_sock *vsk)
 
 static void virtio_vsock_rx_fill(struct virtio_vsock *vsock)
 {
-	int total_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE + VIRTIO_VSOCK_SKB_HEADROOM;
+	int total_len = VIRTIO_VSOCK_DEFAULT_RX_BUF_SIZE;
 	struct scatterlist pkt, *p;
 	struct virtqueue *vq;
 	struct sk_buff *skb;
-- 
2.39.5



