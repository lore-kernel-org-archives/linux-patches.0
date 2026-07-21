Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F5422B8DF;
	Tue, 21 Jul 2026 18:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657719; cv=none; b=Ie+sotjL4AsTW4wgJolLzjJaMMuoo7KVnDleUWbeCgCtRNI3vykjXgpImmuQyrO0sv+0Wqvh66BvQL5CVRX5kzu4XQHU9G5m2KfaSEdAb+v+Vj81ZhSxGPehGHyRXmPRSbg3Dv45U1GVVUXs9cvwNbW3s/ILgSiB4P1aqCJ3XMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657719; c=relaxed/simple;
	bh=nje7rL8U8ZpyO32HiXOZzyC5MX50lHfvjcSfLvwk9kM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JKXDqSyZB5UE5MsMbhxfYyGkfLqfCUSKN0CtOaVsFSdrLoklIj9xvOAeQFE3YeU3vmLWmCz4pBctZA+gacKWUF8oMMTt1chpg+/ByTBI86siQyiKSccdqhRZxc7twqF7PWrzUuCyNN/bmBSwdE2F3RnKGqST3nLbIOAXcrtXPvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rStt4dM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rStt4dM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 431FC1F000E9;
	Tue, 21 Jul 2026 18:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657717;
	bh=imagQzUosZ5DKlaTdRy8g45/UBAs0IuPMLYIhkIPFIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rStt4dM74lvBlMQzRv6XvuQj1unZ2h4llG7vmdOTmYtk6wKZ6LUnMxY96Rj7M3LXN
	 wg9pnd+S2L6Vb3TAYXs1ppWevCo/BfCmo3oz4hQDSOK+ULL9rZKMIU9SCaedZKBJUD
	 lrvikakY0dO76jUG1JWDBLkO9LMEnFENtb20QJ/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Joe Damato <joe@dama.to>,
	Wayen Yan <win847@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0870/1611] net: airoha: Fix skb->priority underflow in airoha_dev_select_queue()
Date: Tue, 21 Jul 2026 17:16:26 +0200
Message-ID: <20260721152534.960361379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wayen Yan <win847@gmail.com>

[ Upstream commit 86e51aa24686cc95bb35613059e8b94b9b81e3f0 ]

In airoha_dev_select_queue(), the expression:

  queue = (skb->priority - 1) % AIROHA_NUM_QOS_QUEUES;

implicitly converts to unsigned arithmetic: when skb->priority is 0
(the default for unclassified traffic), (0u - 1u) wraps to UINT_MAX,
and UINT_MAX % 8 = 7, routing default best-effort packets to the
highest-priority QoS queue. This causes QoS inversion where the
majority of traffic on a PON gateway starves actual high-priority
flows (VoIP, gaming, etc.).

The "- 1" offset was a leftover from the ETS offload implementation
that has since been removed. The correct mapping is a direct modulo:

  queue = skb->priority % AIROHA_NUM_QOS_QUEUES;

This maps priority 0 → queue 0 (lowest), priority 7 → queue 7
(highest), with higher priorities wrapping around. This is the
standard Linux sk_prio → HW queue mapping used by other drivers.

Fixes: 2b288b81560b ("net: airoha: Introduce ndo_select_queue callback")
Link: https://lore.kernel.org/netdev/178185573207.2378135.3729126358670287878@gmail.com/
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: Joe Damato <joe@dama.to>
Signed-off-by: Wayen Yan <win847@gmail.com>
Link: https://patch.msgid.link/178194366700.2485734.5368768965976693502@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.c b/drivers/net/ethernet/airoha/airoha_eth.c
index 5e7939c4f3e6fe..5efd03c2deea77 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.c
+++ b/drivers/net/ethernet/airoha/airoha_eth.c
@@ -1937,7 +1937,7 @@ static u16 airoha_dev_select_queue(struct net_device *dev, struct sk_buff *skb,
 	 */
 	channel = netdev_uses_dsa(dev) ? skb_get_queue_mapping(skb) : port->id;
 	channel = channel % AIROHA_NUM_QOS_CHANNELS;
-	queue = (skb->priority - 1) % AIROHA_NUM_QOS_QUEUES; /* QoS queue */
+	queue = skb->priority % AIROHA_NUM_QOS_QUEUES;
 	queue = channel * AIROHA_NUM_QOS_QUEUES + queue;
 
 	return queue < dev->num_tx_queues ? queue : 0;
-- 
2.53.0



