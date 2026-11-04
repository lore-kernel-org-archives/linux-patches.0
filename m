Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827195;
	b=nP2tCzEsdsOox1TJtstiAjCK5eseXgn90MkV/DfS/oD3G9Kb43D6SFFyqkw2iYGrXxZa
	 xIYxD6n/+BY+Yhew8mAZckjnABTt+sRndgAh0JEBWvrMNhFRIvE4FNsvfw5dFmpOUoQEV
	 /RJ9Mrch4xFNSnINHD80YMHt4P0/t1Z6EhtrMuPXVk8mjasXNnUtul4CnQ/+AzK9XAw3c
	 YvSXy1EDisk2r7SYppjxGZ+VSaLSKiZ0Ib+G1k2z5EYYzcOI9OI4vD6xF140eiZpV8Bm6
	 RZaPxEPHaixmDsdGvtTzlNzmHRe7rEQ04hX9i9xaSEC6koJDTXzgyudoVKP7tJfpv4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+6F/RIDt1camA8P9i4DF0bJC5Z5b43UBopoxwwI8aJc=;
	b=UAFnbdxfSfybG/PHnC1TGhFkJSwzjxWVDLXI2tJgEzP8j85WZNqX/ywpKqonaxkwu66O
	 +21ijlZIp5snqXJ2o/pNxL5zrU3pf2iE/yNope83EyKDkX+Icu2JhqI2W9pjHp1ClLrGw
	 Ec3lZXJhvhTT/nFWq14CBZL8vsovmNMPZPWqkOCPQrcreSXk2Fv8C5VEblT4DpjW+m7kR
	 o/NadZimDdyrTEPESORRrlA4t38g85/+E9EWC1pzNAb9yu9iqciilfnuIFMpsz8LWvxP3
	 GrIhR0/HcgkmFghJLlv9G/+0aIRoOMMeCRTOa1zUhXVuHH6fHx2pWzT93yHcBS1wH6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZidNYziT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1253606B2C1;
	Wed,  4 Nov 2026 21:19:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZidNYziT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9064C1F00919;
	Wed,  4 Nov 2026 21:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827194;
	bh=+6F/RIDt1camA8P9i4DF0bJC5Z5b43UBopoxwwI8aJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZidNYziTc2NUccBwO+aWbDOs0+xIEKdq0SjiYl8Iq9TXD7rcuameHR0mqNqsJo58i
	 eA1MCPnZ+okPZqvb9iZBLyas1gRxabXnBdseo4FTsr8CPRExBPheTvOwaZQ3YlDiu4
	 F1G9EpuF/t2oCew7ulOofhfD4isJnalFmePPTuoc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	co+d17c2bc750a9cbbb@bugs.sh,
	Weiming Shi <bestswngs@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.3 250/547] virtio_net: atomically disable rx mode work
Date: Wed,  4 Nov 2026 16:07:14 -0500
Message-ID: <20261104211045.279640122@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Weiming Shi <bestswngs@gmail.com>

commit 1234707482053f1d1ac7c5756207d2c29057974c upstream.

virtio-net uses a boolean to gate rx_mode_work during device teardown.
The flag is changed under RTNL, but ndo_set_rx_mode checks it under the
address-list lock. A callback can therefore pass the check and enqueue work
after teardown has flushed it. The work is also enabled before late
probe operations that can fail, allowing probe unwind to free the netdev
with work still queued.

KASAN reports the worker using a virtqueue that probe unwind already freed:

  BUG: KASAN: slab-use-after-free in virtqueue_add_split
  Workqueue: events virtnet_rx_mode_work
  Call Trace:
   virtqueue_add_split (drivers/virtio/virtio_ring.c:706)
   virtqueue_add_sgs (drivers/virtio/virtio_ring.c:2839)
   virtnet_send_command_reply (drivers/net/virtio_net.c:3565)
   virtnet_rx_mode_work (drivers/net/virtio_net.c:3833)
   process_one_work (kernel/workqueue.c:3322)
   worker_thread (kernel/workqueue.c:3405)
  Freed by task 119:
   kfree (mm/slub.c:6625)
   vp_del_vq.isra.0 (drivers/virtio/virtio_pci_common.c:259)
   vp_del_vqs (drivers/virtio/virtio_pci_common.c:285)
   virtnet_probe (drivers/net/virtio_net.c:7129)

Use the workqueue disable mechanism to atomically reject new queue attempts
and drain running work. Keep work disabled until probe succeeds or restore
has reattached the netdev, then enable it and replay receive-mode state for
a running interface. Disable it before resource teardown in freeze and
remove.

Fixes: b9f7425239a0 ("virtio-net: convert rx mode setting to use workqueue")
Cc: stable@vger.kernel.org
Reported-by: <co+d17c2bc750a9cbbb@bugs.sh>
Assisted-by: LLM
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Link: https://patch.msgid.link/20261017114237.2786302-2-bestswngs@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |   26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -441,9 +441,6 @@ struct virtnet_info {
 	/* Work struct for setting rx mode */
 	struct work_struct rx_mode_work;
 
-	/* OK to queue work setting RX mode? */
-	bool rx_mode_work_enabled;
-
 	/* Does the affinity hint is set for virtqueues? */
 	bool affinity_hint_set;
 
@@ -710,16 +707,13 @@ static void virtnet_rq_free_buf(struct v
 
 static void enable_rx_mode_work(struct virtnet_info *vi)
 {
-	rtnl_lock();
-	vi->rx_mode_work_enabled = true;
-	rtnl_unlock();
+	if (enable_work(&vi->rx_mode_work) && netif_running(vi->dev))
+		schedule_work(&vi->rx_mode_work);
 }
 
 static void disable_rx_mode_work(struct virtnet_info *vi)
 {
-	rtnl_lock();
-	vi->rx_mode_work_enabled = false;
-	rtnl_unlock();
+	disable_work_sync(&vi->rx_mode_work);
 }
 
 static void virtqueue_napi_schedule(struct napi_struct *napi,
@@ -3925,8 +3919,7 @@ static void virtnet_set_rx_mode(struct n
 {
 	struct virtnet_info *vi = netdev_priv(dev);
 
-	if (vi->rx_mode_work_enabled)
-		schedule_work(&vi->rx_mode_work);
+	schedule_work(&vi->rx_mode_work);
 }
 
 static int virtnet_vlan_rx_add_vid(struct net_device *dev,
@@ -5742,7 +5735,6 @@ static void virtnet_freeze_down(struct v
 	/* Make sure no work handler is accessing the device */
 	flush_work(&vi->config_work);
 	disable_rx_mode_work(vi);
-	flush_work(&vi->rx_mode_work);
 
 	if (netif_running(vi->dev)) {
 		rtnl_lock();
@@ -5772,8 +5764,6 @@ static int virtnet_restore_up(struct vir
 
 	virtio_device_ready(vdev);
 
-	enable_rx_mode_work(vi);
-
 	if (netif_running(vi->dev)) {
 		rtnl_lock();
 		err = virtnet_open(vi->dev);
@@ -5785,6 +5775,8 @@ static int virtnet_restore_up(struct vir
 	netif_tx_lock_bh(vi->dev);
 	netif_device_attach(vi->dev);
 	netif_tx_unlock_bh(vi->dev);
+
+	enable_rx_mode_work(vi);
 	return 0;
 
 err_destroy_pools:
@@ -6880,6 +6872,7 @@ static int virtnet_probe(struct virtio_d
 
 	INIT_WORK(&vi->config_work, virtnet_config_changed_work);
 	INIT_WORK(&vi->rx_mode_work, virtnet_rx_mode_work);
+	disable_work(&vi->rx_mode_work);
 
 	if (virtio_has_feature(vdev, VIRTIO_NET_F_MRG_RXBUF)) {
 		vi->mergeable_rx_bufs = true;
@@ -7038,8 +7031,6 @@ static int virtnet_probe(struct virtio_d
 	if (vi->has_rss || vi->has_rss_hash_report)
 		virtnet_init_default_rss(vi);
 
-	enable_rx_mode_work(vi);
-
 	for (i = 0; i < ARRAY_SIZE(guest_offloads); i++) {
 		unsigned int fbit;
 
@@ -7143,6 +7134,8 @@ static int virtnet_probe(struct virtio_d
 		goto free_unregister_netdev;
 	}
 
+	enable_rx_mode_work(vi);
+
 	pr_debug("virtnet: registered device %s with %d RX and TX vq's\n",
 		 dev->name, max_queue_pairs);
 
@@ -7195,7 +7188,6 @@ static void virtnet_remove(struct virtio
 	/* Make sure no work handler is accessing the device. */
 	flush_work(&vi->config_work);
 	disable_rx_mode_work(vi);
-	flush_work(&vi->rx_mode_work);
 
 	virtnet_free_irq_moder(vi);
 


