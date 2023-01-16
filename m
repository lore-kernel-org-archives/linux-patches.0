Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A62A6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 17:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0145DC433EF;
	Mon, 16 Jan 2023 17:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673889315;
	bh=TbgLibqWRT0eoFdY1kvRJrn4HcRCFHsV1dj3kiNjfYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vG0FF8b0SNorzIRBZWMYcnKAWECtFvMsp7Q+aYHC7ynLC5s+CrlSDMgCGMUj9Oze8
	 lulGARPkbVy2HGtTZGVQthxoCQS7liTTJqEkqyflpHTQQIGkqQQ9EtlY0tHYJLBkMM
	 Vvv55eCJi1CEukku7YoLOLtQcSzJ2vBYIU8INQl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiguang Xiao <jiguang.xiao@windriver.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 311/338] net: amd-xgbe: add missed tasklet_kill
Date: Mon, 16 Jan 2023 16:53:04 +0100
Message-Id: <20230116154834.700955047@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
References: <20230116154820.689115727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiguang Xiao <jiguang.xiao@windriver.com>

[ Upstream commit d530ece70f16f912e1d1bfeea694246ab78b0a4b ]

The driver does not call tasklet_kill in several places.
Add the calls to fix it.

Fixes: 85b85c853401 ("amd-xgbe: Re-issue interrupt if interrupt status not cleared")
Signed-off-by: Jiguang Xiao <jiguang.xiao@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c  | 3 +++
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c  | 4 +++-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c | 4 +++-
 3 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
index 78412d6024aa..ad6f193fac95 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -1142,6 +1142,9 @@ static void xgbe_free_irqs(struct xgbe_prv_data *pdata)
 
 	devm_free_irq(pdata->dev, pdata->dev_irq, pdata);
 
+	tasklet_kill(&pdata->tasklet_dev);
+	tasklet_kill(&pdata->tasklet_ecc);
+
 	if (pdata->vdata->ecc_support && (pdata->dev_irq != pdata->ecc_irq))
 		devm_free_irq(pdata->dev, pdata->ecc_irq, pdata);
 
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
index 4d9062d35930..530043742a07 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-i2c.c
@@ -447,8 +447,10 @@ static void xgbe_i2c_stop(struct xgbe_prv_data *pdata)
 	xgbe_i2c_disable(pdata);
 	xgbe_i2c_clear_all_interrupts(pdata);
 
-	if (pdata->dev_irq != pdata->i2c_irq)
+	if (pdata->dev_irq != pdata->i2c_irq) {
 		devm_free_irq(pdata->dev, pdata->i2c_irq, pdata);
+		tasklet_kill(&pdata->tasklet_i2c);
+	}
 }
 
 static int xgbe_i2c_start(struct xgbe_prv_data *pdata)
diff --git a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
index 20ac6db6437b..bbb93c2637f3 100644
--- a/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-mdio.c
@@ -1400,8 +1400,10 @@ static void xgbe_phy_stop(struct xgbe_prv_data *pdata)
 	/* Disable auto-negotiation */
 	xgbe_an_disable_all(pdata);
 
-	if (pdata->dev_irq != pdata->an_irq)
+	if (pdata->dev_irq != pdata->an_irq) {
 		devm_free_irq(pdata->dev, pdata->an_irq, pdata);
+		tasklet_kill(&pdata->tasklet_an);
+	}
 
 	pdata->phy_if.phy_impl.stop(pdata);
 
-- 
2.35.1



