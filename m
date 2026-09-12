Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2825B3C1F46;
	Sat, 12 Sep 2026 09:13:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204391; cv=none; b=nZ8W0q33Rkikq/YEFkHoJKfIPjgvuSleepiO/sVUiLJSNjpTdCgRSm326Hnur+u7W1zfqNHKZIH0fEQYDpFRaRXHPhDrvtfIwX+KJz9vZylJnX+KYLZL3HWMuzy5Yb6As/+YjjRmGnKMaJp8jh49y6UoL4egpOSFivKVhU3C/78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204391; c=relaxed/simple;
	bh=o37t73Y1VUIk3QYWTa/ahca05yE023l4MoJuPwUwY3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2TYXPbezbar3AzqiI1dYJqHJzZa/KZ1R9guBr/+J90hXfQ/dr1SZM+EKbSHEnaWVQl2PECpJ3zR4WlTRqNeUM9B/82yn0v7oqJn3lipsRFL3LK2nMhoLObiAsMcwHWja5jMg+SB8jk4W5BHa224/findh9s0wb2CdpStDICMBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F60OST4C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F60OST4C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F8161F000FF;
	Sat, 12 Sep 2026 09:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204390;
	bh=PWiO9zDhZ/Dw5SaDzTdcs0f7gQFHClRj+B98Fb+m0P0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F60OST4CFdV1xBG21uOA7aC4J51HIomQ1ZgzNFITC9Zvp7pN+wp9dLLAymO42ZTy3
	 KP6+1NwoiwfCpi5CkFhe0YERiQBCu4RjIiiZRxGPXyXNmHtcqwnB8G7mek40szD4bE
	 jw/UIvkO0SGbBiD1WmY3b+zfV/DgObVQPi3spUV8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Teng Peisen <tengpeisen@huawei.com>,
	Wu Di <wudi234@huawei.com>,
	Fan Gong <gongfan1@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1560/1815] hinic3: Fix skb linearization mismatch and drop skb when skb_checksum_help() failed
Date: Sat, 12 Sep 2026 08:55:10 +0200
Message-ID: <20260912065725.617344794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Gong <gongfan1@huawei.com>

[ Upstream commit d0c2bed6927cbfa2cb51f240b4812bf6916bce0e ]

Previously, hinic3_send_one_skb() cached the skb fragment count before
calling hinic3_tx_offload(). If hinic3_tx_csum() falls back to
skb_checksum_help() for unsupported tunnel packets, the skb may be
linearized. Continuing to build the TX descriptor with the stale
fragment count leads to a descriptor mismatch, which can trigger
out-of-bounds DMA reads or IOMMU faults.

Furthermore, the old code ignored the return value of skb_checksum_help(),
transmitting corrupted packets with incomplete checksums upon failure.

Fix this by:
1. Moving the hinic3_tx_offload() call before calculating 'num_sge' to
   ensure the correct fragment count is used if the SKB is linearized.
2. Propagating skb_checksum_help() errors and returning
   HINIC3_TX_OFFLOAD_INVALID to properly drop the skb.

Fixes: 17fcb3dc12bb ("hinic3: module initialization and tx/rx logic")
Co-developed-by: Teng Peisen <tengpeisen@huawei.com>
Signed-off-by: Teng Peisen <tengpeisen@huawei.com>
Co-developed-by: Wu Di <wudi234@huawei.com>
Signed-off-by: Wu Di <wudi234@huawei.com>
Signed-off-by: Fan Gong <gongfan1@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/78d8c61cab588240948eaddcb437d59add9f77ae.1786448013.git.tengpeisen@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/huawei/hinic3/hinic3_tx.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/huawei/hinic3/hinic3_tx.c b/drivers/net/ethernet/huawei/hinic3/hinic3_tx.c
index 9306bf0020caf..cc541e7a23186 100644
--- a/drivers/net/ethernet/huawei/hinic3/hinic3_tx.c
+++ b/drivers/net/ethernet/huawei/hinic3/hinic3_tx.c
@@ -261,8 +261,7 @@ static int hinic3_tx_csum(struct hinic3_txq *txq, struct hinic3_sq_task *task,
 		    ((struct udphdr *)skb_transport_header(skb))->dest !=
 		    VXLAN_OFFLOAD_PORT_LE) {
 			/* Unsupported tunnel packet, disable csum offload */
-			skb_checksum_help(skb);
-			return 0;
+			return skb_checksum_help(skb);
 		}
 	}
 
@@ -412,6 +411,10 @@ static u32 hinic3_tx_offload(struct sk_buff *skb, struct hinic3_sq_task *task,
 		offload |= HINIC3_TX_OFFLOAD_TSO;
 	} else {
 		tso_cs_en = hinic3_tx_csum(txq, task, skb);
+		if (tso_cs_en < 0) {
+			offload = HINIC3_TX_OFFLOAD_INVALID;
+			return offload;
+		}
 		if (tso_cs_en)
 			offload |= HINIC3_TX_OFFLOAD_CSUM;
 	}
@@ -545,6 +548,7 @@ static netdev_tx_t hinic3_send_one_skb(struct sk_buff *skb,
 		skb->len = MIN_SKB_LEN;
 	}
 
+	offload = hinic3_tx_offload(skb, &task, &queue_info, txq);
 	num_sge = skb_shinfo(skb)->nr_frags + 1;
 	/* assume normal wqe format + 1 wqebb for task info */
 	wqebb_cnt = num_sge + 1;
@@ -560,7 +564,6 @@ static netdev_tx_t hinic3_send_one_skb(struct sk_buff *skb,
 		return NETDEV_TX_BUSY;
 	}
 
-	offload = hinic3_tx_offload(skb, &task, &queue_info, txq);
 	if (unlikely(offload == HINIC3_TX_OFFLOAD_INVALID)) {
 		goto err_drop_pkt;
 	} else if (!offload) {
-- 
2.53.0



