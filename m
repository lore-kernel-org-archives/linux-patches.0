Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D62482F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDAEC433D2;
	Wed, 12 Apr 2023 08:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681289287;
	bh=2cYTJzIIH1iCXH6Fgq2tnB148hRkz+Gntt/P1oBQov4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4fk4jAl2yxYntDZVwnhHB1HniX/TA9rGk/ovGmHm2T/EgpT0y3DIkGvvkoHRagxc
	 6s+fwZPgkYYElQQNDlFoO7k/Lttj3GaIGRYBmt1y/nqPEv3l9qVvbQMUHg9P8ifyPC
	 q3V/rZuZta17Zbaw2nfCijP9Laim2oqMS2dzcwVw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Roger Quadros <rogerq@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 041/173] net: ethernet: ti: am65-cpsw: Fix mdio cleanup in probe
Date: Wed, 12 Apr 2023 10:32:47 +0200
Message-Id: <20230412082839.763344580@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit c6b486fb33680ad5a3a6390ce693c835caaae3f7 ]

In the am65_cpsw_nuss_probe() function's cleanup path, the call to
of_platform_device_destroy() for the common->mdio_dev device is invoked
unconditionally. It is possible that either the MDIO node is not present
in the device-tree, or the MDIO node is disabled in the device-tree. In
both these cases, the MDIO device is not created, resulting in a NULL
pointer dereference when the of_platform_device_destroy() function is
invoked on the common->mdio_dev device on the cleanup path.

Fix this by ensuring that the common->mdio_dev device exists, before
attempting to invoke of_platform_device_destroy().

Fixes: a45cfcc69a25 ("net: ethernet: ti: am65-cpsw-nuss: use of_platform_device_create() for mdio")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Roger Quadros <rogerq@kernel.org>
Link: https://lore.kernel.org/r/20230403090321.835877-1-s-vadapalli@ti.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 3e17152798554..9286b2b3353e3 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2854,7 +2854,8 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpts_release(common->cpts);
 err_of_clear:
-	of_platform_device_destroy(common->mdio_dev, NULL);
+	if (common->mdio_dev)
+		of_platform_device_destroy(common->mdio_dev, NULL);
 err_pm_clear:
 	pm_runtime_put_sync(dev);
 	pm_runtime_disable(dev);
@@ -2883,7 +2884,8 @@ static int am65_cpsw_nuss_remove(struct platform_device *pdev)
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpts_release(common->cpts);
 
-	of_platform_device_destroy(common->mdio_dev, NULL);
+	if (common->mdio_dev)
+		of_platform_device_destroy(common->mdio_dev, NULL);
 
 	pm_runtime_put_sync(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
-- 
2.39.2



