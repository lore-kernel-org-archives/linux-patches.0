Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6BF19D066;
	Thu,  6 Jun 2024 14:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683082; cv=none; b=ZUaSCBip2dSpL4ZoFRgPDB0gdfvHvqiPH2dh/phZAhBRgYey2LoVl74Rw50T0d4nPfJ3L1I/YthSbrd/X9q3OvNlX+QGApKOvPW6O8aGdqM9uVhCzbx7FZ4QA0KRDWlU91q92ivjKTkxd7n6rR8aHTOZYDlnXYh4vG9I7YlQBFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683082; c=relaxed/simple;
	bh=uTzbGQHnCQUzMgw5iq/w5X1+FvVd1iXc10Y10vtXRN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e80dF0+aXMejZYquBhNNft0ikmDkn/IvB2omW0yyIzazYmhCqWqfh5CjoSY3N/ZwAhp7qM28Nlb3VZy1uaxT3BOahCVRNhV5qf9pyi1crWeM3CQFtEwcJSPChFzZU9f4kb4YXooPlzCo3DF7ePYkDFzc5Zdfc8vVUvMMLV4SMwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vfe0sHbv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vfe0sHbv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D241C4AF14;
	Thu,  6 Jun 2024 14:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683082;
	bh=uTzbGQHnCQUzMgw5iq/w5X1+FvVd1iXc10Y10vtXRN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vfe0sHbv3DBZaK361QxSivVuaW0e/2o0i0ncBmWA+TxOOepCSE2Td61ITurgoqdRm
	 zzTEoGc2xWJ7ywR8vmJoxYlPtcg4xb+56qExPvWRXLES01j5DHZm5HxZ4s8yyQDgk1
	 wQpcKzLYSZCvBaezxSX+gIKIVhsRM99ene8eoxSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaolei Wang <xiaolei.wang@windriver.com>,
	Wei Fang <wei.fang@nxp.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 318/374] net:fec: Add fec_enet_deinit()
Date: Thu,  6 Jun 2024 16:04:57 +0200
Message-ID: <20240606131702.527405551@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index a72d8a2eb0b31..881ece735dcf1 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -4130,6 +4130,14 @@ static int fec_enet_init(struct net_device *ndev)
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
@@ -4524,6 +4532,7 @@ fec_probe(struct platform_device *pdev)
 	fec_enet_mii_remove(fep);
 failed_mii_init:
 failed_irq:
+	fec_enet_deinit(ndev);
 failed_init:
 	fec_ptp_stop(pdev);
 failed_reset:
@@ -4587,6 +4596,7 @@ fec_drv_remove(struct platform_device *pdev)
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
+	fec_enet_deinit(ndev);
 	free_netdev(ndev);
 }
 
-- 
2.43.0



