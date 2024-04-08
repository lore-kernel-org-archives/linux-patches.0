Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34CA32E405;
	Mon,  8 Apr 2024 13:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582562; cv=none; b=rXxxOh1qHZyqyJI4+Zpt7AT3q8MJ8MkcepUvWM5n0uwWPXuP/BiUiR3kVjE56d24eLH0LI3O9uKCRz3/HcjcZJe26LqD93VQJnU4Z7ratGnbVDOFtGD4eno0QOdDkebCwegXSCFjaQ6Q7bduRcbjH/5KE0h0pxZPC9O/c3lf7o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582562; c=relaxed/simple;
	bh=qYEKK/VewrCka+PKobrmFC5Rbe0TjDwioGDSkzwi6us=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gZTd68PNAWibG/7bk67hypl4k6dfKiVZkPh7XlFvIEV4WTow4kU+3v41MGX+q+I3P256OTIJBxCkcaQ2pZ+YqD3DgspruHALbqwERX/rYdr4QEKb9OqB36YbGvT0+tgQFT7R5oWzuSHapZPj75+64UkasQaaF9EXbqwVx45XOC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qdF1ErYh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qdF1ErYh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE9F9C433F1;
	Mon,  8 Apr 2024 13:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582562;
	bh=qYEKK/VewrCka+PKobrmFC5Rbe0TjDwioGDSkzwi6us=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qdF1ErYhLg4BboKMBantf13x8zUf1VK7FCxjYnVhXGpw6+z79z2RDhpBjCP7z77zm
	 sFWp7QgjEM7yH7MH2k//m84e1IKfO5V3saxzjFtNtTKP1L918Px7mH34ETIhYzo5P3
	 mjlx0v0xsTYgGDT5oBq0mRWoZO7h9v0kP/xDDRsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@vge.kernel.org,
	Marco Pinna <marco.pinn95@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.8 086/273] vsock/virtio: fix packet delivery to tap device
Date: Mon,  8 Apr 2024 14:56:01 +0200
Message-ID: <20240408125311.968911212@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
@@ -120,7 +120,6 @@ virtio_transport_send_pkt_work(struct wo
 		if (!skb)
 			break;
 
-		virtio_transport_deliver_tap_pkt(skb);
 		reply = virtio_vsock_skb_reply(skb);
 		sgs = vsock->out_sgs;
 		sg_init_one(sgs[out_sg], virtio_vsock_hdr(skb),
@@ -170,6 +169,8 @@ virtio_transport_send_pkt_work(struct wo
 			break;
 		}
 
+		virtio_transport_deliver_tap_pkt(skb);
+
 		if (reply) {
 			struct virtqueue *rx_vq = vsock->vqs[VSOCK_VQ_RX];
 			int val;


