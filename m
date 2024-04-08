Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3411C2DF73;
	Mon,  8 Apr 2024 13:06:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581612; cv=none; b=UovHGo15RVLYNZNaZVs8VAxCkZ5H7u0nPVsv26JdHBZApLC2o/eY2NrIgvCQZgIBu4rUO5xvEE1eVSzeIueEgQ4RzlQnNsQxBGpyzde3bkHbzFmj9EKBHPbdXSqWQMyNXgnJq84gQ35lj599ZvBFiQt4ObInwy8ZfLLWXE98H7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581612; c=relaxed/simple;
	bh=OMsI9VmcL61/g484M5VbN/JvX9cT48N7k0wdn9x+lyk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dV3epkeN0J6cjQzUiHY5nqlpPLy3XUN0qoiRIy8mKeLgdKq7eP2yruK/s2lb8ZltodG4Z6HCOMcN3fIQYmiFyivJ2vh/TPj1tcUflz0e01hlYjuyzGK8WPzPBYOGBiag6isDyTgI1o+5dSkASRMUbY3Lk+D5qZ8dJfFznu2U1FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0lZLQc9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0lZLQc9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFFEAC433F1;
	Mon,  8 Apr 2024 13:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581612;
	bh=OMsI9VmcL61/g484M5VbN/JvX9cT48N7k0wdn9x+lyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0lZLQc9eX3OqE0SqSagfXChPa/VnCLkD8Vh0c1YWGGK6x1rNcNCpz+xFUtdA9sAvM
	 idDNk4PnFQLxN8cBkunguHb7yvlYrTUrlSw0AwVjXZbQhJTlUt6xPL4E8WfuImRLVE
	 aMsebB/xANJi6G1KW/8VP7AQcKoBeChZaOHyt7IA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@vge.kernel.org,
	Marco Pinna <marco.pinn95@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 038/138] vsock/virtio: fix packet delivery to tap device
Date: Mon,  8 Apr 2024 14:57:32 +0200
Message-ID: <20240408125257.409354257@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marco Pinna <marco.pinn95@gmail.com>

commit b32a09ea7c38849ff925489a6bf5bd8914bc45df upstream.

Commit 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks") added
virtio_transport_deliver_tap_pkt() for handing packets to the
vsockmon device. However, in virtio_transport_send_pkt_work(),
the function is called before actually sending the packet (i.e.
before placing it in the virtqueue with virtqueue_add_sgs() and checking
whether it returned successfully).
Queuing the packet in the virtqueue can fail even multiple times.
However, in virtio_transport_deliver_tap_pkt() we deliver the packet
to the monitoring tap interface only the first time we call it.
This certainly avoids seeing the same packet replicated multiple times
in the monitoring interface, but it can show the packet sent with the
wrong timestamp or even before we succeed to queue it in the virtqueue.

Move virtio_transport_deliver_tap_pkt() after calling virtqueue_add_sgs()
and making sure it returned successfully.

Fixes: 82dfb540aeb2 ("VSOCK: Add virtio vsock vsockmon hooks")
Cc: stable@vge.kernel.org
Signed-off-by: Marco Pinna <marco.pinn95@gmail.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20240329161259.411751-1-marco.pinn95@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -109,7 +109,6 @@ virtio_transport_send_pkt_work(struct wo
 		if (!skb)
 			break;
 
-		virtio_transport_deliver_tap_pkt(skb);
 		reply = virtio_vsock_skb_reply(skb);
 
 		sg_init_one(&hdr, virtio_vsock_hdr(skb), sizeof(*virtio_vsock_hdr(skb)));
@@ -128,6 +127,8 @@ virtio_transport_send_pkt_work(struct wo
 			break;
 		}
 
+		virtio_transport_deliver_tap_pkt(skb);
+
 		if (reply) {
 			struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
 			int val;


