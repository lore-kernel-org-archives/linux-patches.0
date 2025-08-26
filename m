Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 307A1299959;
	Tue, 26 Aug 2025 11:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207242; cv=none; b=E/Kkdx7tCzVCX/rqxwdZXDWAoZ77BcTXGv/uJw91+o8QrMYC0Mki2S2d9kT/39QkuwCOxzEbHrBo4LisJgE3XVd0K5Vw4b50ELInKej+9lbkgZyWZqFvR5uB7UhEqcheSZ3BEJZ5HEFleRxKIV7JfyQbYa1blmwafECpzlekR6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207242; c=relaxed/simple;
	bh=O86CINMT6IcAx3oHREfSL0FNfc/OR8ehgAl9LaXoc28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AOpVUmTayrTqupusC87ly6aKsNbYlzC0LZVw0kuogdzhbVNNltIKT+7tScRG202D5sHW9fp55TJ2QmTYMU0V1WnVukC7UxgU5bVItRAOXOI9vnUHoilKVHiMzicjwe82sQ5ruGGepXMj8QgXKTxkqfINxmYHPQLHYE80XWB4K/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0W1hb/YS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0W1hb/YS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A5CDC4CEF1;
	Tue, 26 Aug 2025 11:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207241;
	bh=O86CINMT6IcAx3oHREfSL0FNfc/OR8ehgAl9LaXoc28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0W1hb/YSi74uKI/AJ44/o2NQHKiSACU+BZxZ2Ik5JsJeCG9M82chzAvzWpL1K5hf+
	 06vq+NZuARCUizq+aDBCCt7gw85IRkzudyKTYbPLifFQ/PH4bzgFGL0iwDB7l4908Q
	 TCPTNkLmFalPWe/zU9R9iVC6piSLDRrnRFZ7DLdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>
Subject: [PATCH 6.16 105/457] vsock/virtio: Validate length in packet header before skb_put()
Date: Tue, 26 Aug 2025 13:06:29 +0200
Message-ID: <20250826110939.970196259@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Will Deacon <will@kernel.org>

commit 0dab92484474587b82e8e0455839eaf5ac7bf894 upstream.

When receiving a vsock packet in the guest, only the virtqueue buffer
size is validated prior to virtio_vsock_skb_rx_put(). Unfortunately,
virtio_vsock_skb_rx_put() uses the length from the packet header as the
length argument to skb_put(), potentially resulting in SKB overflow if
the host has gone wonky.

Validate the length as advertised by the packet header before calling
virtio_vsock_skb_rx_put().

Cc: <stable@vger.kernel.org>
Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Signed-off-by: Will Deacon <will@kernel.org>
Message-Id: <20250717090116.11987-3-will@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -624,8 +624,9 @@ static void virtio_transport_rx_work(str
 	do {
 		virtqueue_disable_cb(vq);
 		for (;;) {
+			unsigned int len, payload_len;
+			struct virtio_vsock_hdr *hdr;
 			struct sk_buff *skb;
-			unsigned int len;
 
 			if (!virtio_transport_more_replies(vsock)) {
 				/* Stop rx until the device processes already
@@ -642,11 +643,18 @@ static void virtio_transport_rx_work(str
 			vsock->rx_buf_nr--;
 
 			/* Drop short/long packets */
-			if (unlikely(len < sizeof(struct virtio_vsock_hdr) ||
+			if (unlikely(len < sizeof(*hdr) ||
 				     len > virtio_vsock_skb_len(skb))) {
 				kfree_skb(skb);
 				continue;
 			}
+
+			hdr = virtio_vsock_hdr(skb);
+			payload_len = le32_to_cpu(hdr->len);
+			if (unlikely(payload_len > len - sizeof(*hdr))) {
+				kfree_skb(skb);
+				continue;
+			}
 
 			virtio_vsock_skb_rx_put(skb);
 			virtio_transport_deliver_tap_pkt(skb);


