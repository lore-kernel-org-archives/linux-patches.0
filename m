Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF6671EE001;
	Tue,  3 Dec 2024 15:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239420; cv=none; b=WD9tPHjpbEI/sUcmXhm8PEMY98ErTCDA6XgPlZ+k7w8bLlgzhg3NBzGT5B03tzqHhl27HytkYGvNDbHv/eB0duOdo089GdcFpnWt2gGKu2ov8ytW4BZWL0+EWyk3pBdAbSYCrw7PyeMLB4J9oR5IvTq//navr95tBcz1v0ok1rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239420; c=relaxed/simple;
	bh=81SgdUfX+8zLPsoAXdYjk+MOKlHgOFh+N8pbDKz7s88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbBF4wGGY6RLWQJAS/nCTEXNKJSvLPaylBZJXSo7y2rNBBYgcR9ix+Jss5GaL7CHOUr08609El73quUn9Ga/3rPqVt3CBh+/pBss1/a0H/7riRxdg5+0+bDV+n4XmA/Qp8zpnHjVdGs/ofEd/flCS3bsCbtyxXXTg5TxthRtwos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mIu3Tqc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mIu3Tqc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32BEEC4CECF;
	Tue,  3 Dec 2024 15:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239419;
	bh=81SgdUfX+8zLPsoAXdYjk+MOKlHgOFh+N8pbDKz7s88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mIu3Tqc4r87xHS4OCiNw8McgcFT/WU7Cck71DmoLSnKtT/fWtiHrcqHeSFxyoowsH
	 sHpCeCJ7qro8kjDrPLsIC2dn4RmWzHJhcOPHcE6+wI7xp2Hp8mlZYiY8XR0wonKZgM
	 U1HcEVcM7YXDft4wPtElKsIz50w4/e4VMue6qmew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Han <hanchunchao@inspur.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 606/817] phy: realtek: usb: fix NULL deref in rtk_usb2phy_probe
Date: Tue,  3 Dec 2024 15:42:58 +0100
Message-ID: <20241203144019.582280254@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Han <hanchunchao@inspur.com>

[ Upstream commit 04e3e9188291a183b27306ddb833722c0d083d6a ]

In rtk_usb2phy_probe() devm_kzalloc() may return NULL
but this returned value is not checked.

Fixes: 134e6d25f6bd ("phy: realtek: usb: Add driver for the Realtek SoC USB 2.0 PHY")
Signed-off-by: Charles Han <hanchunchao@inspur.com>
Link: https://lore.kernel.org/r/20241025065912.143692-1-hanchunchao@inspur.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/realtek/phy-rtk-usb2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/phy/realtek/phy-rtk-usb2.c b/drivers/phy/realtek/phy-rtk-usb2.c
index e3ad7cea51099..e8ca2ec5998fe 100644
--- a/drivers/phy/realtek/phy-rtk-usb2.c
+++ b/drivers/phy/realtek/phy-rtk-usb2.c
@@ -1023,6 +1023,8 @@ static int rtk_usb2phy_probe(struct platform_device *pdev)
 
 	rtk_phy->dev			= &pdev->dev;
 	rtk_phy->phy_cfg = devm_kzalloc(dev, sizeof(*phy_cfg), GFP_KERNEL);
+	if (!rtk_phy->phy_cfg)
+		return -ENOMEM;
 
 	memcpy(rtk_phy->phy_cfg, phy_cfg, sizeof(*phy_cfg));
 
-- 
2.43.0



