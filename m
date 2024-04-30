Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F5112B176;
	Tue, 30 Apr 2024 10:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474738; cv=none; b=q04YlcPBJMolDoSNKpHErseEojVN/hQcX9Kv7rF/yCJHQKYptRHWA7qvUEdOCdyKdDoSt7HPkc2TX8x+hY1sEa6Omg07mwfh26ruMC/hac8n+xUTzMJgsVpupFAFJQWz4Vk+TNiBEIVAiQ0t1UfBKHI5MU4bVMA27z2XghKL328=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474738; c=relaxed/simple;
	bh=88K6vLAHWimZBZVJ9BRZ3Y08l8vE3sBKGUL5vnQeoxk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CA7OUG18bVBdjt9RJ4gBsAY+iKZoAIUE9w8YFMWrb98o/XvMlII4MIV4co9al0ws03iedwfE/q4VgkqnNh4m6aOn9CM1vO86FNuXkwmzlEmQVHL9WmkbzYB3XISJb320f8fxTHjctj+JaXJRKjHT1nMO2GhsvX6DHLA/wuEw/6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KrpHidgP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KrpHidgP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1593AC2BBFC;
	Tue, 30 Apr 2024 10:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474738;
	bh=88K6vLAHWimZBZVJ9BRZ3Y08l8vE3sBKGUL5vnQeoxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KrpHidgP1g7w5h05igdumfO1Y0ywZLnGHiUUQtBKdaV2IYVJG0c5+EmzEc9WJsDcx
	 OTWm2gPP2b98qF/G/P9T2cpJwM1Z7WR+LcQFQk7/90SCHmFoDWyrFfsm+DrAvrV864
	 HquH5GaSm5lO5RfM5tHvFbqT9Ce0013H/hNl6s74=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shay Agroskin <shayagr@amazon.com>,
	David Arinzon <darinzon@amazon.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/138] net: ena: Fix incorrect descriptor free behavior
Date: Tue, 30 Apr 2024 12:38:25 +0200
Message-ID: <20240430103050.021609374@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f403a5acda5b0..9149c82c0a564 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1105,8 +1105,11 @@ static void ena_unmap_tx_buff(struct ena_ring *tx_ring,
 static void ena_free_tx_bufs(struct ena_ring *tx_ring)
 {
 	bool print_once = true;
+	bool is_xdp_ring;
 	u32 i;
 
+	is_xdp_ring = ENA_IS_XDP_INDEX(tx_ring->adapter, tx_ring->qid);
+
 	for (i = 0; i < tx_ring->ring_size; i++) {
 		struct ena_tx_buffer *tx_info = &tx_ring->tx_buffer_info[i];
 
@@ -1126,10 +1129,15 @@ static void ena_free_tx_bufs(struct ena_ring *tx_ring)
 
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



