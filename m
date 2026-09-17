Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548694D178C;
	Thu, 17 Sep 2026 18:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789669010; cv=none; b=MdbcvW2LoRZ7zQ58XTYXdHyW3FClQUG4mymO21t7oJAtQVfGLihi3agID6ov4321drQ+V670YxTkJj1f/s4D7KIyFDl+DXwH+PKwzhfN/9BT86DY1vYZWMnaRLp5EpX2EjfX0xWIeUU3XCAYcRzt3Q28EJfzNLpOzKdyPzbcrPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789669010; c=relaxed/simple;
	bh=2kL4hlb9Xr18yLDC65NyQrCXs03airyx4jEWerzBqUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LejU4FDxUnzeTKmc8wpdbg8C5lT3VHNcqxUP1FjxmPWmE3FY4SMnqe/h/m1Ph7e2qOUHAXUdzy2hy5fr4KR0rcbUagS7GOefbvVpMk7rxVboeBDnK4jAbkNJYeISay7uqnbT3AwaiN2oMs9tRZJLYBX877XwlsUrH6EizLaRne0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPvUkGMR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPvUkGMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72471F000FF;
	Thu, 17 Sep 2026 18:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789669009;
	bh=XkriwsPYwpU0lPi6eVBn5Rq7rsf+J1iH5mInYBsc+5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPvUkGMRTDsQOw+ss8VwenRFlZ2HrW/JlPkWc26oxOBmiv82AOnpNAmSA4w1GDdk7
	 HdsuCBLxs4CwGtsJcufnX/htb47WKBwnsreL0GHRahIc7ZJEbef4fujPYTkfrm6wlS
	 JR6+mfakrzfg6Tl6wFXgGskk08wEpNMclo3zuL7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0614/1102] ASoC: ux500: Request the MSP MMIO resource
Date: Thu, 17 Sep 2026 16:09:17 +0100
Message-ID: <20260917151555.466302518@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 4fb67925f33ad789e9e00903a73306ed40f7ae32 ]

A bare devm_ioremap() neither reserves the register range nor preserves
the platform resource error. This permits another driver to claim the
same range and reports every mapping failure as an allocation failure.

Use the managed platform resource helper, retaining the resolved
resource only to derive the DMA register address.

Fixes: 3592b7f69a54 ("ASoC: Ux500: Add MSP I2S-driver")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260902-ux500-msp-fixes-v2-6-4b60b002d55a@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ux500/ux500_msp_i2s.c | 18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
index bc77174e00707..43dc9b3aa4ef5 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -733,7 +733,7 @@ int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
 int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 			struct ux500_msp **msp_p)
 {
-	struct resource *res = NULL;
+	struct resource *res;
 	struct ux500_msp *msp;
 
 	*msp_p = devm_kzalloc(&pdev->dev, sizeof(struct ux500_msp), GFP_KERNEL);
@@ -743,20 +743,10 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 
 	msp->dev = &pdev->dev;
 
-	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (res == NULL) {
-		dev_err(&pdev->dev, "%s: ERROR: Unable to get resource!\n",
-			__func__);
-		return -ENOMEM;
-	}
-
+	msp->registers = devm_platform_get_and_ioremap_resource(pdev, 0, &res);
+	if (IS_ERR(msp->registers))
+		return PTR_ERR(msp->registers);
 	msp->tx_rx_addr = res->start + MSP_DR;
-	msp->registers = devm_ioremap(&pdev->dev, res->start,
-				      resource_size(res));
-	if (msp->registers == NULL) {
-		dev_err(&pdev->dev, "%s: ERROR: ioremap failed!\n", __func__);
-		return -ENOMEM;
-	}
 
 	msp->msp_state = MSP_STATE_IDLE;
 	msp->loopback_enable = 0;
-- 
2.53.0



