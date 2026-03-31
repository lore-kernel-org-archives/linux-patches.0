Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1004423146;
	Tue, 31 Mar 2026 16:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975503; cv=none; b=ZzPaeoz/9+u1tyLbemu51lqFDMkWt+K6F7G1gI2y79yKTGdbpt96i3gJP2DkTC0oH8EZgVS3Hi+dSvgBfVEeNCK6YL871rYO9mjCEIqdrQwD8BOC0mO99VBz0PfFBK0EZO+ILwqEr/p3z/cZatK94OiabT8cZAIROF6TzWC/ZFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975503; c=relaxed/simple;
	bh=LB0UHdoS636P470xJCb65tgGt9rLuT+/PicXzoEMWKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MlMJacT34qMucAqzNahOHKSpMiAkVZmo9OZI5pLP3pdele0BJz2gpDgOzksumKbeS0gBsnLL7jL/6Z1ZE4f8OoXkU1bPFtHMO1Tihi1yBY2nlhVTBcat29KO/4QDxnXsDXxCU8gM0Y94Zd7TGfXkBLWmwae9g59aTwqVTZ3uLDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZUy3hPG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZUy3hPG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5903DC19423;
	Tue, 31 Mar 2026 16:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975503;
	bh=LB0UHdoS636P470xJCb65tgGt9rLuT+/PicXzoEMWKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZUy3hPG41GyGMc9VcyUjGD4p7SjuK13D1bRn2PL5r+iVAR7W1B3ph4yzTMn7Z31Iz
	 Wg+gudc29wZiPvm5kwTHWRQn37Fa7YeoDCGnTYWUQO25hPfkSe+4ahKLJnw4H9wIIn
	 S89djTVOeaY2yhbwSaHLC1a45Jw0xqJ6JfFkVf8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 321/342] dmaengine: xilinx: xdma: Fix regmap init error handling
Date: Tue, 31 Mar 2026 18:22:34 +0200
Message-ID: <20260331161810.727763389@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit e0adbf74e2a0455a6bc9628726ba87bcd0b42bf8 ]

devm_regmap_init_mmio returns an ERR_PTR() upon error, not NULL.
Fix the error check and also fix the error message. Use the error code
from ERR_PTR() instead of the wrong value in ret.

Fixes: 17ce252266c7 ("dmaengine: xilinx: xdma: Add xilinx xdma driver")
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20251014061309.283468-1-alexander.stein@ew.tq-group.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/xilinx/xdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/xdma.c b/drivers/dma/xilinx/xdma.c
index 5ecf8223c112e..58e01e22b9765 100644
--- a/drivers/dma/xilinx/xdma.c
+++ b/drivers/dma/xilinx/xdma.c
@@ -1236,8 +1236,8 @@ static int xdma_probe(struct platform_device *pdev)
 
 	xdev->rmap = devm_regmap_init_mmio(&pdev->dev, reg_base,
 					   &xdma_regmap_config);
-	if (!xdev->rmap) {
-		xdma_err(xdev, "config regmap failed: %d", ret);
+	if (IS_ERR(xdev->rmap)) {
+		xdma_err(xdev, "config regmap failed: %pe", xdev->rmap);
 		goto failed;
 	}
 	INIT_LIST_HEAD(&xdev->dma_dev.channels);
-- 
2.53.0



