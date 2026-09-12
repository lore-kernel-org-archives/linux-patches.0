Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E70B33939B3;
	Sat, 12 Sep 2026 19:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239807; cv=none; b=t5ZDgGs/GBkj0tpb3pkvYRB4GMRkqSh66e4TqaCuLjxVcGcrIkSbtHrlDaHo5xIKKrEGnjzT1N0Xv9ldNNA6TxfVtxZqDoOOYXKB/2l/VnopxY7I5ATn46vN0YThnJqD+NOG/iNncx/L6SOL8GPlE0si4m5VXRrI+6EFSnorYqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239807; c=relaxed/simple;
	bh=YU/fCr4CXjHRBW7bQnJctSlruogcGFjLQLJFTB5Xm4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uut6E7nO3wHTOwsib9N+a8k4qqUuWkCqPemXWpLVOBn7eBKSfE2tMxso3hKpxpkI0mrlFlfCkwUbtKgKYyN1VSOntiEz75ihcGTCfrw21L5Wcm/Z7aFMzs4+9gqWqKbKLxVFrvTNIilkmtoJLViD2vZBy3brDY2q+p0+RtBRZBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KFamgg0z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KFamgg0z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 095311F000FF;
	Sat, 12 Sep 2026 19:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239805;
	bh=S2tQF/7zF0uNGQQKJF7ewTA+NKEmO4WvI0DAMb/uCPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KFamgg0zKvqDUqcHVoruRwOxpBNKGFxyQ4bLmyiN8qmiafd0TgtxPUl6EapTolB7s
	 yKJeeIURl0tR81pK4ZLWCoomyp3v9AVNs4mqSsXiXEKj4aXJt/eWZNmvSjdwZlXBoI
	 M4TJsi5/VlalBJxMSoj/hz9Vl/9j8ZNxwm/nYYtw=
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
Subject: [PATCH 5.15 739/935] phy: qcom: snps-femto-v2: Fix possible NULL-deref on early runtime suspend
Date: Sat, 12 Sep 2026 09:02:49 +0200
Message-ID: <20260912065543.780595652@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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



