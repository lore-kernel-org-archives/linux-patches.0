Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17AED4718CC;
	Sat, 12 Sep 2026 11:00:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210813; cv=none; b=mErK7SQYKzQfOlnzMsKlNFTLUh46AjgUBDLZYEDRoi3eU0wNqjBFY0xwipv95BsD+G4Ss9G2Wl28ZSA97+fLE6k0O6BTIZq3+POaowDLel0B23Gl/sCYjHABubqbGh41/eWsKpJAx9cVdgxFM+nCG4QlJzrSOZj3BCwmPXCDNn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210813; c=relaxed/simple;
	bh=5q69shNtBk6QUGzvGj2grdyEpVqKpZj0YA7cwYfMN70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USHADOYkP4zHpIs/MUPpk1NTUBmJAvrPbI5P14cq/MymIBCEhQc6LMl6jukGHV3lvEz7DicutdvkmSMwXnw8F6sX7G4iW2pNBmx2XalhZcD1SaY0xcU8rwVsbpzE+aNGCpfcxxHBiIdfuqdfqF8vKn8mnWZlcDah+P7HrJbN4wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwlfVYvO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwlfVYvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF481F000FF;
	Sat, 12 Sep 2026 11:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210810;
	bh=94Ys7xK4JMMtCm+YlmrTxDInGGKpbir1AaGVGLGteps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NwlfVYvOflXzd7qvexMCdk7UIA1qGzL5ns91hyvM/2fjdwPtSuGYXrc6vanuvdnwK
	 uLp2PceBU8G7OIZ0UYNKKcTP1y7pkYv7Ast2VG40qJTI1aGQIezYp41gT01nnDQBaG
	 f8l3HBsabH3JS5MqmfgQ3bx/brMwpOuSUkwH4/Gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Faisal Hassan <faisal.hassan@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1100/1518] phy: qcom-qmp-combo: Use regulator_bulk_data with init_load_uA for regulator setup
Date: Sat, 12 Sep 2026 08:54:29 +0200
Message-ID: <20260912065648.335180119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Faisal Hassan <faisal.hassan@oss.qualcomm.com>

[ Upstream commit 81d75558406609f311766a37ec4b2c74d7b11ea0 ]

Replace the custom qmp_regulator_data structure with the standard
regulator_bulk_data and use the init_load_uA field to set regulator
load during initialization.

This change simplifies the regulator setup by removing manual
allocation and load configuration logic, and leverages
devm_regulator_bulk_get_const() to automatically apply load settings
before enabling regulators.

Signed-off-by: Faisal Hassan <faisal.hassan@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://patch.msgid.link/20250922135901.2067-1-faisal.hassan@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 8fd2b30d187f ("phy: qcom: qmp-combo: Drop qmp_v4_calibrate_dp_phy")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c | 49 +++--------------------
 1 file changed, 6 insertions(+), 43 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
index 0c611ad34dfe9..ec0643cecaca5 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-combo.c
@@ -1643,14 +1643,9 @@ static const struct qmp_phy_init_tbl x1e80100_usb43dp_pcs_usb_tbl[] = {
 };
 
 /* list of regulators */
-struct qmp_regulator_data {
-	const char *name;
-	unsigned int enable_load;
-};
-
-static struct qmp_regulator_data qmp_phy_vreg_l[] = {
-	{ .name = "vdda-phy", .enable_load = 21800 },
-	{ .name = "vdda-pll", .enable_load = 36000 },
+static struct regulator_bulk_data qmp_phy_vreg_l[] = {
+	{ .supply = "vdda-phy", .init_load_uA = 21800, },
+	{ .supply = "vdda-pll", .init_load_uA = 36000, },
 };
 
 static const u8 qmp_dp_v3_pre_emphasis_hbr3_hbr2[4][4] = {
@@ -1808,7 +1803,7 @@ struct qmp_phy_cfg {
 	const char * const *reset_list;
 	int num_resets;
 	/* regulators to be requested */
-	const struct qmp_regulator_data *vreg_list;
+	const struct regulator_bulk_data *vreg_list;
 	int num_vregs;
 
 	/* array of registers with different offsets */
@@ -3439,39 +3434,6 @@ static const struct dev_pm_ops qmp_combo_pm_ops = {
 			   qmp_combo_runtime_resume, NULL)
 };
 
-static int qmp_combo_vreg_init(struct qmp_combo *qmp)
-{
-	const struct qmp_phy_cfg *cfg = qmp->cfg;
-	struct device *dev = qmp->dev;
-	int num = cfg->num_vregs;
-	int ret, i;
-
-	qmp->vregs = devm_kcalloc(dev, num, sizeof(*qmp->vregs), GFP_KERNEL);
-	if (!qmp->vregs)
-		return -ENOMEM;
-
-	for (i = 0; i < num; i++)
-		qmp->vregs[i].supply = cfg->vreg_list[i].name;
-
-	ret = devm_regulator_bulk_get(dev, num, qmp->vregs);
-	if (ret) {
-		dev_err(dev, "failed at devm_regulator_bulk_get\n");
-		return ret;
-	}
-
-	for (i = 0; i < num; i++) {
-		ret = regulator_set_load(qmp->vregs[i].consumer,
-					cfg->vreg_list[i].enable_load);
-		if (ret) {
-			dev_err(dev, "failed to set load at %s\n",
-				qmp->vregs[i].supply);
-			return ret;
-		}
-	}
-
-	return 0;
-}
-
 static int qmp_combo_reset_init(struct qmp_combo *qmp)
 {
 	const struct qmp_phy_cfg *cfg = qmp->cfg;
@@ -4144,7 +4106,8 @@ static int qmp_combo_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
-	ret = qmp_combo_vreg_init(qmp);
+	ret = devm_regulator_bulk_get_const(dev, qmp->cfg->num_vregs,
+					qmp->cfg->vreg_list, &qmp->vregs);
 	if (ret)
 		return ret;
 
-- 
2.53.0



