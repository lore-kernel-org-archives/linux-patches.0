Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCB5757FB;
	Mon, 15 Apr 2024 14:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713191740; cv=none; b=dpDc0zUnlPxAFbKxuwTxY7PEEGWkR/Dfjbv4Lcm99k8/Vyia+Z7hq8kw1512ABnCNGjQivF3LCvrTDA9Da1zV2q0+YfWuQ/+dD3EHHfVD6T5ZyH+KrlK0tv8iO01GQzza4RfmcgvaoluNx+2W2drDUW2GQmTzskgX9CbaWkNnH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713191740; c=relaxed/simple;
	bh=pcqRow4y7iMnFX1UbeZdLJ7N1tH75/q+KQL4yBka4zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SRhGVQjtaEPKTnURUenap96P3cNqPiiyKmmcyqei2cfwVb3vvuYiMmJSScqVjlv3Ssz7uWtEfOf2XZY8Wh1ftmAuTiqvs7sRWsaAQflTE/glcnOSvI21Lvy7L9sfvFW7ogXxgEKg58jbmGiHO2FcTV6dvjt1YO3by8XAGxuwCwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0/7yxyH+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0/7yxyH+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65209C113CC;
	Mon, 15 Apr 2024 14:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713191740;
	bh=pcqRow4y7iMnFX1UbeZdLJ7N1tH75/q+KQL4yBka4zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0/7yxyH+9Ec7LMkOmlUmT9LveVotsDlwt9EcBSbnqeLmUCtFO+gXjrSF3JG1wdTQH
	 QoTowKNhQqZ4CvSK7dhmPuIFgrLB9yIMZo9v0wET5IvMz/+meUrG6K4xstBlFhMnEc
	 FRITPS6bWQLgxfuwfg4R86Cn/Ggsg7QcoKpTxA64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Agroskin <shayagr@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 070/122] net: ena: Fix incorrect descriptor free behavior
Date: Mon, 15 Apr 2024 16:20:35 +0200
Message-ID: <20240415141955.479384450@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240415141953.365222063@linuxfoundation.org>
References: <20240415141953.365222063@linuxfoundation.org>
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

From: David Arinzon <darinzon@amazon.com>

[ Upstream commit bf02d9fe00632d22fa91d34749c7aacf397b6cde ]

ENA has two types of TX queues:
- queues which only process TX packets arriving from the network stack
- queues which only process TX packets forwarded to it by XDP_REDIRECT
  or XDP_TX instructions

The ena_free_tx_bufs() cycles through all descriptors in a TX queue
and unmaps + frees every descriptor that hasn't been acknowledged yet
by the device (uncompleted TX transactions).
The function assumes that the processed TX queue is necessarily from
the first category listed above and ends up using napi_consume_skb()
for descriptors belonging to an XDP specific queue.

This patch solves a bug in which, in case of a VF reset, the
descriptors aren't freed correctly, leading to crashes.

Fixes: 548c4940b9f1 ("net: ena: Implement XDP_TX action")
Signed-off-by: Shay Agroskin <shayagr@amazon.com>
Signed-off-by: David Arinzon <darinzon@amazon.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 5178eb089eabe..fd34f01a60b5c 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1205,8 +1205,11 @@ static void ena_unmap_tx_buff(struct ena_ring *tx_ring,
 static void ena_free_tx_bufs(struct ena_ring *tx_ring)
 {
 	bool print_once = true;
+	bool is_xdp_ring;
 	u32 i;
 
+	is_xdp_ring = ENA_IS_XDP_INDEX(tx_ring->adapter, tx_ring->qid);
+
 	for (i = 0; i < tx_ring->ring_size; i++) {
 		struct ena_tx_buffer *tx_info = &tx_ring->tx_buffer_info[i];
 
@@ -1226,10 +1229,15 @@ static void ena_free_tx_bufs(struct ena_ring *tx_ring)
 
 		ena_unmap_tx_buff(tx_ring, tx_info);
 
-		dev_kfree_skb_any(tx_info->skb);
+		if (is_xdp_ring)
+			xdp_return_frame(tx_info->xdpf);
+		else
+			dev_kfree_skb_any(tx_info->skb);
 	}
-	netdev_tx_reset_queue(netdev_get_tx_queue(tx_ring->netdev,
-						  tx_ring->qid));
+
+	if (!is_xdp_ring)
+		netdev_tx_reset_queue(netdev_get_tx_queue(tx_ring->netdev,
+							  tx_ring->qid));
 }
 
 static void ena_free_all_tx_bufs(struct ena_adapter *adapter)
-- 
2.43.0



