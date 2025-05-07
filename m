Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4309729A0;
	Wed,  7 May 2025 18:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643638; cv=none; b=mxWvGnrFtwpWFZB0xtfUFcgm1kjb8N3nm7cd5a9tfLye17gioxdYXNgHXGS4OmgzZcxe30DNv3MSBEyqySzNDHxtWcYHsu8t4FZCp1qzksT6crl6SX8D3hlS4dgQZina+mnxkDOvicgT2z381KhKodACYyfUC+wDN1e1hFPpoOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643638; c=relaxed/simple;
	bh=G690tvvv2yhWktKexfRkltwL5Z7hH++Vd7o0z4d+N8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfPaMiWphoKnAdZO+A6CWnfRM1gHqzTBP9topzDpYFKsM9ZbR3VdEu4HOPis9QXpQf8LTx3BgwF4gP/aMjoiWIv9qG12AcX6saT9olatU3qB9LJ16Qo7QAsi/Q6xmu+SgOOQMcih8jU7IGzeIr2MAyIHmcn87UMXFhQ6FIDzOrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vcVyNNvm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vcVyNNvm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7BAC4CEE2;
	Wed,  7 May 2025 18:47:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643637;
	bh=G690tvvv2yhWktKexfRkltwL5Z7hH++Vd7o0z4d+N8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vcVyNNvmZZI8o8qh/Bg61jQ2mn4WELinpnvJM0bjIfmrnYtvOFVwHLRcysd/Z6dy6
	 xed1FZ1QFpjtiVFZAYnTuEaPVgVklzMAOFpf2xHl60kzzJ92RhFy+eZXtY8ZhGyxNZ
	 aHh5jbILoYAwL93nUwgGpfyuj9irYUJTwi9doRT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 68/97] net: vertexcom: mse102x: Fix possible stuck of SPI interrupt
Date: Wed,  7 May 2025 20:39:43 +0200
Message-ID: <20250507183809.730568742@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183806.987408728@linuxfoundation.org>
References: <20250507183806.987408728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit 55f362885951b2d00fd7fbb02ef0227deea572c2 ]

The MSE102x doesn't provide any SPI commands for interrupt handling.
So in case the interrupt fired before the driver requests the IRQ,
the interrupt will never fire again. In order to fix this always poll
for pending packets after opening the interface.

Fixes: 2f207cbf0dd4 ("net: vertexcom: Add MSE102x SPI support")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250430133043.7722-2-wahrenst@gmx.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/vertexcom/mse102x.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/vertexcom/mse102x.c b/drivers/net/ethernet/vertexcom/mse102x.c
index 8f67c39f479ee..45f4d2cb5b31a 100644
--- a/drivers/net/ethernet/vertexcom/mse102x.c
+++ b/drivers/net/ethernet/vertexcom/mse102x.c
@@ -509,6 +509,7 @@ static irqreturn_t mse102x_irq(int irq, void *_mse)
 static int mse102x_net_open(struct net_device *ndev)
 {
 	struct mse102x_net *mse = netdev_priv(ndev);
+	struct mse102x_net_spi *mses = to_mse102x_spi(mse);
 	int ret;
 
 	ret = request_threaded_irq(ndev->irq, NULL, mse102x_irq, IRQF_ONESHOT,
@@ -524,6 +525,13 @@ static int mse102x_net_open(struct net_device *ndev)
 
 	netif_carrier_on(ndev);
 
+	/* The SPI interrupt can stuck in case of pending packet(s).
+	 * So poll for possible packet(s) to re-arm the interrupt.
+	 */
+	mutex_lock(&mses->lock);
+	mse102x_rx_pkt_spi(mse);
+	mutex_unlock(&mses->lock);
+
 	netif_dbg(mse, ifup, ndev, "network device up\n");
 
 	return 0;
-- 
2.39.5



