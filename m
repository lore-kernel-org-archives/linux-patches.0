Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9ED1415F22;
	Fri,  4 Sep 2026 05:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499299; cv=none; b=OOcC76kPQSiUYrZimJYt/yCbpCC4nsz4LOzzScnepSJ9iT+ZamWpRbDnZVHiQSTO183i0qCl+jonurtfFqM0PXzfHeHmoXI+DfmJcdASmH39Tgfofyoy5jt21Z9NbE9Zl8E2ZV7AD1lIOcpdYz1ILkY7UOS6Mx3SI1uD7H7FnYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499299; c=relaxed/simple;
	bh=FTJcyssRH9kxY1W3kCWqQ9+CkD69PupxpXA0kcjxyHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZhmZTVCvqMCHgNxXd1S+5Nr/M06htgva6eZvlwgPy5MLKC8/SlHOLgrV0T+3UGTEZAu5DV5b2zaXjHAMMxchV18mMrVUJQjxk0B7o3fnDPojqxt4KjTudftCi5jjXh7y5xQjXfbldihUAazlzuS+T4ZLqPk8k/L2EEuofDhfUZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gEvP8wUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gEvP8wUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F0B81F00ACA;
	Fri,  4 Sep 2026 05:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499298;
	bh=Qq6poiQjs3SzHwQsNOt7ohCc3H6jX4fx1WFEmduVmz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gEvP8wUBvSr5SOBkvq8WBukefeBm+Fhzv+SqhSs121OT9oHeORH9qX5DWITYyDcFn
	 R4OI4iVGvp61inKZ/NIsjXJfDDHqytBqaKSo31BJmLHdsp7RYxssfbekOoMo3z967t
	 TR3D2ovoTbTCV3GOqZ+pxA3p/0WdoVrdgeFLoayI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Xu Yang <xu.yang_2@nxp.com>,
	Felix Gu <ustc.gu@gmail.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.2 369/713] phy: fsl-imx8mq-usb: fix typec switch leak on probe error path
Date: Fri,  4 Sep 2026 06:55:37 +0200
Message-ID: <20260904045812.099471493@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Gu <ustc.gu@gmail.com>

commit 87a1805b1c346b092c34f96f3806f207792910e1 upstream.

If probe fails after imx95_usb_phy_get_tca() succeeds, the typec
switch leaks because the only cleanup path was in .remove(), which
never runs on probe failure.

Use devm_add_action_or_reset() so the switch is cleaned up on both
probe failure and driver removal. The imx95_usb_phy_put_tca() is no
longer needed, it will be removed in .remove() too.

Fixes: b58f0f86fd61 ("phy: fsl-imx8mq-usb: add tca function driver for imx95")
Cc: stable@vger.kernel.org
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Xu Yang <xu.yang_2@nxp.com>
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Link: https://patch.msgid.link/20260731-imx8mp-usb-phy-improvement-v8-1-2ec8d6b3854d@nxp.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/freescale/phy-fsl-imx8mq-usb.c |   21 +++++++--------------
 1 file changed, 7 insertions(+), 14 deletions(-)

--- a/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
+++ b/drivers/phy/freescale/phy-fsl-imx8mq-usb.c
@@ -173,9 +173,9 @@ static struct typec_switch_dev *tca_blk_
 	return sw;
 }
 
-static void tca_blk_put_typec_switch(struct typec_switch_dev *sw)
+static void tca_blk_put_typec_switch(void *data)
 {
-	typec_switch_unregister(sw);
+	typec_switch_unregister(data);
 }
 
 static void tca_blk_orientation_set(struct tca_blk *tca,
@@ -248,6 +248,7 @@ static struct tca_blk *imx95_usb_phy_get
 	struct device *dev = &pdev->dev;
 	struct resource *res;
 	struct tca_blk *tca;
+	int ret;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
 	if (!res)
@@ -266,17 +267,11 @@ static struct tca_blk *imx95_usb_phy_get
 	tca->orientation = TYPEC_ORIENTATION_NORMAL;
 	tca->sw = tca_blk_get_typec_switch(pdev, imx_phy);
 
-	return tca;
-}
-
-static void imx95_usb_phy_put_tca(struct imx8mq_usb_phy *imx_phy)
-{
-	struct tca_blk *tca = imx_phy->tca;
-
-	if (!tca)
-		return;
+	ret = devm_add_action_or_reset(&pdev->dev, tca_blk_put_typec_switch, tca->sw);
+	if (ret)
+		return ERR_PTR(ret);
 
-	tca_blk_put_typec_switch(tca->sw);
+	return tca;
 }
 
 static u32 phy_tx_vref_tune_from_property(u32 percent)
@@ -741,9 +736,7 @@ static int imx8mq_usb_phy_probe(struct p
 
 static void imx8mq_usb_phy_remove(struct platform_device *pdev)
 {
-	struct imx8mq_usb_phy *imx_phy = platform_get_drvdata(pdev);
 
-	imx95_usb_phy_put_tca(imx_phy);
 }
 
 static struct platform_driver imx8mq_usb_phy_driver = {


