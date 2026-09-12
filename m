Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F8903921DE;
	Sat, 12 Sep 2026 19:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243133; cv=none; b=ipzfZjTyZmilUW0sQq7YBrR3hNPg3+oy9NvoPI9Fou7aedIIa7BfpP7t17qRnT2/DbYkkWTmf4Gg+nmI6SIzknbmZH1Z9jW4sR8qa+Sby3U+JlIle92K5dL4gvsZSoojdHDZSKNHi9x6v6NDGQ/mVjNQUq4q2ottMPnm9PUmrjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243133; c=relaxed/simple;
	bh=YjnYkQAsqOw+XVB7bJ1Tv+2jAFrTjvdS93uE3jd79lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Blj/AIJqLjfn04YwdzSTfL8dYdUscdTWAXxWWArlHxnUvPAX6otVbcZOO165Wr1lqAMXuE+RkSaebV4tQLe/8IwZEumbkDHufjiLfYUMdk0/eS6/eu552PU1LEvXewY8T6oS2y37BK5HDCPoRMfXcyHiWF51eZGC2QlVjPJiJE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dy4i9O9W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dy4i9O9W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E0FF1F00893;
	Sat, 12 Sep 2026 19:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243129;
	bh=qcei63blYXDa4E6XOnbnl2uYd/LttsjzR9cVeW5ppzg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dy4i9O9WW4vCeCUdBnmla3k279JJl0LSaQH/N3zdJryuiWH4weoyhh6+SrdtCDk7Y
	 W3YXh0CGckdKB0rMsDQzLZRRRJ7Uwgkx/ZrEbT90HhthybSRx6n2PtM6yfzjOy/GOB
	 7mwfeBdyJSQuX1p3lMQGSzif/HXUo/nLZsmtFybE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 645/798] phy: qcom: snps-femto-v2: Fix possible NULL-deref on early runtime suspend
Date: Sat, 12 Sep 2026 09:04:33 +0200
Message-ID: <20260912065531.899448737@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit c271a6926ea7d3c9566b033d63fd4e8c488dc860 ]

Runtime PM must be enabled before creating the PHY, since phy_create()
only enables runtime PM on the PHY device if it is already enabled on
this parent device. However, the runtime PM callbacks dereference the
hsphy instance, which is not yet ready, leaving a window where a suspend
callback may trigger a NULL pointer dereference.

Take a runtime PM usage reference with pm_runtime_get_noresume() before
enabling runtime PM and release it once the PHY has been created, so that
no runtime suspend can run before the PHY is ready. This also prevents a
short window where an unnecessary runtime suspend can occur.

Use the devres-managed version to ensure PM runtime is symmetrically
disabled during driver removal for proper cleanup.

Fixes: 0d75f508a9d5 ("phy: qcom-snps: Add runtime suspend and resume handlers")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260722-qcom-usb-phy-fix-null-v6-5-534f7e61b9a6@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c | 26 ++++++++++++++-----
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c b/drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c
index 173d166ed8295..2a49da9832d8a 100644
--- a/drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c
+++ b/drivers/phy/qualcomm/phy-qcom-snps-femto-v2.c
@@ -345,8 +345,18 @@ static int qcom_snps_hsphy_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, ret,
 				     "failed to get regulator supplies\n");
 
+	/*
+	 * Enable runtime PM before creating the PHY, phy_create() only enables
+	 * it on the PHY device if already enabled on the parent. Hold a usage
+	 * reference so callbacks cannot run before the PHY is ready.
+	 */
+	pm_runtime_get_noresume(dev);
 	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
+	ret = devm_pm_runtime_enable(dev);
+	if (ret) {
+		pm_runtime_put_noidle(dev);
+		return ret;
+	}
 	/*
 	 * Prevent runtime pm from being ON by default. Users can enable
 	 * it using power/control in sysfs.
@@ -357,6 +367,7 @@ static int qcom_snps_hsphy_probe(struct platform_device *pdev)
 	if (IS_ERR(generic_phy)) {
 		ret = PTR_ERR(generic_phy);
 		dev_err(dev, "failed to create phy, %d\n", ret);
+		pm_runtime_put_noidle(dev);
 		return ret;
 	}
 	hsphy->phy = generic_phy;
@@ -365,12 +376,15 @@ static int qcom_snps_hsphy_probe(struct platform_device *pdev)
 	phy_set_drvdata(generic_phy, hsphy);
 
 	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
-	if (!IS_ERR(phy_provider))
-		dev_dbg(dev, "Registered Qcom-SNPS HS phy\n");
-	else
-		pm_runtime_disable(dev);
+	if (IS_ERR(phy_provider)) {
+		pm_runtime_put_noidle(dev);
+		return PTR_ERR(phy_provider);
+	}
 
-	return PTR_ERR_OR_ZERO(phy_provider);
+	dev_dbg(dev, "Registered Qcom-SNPS HS phy\n");
+	pm_runtime_put(dev);
+
+	return 0;
 }
 
 static struct platform_driver qcom_snps_hsphy_driver = {
-- 
2.53.0



