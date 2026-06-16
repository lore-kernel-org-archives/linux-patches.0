Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273BC478E5E;
	Tue, 16 Jun 2026 18:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635158; cv=none; b=KsRpvf1rS5cbEnDjTxfypsX8yRBatbV41qgPjd8sA3H7IKuPWyKQLtD/e1KWT0xzJBIherMGdlALI6fxVJ3rRFYk+D7ZRoPmTyoVlNsVT0PlbpV9p8Dxn5c9An3GHbi9UVi3BqCwEPXBfdrAA8OMkn+/mDsxPPy6vFQwRcg2O28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635158; c=relaxed/simple;
	bh=kGDB6Qsbm9y1GvUV0TmhEFLK1nBQG+52sHkCyRLmBZk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cltL61Qw+vkGZ+hIJzgxRJ6qkFLvMswCHzOjcSsb4v/GHge8oLdoRcg7vGKGr4k+cFN7A7xMueAbm1sHt3prKBR1AQFCHFSnL58eXSUZSDRyiowp8R9ce49Ud6THcsz5XmOK/gNAATpVQC1LVDo4gJQGlpDlQPKcCZ3nMBiP7B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vzfkgVZP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vzfkgVZP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199C21F000E9;
	Tue, 16 Jun 2026 18:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635157;
	bh=sLA5NHvTEQFIdAGbiNEtCC221QlCAYCRMpYErXmXqsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vzfkgVZPoNGzaTPr1wTiiAtf34JpQertoPbOFT61lTbO2OJL2UgFbP3mbhy4nHILR
	 C1nrY4c3rOxIjIkN/vZ6ztDk9VhVOEgA874wuiZ4gi+F3Pxjz6VX2laN1dLWsF4Ofb
	 4jLWNFURzuHMNQ12tmwjeOrhYzN45DD2pTKKOoMQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	sashiko-bot <sashiko-bot@kernel.org>,
	Peter Chen <peter.chen@cixtech.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 368/411] usb: cdns3: plat: fix leaked usb2_phy initialization on usb3_phy acquisition failure
Date: Tue, 16 Jun 2026 20:30:06 +0530
Message-ID: <20260616145120.892240130@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

From: Peter Chen <peter.chen@cixtech.com>

[ Upstream commit e6970cda63fd4b4546aeed9d0e2f53a7c95cd09c ]

Move usb2_phy initialization after usb3_phy acquisition.

Fixes: f738957277ba ("usb: cdns3: Split core.c into cdns3-plat and core.c file")
Cc: stable <stable@kernel.org>
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-devicetree/agKaEePSFknhDBg2@nchen-desktop/T/#m21e1d9c1574eb127ce03c0c2a1a49002ce435b52
Signed-off-by: Peter Chen <peter.chen@cixtech.com>
Link: https://patch.msgid.link/20260513085310.2217547-2-peter.chen@cixtech.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdns3-plat.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/usb/cdns3/cdns3-plat.c
+++ b/drivers/usb/cdns3/cdns3-plat.c
@@ -120,14 +120,14 @@ static int cdns3_plat_probe(struct platf
 	if (IS_ERR(cdns->usb2_phy))
 		return PTR_ERR(cdns->usb2_phy);
 
-	ret = phy_init(cdns->usb2_phy);
-	if (ret)
-		return ret;
-
 	cdns->usb3_phy = devm_phy_optional_get(dev, "cdns3,usb3-phy");
 	if (IS_ERR(cdns->usb3_phy))
 		return PTR_ERR(cdns->usb3_phy);
 
+	ret = phy_init(cdns->usb2_phy);
+	if (ret)
+		return ret;
+
 	ret = phy_init(cdns->usb3_phy);
 	if (ret)
 		goto err_phy3_init;


