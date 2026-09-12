Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D4064BEE55;
	Sat, 12 Sep 2026 14:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225135; cv=none; b=e1iSmbFo7/+x5zhv3P5sYIZXK4IJy+6/vq0jgaKjQHLh56qBUoalYlyhzcZNIB4+F1wjOO82xrYxjrOXf5JvCFGhVTmydcL4n0CirhRu1J4IfsIctFktmOMw2RJkCXqBlcG/ju4zcIxIRWtnlCee365LnM1ObBZ5r06L2VcTshY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225135; c=relaxed/simple;
	bh=9V7KBJLT7vG+UZJ1R3Eoy3STHeVsCOl6e4Yl/Gne/f8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QVGTVx4t2KJsTPK283oXHEoegvgal5Jg9NawmcT49cVeZzbkm2B1NH3TD+JUkpQq2KsGQQ3CH/DuQtmh8aAqF3g8JZSMTiLe6utlIbrQuBMCFICtMzVweT/U4yoFffOOVmBqtMQ/szPStvkZn2KaoZJLKXtyUyZrcrTTiOTnh0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbcE5I6H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbcE5I6H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 462241F000FF;
	Sat, 12 Sep 2026 14:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225134;
	bh=MttuPSvmM7WuQSpulQVo5cM072ux5pJ2/D5kpWcaWuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jbcE5I6HpqoUxZ2xu3JNU1hrCzRgR3QF0xa3b+GPrJCNzEoNb9Kln+FbXxTWS0o1m
	 kFGK7a/uUqTWkQeoW0HTQZ7nTu7rJFNvSp2IzmFbiPRGvTNMc2DGh/cR/yHxJq7dqj
	 ykuc2wDczd2EH645JOEQDOWmfKNcPEL0D4TCpNcY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1093/1424] phy: sunplus: fix error handling in sp_uphy_init()
Date: Sat, 12 Sep 2026 08:58:45 +0200
Message-ID: <20260912065631.784219739@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit 8b2683bc4cc18c581b7cd24f227cbe61abca7f4d ]

Fix the error paths of sp_uphy_init() to undo exactly what each stage
did: return directly if clk_prepare_enable() fails, release only the clock
if reset_control_deassert() fails, and jump to err_reset if
update_disc_vol() fails so the clock and reset are not leaked.

Fixes: 99d9ccd97385 ("phy: usb: Add USB2.0 phy driver for Sunplus SP7021")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Link: https://patch.msgid.link/20260803-sunplus-usb3-v1-1-5a562524c869@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/sunplus/phy-sunplus-usb2.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/phy/sunplus/phy-sunplus-usb2.c b/drivers/phy/sunplus/phy-sunplus-usb2.c
index 637a5fbae6d9a..0ad4c7160d17c 100644
--- a/drivers/phy/sunplus/phy-sunplus-usb2.c
+++ b/drivers/phy/sunplus/phy-sunplus-usb2.c
@@ -116,11 +116,11 @@ static int sp_uphy_init(struct phy *phy)
 
 	ret = clk_prepare_enable(usbphy->phy_clk);
 	if (ret)
-		goto err_clk;
+		return ret;
 
 	ret = reset_control_deassert(usbphy->rstc);
 	if (ret)
-		goto err_reset;
+		goto err_clk;
 
 	/* Default value modification */
 	writel(HIGH_MASK_BITS | 0x4002, usbphy->moon4_regs + UPHY_CONTROL0);
@@ -129,7 +129,7 @@ static int sp_uphy_init(struct phy *phy)
 	/* disconnect voltage */
 	ret = update_disc_vol(usbphy);
 	if (ret < 0)
-		return ret;
+		goto err_reset;
 
 	/* board uphy 0 internal register modification for tid certification */
 	val = readl(usbphy->phy_regs + CONFIG9);
-- 
2.53.0



