Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A4B1CAA95;
	Wed, 19 Feb 2025 08:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953929; cv=none; b=tJA+6xhpKHXOtxchpP9ktxqjzkHSwx6L8s/utWt0BJ85rNRMbZCmu9Y+A2W3qCTQVGIh6opz91ZRIHBm+D5iDMdZc9wthc5l2da0IHhhd7Q9teA58Ua/TDLLfTnmAiOr24HYUDl1AH5caYS0E03ydEQNiAI8jn0d7tln3t6QM6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953929; c=relaxed/simple;
	bh=G8sFoG/DMVtwBYHBJXdUavmsLPWsd1UQqIZXptvnIM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rUCnNgI/IqI5JPdXYekP98IgnscQoxh/7fLkbdt3kSRrjkTXWae+t3ZQEe4QghALgnPBAM07OwWBS8PjI1ym4otSRJrdC5xAnuWtLUOMJkQSDlchbUeFQgH8L/T63+jt7o8dT0tJo5AfYBumjOX4ebsrvq+q5ks9iuI+DTA6WiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WOtI9D6t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WOtI9D6t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B4DC4CED1;
	Wed, 19 Feb 2025 08:32:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953928;
	bh=G8sFoG/DMVtwBYHBJXdUavmsLPWsd1UQqIZXptvnIM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WOtI9D6tjsP0Ao0r72pQa/l4b2RHYkBKy7Cp3ytwqqn6Sh0TwhsvW4Hhkc3HExPNc
	 BMqxmQl+L1BKEB9dfrdQ9MQWei8Ef54H9t6mDfr0DsYdCJsHB3hOD0qeAMsLBqFtYn
	 UF2bjrnq9A/h9qmtef4SxcXEpZ3RkHiRT7BF9xL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Quadros <rogerq@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 034/274] net: ethernet: ti: am65-cpsw: fix RX & TX statistics for XDP_TX case
Date: Wed, 19 Feb 2025 09:24:48 +0100
Message-ID: <20250219082610.865288839@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@kernel.org>

[ Upstream commit 8a9f82ff15da03a6804cdd6557fb36ff71c0924f ]

For successful XDP_TX and XDP_REDIRECT cases, the packet was received
successfully so update RX statistics. Use original received
packet length for that.

TX packets statistics are incremented on TX completion so don't
update it while TX queueing.

If xdp_convert_buff_to_frame() fails, increment tx_dropped.

Signed-off-by: Roger Quadros <rogerq@kernel.org>
Fixes: 8acacc40f733 ("net: ethernet: ti: am65-cpsw: Add minimal XDP support")
Link: https://patch.msgid.link/20250210-am65-cpsw-xdp-fixes-v1-2-ec6b1f7f1aca@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 0bbbd4cb6fb5c..43a3f36f0d220 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1134,9 +1134,11 @@ static int am65_cpsw_run_xdp(struct am65_cpsw_rx_flow *flow,
 	struct xdp_frame *xdpf;
 	struct bpf_prog *prog;
 	struct page *page;
+	int pkt_len;
 	u32 act;
 	int err;
 
+	pkt_len = *len;
 	prog = READ_ONCE(port->xdp_prog);
 	if (!prog)
 		return AM65_CPSW_XDP_PASS;
@@ -1154,8 +1156,10 @@ static int am65_cpsw_run_xdp(struct am65_cpsw_rx_flow *flow,
 		netif_txq = netdev_get_tx_queue(ndev, tx_chn->id);
 
 		xdpf = xdp_convert_buff_to_frame(xdp);
-		if (unlikely(!xdpf))
+		if (unlikely(!xdpf)) {
+			ndev->stats.tx_dropped++;
 			goto drop;
+		}
 
 		__netif_tx_lock(netif_txq, cpu);
 		err = am65_cpsw_xdp_tx_frame(ndev, tx_chn, xdpf,
@@ -1164,14 +1168,14 @@ static int am65_cpsw_run_xdp(struct am65_cpsw_rx_flow *flow,
 		if (err)
 			goto drop;
 
-		dev_sw_netstats_tx_add(ndev, 1, *len);
+		dev_sw_netstats_rx_add(ndev, pkt_len);
 		ret = AM65_CPSW_XDP_CONSUMED;
 		goto out;
 	case XDP_REDIRECT:
 		if (unlikely(xdp_do_redirect(ndev, xdp, prog)))
 			goto drop;
 
-		dev_sw_netstats_rx_add(ndev, *len);
+		dev_sw_netstats_rx_add(ndev, pkt_len);
 		ret = AM65_CPSW_XDP_REDIRECT;
 		goto out;
 	default:
-- 
2.39.5



