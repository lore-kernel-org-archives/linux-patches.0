Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3A32288B9;
	Sat, 12 Sep 2026 16:36:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230990; cv=none; b=QfGn2EGq+Q9xjSGrI9xyrf6fiNY0fvQhvPUauNgDzZF6i6Xygms7viUlghWDd9IIHvOPIU5ad6acvOXPKeU2I6tD8r+Tt5y74i8SMsiTx185oWv0fEDSbnCy6zAOmlPsN6gogR3Nf6xv+MfGkgT+hqdmVdJXbRfLf61QAB5Tb24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230990; c=relaxed/simple;
	bh=hosONQ1mDqy85yrgLkevQY5A/eQ8YAr6yRbUppcQnls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aw6KY6nqTYgcf5yxQS/16pb81UKSXesyZhBXO0/xY8i0ofm8hG72tYy6cfwEt0J9usUtb+sIIgP2w+aFHNRgojfvNJDwho99mEbkhwfoJA3t7E2qE502uqQ3rKOHW/Zs4HXrzskkPBuxgsHZxNQioC+9FlOacF3+25WkBZWKnoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oAszQ4YV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oAszQ4YV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D339E1F000FF;
	Sat, 12 Sep 2026 16:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230989;
	bh=Wl9Yqvx9mhPgb54OWKSB09vE5kavNmT/ayu7C2x3FB8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oAszQ4YVg05SpdBgfHAHYGxAHeLzg75NutLDLYK4jNJaqFCjocW/O2SxoDOO6qhZA
	 o61bbijcmlAsAr+sTP4+ZgJCN3XJK69y/FDsE+6Q4Scu8pbUro2GoDNu5D5nTktTVY
	 rUvlMJI+3yuJ0OC5NIiDvTT18EiTE5obZtKJLmeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0906/1191] phy: sunplus: fix error handling in sp_uphy_init()
Date: Sat, 12 Sep 2026 09:00:34 +0200
Message-ID: <20260912065608.582159364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 56de41091d639..e18a9e6795360 100644
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



