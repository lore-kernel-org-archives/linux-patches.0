Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56E6231281F;
	Tue,  2 Sep 2025 13:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819992; cv=none; b=mEtohWveS1m8zeTa6tKNDWQsw1FlRcEdpG/TO45FM0/T51qyv4BhSbKYTQX85TWSc9hFq1G4p0jZxrEOrg8yF5fbMiMtcCnVtO1BLFeq2hxKhbZwTBkcGfpPMmNwhQI7I4OnMsjHY1VAvl50+60q8in0t4TFPsqzf5k72+H+xG4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819992; c=relaxed/simple;
	bh=k4lEkO5SNv9t/nAxqi7Jqaz3tMnCQb/dvgJOTa24c/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sR6SvQNjNbUEJWYAUpvjN11R+nP4cVbGC36CnXrky9PnM5xCE3eQGNkRasUj5UemQqW5LFLewtoWveOb9e+Bo1crRb+xtxUjSMmtExn6e4gPPifodimuTSj5vurqHBUvBfMgCcbgy+q8k1nooeIc4eV3Caozr8kfCm58uHXiWDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mA8FSjgi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mA8FSjgi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8E65C4CEED;
	Tue,  2 Sep 2025 13:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819992;
	bh=k4lEkO5SNv9t/nAxqi7Jqaz3tMnCQb/dvgJOTa24c/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mA8FSjgitgp3o/yXb6nYhskZGT7PSNMTIRUCyeddl21HilXeqLaYU57avFJShtSb2
	 xJlaFD6VvN4tweqo6A89haFPZNvHi425e5LUntoLmcuY5uPiVlv66OXLqQdT0IANHk
	 vh5IQG8NpEO5pasfi14YGQH9D20oJ0psko9GEurg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Damato <jdamato@fastly.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Shradha Gupta <shradhagupta@linux.microsoft.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 57/95] hv_netvsc: Link queues to NAPIs
Date: Tue,  2 Sep 2025 15:20:33 +0200
Message-ID: <20250902131941.791991233@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
References: <20250902131939.601201881@linuxfoundation.org>
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

From: Joe Damato <jdamato@fastly.com>

[ Upstream commit 8b641b5e4c782464c8818a71b443eeef8984bf34 ]

Use netif_queue_set_napi to link queues to NAPI instances so that they
can be queried with netlink.

Shradha Gupta tested the patch and reported that the results are
as expected:

$ ./tools/net/ynl/cli.py --spec Documentation/netlink/specs/netdev.yaml \
                           --dump queue-get --json='{"ifindex": 2}'

 [{'id': 0, 'ifindex': 2, 'napi-id': 8193, 'type': 'rx'},
  {'id': 1, 'ifindex': 2, 'napi-id': 8194, 'type': 'rx'},
  {'id': 2, 'ifindex': 2, 'napi-id': 8195, 'type': 'rx'},
  {'id': 3, 'ifindex': 2, 'napi-id': 8196, 'type': 'rx'},
  {'id': 4, 'ifindex': 2, 'napi-id': 8197, 'type': 'rx'},
  {'id': 5, 'ifindex': 2, 'napi-id': 8198, 'type': 'rx'},
  {'id': 6, 'ifindex': 2, 'napi-id': 8199, 'type': 'rx'},
  {'id': 7, 'ifindex': 2, 'napi-id': 8200, 'type': 'rx'},
  {'id': 0, 'ifindex': 2, 'napi-id': 8193, 'type': 'tx'},
  {'id': 1, 'ifindex': 2, 'napi-id': 8194, 'type': 'tx'},
  {'id': 2, 'ifindex': 2, 'napi-id': 8195, 'type': 'tx'},
  {'id': 3, 'ifindex': 2, 'napi-id': 8196, 'type': 'tx'},
  {'id': 4, 'ifindex': 2, 'napi-id': 8197, 'type': 'tx'},
  {'id': 5, 'ifindex': 2, 'napi-id': 8198, 'type': 'tx'},
  {'id': 6, 'ifindex': 2, 'napi-id': 8199, 'type': 'tx'},
  {'id': 7, 'ifindex': 2, 'napi-id': 8200, 'type': 'tx'}]

Signed-off-by: Joe Damato <jdamato@fastly.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Tested-by: Shradha Gupta <shradhagupta@linux.microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9448ccd85336 ("net: hv_netvsc: fix loss of early receive events from host during channel open.")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/hyperv/netvsc.c       | 13 ++++++++++++-
 drivers/net/hyperv/rndis_filter.c |  9 +++++++--
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/drivers/net/hyperv/netvsc.c b/drivers/net/hyperv/netvsc.c
index 807465dd4c8e3..87ac2a5f18091 100644
--- a/drivers/net/hyperv/netvsc.c
+++ b/drivers/net/hyperv/netvsc.c
@@ -712,8 +712,13 @@ void netvsc_device_remove(struct hv_device *device)
 	for (i = 0; i < net_device->num_chn; i++) {
 		/* See also vmbus_reset_channel_cb(). */
 		/* only disable enabled NAPI channel */
-		if (i < ndev->real_num_rx_queues)
+		if (i < ndev->real_num_rx_queues) {
+			netif_queue_set_napi(ndev, i, NETDEV_QUEUE_TYPE_TX,
+					     NULL);
+			netif_queue_set_napi(ndev, i, NETDEV_QUEUE_TYPE_RX,
+					     NULL);
 			napi_disable(&net_device->chan_table[i].napi);
+		}
 
 		netif_napi_del(&net_device->chan_table[i].napi);
 	}
@@ -1826,6 +1831,10 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 	netdev_dbg(ndev, "hv_netvsc channel opened successfully\n");
 
 	napi_enable(&net_device->chan_table[0].napi);
+	netif_queue_set_napi(ndev, 0, NETDEV_QUEUE_TYPE_RX,
+			     &net_device->chan_table[0].napi);
+	netif_queue_set_napi(ndev, 0, NETDEV_QUEUE_TYPE_TX,
+			     &net_device->chan_table[0].napi);
 
 	/* Connect with the NetVsp */
 	ret = netvsc_connect_vsp(device, net_device, device_info);
@@ -1844,6 +1853,8 @@ struct netvsc_device *netvsc_device_add(struct hv_device *device,
 
 close:
 	RCU_INIT_POINTER(net_device_ctx->nvdev, NULL);
+	netif_queue_set_napi(ndev, 0, NETDEV_QUEUE_TYPE_TX, NULL);
+	netif_queue_set_napi(ndev, 0, NETDEV_QUEUE_TYPE_RX, NULL);
 	napi_disable(&net_device->chan_table[0].napi);
 
 	/* Now, we can close the channel safely */
diff --git a/drivers/net/hyperv/rndis_filter.c b/drivers/net/hyperv/rndis_filter.c
index e457f809fe311..9b8769a8b77a1 100644
--- a/drivers/net/hyperv/rndis_filter.c
+++ b/drivers/net/hyperv/rndis_filter.c
@@ -1255,10 +1255,15 @@ static void netvsc_sc_open(struct vmbus_channel *new_sc)
 	ret = vmbus_open(new_sc, netvsc_ring_bytes,
 			 netvsc_ring_bytes, NULL, 0,
 			 netvsc_channel_cb, nvchan);
-	if (ret == 0)
+	if (ret == 0) {
 		napi_enable(&nvchan->napi);
-	else
+		netif_queue_set_napi(ndev, chn_index, NETDEV_QUEUE_TYPE_RX,
+				     &nvchan->napi);
+		netif_queue_set_napi(ndev, chn_index, NETDEV_QUEUE_TYPE_TX,
+				     &nvchan->napi);
+	} else {
 		netdev_notice(ndev, "sub channel open failed: %d\n", ret);
+	}
 
 	if (atomic_inc_return(&nvscdev->open_chn) == nvscdev->num_chn)
 		wake_up(&nvscdev->subchan_open);
-- 
2.50.1



