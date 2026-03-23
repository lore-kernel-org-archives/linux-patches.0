Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BC7E2737EB;
	Mon, 23 Mar 2026 14:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277894; cv=none; b=dbhHJApUNEbAOoJZC1hjD5gbuLI88SSXLDZlcf6dtzDIXFRG3td+ElBGbhyTqqU97u3pPhFiqQy9RbjqkwyTAiQ0ZRhPQaFXx+d7RA/nQhjUbUCqVhFlPrBSWHDXo+O+aZz3D2mY0eh3FOW86kQqDcBYCw09TenY0a8Q3f5x4F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277894; c=relaxed/simple;
	bh=k6Tdl9uHpupp8pD2Zk6lgVOuf+J0Ngt/ZUMNXD+sryA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i4xr/8kxTLUjUKcNXVCQjRq+2D/qFuv41uTXekgLVtMNIIu371Hjt5hy69CZlujAtTGr2KTDdBihMXYtK2/wETclEruoXrCD5wpaqZgaPOlVjd8Zt3hgh6Ru44l0muF0WlJEGqa1CfN98g92hLW9oK57gnmdnsJ8dPmi3c+wOlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kH3hin8M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kH3hin8M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5B82C4CEF7;
	Mon, 23 Mar 2026 14:58:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277894;
	bh=k6Tdl9uHpupp8pD2Zk6lgVOuf+J0Ngt/ZUMNXD+sryA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kH3hin8MgQRCJA1ammJUMfoDsV8BkhF2OqhfHvLKXkXmzrPXSwCSPxvm15Ka8BIMm
	 7Va0l/RBwqMu171P+VSQARi1b99worPGJqw+ZfoeeDdkloDzoceS5B6cexLOlZtnd9
	 D3xmfdfmLA708KIAXg3bV74R05QRJ9+OHExKJfZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chintan Vankar <c-vankar@ti.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 134/567] net: ethernet: ti: am65-cpsw-nuss/cpsw-ale: Fix multicast entry handling in ALE table
Date: Mon, 23 Mar 2026 14:40:54 +0100
Message-ID: <20260323134537.122772129@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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
index 28cc23736a69b..93cb4193cf0ac 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -261,7 +261,7 @@ static void am65_cpsw_nuss_ndo_slave_set_rx_mode(struct net_device *ndev)
 	cpsw_ale_set_allmulti(common->ale,
 			      ndev->flags & IFF_ALLMULTI, port->port_id);
 
-	port_mask = ALE_PORT_HOST;
+	port_mask = BIT(port->port_id) | ALE_PORT_HOST;
 	/* Clear all mcast from ALE */
 	cpsw_ale_flush_multicast(common->ale, port_mask, -1);
 
diff --git a/drivers/net/ethernet/ti/cpsw_ale.c b/drivers/net/ethernet/ti/cpsw_ale.c
index 9eccc7064c2b0..bf0b2950272cf 100644
--- a/drivers/net/ethernet/ti/cpsw_ale.c
+++ b/drivers/net/ethernet/ti/cpsw_ale.c
@@ -422,14 +422,13 @@ static void cpsw_ale_flush_mcast(struct cpsw_ale *ale, u32 *ale_entry,
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



