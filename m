Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624916;
	b=pko2b1tlDani02yG6CVJv8SngsV9fXdVxtM5Og3hCz/sX3r/YgqhTGLlu6Kl69dUO2D4
	 QOoS5DB+LnCQpOvPFdV2XDDKWsFpz+MmwmCiJW/parFLMJJxXjLYKghkniRuU3cGlXQvr
	 Qr+CBwCboVhjRzSIIeqSN0esa3CAbgqXFDkG9I+nYpNWn+2Ahn/WO14GfK6xWjhn1vqHZ
	 Jf8gI+uG28Ecqq57HDXwOPsK1HZvmi5Kp9nOTYVRQBMujMvTeaxReR3tXhjmtyj+XFQmU
	 +rETRfEw5cD2sQvbqb+LuH17hUVzqUpvwr4kE6pPyjFIPtjtr6UE6khqkyMT1abpKmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624916;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IClsKyI8YjbyX4qkmQ2qM4o7zyGAKKG97KfhZQkDphM=;
	b=BvBrqFnmqm8PO31+w17dTdvKGN6hfdaad7ujAqAYqviO6stJnU5690ExB9XAJfjpfON3
	 +SA5LzcPy6KoEee9NV6ckL7NGmJqqlgR34cq8PtEDX/YFeeXraqZhJtsZXPLjlEN748sd
	 lWJTW5Su5uiEMhwQJGikz6sh9ddKpJA4iCyqckCGl5XvdoEtrOi1aYTvxxFMVkldKm/5O
	 G90PbCyGNV9pahHw7xtQvD5OFaX/mu4LiBrWWVsMaxlk5ZA1+2QLvrqxmFrD0oAq1bf6W
	 Yyr1sHmbVmYD5smqyPBvIPpQxOk4AtxvpYCtJVA+wX+4N0SsZZ0XxTotHXAe49d96EA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="N22tZ/61";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8579606A31E;
	Wed, 25 Nov 2026 16:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=N22tZ/61
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14151F000CA;
	Wed, 25 Nov 2026 16:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624916;
	bh=IClsKyI8YjbyX4qkmQ2qM4o7zyGAKKG97KfhZQkDphM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N22tZ/61wdIMfKkWzqZePMtBIIuZ69oqBCtnD+T4rUs1xcgigntiQLhgV2Koqyeji
	 54Ej0LpQ69l6mEQjx0d7VRFXMgx9T5x/HxcL6vmM+rVo0wO5dTaq5RwurGr0vOiDNm
	 7akLu39j0nC7774zSWpULuKhlW/fygRlzcpADMGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 347/816] net: ena: avoid RX copybreak for multi-descriptor packets
Date: Wed, 25 Nov 2026 15:31:35 +0100
Message-ID: <20261125143857.230077467@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Weiss <thnkslprpt@gmail.com>

[ Upstream commit f3c790c34d228d46c4a05fe5d001d1bbea444e2b ]

ena_rx_skb() selects the copybreak path based on the first RX
descriptor's length without checking the number of descriptors. When
a packet spans multiple descriptors, this copies only the first
buffer into the skb and fails to recycle the remaining request IDs,
while RX cleanup advances by the full descriptor count.

Restrict copybreak to single-descriptor packets and apply the same
restriction to the rx_copybreak_pkt statistic. Multi-descriptor
packets then use the existing fragment-processing path.

Discovered by comparing the in-tree ENA driver with Amazon's
standalone ENA driver.

Compiled with W=1 under x86_64 defconfig.

Fixes: 1738cd3ed342 ("net: ena: Add a driver for Amazon Elastic Network Adapters (ENA)")
Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Link: https://patch.msgid.link/20261109141343.920187-2-thnkslprpt@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index 729fd2b12c63e..6253b86c52779 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -1009,7 +1009,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 	page_offset = rx_info->page_offset;
 	buf_addr = page_address(rx_info->page) + page_offset;
 
-	if (len <= rx_ring->rx_copybreak) {
+	if (len <= rx_ring->rx_copybreak && likely(descs == 1)) {
 		skb = ena_alloc_skb(rx_ring, NULL, len);
 		if (unlikely(!skb))
 			return NULL;
@@ -1316,7 +1316,8 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 
 		skb_record_rx_queue(skb, rx_ring->qid);
 
-		if (rx_ring->ena_bufs[0].len <= rx_ring->rx_copybreak)
+		if (rx_ring->ena_bufs[0].len <= rx_ring->rx_copybreak &&
+		    ena_rx_ctx.descs == 1)
 			rx_copybreak_pkt++;
 
 		total_len += skb->len;
-- 
2.53.0



