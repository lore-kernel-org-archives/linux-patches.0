Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8A81420A5;
	Tue, 23 Jan 2024 00:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969453; cv=none; b=IcbXkVOK2pfh4FKP/y5pSQTGtXiBjsG3vOhShN5s5m6/EKWq+TwG5uI8g6KFQLquxsaWW3KEbcL3Ein6/PkvtvCKRkxtcNnLWdkU9mlfPMhppLWgmUqZnMr2j4ph8tiixoDIVAoTHA6Q7dgZP015JsmUPt6s/FZvwEQ3RRQH2w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969453; c=relaxed/simple;
	bh=S2zmGTOEb/3+SDu+mH+iDuQRBE67nIHyVVWCXqgHSP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDxU+TQBRgaknNcWnUZrMN8Wzo9ByLB/lsrUk6PfeM+T6nrTOVo1YSxE4wq8t7Z5crSGF9ftkZL9Vy4J9s3B1bu2vbxnac+9e6YJWtB7ONb/tuUfuVPhsXJo/+p5M2ha0vegAjiKB2G0lH7LEEeHyTHTIUhGiL0kOzIh6SwxVoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CoBqP48h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CoBqP48h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1796C43390;
	Tue, 23 Jan 2024 00:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969453;
	bh=S2zmGTOEb/3+SDu+mH+iDuQRBE67nIHyVVWCXqgHSP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CoBqP48h+HBlrGhF8S1HggGoYfErjnzN0yVIXu8k8CX+6vnen9AwLoGBloJ66oLDO
	 /FlxmHMeT3DyCQ+7v/N5nNzqIX76AfRsSjbF9sOktOJwn2Azbv5HdUbaDYFcWWSstX
	 fUZFF+YkLnNpuU27PRg38w2AAzNGWRKjXwtFs8cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 238/641] mlxbf_gige: Enable the GigE port in mlxbf_gige_open
Date: Mon, 22 Jan 2024 15:52:22 -0800
Message-ID: <20240122235825.378679763@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index ac7f0128619c..3d09fa54598f 100644
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
@@ -365,7 +371,6 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	void __iomem *plu_base;
 	void __iomem *base;
 	int addr, phy_irq;
-	u64 control;
 	int err;
 
 	base = devm_platform_ioremap_resource(pdev, MLXBF_GIGE_RES_MAC);
@@ -380,11 +385,6 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
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



