Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A82746F4AD;
	Tue, 21 Jul 2026 19:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660568; cv=none; b=aQA5VxTxww64ugNk3te/kVKDmsdxezDzf5C2+Amjm2CIMarbe9LREnKjEJeOVCF9HlpqCMBxOEjQ++HUIACbRnTLb5Aupz07+Uya30805Qdad+tp/yKLTY69hSGmN6O/5tO0+J5R2yeAnsjl6/lyYT4EBt0/0FmXDh3iGb7rX/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660568; c=relaxed/simple;
	bh=VS/OdnKGoHprlW3Vc1aXVlpk4vhlcU7yDrO3+jczZ8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d188wpe4N5uTf2Z+39kG7+8odeJBDTKq/nlLFJ++0przjJGnzMJ8qpZNzCwqdv9tWkL20SpDfxZsUbBlRbWyLLySptDBqasQdPXwWs/gSCE6pDrtP23mx3W8SHnRM+Tj2taPHPMBdTnx9fVqjWaii2sJvGLawMEqAONfSKUfeZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gbwICVQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gbwICVQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EEA71F000E9;
	Tue, 21 Jul 2026 19:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660565;
	bh=XkFStCgmK1qZh7GhQcFoW9yhZSKnieKnxuyAeaK/G74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0gbwICVQvFpmqZ/plFfIJjLxF0pzGa23mIs0XymU4f4Z9YHVRr9fSlOgqb5sHCvn/
	 o9Q2xUJzr8JqJby+7juHvLwOWnO3P5WlnPfTFudXMTRLxx4y/42WrapmZrPNv4McN3
	 hkHIjZG/3j838K55D14PMYzuUMjmM+ZYwMiEQB2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko <sashiko-bot@kernel.org>,
	Felix Gu <ustc.gu@gmail.com>,
	Frank Li <Frank.Li@nxp.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1029/2077] phy: freescale: phy-fsl-imx8qm-lvds-phy: Use synchronous PM runtime put in reset
Date: Tue, 21 Jul 2026 17:11:42 +0200
Message-ID: <20260721152617.089424599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

[ Upstream commit b28ec8ce03d8f9a0f7a9ec84f1ed9b5a6f393791 ]

The mixel_lvds_phy_reset() function pairs pm_runtime_resume_and_get()
with pm_runtime_put(). The asynchronous variant queues a work item
to handle the idle check and potential suspend, which can be cancelled
by a subsequent pm_runtime_disable() call if probe fails after the reset.

Switch to pm_runtime_put_sync() to run the idle check and suspend
synchronously.

Fixes: 06ff622d61d2 ("phy: freescale: Add i.MX8qm Mixel LVDS PHY support")
Reported-by: sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260605-lvds-v2-1-3ce7539d1104%40gmail.com
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20260609-lvds-phy-v1-1-6ad790c6d0ea@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/freescale/phy-fsl-imx8qm-lvds-phy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/phy/freescale/phy-fsl-imx8qm-lvds-phy.c b/drivers/phy/freescale/phy-fsl-imx8qm-lvds-phy.c
index ece35744352170..e2a1645000ae55 100644
--- a/drivers/phy/freescale/phy-fsl-imx8qm-lvds-phy.c
+++ b/drivers/phy/freescale/phy-fsl-imx8qm-lvds-phy.c
@@ -286,7 +286,7 @@ static int mixel_lvds_phy_reset(struct device *dev)
 
 	regmap_write(priv->regmap, PHY_CTRL, CTRL_RESET_VAL);
 
-	pm_runtime_put(dev);
+	pm_runtime_put_sync(dev);
 
 	return 0;
 }
-- 
2.53.0



