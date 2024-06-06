Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C879E1A01A5;
	Thu,  6 Jun 2024 14:20:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683632; cv=none; b=EPwL3bT1L9UL7BiCSPfT7DGC4AasujvHrFEt67rumc46KDllUm0+lxvL1Biy9b5hcboMXynTLYzFZP4Ezw5C+XFnWZs/FkmAzX3gxipQ2dQrjXoHHiZfIxeTb8CUR0eZBE3GvlN2H+JDClNnhfnoRRsNu1+EdjPm+i+bSQCQLIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683632; c=relaxed/simple;
	bh=4BvJ3rcDHwSpuGZ5sb3lhnWSmGs36GYMuihfUAClvQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ry3N/eizN4TTg6jaIFqYCIz8NR8I2ATqouwdXPulmNi2xBAG0YNf9NGz1erpA0y6qE73Sd7oryks5jJ8K4vQhNBgaVJRFVpdHo+tZH8guzz3eoDO1FMqvjycsuXG6Fe2PC9RnI5gw5X2/xsLmVQYMvYUuWw437zTQPsmcr1S1Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hwjQkgu/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hwjQkgu/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693BBC32781;
	Thu,  6 Jun 2024 14:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683632;
	bh=4BvJ3rcDHwSpuGZ5sb3lhnWSmGs36GYMuihfUAClvQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hwjQkgu/IHsylm7ysLV+tMMTNqjrhfZbUjbZbiA9rwMeHOvsWUn9r4ZHQ2NSTV7G8
	 LouFTIWIy4Oy8+kxGLCKR4oftLFH5Fy8ZVfYOfbZQFzBjyIrF6kPXvb9/iXKY/E42X
	 OKjiGIbKQZSekBmYxDeA8SeUlBqfO49uaO4XMMrI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Wei Fang <wei.fang@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 453/473] net:fec: Add fec_enet_deinit()
Date: Thu,  6 Jun 2024 16:06:22 +0200
Message-ID: <20240606131714.675185456@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaolei Wang <xiaolei.wang@windriver.com>

[ Upstream commit bf0497f53c8535f99b72041529d3f7708a6e2c0d ]

When fec_probe() fails or fec_drv_remove() needs to release the
fec queue and remove a NAPI context, therefore add a function
corresponding to fec_enet_init() and call fec_enet_deinit() which
does the opposite to release memory and remove a NAPI context.

Fixes: 59d0f7465644 ("net: fec: init multi queue date structure")
Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
Reviewed-by: Wei Fang <wei.fang@nxp.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/20240524050528.4115581-1-xiaolei.wang@windriver.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/fec_main.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index ebff14b0837d9..0a3df468316e5 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3732,6 +3732,14 @@ static int fec_enet_init(struct net_device *ndev)
 	return ret;
 }
 
+static void fec_enet_deinit(struct net_device *ndev)
+{
+	struct fec_enet_private *fep = netdev_priv(ndev);
+
+	netif_napi_del(&fep->napi);
+	fec_enet_free_queue(ndev);
+}
+
 #ifdef CONFIG_OF
 static int fec_reset_phy(struct platform_device *pdev)
 {
@@ -4136,6 +4144,7 @@ fec_probe(struct platform_device *pdev)
 	fec_enet_mii_remove(fep);
 failed_mii_init:
 failed_irq:
+	fec_enet_deinit(ndev);
 failed_init:
 	fec_ptp_stop(pdev);
 failed_reset:
@@ -4199,6 +4208,7 @@ fec_drv_remove(struct platform_device *pdev)
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
+	fec_enet_deinit(ndev);
 	free_netdev(ndev);
 	return 0;
 }
-- 
2.43.0



