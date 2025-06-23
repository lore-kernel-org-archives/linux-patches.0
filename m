Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 285D3222571;
	Mon, 23 Jun 2025 21:26:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713989; cv=none; b=B0sbGQEGvTJjn3Ykps97H7QxdJm4xrpI5rFavT12pLnBEUiEGxNt3FAhB/Px8cRc3Lnv7de0Nr5q6AYGqQNfPF+YqgShsEDU7BHxXtk2AWDRntRW+CMWMSK0UWMMGNLsaYISK9kJhLIri53l2vNFQ3JiJN3I6JO4PoXIjWkoj3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713989; c=relaxed/simple;
	bh=o5LReWh77fLLb8yniY+Doik4tZMgVVWgk05N27z4Bmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieV0cvmOga/2ucTB2WF2APWfjoSChFYdLP3oU5EENNmewsyrYZOO18lDvGM4YIeIuZEb8NBeCcUCyO36n5anCa94o8fDz6evklQT/pLC454qmhFXxOo04ymngFVUqOwL8GghCrQdzRpaG935pf4C7oQ7TOqKZgTbzc1awYhUBKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWkcqoD5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWkcqoD5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B5FC4CEEA;
	Mon, 23 Jun 2025 21:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713989;
	bh=o5LReWh77fLLb8yniY+Doik4tZMgVVWgk05N27z4Bmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RWkcqoD5k6u8WfIlSXeQzuZFBmKRk3/Bx4DpIx2N+jtXZZKj2kt5KiNfEwK2E82OW
	 t1V5qXMK0IRqiI82Ryr7DkdQ5woNdHyXeb99k8YZ2U9wylXb1ttXWG5hKjdGY3FI8B
	 d4pP8WfCH3nrNjJ6ge9yhgK6IZH9M3bu1VUUp0vY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 357/592] net: stmmac: generate software timestamp just before the doorbell
Date: Mon, 23 Jun 2025 15:05:15 +0200
Message-ID: <20250623130708.934194404@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 33d4cc81fcd930fdbcca7ac9e8959225cbec0a5e ]

Make sure the call of skb_tx_timestamp is as close as possbile to the
doorbell.

The patch also adjusts the order of setting SKBTX_IN_PROGRESS and
generate software timestamp so that without SOF_TIMESTAMPING_OPT_TX_SWHW
being set the software and hardware timestamps will not appear in the
error queue of socket nearly at the same time (Please see __skb_tstamp_tx()).

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Link: https://patch.msgid.link/20250510134812.48199-4-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 3a049a158ea11..1d716cee0cb10 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4493,8 +4493,6 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (priv->sarc_type)
 		stmmac_set_desc_sarc(priv, first, priv->sarc_type);
 
-	skb_tx_timestamp(skb);
-
 	if (unlikely((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
 		     priv->hwts_tx_en)) {
 		/* declare that device is doing timestamping */
@@ -4527,6 +4525,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	netdev_tx_sent_queue(netdev_get_tx_queue(dev, queue), skb->len);
+	skb_tx_timestamp(skb);
 
 	stmmac_flush_tx_descriptors(priv, queue);
 	stmmac_tx_timer_arm(priv, queue);
@@ -4770,8 +4769,6 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (priv->sarc_type)
 		stmmac_set_desc_sarc(priv, first, priv->sarc_type);
 
-	skb_tx_timestamp(skb);
-
 	/* Ready to fill the first descriptor and set the OWN bit w/o any
 	 * problems because all the descriptors are actually ready to be
 	 * passed to the DMA engine.
@@ -4818,7 +4815,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	netdev_tx_sent_queue(netdev_get_tx_queue(dev, queue), skb->len);
 
 	stmmac_enable_dma_transmission(priv, priv->ioaddr, queue);
-
+	skb_tx_timestamp(skb);
 	stmmac_flush_tx_descriptors(priv, queue);
 	stmmac_tx_timer_arm(priv, queue);
 
-- 
2.39.5



