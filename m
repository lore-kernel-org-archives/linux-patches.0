Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D674676413;
	Mon,  8 Apr 2024 13:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582392; cv=none; b=F8291AROVfmdALPiJUoAngBHWpY8RSJg2yEFWPCEym8QCqDb/blWdTc7xi8ccbvXZ1tg/URH/lS5zzbgzwTEnGJ1tEFFb852N7CDFPoD+wdKqBR+THOkw88aktGTCMIdvh0yiJy7UfOOoiXiKqp/NygiLYallLH7ZP4EKIoXb7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582392; c=relaxed/simple;
	bh=gDa1I6FkFp46onJlH9QQZR4kixDZd32f+9MDqO9kKuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rxZj7Aoexd6lPnKLs60Z9gtfLDX6h/QZERz/GTFZ+F7qje307uWeHPexUGJorz4Tkv0Y5f3C1uHWJ9MNWBHyDLLEueLfpMVg9AKCCDBw6YDkFGVPHgko39s3LUgFC5xRaaxIVhwZWLZCvmbFwe+RUmpS8dVhXNzBh6X7cpsmrFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G/YE1Szs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G/YE1Szs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DB85C433F1;
	Mon,  8 Apr 2024 13:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582392;
	bh=gDa1I6FkFp46onJlH9QQZR4kixDZd32f+9MDqO9kKuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G/YE1SzsSqkhd7SvIGkQctUFYhaBcAOvXJv/YcUavB7Ew0ahhxTbgmP1sOBHntJ1Q
	 Cng6x6gPgrgcLedmhqQsmJpYOziLm5UWA7pMUiYiDNI4/86XvULVM7qoMCfyCFI4bE
	 v12wsETZtUUSWOpxAp77HFNDgPvFGzSeGD/TkAPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@vge.kernel.org,
	Marco Pinna <marco.pinn95@gmail.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 089/252] vsock/virtio: fix packet delivery to tap device
Date: Mon,  8 Apr 2024 14:56:28 +0200
Message-ID: <20240408125309.416922471@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
References: <20240408125306.643546457@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


