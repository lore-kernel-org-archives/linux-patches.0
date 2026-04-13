Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2D62E2850;
	Mon, 13 Apr 2026 16:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098696; cv=none; b=e1RhXOIZ9omYaoiAPo8n57RXFGNJRsRsXUMZfIkgBk8Kn9/p9K0o+iObXlVrEBzLlO9zYX3cWDedZOWU/Wpoeb+scDNaXfhQrkCzRfKA5abKBGQBzMQ5Lff/VHI5HPbNIMWOGmDj7GbvpnOw3Qbs1HyoUvEd6cVchdFiCf7a4nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098696; c=relaxed/simple;
	bh=UbWa89KLVpLdu3bnuwmEgM+Pb/JCsojmUpQkCfoqeTs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tdPnDIlFIiXohsdeiXYDtt9ytpGnTyl2uywHySvw8V9T7DnA3wVyiY6ZxSLhgGVG2tBRQVoPXWee+WriECZNFTbIHo5OU2f793KfoQqkLETLqFM3vlpduUhiWHmEN4k6mCmOroaO5aYWUWp4SwYX1spYB3+g8DPq9Uex8jsJCuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AugTNrid; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AugTNrid"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705A3C2BCAF;
	Mon, 13 Apr 2026 16:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098696;
	bh=UbWa89KLVpLdu3bnuwmEgM+Pb/JCsojmUpQkCfoqeTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AugTNridrnPem65Qoku8Od0A/qoL3+t9ncI1+4n3o/9OpkLwL7EJDG+0OTmm7uR2U
	 Qjub+C9tcJhHtV0X6bjaPOkU/6SDlVOKzBUXrXI4X7/aDzCl9x0Sya3GNBWiFJQG2a
	 XYpxEzNZL5WuJIN2yqDjIrJKlQ7j/7/Rkwc1s2pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chintan Vankar <c-vankar@ti.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/491] net: ethernet: ti: am65-cpsw-nuss/cpsw-ale: Fix multicast entry handling in ALE table
Date: Mon, 13 Apr 2026 17:54:41 +0200
Message-ID: <20260413155820.405069530@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chintan Vankar <c-vankar@ti.com>

[ Upstream commit be11a537224d72b906db6b98510619770298c8a4 ]

In the current implementation, flushing multicast entries in MAC mode
incorrectly deletes entries for all ports instead of only the target port,
disrupting multicast traffic on other ports. The cause is adding multicast
entries by setting only host port bit, and not setting the MAC port bits.

Fix this by setting the MAC port's bit in the port mask while adding the
multicast entry. Also fix the flush logic to preserve the host port bit
during removal of MAC port and free ALE entries when mask contains only
host port.

Fixes: 5c50a856d550 ("drivers: net: ethernet: cpsw: add multicast address to ALE table")
Signed-off-by: Chintan Vankar <c-vankar@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260224181359.2055322-1-c-vankar@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 2 +-
 drivers/net/ethernet/ti/cpsw_ale.c       | 9 ++++-----
 2 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 07510e068742e..2dc3e5be1d717 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -305,7 +305,7 @@ static void am65_cpsw_nuss_ndo_slave_set_rx_mode(struct net_device *ndev)
 	cpsw_ale_set_allmulti(common->ale,
 			      ndev->flags & IFF_ALLMULTI, port->port_id);
 
-	port_mask = ALE_PORT_HOST;
+	port_mask = BIT(port->port_id) | ALE_PORT_HOST;
 	/* Clear all mcast from ALE */
 	cpsw_ale_flush_multicast(common->ale, port_mask, -1);
 
diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index bec6a68a973c4..eb4262017d235 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -420,14 +420,13 @@ static void cpsw_ale_flush_mcast(struct cpsw_ale *ale, u32 *ale_entry,
 				      ale->port_mask_bits);
 	if ((mask & port_mask) == 0)
 		return; /* ports dont intersect, not interested */
-	mask &= ~port_mask;
+	mask &= (~port_mask | ALE_PORT_HOST);
 
-	/* free if only remaining port is host port */
-	if (mask)
+	if (mask == 0x0 || mask == ALE_PORT_HOST)
+		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
+	else
 		cpsw_ale_set_port_mask(ale_entry, mask,
 				       ale->port_mask_bits);
-	else
-		cpsw_ale_set_entry_type(ale_entry, ALE_TYPE_FREE);
 }
 
 int cpsw_ale_flush_multicast(struct cpsw_ale *ale, int port_mask, int vid)
-- 
2.51.0



