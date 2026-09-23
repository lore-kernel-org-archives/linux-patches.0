Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2015F530DE2;
	Wed, 23 Sep 2026 14:20:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173234; cv=none; b=fc7xMVGH5IIHRYZ0fj93P6+ypUxkabMc3Cx8GG1bMMkj/i26OsGN9V51NnLtzL++a+lPPsKZj7edjoUNMTyqohW8wLMg8jtSCIr71yv0BhyYMSRUmpDYeY/+vm+W4Ff0oSPrj8JxWal6xssIQl8MgrY3phHF1aNum2PFwEvkLvE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173234; c=relaxed/simple;
	bh=B7yEzyFFbdglZazCdrainufqljMJwkO3DrDI5FBOoSc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rj+4TWeFLOv3/E7uofkUslJvMPFXZ1cYLsQEjKblvmZg1NGz4qbsUYoASua8r+a8sizlz4AEJWMDYo5bCHrgjOkdo5HRm/sAZrYFicidWEGV+CECwnKcIwa0TF99Ptt7eyK+BxWPJd83J2QkCkZYm2FNXkV7i2vRlS7IEkVW4OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7EWKWgm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7EWKWgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47F231F000FF;
	Wed, 23 Sep 2026 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173232;
	bh=fT2retH02UCs8DdQhyVt2571S/UIoKi6UpuRXzOxh70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T7EWKWgmlxqXb7HCCfPo8L8P/hlcjPGClU3RiKujPQgvgYb3elvM5UOHFgs6vky5m
	 PB9mPjTaqN9HnMK1WRLjKBAXrT99wrmDkdesgi4bUujuKCCVkSlEoxqGGVVHt7kJlY
	 nacxDmMjlpnJOdk/+zcfGqqs0W5J7MHEFIhyqalY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 181/438] net: stmmac: fix TSO header length truncation
Date: Wed, 23 Sep 2026 16:03:22 +0200
Message-ID: <20260923140649.458801710@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>

[ Upstream commit 15989abd74f16f44bf953d056b95f1d2fda9b0cd ]

stmmac_tso_xmit() stores the protocol header length returned by
stmmac_tso_header_size() in a u8. stmmac_tso_valid_packet() admits
headers up to 1023 bytes, so a header longer than 255 bytes wraps modulo
256 (486 becomes 230, 256 becomes 0).

A TCP over IPv6 socket carrying a few hundred bytes of sticky
destination/hop-by-hop options makes skb_tcp_all_headers() exceed 255
while staying below the 1023-byte limit, so such an skb reaches
stmmac_tso_xmit().

Widen proto_hdr_len to unsigned int, which is sufficient since the value
is bounded by the hardware limit, and adjust the debug print specifier
accordingly.

Fixes: 9edfa7dab811 ("net: stmmac: enable TSO for IPv6")
Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@oss.qualcomm.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20260911-stmmac-fix-header-length-v1-1-8fc103334327@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index f801caf65fff1..5f717f02c3c01 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4513,16 +4513,16 @@ static int stmmac_tso_get_num_desc(struct stmmac_tx_queue *tx_q,
  */
 static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 {
+	unsigned int first_entry, entry, tx_packets, proto_hdr_len;
 	struct dma_desc *desc, *first, *mss_desc = NULL;
 	struct stmmac_priv *priv = netdev_priv(dev);
-	unsigned int first_entry, entry, tx_packets;
 	struct stmmac_txq_stats *txq_stats;
 	int i, first_tx, nfrags, ndesc;
 	struct stmmac_tx_queue *tx_q;
 	bool set_ic, is_last_segment;
 	u32 pay_len, mss, queue;
-	u8 proto_hdr_len, hdr;
 	dma_addr_t des;
+	u8 hdr;
 
 	nfrags = skb_shinfo(skb)->nr_frags;
 	queue = skb_get_queue_mapping(skb);
@@ -4570,7 +4570,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	if (netif_msg_tx_queued(priv)) {
-		pr_info("%s: hdrlen %d, hdr_len %d, pay_len %d, mss %d\n",
+		pr_info("%s: hdrlen %d, hdr_len %u, pay_len %d, mss %d\n",
 			__func__, hdr, proto_hdr_len, pay_len, mss);
 		pr_info("\tskb->len %d, skb->data_len %d\n", skb->len,
 			skb->data_len);
-- 
2.53.0



