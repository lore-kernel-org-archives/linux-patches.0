Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24411468C20;
	Sat, 12 Sep 2026 10:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210117; cv=none; b=hnYBuXO71JtwBgMVHI6o1I/Sa6LAtcEFCjXGKD6WqNAEoqaNyULYNNHFk62ioJtYqG4MHk9qd6x3E+zkESosqeFlmpNPBoVl/cu+nJirMilLxd0acz5JWH57sXWgBQIkyyRY1/KS43c5pdzaXTRaDgWId/ljg/6aR/o6cHWjt4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210117; c=relaxed/simple;
	bh=Q/D3ZYUlL1MBGWN/PW0WqoklW/FjbG9Sw+lYuJTC8L0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFQAFcUeDGxgJ7msSDR3W5FKG6LaINnJY/W3Iu+ija3YePwJEx+MM2KqZeF4S7d5lVwohxyX2O4rR866EOkrt/PMaqUrVAWmZtNv10kuPPWeEdi8kiz3NQ6rzMk8SDm2ZgcQ636z16bBN6icEzzJDCZP04zZ5r+p4squQ+wHd2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PZrAvWH/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PZrAvWH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7DF1F00893;
	Sat, 12 Sep 2026 10:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210114;
	bh=HJKT1NeZHmYoKdqHyQnX8nNaWJSRxX2NrSH8EBmPEEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PZrAvWH/MarHExjWKYAM5qZn9WaIAVY23Zzcy9wQLOdEf8KDmj70Wljyfwni/N4Gx
	 0AHvwUqdYuoIvGwlOeapiLJqGRdM1eec72GVPDRiMFkj9ReCbZu4RHPURus9PCMmAJ
	 hKyOsPW/zxDMa1wUYK+fi427fu+eUBBaKX7Lr23Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0958/1518] phy: qcom: qmp-usb-legacy: Fix possible NULL-deref on early runtime suspend
Date: Sat, 12 Sep 2026 08:52:07 +0200
Message-ID: <20260912065645.131442246@linuxfoundation.org>
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

From: Loic Poulain <loic.poulain@oss.qualcomm.com>

[ Upstream commit 8e3687f7e18fe84372e86875709d56c37e7525a8 ]

There is a small window where the runtime suspend callback may run
after pm_runtime_enable() and before pm_runtime_forbid(). In this
case, a crash occurs because runtime suspend/resume dereferences
qmp->phy pointer, which is not yet initialized:
        `if (!qmp->phy->init_count) {`

This can also happen if user re-enables runtime-pm via the sysfs
attribute before qmp phy is initialized.

Similarly to other qcom phy drivers, introduce a qmp->phy_initialized
variable that can be used to avoid relying on the possibly uninitialized
phy pointer.

Fixes: e464a3180a43 ("phy: qcom-qmp-usb: split off the legacy USB+dp_com support")
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260722-qcom-usb-phy-fix-null-v6-3-534f7e61b9a6@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usb-legacy.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-usb-legacy.c b/drivers/phy/qualcomm/phy-qcom-qmp-usb-legacy.c
index 8bf951b0490cf..fc490589c8e48 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb-legacy.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb-legacy.c
@@ -542,6 +542,8 @@ struct qmp_usb {
 
 	enum phy_mode mode;
 
+	bool phy_initialized;
+
 	struct phy *phy;
 
 	struct clk_fixed_rate pipe_clk_fixed;
@@ -895,6 +897,7 @@ static int qmp_usb_legacy_power_off(struct phy *phy)
 
 static int qmp_usb_legacy_enable(struct phy *phy)
 {
+	struct qmp_usb *qmp = phy_get_drvdata(phy);
 	int ret;
 
 	ret = qmp_usb_legacy_init(phy);
@@ -904,14 +907,19 @@ static int qmp_usb_legacy_enable(struct phy *phy)
 	ret = qmp_usb_legacy_power_on(phy);
 	if (ret)
 		qmp_usb_legacy_exit(phy);
+	else
+		qmp->phy_initialized = true;
 
 	return ret;
 }
 
 static int qmp_usb_legacy_disable(struct phy *phy)
 {
+	struct qmp_usb *qmp = phy_get_drvdata(phy);
 	int ret;
 
+	qmp->phy_initialized = false;
+
 	ret = qmp_usb_legacy_power_off(phy);
 	if (ret)
 		return ret;
@@ -988,7 +996,7 @@ static int __maybe_unused qmp_usb_legacy_runtime_suspend(struct device *dev)
 
 	dev_vdbg(dev, "Suspending QMP phy, mode:%d\n", qmp->mode);
 
-	if (!qmp->phy->init_count) {
+	if (!qmp->phy_initialized) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;
 	}
@@ -1009,7 +1017,7 @@ static int __maybe_unused qmp_usb_legacy_runtime_resume(struct device *dev)
 
 	dev_vdbg(dev, "Resuming QMP phy, mode:%d\n", qmp->mode);
 
-	if (!qmp->phy->init_count) {
+	if (!qmp->phy_initialized) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;
 	}
-- 
2.53.0



