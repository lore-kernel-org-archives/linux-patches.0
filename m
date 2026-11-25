Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622955;
	b=2jBrmhv6P3F912Wd8E2+//vVdOABZ1xeoJKPv3qDtg1S16xwF80Ju8YulyKBijv6j1p9
	 o/Vlhim04+IkmhnYyYH+0ncCzQ9Qt3+sKYptZVx9fdELdx57hR6oNoiey8xv6dPxAROwh
	 7MUY41mBKdbaJOyNlF5peibGba/H6i4d04PbTFDcFOQtz6r9yPmurnKcMk2D8WumzspqZ
	 /HKHjz+weRiC3CltarvAC1Ube4NalyqJycxPn0kvGxI517kPCrSONCCphA76XPnf+b3E8
	 /9a+f8i9gYjFoEdYbwNK4t/0ixWZsH8hLpyTuwqc3+3kI5j+Qz2pFps2IQUSIWYSamw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iYwMS+Po2H/pSPwRxki4Ew6SV8Kvn4XhVEdzDi5R7GY=;
	b=jV9iTtkDN99hPtZM3OZVDyur3cem3YGgpNMZKZUn+q113F2AnKXP2cDtXkYgXfgPwcl8
	 7pYar5Lt0KR1uf8Cp6R268i8jrv8A9YQAh8Cxx0OKGdstNXkwaPFvyL1z6tOc7WYmeOYb
	 8Q37/obIYztctu/ydL4YLWBAe7j2TutPkI3PYFGX9lr2Dl1AKTM8xeC04iWB2ByiKRT9i
	 PqJgUyZFqrIR36AryygNOHtFTD3rxx9YrKwste9zNzqIF1xkmEKMxaNp7XjSH3rxvsDBj
	 XLLmTcCptt/tfWTrjq/jMQd13WzhCCAS3v16QE1oFzSxMMyAvlvDRhPEJMi2nC+jrBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v9IV5Cvg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315F7606A31E;
	Wed, 25 Nov 2026 16:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v9IV5Cvg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FC731F000C4;
	Wed, 25 Nov 2026 16:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622955;
	bh=iYwMS+Po2H/pSPwRxki4Ew6SV8Kvn4XhVEdzDi5R7GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v9IV5CvgBPXdbGZtXy5hBxsjdbjkw3M2U9qKO8fHOc17Qau6aUStW+Z92Fc+zVeNc
	 pIyBzl49cTMAh/e4a+StttmtxpWlOMVe+Knlon5dTaHGXexvQrCXQPnfeCkiKPoII1
	 YEw1oRgeRgvuuMD7Z3KtxXa5uYcWyFSqvbl8fX/g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Mohm <jrmmhm.kernel@eldare.de>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 704/990] vsock/virtio: clear vqs[] to avoid a UAF on a failed PM restore
Date: Wed, 25 Nov 2026 15:34:31 +0100
Message-ID: <20261125143838.573707488@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Jerome Mohm <jrmmhm.kernel@eldare.de>

commit 2a24ba1694f14299fbde3fa107e5d56629f2f8b6 upstream.

virtio_vsock_vqs_del() frees the virtqueues but leaves vsock->vqs[]
pointing at them. If virtio_vsock_restore() then fails, the driver
stays bound with a dangling vqs[], and the next freeze or unbind
passes a freed virtqueue to virtqueue_detach_unused_buf():

  BUG: KASAN: slab-use-after-free in virtqueue_detach_unused_buf
   virtio_vsock_vqs_del (net/vmw_vsock/virtio_transport.c:785)
   virtio_vsock_remove
  Freed by task ...:
   vp_del_vqs
   virtio_vsock_freeze

Clear vqs[] after del_vqs() and when virtio_find_vqs() fails. Return
early from virtio_vsock_vqs_del() when vqs[] is empty: the detach
loops would pass NULL to virtqueue_detach_unused_buf(), and a second
del_vqs() would free virtio-mmio's IRQ again, which only WARNs in
free_irq() ("Trying to free already-free IRQ").

Found with the help of Anthropic's Claude and reproduced on virtio-pci
and virtio-mmio by failing the restore with failslab, without other
kernel changes; the virtio-mmio WARN was found by the netdev Sashiko
review and reproduced with v1 of this patch. With this patch neither
report appears on virtio-pci or virtio-mmio guests, and the vsock
vmtest.sh single-VM tests pass. A find_vqs() failure after some
virtqueues were set up was not exercised.

Fixes: bd50c5dc182b ("vsock/virtio: add support for device suspend/resume")
Cc: stable@vger.kernel.org
Signed-off-by: Jerome Mohm <jrmmhm.kernel@eldare.de>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://patch.msgid.link/20261109-vsock-restore-uaf-send-v4-1-1df8dfb5d5de@eldare.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/net/vmw_vsock/virtio_transport.c
+++ b/net/vmw_vsock/virtio_transport.c
@@ -690,8 +690,10 @@ static int virtio_vsock_vqs_init(struct
 	atomic_set(&vsock->queued_replies, 0);
 
 	ret = virtio_find_vqs(vdev, VSOCK_VQ_MAX, vsock->vqs, vqs_info, NULL);
-	if (ret < 0)
+	if (ret < 0) {
+		memset(vsock->vqs, 0, sizeof(vsock->vqs));
 		return ret;
+	}
 
 	virtio_vsock_update_guest_cid(vsock);
 
@@ -752,11 +754,19 @@ static void virtio_vsock_vqs_del(struct
 	vsock->event_run = false;
 	mutex_unlock(&vsock->event_lock);
 
+	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
+
 	/* Flush all device writes and interrupts, device will not use any
 	 * more buffers.
 	 */
 	virtio_reset_device(vdev);
 
+	/* After a failed restore no virtqueues are live, and a second
+	 * del_vqs() would free virtio-mmio's IRQ again (a WARN in free_irq()).
+	 */
+	if (!vsock->vqs[VSOCK_VQ_RX])
+		return;
+
 	mutex_lock(&vsock->rx_lock);
 	while ((skb = virtqueue_detach_unused_buf(vsock->vqs[VSOCK_VQ_RX])))
 		kfree_skb(skb);
@@ -767,10 +777,10 @@ static void virtio_vsock_vqs_del(struct
 		kfree_skb(skb);
 	mutex_unlock(&vsock->tx_lock);
 
-	virtio_vsock_skb_queue_purge(&vsock->send_pkt_queue);
-
 	/* Delete virtqueues and flush outstanding callbacks if any */
 	vdev->config->del_vqs(vdev);
+
+	memset(vsock->vqs, 0, sizeof(vsock->vqs));
 }
 
 static int virtio_vsock_probe(struct virtio_device *vdev)


