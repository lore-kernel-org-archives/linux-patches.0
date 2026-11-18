Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048107;
	b=cCKp00N19lFrpLGhTqHsCNbR+cLm3C+w+oQ6AKNiSG4rta6bkUktgXJU7nce0KYjJv9+
	 nbFSzCHZgDl73ZVb0ybb00i22lEW1fZyFiaSXbNWQpvBxlTnxvlehWy9ZAU9rGk/CiYaR
	 kuvy6Tb6ANVkR88qifkH7089kAINXmk4jW52CLhbxMzIrxxi98paNqRQi5eyZExYqAchN
	 DJhp4sGPa3WBLnUGZHOGCo+ISS8EZY2NSoS6QyX6SMxJO42oEQPOL4Rw6HRdnKzO3u+Ed
	 hx+ugYxy82P1KpimikXcOX2O3puAAqLkjAZ+6piaHg87tXlci5+F4GnQL41j6gaadUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048107;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=30zZP9feMkVVpZ5H352tqM4dUfu7XHERM6AoltXZ4QU=;
	b=uPt70yCSALXQ1BtF/wIOh6ln3cV1Gl3FzKpXAndjeHoR+pYLTOV7wGhxrF9SRB2F2LE2
	 ofn9bWqLDD2FRkUqeYxLhgEDBl8k8NqZyU3Bu1tYL8utguXJ8AzfYciVMLQOpX8Ad/EhM
	 nl4YKeCz3DABwrjBKWG/8uVmgdGrbuqOO8RL5Hz6B3RKeXYZB97dmeZPfhuKE+j1MFhRV
	 T4awrkBiT+FeWnv0I1yo+6PytoWQ8WT4vx/tacUJo4BY4eq0MMIgjNekcu0TFerr7NJfG
	 ObyZAOHKl26iB7cLiYZ3SWcsYbHf4bauuh6K7xlt1S1HEgxdOa47WBGT9BS6xHsEKNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jSmWYLTt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E87606A320;
	Thu, 19 Nov 2026 00:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jSmWYLTt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D58BD1F000C4;
	Thu, 19 Nov 2026 00:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048107;
	bh=30zZP9feMkVVpZ5H352tqM4dUfu7XHERM6AoltXZ4QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jSmWYLTt3lkj9XLTTseWU1EgxdozjzeP6feNVpsd4vUToMefhH/IKzGVDUo+fTPci
	 o/ZWof+JmgEysqzvlF8L5ndaJrGijC0O2o2GsyDim/RlK2Dcwq1zZt5MxTp/80dIyZ
	 F9Xrgn8ssKfrhMHCHXiHr/9bYaBguWvqzMePvCSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chaithanya Lagisetty <nagachaithanya9911@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1877/2857] dmaengine: sprd: use clk_bulk API to fix clock imbalance
Date: Wed, 18 Nov 2026 15:48:31 +0100
Message-ID: <20261118150308.814435155@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>

[ Upstream commit d09cd5e8bbc98969b5333015b45c525078ac0f6f ]

sprd_dma_enable() enabled sdev->clk and then the optional ashb_clk. If
enabling ashb_clk failed, sdev->clk was left enabled: both callers
(probe and resume) treat a non-zero return as "nothing was enabled" and
bail out, leaking sdev->clk.

Convert the driver to the clk_bulk API. clk_bulk_prepare_enable()
enables all clocks and unwinds them on failure, and
clk_bulk_disable_unprepare() disables them, which fixes the imbalance
and simplifies the enable/disable paths. Both clocks are fetched with
devm_clk_bulk_get_optional(); the optional ashb_eb clock simply becomes
a NULL entry that the bulk helpers treat as a no-op, while the mandatory
enable clock is still checked explicitly.

Fixes: 9b3b8171f7f4 ("dmaengine: sprd: Add Spreadtrum DMA driver")
Signed-off-by: Chaithanya Lagisetty <nagachaithanya9911@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260819053518.2825514-1-nagachaithanya9911@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/sprd-dma.c | 45 ++++++++++++------------------------------
 1 file changed, 13 insertions(+), 32 deletions(-)

diff --git a/drivers/dma/sprd-dma.c b/drivers/dma/sprd-dma.c
index cb48e4d2640cd..53d59f0350c53 100644
--- a/drivers/dma/sprd-dma.c
+++ b/drivers/dma/sprd-dma.c
@@ -208,8 +208,7 @@ struct sprd_dma_chn {
 struct sprd_dma_dev {
 	struct dma_device	dma_dev;
 	void __iomem		*glb_base;
-	struct clk		*clk;
-	struct clk		*ashb_clk;
+	struct clk_bulk_data	clks[2];
 	int			irq;
 	u32			total_chns;
 	struct sprd_dma_chn	channels[];
@@ -260,31 +259,12 @@ static void sprd_dma_chn_update(struct sprd_dma_chn *schan, u32 reg,
 
 static int sprd_dma_enable(struct sprd_dma_dev *sdev)
 {
-	int ret;
-
-	ret = clk_prepare_enable(sdev->clk);
-	if (ret)
-		return ret;
-
-	/*
-	 * The ashb_clk is optional and only for AGCP DMA controller, so we
-	 * need add one condition to check if the ashb_clk need enable.
-	 */
-	if (!IS_ERR(sdev->ashb_clk))
-		ret = clk_prepare_enable(sdev->ashb_clk);
-
-	return ret;
+	return clk_bulk_prepare_enable(ARRAY_SIZE(sdev->clks), sdev->clks);
 }
 
 static void sprd_dma_disable(struct sprd_dma_dev *sdev)
 {
-	clk_disable_unprepare(sdev->clk);
-
-	/*
-	 * Need to check if we need disable the optional ashb_clk for AGCP DMA.
-	 */
-	if (!IS_ERR(sdev->ashb_clk))
-		clk_disable_unprepare(sdev->ashb_clk);
+	clk_bulk_disable_unprepare(ARRAY_SIZE(sdev->clks), sdev->clks);
 }
 
 static void sprd_dma_set_uid(struct sprd_dma_chn *schan)
@@ -1133,16 +1113,17 @@ static int sprd_dma_probe(struct platform_device *pdev)
 	if (!sdev)
 		return -ENOMEM;
 
-	sdev->clk = devm_clk_get(&pdev->dev, "enable");
-	if (IS_ERR(sdev->clk)) {
-		dev_err(&pdev->dev, "get enable clock failed\n");
-		return PTR_ERR(sdev->clk);
-	}
+	/* The ashb_eb clock is optional and only present for AGCP DMA */
+	sdev->clks[0].id = "enable";
+	sdev->clks[1].id = "ashb_eb";
+	ret = devm_clk_bulk_get_optional(&pdev->dev, ARRAY_SIZE(sdev->clks),
+					 sdev->clks);
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret, "get clocks failed\n");
 
-	/* ashb clock is optional for AGCP DMA */
-	sdev->ashb_clk = devm_clk_get(&pdev->dev, "ashb_eb");
-	if (IS_ERR(sdev->ashb_clk))
-		dev_warn(&pdev->dev, "no optional ashb eb clock\n");
+	if (!sdev->clks[0].clk)
+		return dev_err_probe(&pdev->dev, -ENOENT,
+				     "get enable clock failed\n");
 
 	/*
 	 * We have three DMA controllers: AP DMA, AON DMA and AGCP DMA. For AGCP
-- 
2.53.0



