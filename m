Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D174B7C0A5;
	Tue, 23 Jan 2024 00:49:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970974; cv=none; b=j5tVJ92kWfL80aHH9KTCsTdXQpLMzviYqm5m+4SBGKQ7S81LFHy8fsfrT1Mz2ofkc4R8iSH6K4tPYpEquV5fI8/slqUg8i9BLgFEt+5rPAPwCJdRairNpxC/j2VR/weblbWTB5bszcEX467K43M6BJf+7M2qKR/V9vxkVFWPLgQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970974; c=relaxed/simple;
	bh=Cg26YXIzqjDrhwl5/KvBsgX+9couq384p/o3CA9izfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S98l53tZiViyxvXI7z3bbMU1lFk3+yj5I3P8qLBX/hPKM/dYdbQKNfaapaRlOuKxN6VU10sBVufOpa1fk9D1Bz6V7Vm1iiHXIq4RX+rDDI7Xfq8b/k+f3Zb3D9c4k/JvEdkp+tPPoxK2Lj8WWApKNbAITQ1psSx4MMVG7g0DMYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uUhYf4w+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uUhYf4w+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDFF2C43394;
	Tue, 23 Jan 2024 00:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970974;
	bh=Cg26YXIzqjDrhwl5/KvBsgX+9couq384p/o3CA9izfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uUhYf4w+RJmZaqV9UwAO7Hx+MU1zuTkF+N8xPyxrgE17+aeZoDiV29xmHHNdQsPHM
	 FyfjtFcf6wnYoHJNPtBhxKuscGBw98MalvIDURw0yKJH0Z165F+hm/hxcuKAIfVJ0g
	 UO/2wF4gJiKXl1sIXkX+wsKGPNM7Hy5IvsaYHzl0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 153/417] mlxbf_gige: Enable the GigE port in mlxbf_gige_open
Date: Mon, 22 Jan 2024 15:55:21 -0800
Message-ID: <20240122235757.136890327@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

From: Asmaa Mnebhi <asmaa@nvidia.com>

[ Upstream commit a460f4a684511e007bbf1700758a41f05d9981e6 ]

At the moment, the GigE port is enabled in the mlxbf_gige_probe
function. If the mlxbf_gige_open is not executed, this could cause
pause frames to increase in the case where there is high backgroud
traffic. This results in clogging the port.
So move enabling the OOB port to mlxbf_gige_open.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Reviewed-by: David Thompson <davthompson@nvidia.com>
Signed-off-by: Asmaa Mnebhi <asmaa@nvidia.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c   | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index eafc0d3313fd..83c4659390fd 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -130,9 +130,15 @@ static int mlxbf_gige_open(struct net_device *netdev)
 {
 	struct mlxbf_gige *priv = netdev_priv(netdev);
 	struct phy_device *phydev = netdev->phydev;
+	u64 control;
 	u64 int_en;
 	int err;
 
+	/* Perform general init of GigE block */
+	control = readq(priv->base + MLXBF_GIGE_CONTROL);
+	control |= MLXBF_GIGE_CONTROL_PORT_EN;
+	writeq(control, priv->base + MLXBF_GIGE_CONTROL);
+
 	err = mlxbf_gige_request_irqs(priv);
 	if (err)
 		return err;
@@ -279,7 +285,6 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	void __iomem *plu_base;
 	void __iomem *base;
 	int addr, phy_irq;
-	u64 control;
 	int err;
 
 	base = devm_platform_ioremap_resource(pdev, MLXBF_GIGE_RES_MAC);
@@ -294,11 +299,6 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	if (IS_ERR(plu_base))
 		return PTR_ERR(plu_base);
 
-	/* Perform general init of GigE block */
-	control = readq(base + MLXBF_GIGE_CONTROL);
-	control |= MLXBF_GIGE_CONTROL_PORT_EN;
-	writeq(control, base + MLXBF_GIGE_CONTROL);
-
 	netdev = devm_alloc_etherdev(&pdev->dev, sizeof(*priv));
 	if (!netdev)
 		return -ENOMEM;
-- 
2.43.0



