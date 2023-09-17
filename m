Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA066FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECCC1C433C7;
	Sun, 17 Sep 2023 20:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694981476;
	bh=djLYwqt6oW1+/YXVrMXpuWibjRyabdbuQmkFmOMZRFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZ2db/9RDMr/hE2pGJG5Kqz73AodSQWsubNovTtMMHBtmVNMpbvqbfggXojHgjgRl
	 8Ye1ulkX70vzGeoV5zkk0p2Oct/PVVwOKyvEqNRHWs6qsGEyAe7ylAUzOXJgl8Tufe
	 MKSjP7m8HQTsw5VY4vgGO1ZCqKmuM+ZHbdbpxHkE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jian Shen <shenjian15@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 129/219] net: hns3: fix tx timeout issue
Date: Sun, 17 Sep 2023 21:14:16 +0200
Message-ID: <20230917191045.654628882@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
References: <20230917191040.964416434@linuxfoundation.org>
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

From: Jian Shen <shenjian15@huawei.com>

[ Upstream commit 61a1deacc3d4fd3d57d7fda4d935f7f7503e8440 ]

Currently, the driver knocks the ring doorbell before updating
the ring->last_to_use in tx flow. if the hardware transmiting
packet and napi poll scheduling are fast enough, it may get
the old ring->last_to_use in drivers' napi poll.
In this case, the driver will think the tx is not completed, and
return directly without clear the flag __QUEUE_STATE_STACK_XOFF,
which may cause tx timeout.

Fixes: 20d06ca2679c ("net: hns3: optimize the tx clean process")
Signed-off-by: Jian Shen <shenjian15@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
index 61f833d61f583..9942b21cd6193 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.c
@@ -2102,8 +2102,12 @@ static void hns3_tx_doorbell(struct hns3_enet_ring *ring, int num,
 	 */
 	if (test_bit(HNS3_NIC_STATE_TX_PUSH_ENABLE, &priv->state) && num &&
 	    !ring->pending_buf && num <= HNS3_MAX_PUSH_BD_NUM && doorbell) {
+		/* This smp_store_release() pairs with smp_load_aquire() in
+		 * hns3_nic_reclaim_desc(). Ensure that the BD valid bit
+		 * is updated.
+		 */
+		smp_store_release(&ring->last_to_use, ring->next_to_use);
 		hns3_tx_push_bd(ring, num);
-		WRITE_ONCE(ring->last_to_use, ring->next_to_use);
 		return;
 	}
 
@@ -2114,6 +2118,11 @@ static void hns3_tx_doorbell(struct hns3_enet_ring *ring, int num,
 		return;
 	}
 
+	/* This smp_store_release() pairs with smp_load_aquire() in
+	 * hns3_nic_reclaim_desc(). Ensure that the BD valid bit is updated.
+	 */
+	smp_store_release(&ring->last_to_use, ring->next_to_use);
+
 	if (ring->tqp->mem_base)
 		hns3_tx_mem_doorbell(ring);
 	else
@@ -2121,7 +2130,6 @@ static void hns3_tx_doorbell(struct hns3_enet_ring *ring, int num,
 		       ring->tqp->io_base + HNS3_RING_TX_RING_TAIL_REG);
 
 	ring->pending_buf = 0;
-	WRITE_ONCE(ring->last_to_use, ring->next_to_use);
 }
 
 static void hns3_tsyn(struct net_device *netdev, struct sk_buff *skb,
@@ -3562,9 +3570,8 @@ static void hns3_reuse_buffer(struct hns3_enet_ring *ring, int i)
 static bool hns3_nic_reclaim_desc(struct hns3_enet_ring *ring,
 				  int *bytes, int *pkts, int budget)
 {
-	/* pair with ring->last_to_use update in hns3_tx_doorbell(),
-	 * smp_store_release() is not used in hns3_tx_doorbell() because
-	 * the doorbell operation already have the needed barrier operation.
+	/* This smp_load_acquire() pairs with smp_store_release() in
+	 * hns3_tx_doorbell().
 	 */
 	int ltu = smp_load_acquire(&ring->last_to_use);
 	int ntc = ring->next_to_clean;
-- 
2.40.1



