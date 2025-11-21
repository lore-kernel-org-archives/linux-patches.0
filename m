Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E61734D93E;
	Fri, 21 Nov 2025 13:42:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732539; cv=none; b=CGcQ5LVf7D+4QGAwfEfIFMR57K2SrrOCv3IFdj5Y+rS0/Ls7CSC2tCjsVscACTz4+wqgPV1xUA42s6udpnaW0uZ2CSwsKO3Exlqx51Oxi0g3v/T96/J8ZH6Idj6rSL0tf74uEB0i49MrElbEynrcATynwv3FCHv6wkwLwrCjSG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732539; c=relaxed/simple;
	bh=NZ22hQ+OVbEOz0m4FxXvJ2IEKfz+B2dVnTGJ1zBa4E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ugtbSVh9VapUcDcTRPeLtzQXxiAEcvgzgaEO6A5uCJ3JnDetVhyI+Vi4Ex4xHYr2BiLwt3T6f2D0KthbaIvyagCYInSdUigTf+8vPcIJJRlYl9ZuJ1CGx1vuBIWPMlHxykNYQufk4ur8cW/8H535nPer/SYvlT+ixGF+GZpVnlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuDcaFA9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuDcaFA9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0499C4CEF1;
	Fri, 21 Nov 2025 13:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732539;
	bh=NZ22hQ+OVbEOz0m4FxXvJ2IEKfz+B2dVnTGJ1zBa4E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OuDcaFA9HcK8Brq+ANG7NwbXlHVOCpLggUNjSKJJTPGMqYfOX3tEHYNqtqgphUy6W
	 KRAJR9LNcN3jVoGhGihUkFqrgHvquOO5NNBIkWADuPbdLnNZ0BWqMiJtDnaE11i+tb
	 RMBJMVUEZsdcJOz4S3GSSrgG//wBDu7NJZrPNWUs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 156/529] net: stmmac: Correctly handle Rx checksum offload errors
Date: Fri, 21 Nov 2025 14:07:35 +0100
Message-ID: <20251121130236.570670010@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit ee0aace5f844ef59335148875d05bec8764e71e8 ]

The stmmac_rx function would previously set skb->ip_summed to
CHECKSUM_UNNECESSARY if hardware checksum offload (CoE) was enabled
and the packet was of a known IP ethertype.

However, this logic failed to check if the hardware had actually
reported a checksum error. The hardware status, indicating a header or
payload checksum failure, was being ignored at this stage. This could
cause corrupt packets to be passed up the network stack as valid.

This patch corrects the logic by checking the `csum_none` status flag,
which is set when the hardware reports a checksum error. If this flag
is set, skb->ip_summed is now correctly set to CHECKSUM_NONE,
ensuring the kernel's network stack will perform its own validation and
properly handle the corrupt packet.

Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://patch.msgid.link/20250818090217.2789521-2-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
index 5096b70f82e1a..c5d08d042f223 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -5527,7 +5527,8 @@ static int stmmac_rx(struct stmmac_priv *priv, int limit, u32 queue)
 		stmmac_rx_vlan(priv->dev, skb);
 		skb->protocol = eth_type_trans(skb, priv->dev);
 
-		if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb))
+		if (unlikely(!coe) || !stmmac_has_ip_ethertype(skb) ||
+		    (status & csum_none))
 			skb_checksum_none_assert(skb);
 		else
 			skb->ip_summed = CHECKSUM_UNNECESSARY;
-- 
2.51.0



