Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622283;
	b=ErcF6OMgjiCvR75d+0KviJgrHU3QXKbhJNR3+/wUia1nJPmL2YYj9T0Hw8xn3BxyPkyy
	 m6/ThUpp+2k1jtdM+eoxuqF5vqvBXYgov1mJAeKncWxITNVtSc1OxVNuUk4wmICFWiCds
	 dSMKq0j/1IjWh1pkt2mLDo8nsPN8E/zKaGyUCdTfsrMrZSAnLCwm/kHLcGP3CkEkcI3mi
	 Iv496NMvq4Bru7OkzhDcdhCq9PEQEl7yVpBP40kCSuQwecr7LTm/ltYRGAFLrDWqYnoVr
	 BWDBJfejK9VLzwKpc/0tUMmFLlIQly0EIz0Eg6zONJM/VHebk4NFc9uPv2yUzE+s8lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kL+AIRUg60+R63jFMYcBam7SUM7PjxNQClOJdxS/VkU=;
	b=GscIXMZ485XuB7tq9o3pXt9Y0zyjn/Xtkkmeozq6O3S7+Fs5U5Jse5P2Dwq+XZU/DsNw
	 YbZ+8b7ks1zSfQbk8yhbFMoqjEawow0Vwwqx5C116YrbUVADA8VwE8q8/CBcISFNmMwcf
	 e7k9ALT3bKbEC54cQDRqBSMXjCBHZH7gND5WZzE+bl72ZGBnAmFTHe8NznZCBgwHBfDni
	 6XuTMFk5EmiAdqbfYYj4v1YoukGwBoQMPusxvGN6aema/z3Dd5mQPGpOjxKt2XcSCDasz
	 +BEp0LA3v52Tq9yG1Z++v2TNczoDtetsdEyU3+Fmmhdl+CoNDaCAN6NMy8ph5++9KLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vdctAhNg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E91AD606A31E;
	Wed, 25 Nov 2026 15:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vdctAhNg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7162B1F000C6;
	Wed, 25 Nov 2026 15:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622282;
	bh=kL+AIRUg60+R63jFMYcBam7SUM7PjxNQClOJdxS/VkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vdctAhNg4uDNhq841oh7eHJy1t4MGt3qoITDnR+lKE/RTjOtq6iZE8GZ0x8Lq0rPq
	 TJgTZd7N7OreNLkV9bu8PJOQwZGMDx2ZmJnU0s9cP27g/C9yMT5AVqI1x0pknT7x3J
	 1nYkr1BZtqUySeWE92AJkx/jywux1XIJivwKYNhQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avi Weiss <thnkslprpt@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 451/990] net: ena: avoid RX copybreak for multi-descriptor packets
Date: Wed, 25 Nov 2026 15:30:18 +0100
Message-ID: <20261125143832.657301370@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 61bac152cf99a..f5b738ddb49ea 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -986,7 +986,7 @@ static struct sk_buff *ena_rx_skb(struct ena_ring *rx_ring,
 	page_offset = rx_info->page_offset;
 	buf_addr = page_address(rx_info->page) + page_offset;
 
-	if (len <= rx_ring->rx_copybreak) {
+	if (len <= rx_ring->rx_copybreak && likely(descs == 1)) {
 		skb = ena_alloc_skb(rx_ring, NULL, len);
 		if (unlikely(!skb))
 			return NULL;
@@ -1293,7 +1293,8 @@ static int ena_clean_rx_irq(struct ena_ring *rx_ring, struct napi_struct *napi,
 
 		skb_record_rx_queue(skb, rx_ring->qid);
 
-		if (rx_ring->ena_bufs[0].len <= rx_ring->rx_copybreak)
+		if (rx_ring->ena_bufs[0].len <= rx_ring->rx_copybreak &&
+		    ena_rx_ctx.descs == 1)
 			rx_copybreak_pkt++;
 
 		total_len += skb->len;
-- 
2.53.0



