Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F039E14A617;
	Mon,  6 Jan 2025 15:56:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179010; cv=none; b=KVkFD1wPglAzHtVVOHapPbwmPhkIdvgbR79ilxbIcfqPnSe49zX80Xu8ePckjEF6pVSFYEayxNmvcyOZOpwP5K/pSIISjFF8yb4a509pzdkJ2oGAvMtmQRBeOwa6VU2YnZ5nK/slLgVSGU/QLVSYSpl14EwEmyJdhPdUYo9ip1M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179010; c=relaxed/simple;
	bh=Oo8X2zoQB9K/gB4zrVUym79bTgI4iYBNB04L1/SCERE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhPYzXeRSFa9CKuDFLxnT6pq29V4JBEkAS+1MC5dtaXjs/L4PXszlAbtzTXlo5FElC5vqpuEk30rIAjiSkVhgxIn2V3O1rCzROgs45UsCw80LsJq5bFhnnqtGPMW/zl6MwG8KZU6k5kp3iSFVAp/IMkqHQxuVPxd16/Wat1vEfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HJWO16oZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HJWO16oZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77D55C4CED2;
	Mon,  6 Jan 2025 15:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179009;
	bh=Oo8X2zoQB9K/gB4zrVUym79bTgI4iYBNB04L1/SCERE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HJWO16oZa93UZ2ktKRsEvAxRtqYX81qg3zLo8ePtw1I+VijfvoF1v1xn35i9a8fIs
	 6UOyjlpgg23PE81kkEFKWQSq1HTTKhKDOefAjGl8mlBXzh5GDhE3MO/yJ2dCvaUZXJ
	 WAcS2E89xc9bDxZ7xSybxJ8NeKjuybqJPFTno+wg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 138/168] net: mv643xx_eth: fix an OF node reference leak
Date: Mon,  6 Jan 2025 16:17:26 +0100
Message-ID: <20250106151143.648604677@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit ad5c318086e2e23b577eca33559c5ebf89bc7eb9 ]

Current implementation of mv643xx_eth_shared_of_add_port() calls
of_parse_phandle(), but does not release the refcount on error. Call
of_node_put() in the error path and in mv643xx_eth_shared_of_remove().

This bug was found by an experimental verification tool that I am
developing.

Fixes: 76723bca2802 ("net: mv643xx_eth: add DT parsing support")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Link: https://patch.msgid.link/20241221081448.3313163-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/mv643xx_eth.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/mv643xx_eth.c b/drivers/net/ethernet/marvell/mv643xx_eth.c
index d37a0fba3d16..6174b4bd44d3 100644
--- a/drivers/net/ethernet/marvell/mv643xx_eth.c
+++ b/drivers/net/ethernet/marvell/mv643xx_eth.c
@@ -2703,9 +2703,15 @@ static struct platform_device *port_platdev[3];
 
 static void mv643xx_eth_shared_of_remove(void)
 {
+	struct mv643xx_eth_platform_data *pd;
 	int n;
 
 	for (n = 0; n < 3; n++) {
+		if (!port_platdev[n])
+			continue;
+		pd = dev_get_platdata(&port_platdev[n]->dev);
+		if (pd)
+			of_node_put(pd->phy_node);
 		platform_device_del(port_platdev[n]);
 		port_platdev[n] = NULL;
 	}
@@ -2766,8 +2772,10 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 	}
 
 	ppdev = platform_device_alloc(MV643XX_ETH_NAME, dev_num);
-	if (!ppdev)
-		return -ENOMEM;
+	if (!ppdev) {
+		ret = -ENOMEM;
+		goto put_err;
+	}
 	ppdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	ppdev->dev.of_node = pnp;
 
@@ -2789,6 +2797,8 @@ static int mv643xx_eth_shared_of_add_port(struct platform_device *pdev,
 
 port_err:
 	platform_device_put(ppdev);
+put_err:
+	of_node_put(ppd.phy_node);
 	return ret;
 }
 
-- 
2.39.5



