Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CBFE403AFB;
	Tue, 21 Jul 2026 17:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654953; cv=none; b=GvmkcOhlFTrzbScPF0kxkMRqja/dy4kfsz9EY6e3jBbkwSwf8fEDY279bACWac4syG0EClTmnBduzD8AIpPPWhyEdx7XyZAQqbZaGfwJeB0lRv2jPNKwtkBeZYG20fN++MGs2K1bS9KMobZZDUSWmuQL9s+5FR9KmRiQrTjmkpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654953; c=relaxed/simple;
	bh=YBZXMC6wJ9KYN/JDfXTBn34MouBMntA9MqInaCsamO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXcjuUhBN/Rp+B591Xb4Jhc8znVTVBHINYQf28IZZMJ3kXsGyBMaXulunrTyEuZr6b/lK81Hk8869LsAbJYBMiMDgZwMG0eQxCqWtTp4bt3wxBxV3V74gPbvL8ifP5IQj63Axz2jOHiBd6u6eUNpVZL8V0m1QgJ6XIpsj+DlEp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H29iV0YL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H29iV0YL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD9F1F000E9;
	Tue, 21 Jul 2026 17:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654952;
	bh=DkkkTm6rM1EzKgldSKBW080yn84sSg/KPLy4hg2OT1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H29iV0YLRIKgcLWjP4F06rpcPuH/o8Jq9dKHt4gj/UVn4VQgbIiSjgzURiDTkGDa3
	 AKphKuwaZsaWKacyfKCeTnUeAneIcSm7eXtMDDzCobh5v/Ii6NLAt4rC7ucEeh2QxY
	 w7nO03r1GYwFAxEcW/erBJZrpJ64Oa+SlaO3UWVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dexuan Cui <decui@microsoft.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 7.1 1901/2077] net: mana: Validate the packet length reported by the NIC
Date: Tue, 21 Jul 2026 17:26:14 +0200
Message-ID: <20260721152637.559753480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dexuan Cui <decui@microsoft.com>

commit 2e2a83b4998af4384e677d3b2ac08565274279bf upstream.

Validate the packet length reported in the RX CQE before passing it
to skb processing. The CQE is supplied by the NIC device and should
not be blindly trusted.

Cc: stable@vger.kernel.org
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dexuan Cui <decui@microsoft.com>
Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Link: https://patch.msgid.link/20260702041237.617719-2-decui@microsoft.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2182,12 +2182,25 @@ static void mana_process_rx_cqe(struct m
 		rxbuf_oob = &rxq->rx_oobs[curr];
 		WARN_ON_ONCE(rxbuf_oob->wqe_inf.wqe_size_in_bu != 1);
 
-		mana_refill_rx_oob(dev, rxq, rxbuf_oob, &old_buf, &old_fp);
+		if (unlikely(pktlen > rxq->datasize)) {
+			/* Increase it even if mana_rx_skb() isn't called. */
+			rxq->rx_cq.work_done++;
 
-		/* Unsuccessful refill will have old_buf == NULL.
-		 * In this case, mana_rx_skb() will drop the packet.
-		 */
-		mana_rx_skb(old_buf, old_fp, oob, rxq, i);
+			++ndev->stats.rx_dropped;
+			netdev_warn_once(ndev,
+				"Dropped oversized RX packet: len=%u, datasize=%u\n",
+				pktlen, rxq->datasize);
+
+			/* Reuse the RX buffer since rxbuf_oob is unchanged. */
+		} else {
+
+			mana_refill_rx_oob(dev, rxq, rxbuf_oob, &old_buf, &old_fp);
+
+			/* Unsuccessful refill will have old_buf == NULL.
+			 * In this case, mana_rx_skb() will drop the packet.
+			 */
+			mana_rx_skb(old_buf, old_fp, oob, rxq, i);
+		}
 
 		mana_move_wq_tail(rxq->gdma_rq,
 				  rxbuf_oob->wqe_inf.wqe_size_in_bu);


