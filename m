Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A49615DBA7;
	Mon, 29 Jan 2024 17:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548430; cv=none; b=cqsp9eQww22GdGv49sihKsF2BbdJ0OH+s11j9V7Rw33n9E5M94TObfnamOrhbEk9aSpDnk0r/iJJYgWjQSgYKDAk2R0iBAAno5RJhXPTjKRyEhUMOQp+338cJbZHyn93wS4OZJaElj4+8/ukceC416WGZWBsywpGB4iPMlnJgXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548430; c=relaxed/simple;
	bh=IiTTX3OmTFXF+C5o9OjIpJGUPDZJU7zM5YKrC3z3E/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZtTQ6qcnQgOtrAwQxC1seCgUOEWWUGcqYwmQ4e4k0HvhS9VciYFVOxgGf+HUKTEbc770397wlEWolqHqEM2PZTjvNKgbpiFd78JY2Xk+KvqwqorKH/3OVYBSrFPcnItJKYLlk/psjG8ph5LoT/FcYCM6q9FzEJLYNwFHVfb7sOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r8Ydp+VH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r8Ydp+VH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E791C433F1;
	Mon, 29 Jan 2024 17:13:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548430;
	bh=IiTTX3OmTFXF+C5o9OjIpJGUPDZJU7zM5YKrC3z3E/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r8Ydp+VHzItF5RxgRZRQgIWzVTjVwowct/2P89YtWbadYfTlEF/+ij9bi7ypqdsJc
	 GJnxfSKhnDP32vG/bY7Wi9xO7Yr/Fp6CSMx0gD7E44/E9as2BsIwslkotECQjNZbse
	 A1tPw1SvrmSrzNbCYHB+ecHnx/IXGsFsFFeiBk78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 008/331] net: stmmac: Tx coe sw fallback
Date: Mon, 29 Jan 2024 09:01:12 -0800
Message-ID: <20240129170015.205472340@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

From: Rohan G Thomas <rohan.g.thomas@intel.com>

[ Upstream commit 8452a05b2c633b708dbe3e742f71b24bf21fe42d ]

Add sw fallback of tx checksum calculation for those tx queues that
don't support tx checksum offloading. DW xGMAC IP can be synthesized
such that it can support tx checksum offloading only for a few
initial tx queues. Also as Serge pointed out, for the DW QoS IP, tx
coe can be individually configured for each tx queue.

So when tx coe is enabled, for any tx queue that doesn't support
tx coe with 'coe-unsupported' flag set will have a sw fallback
happen in the driver for tx checksum calculation when any packets to
be transmitted on these tx queues.

Signed-off-by: Rohan G Thomas <rohan.g.thomas@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: c2945c435c99 ("net: stmmac: Prevent DSA tags from breaking COE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c     | 10 ++++++++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c |  3 +++
 include/linux/stmmac.h                                |  1 +
 3 files changed, 14 insertions(+)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 1bfcf673b3ce..59e07efe08c9 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4417,6 +4417,16 @@ static netdev_tx_t stmmac_xmit(struct sk_buff *skb, struct net_device *dev)
 	WARN_ON(tx_q->tx_skbuff[first_entry]);
 
 	csum_insertion = (skb->ip_summed == CHECKSUM_PARTIAL);
+	/* DWMAC IPs can be synthesized to support tx coe only for a few tx
+	 * queues. In that case, checksum offloading for those queues that don't
+	 * support tx coe needs to fallback to software checksum calculation.
+	 */
+	if (csum_insertion &&
+	    priv->plat->tx_queues_cfg[queue].coe_unsupported) {
+		if (unlikely(skb_checksum_help(skb)))
+			goto dma_map_err;
+		csum_insertion = !csum_insertion;
+	}
 
 	if (likely(priv->extend_desc))
 		desc = (struct dma_desc *)(tx_q->dma_etx + entry);
diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
index 2f0678f15fb7..30d5e635190e 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_platform.c
@@ -276,6 +276,9 @@ static int stmmac_mtl_setup(struct platform_device *pdev,
 			plat->tx_queues_cfg[queue].use_prio = true;
 		}
 
+		plat->tx_queues_cfg[queue].coe_unsupported =
+			of_property_read_bool(q_node, "snps,coe-unsupported");
+
 		queue++;
 	}
 	if (queue != plat->tx_queues_to_use) {
diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index e3f7ee169c08..5acb77968902 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -139,6 +139,7 @@ struct stmmac_rxq_cfg {
 
 struct stmmac_txq_cfg {
 	u32 weight;
+	bool coe_unsupported;
 	u8 mode_to_use;
 	/* Credit Base Shaper parameters */
 	u32 send_slope;
-- 
2.43.0



