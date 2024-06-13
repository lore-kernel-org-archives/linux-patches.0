Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91AEA17FD;
	Thu, 13 Jun 2024 12:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282640; cv=none; b=Tv0f6NhsgvVNkPwLSANHGUwg8RjUB/zXJOnb1lmT7b9AM0v9kUOPI1VrtEdklLuB76DomeEFAINDIUOx7lhN8uNWsGS84w53sbJSPTinMID21mrOFyu/xz6wamaplv6Z2kRUcMs9TRsHSXNU+DeHKqeE8iN1LMLe99/BttiCJtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282640; c=relaxed/simple;
	bh=AtBA0DwF/9ocoL3GSIz8g6plWA15RSEgKytU7G+GqcQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XGprE1MKiJyvvmzwQhNWGa6wZyKzEzZ91bnKbtW9MB8ElayUzTXnc4zLB9BNhUfiWhh+6484s+DKjcY+ltnF+eBNDvhckxi4eP0S/zPU5zHMTdpXyUsLk4FwR2U0xXyfBR2+9WCA8DO1JyLI4VstRxk5eg8ku1tEquGqgGAnz2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5LxF+KT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5LxF+KT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D280DC2BBFC;
	Thu, 13 Jun 2024 12:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282640;
	bh=AtBA0DwF/9ocoL3GSIz8g6plWA15RSEgKytU7G+GqcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5LxF+KTwR8FJmfdE8hdz7xohl+hKXlBn3FlspXVtSXY+s3tK07dKnPKVKtnrzs5T
	 TmtnVFFkZ2x4/HxtAo7dUUm/SHXm1t5FET2XFmDeSQ6iVdwqjcAOT5m/QtOzUFJ3Br
	 YFdbxzbKUO8Nh07SQC9xCmvcW/+ZHVmztpJ0i2S4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Wei Fang <wei.fang@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 318/402] net:fec: Add fec_enet_deinit()
Date: Thu, 13 Jun 2024 13:34:35 +0200
Message-ID: <20240613113314.544173065@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 972808777f308..f02376555ed45 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -3627,6 +3627,14 @@ static int fec_enet_init(struct net_device *ndev)
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
@@ -4023,6 +4031,7 @@ fec_probe(struct platform_device *pdev)
 	fec_enet_mii_remove(fep);
 failed_mii_init:
 failed_irq:
+	fec_enet_deinit(ndev);
 failed_init:
 	fec_ptp_stop(pdev);
 failed_reset:
@@ -4085,6 +4094,7 @@ fec_drv_remove(struct platform_device *pdev)
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
+	fec_enet_deinit(ndev);
 	free_netdev(ndev);
 	return 0;
 }
-- 
2.43.0



