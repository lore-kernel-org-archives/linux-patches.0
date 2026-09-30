Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22F3314A86;
	Wed, 30 Sep 2026 18:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791381; cv=none; b=saz3jlt9Yxf3vGFrLPItlg85D/kn7G82N3AAGh/HsgMeDxpougdBbfQVaQioxagxzLtSt3J+WLveqHdzQ7w6LUMBZLJ5BOesr+IDI0ksuHZLRIEnH684j9YzWCDdVJ5TmmBIFJpoWtAM8pMZxrMWVgf3BhHjPeKdp55vo7HHnWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791381; c=relaxed/simple;
	bh=V4YYo75v3y2Jw1Sby6l2iKRxf8esWk7xm0xRTa7BmvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SgOUgbtNdjbu7+WlOr1HxgihbWQglYF2/f9PAUphSmp4nLsTqhktAdM+nTS+PE6w9+4jqcyO5l2LhgB9NYMqvovtk7MLpc5gnzx6ufoapRiDmy6abdC/mJMFalJZN8e1R5fVqjKVFfZXRrKeGL88iPIYDu+HYbgUHZoVY9biDrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Iv+9QDlJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Iv+9QDlJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62331F000FF;
	Wed, 30 Sep 2026 18:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791380;
	bh=QW5ixdFOjl91Igm3wpve7tFeXOBrv5E+UHFHvn6Ndww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Iv+9QDlJhUiQNddCNesXS/JzyJXxCbXMhmcAHCTRcOGPx8CZe3PdOm/HNBEgtNmxd
	 AdNiIix4BJ48oFWhujofvkWqyvKPpI5gam17S8gB/PJc067YcFE+gikMJXVPxrcfQF
	 Xj2tLXdWmpwgRiVcm+19J+w4/5xBKqYxQa5CWj2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 283/752] ASoC: ux500: Request the MSP MMIO resource
Date: Wed, 30 Sep 2026 17:22:33 +0200
Message-ID: <20260930152404.412156529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6e0e10cd86e5e..11a697d7074e6 100644
--- a/sound/soc/ux500/ux500_msp_i2s.c
+++ b/sound/soc/ux500/ux500_msp_i2s.c
@@ -735,7 +735,7 @@ int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
 int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 			struct ux500_msp **msp_p)
 {
-	struct resource *res = NULL;
+	struct resource *res;
 	struct ux500_msp *msp;
 
 	*msp_p = devm_kzalloc(&pdev->dev, sizeof(struct ux500_msp), GFP_KERNEL);
@@ -745,20 +745,10 @@ int ux500_msp_i2s_init_msp(struct platform_device *pdev,
 
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



