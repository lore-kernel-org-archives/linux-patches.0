Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7A9623D7EC;
	Tue,  2 Sep 2025 13:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819634; cv=none; b=guqZ48J6fq7Tmow9WWE65OAMSMaffOGvjIaxJ3ma370XvwCgcyZnyvn8F5qbS5VGleYhL9PPz+UlXYf7zvVUbEU4nipeOTqjYkTtULgJ2I2ThEyRLpLi5T/6S31w7Ce1A8wF3IFunfszAHhNu/CLDuwX38jSdtfvHrxirpIUxEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819634; c=relaxed/simple;
	bh=sNCXZbu9VKXPfzDfoTtufafagTkI6AmDB8gBT7gMo0Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D60AFqQhmR8TRzZtEuIKfoDdurFp6cb6xBrHBn7kFNhQKlpqGySKbGeMTFyNr774Z+FQ5RetEr0GR4RcnQNy5XeAm65lyZ/Hu4zSfj2dDI50UK1t9rA34vR0KdrrZJJ8Xk4K5nOrw9/fYvPOJcopJeo0MfyrZswajPLCFC6XgUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i5uMfu7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i5uMfu7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47789C4CEED;
	Tue,  2 Sep 2025 13:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819634;
	bh=sNCXZbu9VKXPfzDfoTtufafagTkI6AmDB8gBT7gMo0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i5uMfu7QE/dxycjFlZnph2gbGpSLrlZTbHdWkUTBa4ZDIUiT7H4XIIvgYlgjfIZlF
	 gJXi5w0hYNgoZJ3whRUKzN+BYUfHF3aMMTNtIvCqvGWljwh5tK+OX+hYHxvx/wwmpC
	 JpsVDHTmAKcHiOvplvA2ui+t+hdgcrxQgECEEDgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 092/142] net: hv_netvsc: fix loss of early receive events from host during channel open.
Date: Tue,  2 Sep 2025 15:19:54 +0200
Message-ID: <20250902131951.788993568@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

[ Upstream commit 9448ccd853368582efa9db05db344f8bb9dffe0f ]

The hv_netvsc driver currently enables NAPI after opening the primary and
subchannels. This ordering creates a race: if the Hyper-V host places data
in the host -> guest ring buffer and signals the channel before
napi_enable() has been called, the channel callback will run but
napi_schedule_prep() will return false. As a result, the NAPI poller never
gets scheduled, the data in the ring buffer is not consumed, and the
receive queue may remain permanently stuck until another interrupt happens
to arrive.

Fix this by enabling NAPI and registering it with the RX/TX queues before
vmbus channel is opened. This guarantees that any early host signal after
open will correctly trigger NAPI scheduling and the ring buffer will be
drained.

Fixes: 76bb5db5c749d ("netvsc: fix use after free on module removal")
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Link: https://patch.msgid.link/20250825115627.GA32189@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc.c       | 17 ++++++++---------
 drivers/net/hyperv/rndis_filter.c | 23 ++++++++++++++++-------
 2 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 720104661d7f2..60a4629fe6ba7 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -1812,6 +1812,11 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 
 	/* Enable NAPI handler before init callbacks */
 	netif_napi_add(ndev, &net_device->chan_table[0].napi, netvsc_poll);
+	napi_enable(&net_device->chan_table[0].napi);
+	netif_queue_set_napi(ndev, 0, NETDEV_QUEUE_TYPE_RX,
+			     &net_device->chan_table[0].napi);
+	netif_queue_set_napi(ndev, 0, NETDEV_QUEUE_TYPE_TX,
+			     &net_device->chan_table[0].napi);
 
 	/* Open the channel */
 	device->channel->next_request_id_callback = vmbus_next_request_id;
@@ -1831,12 +1836,6 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 	/* Channel is opened */
 	netdev_dbg(ndev, "hv_netvsc channel opened successfully\n");
 
-	napi_enable(&net_device->chan_table[0].napi);
-	netif_queue_set_napi(ndev, 0, NETDEV_QUEUE_TYPE_RX,
-			     &net_device->chan_table[0].napi);
-	netif_queue_set_napi(ndev, 0, NETDEV_QUEUE_TYPE_TX,
-			     &net_device->chan_table[0].napi);
-
 	/* Connect with the NetVsp */
 	ret = netvsc_connect_vsp(device, net_device, device_info);
 	if (ret != 0) {
@@ -1854,14 +1853,14 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 
 close:
 	RCU_INIT_POINTER(net_device_ctx->nvdev, NULL);
-	netif_queue_set_napi(ndev, 0, NETDEV_QUEUE_TYPE_TX, NULL);
-	netif_queue_set_napi(ndev, 0, NETDEV_QUEUE_TYPE_RX, NULL);
-	napi_disable(&net_device->chan_table[0].napi);
 
 	/* Now, we can close the channel safely */
 	vmbus_close(device->channel);
 
 cleanup:
+	netif_queue_set_napi(ndev, 0, NETDEV_QUEUE_TYPE_TX, NULL);
+	netif_queue_set_napi(ndev, 0, NETDEV_QUEUE_TYPE_RX, NULL);
+	napi_disable(&net_device->chan_table[0].napi);
 	netif_napi_del(&net_device->chan_table[0].napi);
 
 cleanup2:
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index 9e73959e61ee0..c35f9685b6bf0 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1252,17 +1252,26 @@ static void netvsc_sc_open(struct vmbus_channel *new_sc)
 	new_sc->rqstor_size = netvsc_rqstor_size(netvsc_ring_bytes);
 	new_sc->max_pkt_size = NETVSC_MAX_PKT_SIZE;
 
+	/* Enable napi before opening the vmbus channel to avoid races
+	 * as the host placing data on the host->guest ring may be left
+	 * out if napi was not enabled.
+	 */
+	napi_enable(&nvchan->napi);
+	netif_queue_set_napi(ndev, chn_index, NETDEV_QUEUE_TYPE_RX,
+			     &nvchan->napi);
+	netif_queue_set_napi(ndev, chn_index, NETDEV_QUEUE_TYPE_TX,
+			     &nvchan->napi);
+
 	ret = vmbus_open(new_sc, netvsc_ring_bytes,
 			 netvsc_ring_bytes, NULL, 0,
 			 netvsc_channel_cb, nvchan);
-	if (ret == 0) {
-		napi_enable(&nvchan->napi);
-		netif_queue_set_napi(ndev, chn_index, NETDEV_QUEUE_TYPE_RX,
-				     &nvchan->napi);
-		netif_queue_set_napi(ndev, chn_index, NETDEV_QUEUE_TYPE_TX,
-				     &nvchan->napi);
-	} else {
+	if (ret != 0) {
 		netdev_notice(ndev, "sub channel open failed: %d\n", ret);
+		netif_queue_set_napi(ndev, chn_index, NETDEV_QUEUE_TYPE_TX,
+				     NULL);
+		netif_queue_set_napi(ndev, chn_index, NETDEV_QUEUE_TYPE_RX,
+				     NULL);
+		napi_disable(&nvchan->napi);
 	}
 
 	if (atomic_inc_return(&nvscdev->open_chn) == nvscdev->num_chn)
-- 
2.50.1



