Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 026954C74;
	Mon, 23 Jun 2025 22:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716130; cv=none; b=eOsllXcrTJzHVmJ1BL43mY1xd4O8UnzUYs96RigSUwevkb8Kx0o50Lxgq5km+m5H/PeV+XVWztQgvYGQgeUgaPQAX7gFd6E3UYgI3/Iq5UAOEWoIBD0UiqyTkavSi8+1yV3socgR/0NGf+i04uuqXImNXlMduHbMLZlcNEpr+NM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716130; c=relaxed/simple;
	bh=7I6aBsWliRGGTjGq92XHTexLctLxeMyKcMR0SdihF3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoGp+CBAVJOlkoNgBQkkOkyu8iZuQ4svJ/FZ/CUXGLAaUIQW/5GrgaAW4MBNxyVDNcB7cjAtR3bTP1UVP2TUGH5l80/FDhpwc1J9IqpqI2fmIemXjj9R97H8UBqw4k9wtGNH8OM0GRS9H4tTBkYsGyXT+6Fs6Z88C5KCSf2at0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGGBg4Vx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGGBg4Vx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F368C4CEEA;
	Mon, 23 Jun 2025 22:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716129;
	bh=7I6aBsWliRGGTjGq92XHTexLctLxeMyKcMR0SdihF3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGGBg4Vx3quzmAZIuEY+jR/5JRQ97qgUGY5f8lnzzQREcppU5FVNCwfyh+UHsbWLJ
	 AtzbqJfTcVTlc6lWEyvcdpY8zSdi4MkSi9uVFGt3ImpvfMCnWXSG7xa5ZMiL/EG/cW
	 wGFP0oyI1Zeu5XMBm7RNvBIq9tk3cXkjV5xXciGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Xing <kernelxing@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 229/414] net: stmmac: generate software timestamp just before the doorbell
Date: Mon, 23 Jun 2025 15:06:06 +0200
Message-ID: <20250623130647.761954801@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f68e3ece919cc..0250c5cb28ff2 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4424,8 +4424,6 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (priv->sarc_type)
 		stmmac_set_desc_sarc(priv, first, priv->sarc_type);
 
-	skb_tx_timestamp(skb);
-
 	if (unlikely((skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP) &&
 		     priv->hwts_tx_en)) {
 		/* declare that device is doing timestamping */
@@ -4460,6 +4458,7 @@ static netdev_tx_t stmmac_tso_xmit(struct sk_buff *skb, struct net_device *dev)
 	}
 
 	netdev_tx_sent_queue(netdev_get_tx_queue(dev, queue), skb->len);
+	skb_tx_timestamp(skb);
 
 	stmmac_flush_tx_descriptors(priv, queue);
 	stmmac_tx_timer_arm(priv, queue);
@@ -4703,8 +4702,6 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (priv->sarc_type)
 		stmmac_set_desc_sarc(priv, first, priv->sarc_type);
 
-	skb_tx_timestamp(skb);
-
 	/* Ready to fill the first descriptor and set the OWN bit w/o any
 	 * problems because all the descriptors are actually ready to be
 	 * passed to the DMA engine.
@@ -4751,7 +4748,7 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	netdev_tx_sent_queue(netdev_get_tx_queue(dev, queue), skb->len);
 
 	stmmac_enable_dma_transmission(priv, priv->ioaddr, queue);
-
+	skb_tx_timestamp(skb);
 	stmmac_flush_tx_descriptors(priv, queue);
 	stmmac_tx_timer_arm(priv, queue);
 
-- 
2.39.5



