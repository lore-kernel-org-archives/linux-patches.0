Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF13946AA73;
	Sat, 12 Sep 2026 10:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210129; cv=none; b=PlyxofpHGwk78GkVduCG+giW4/DFxI/rAUVsU3POm+TghA1r1akwXWjoaMQgujk9PmoJvhs1UHM05gbgJRz9vr28rHk2C+MlIszIpdzEh8W7ElnFGOJYctLN4ZISI1FZxzM6GUlgZrg01oRTUkL5CbN0/iqYyLYhc3u/pB2xG1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210129; c=relaxed/simple;
	bh=SfUvuCj6OxtTOg7XKaYaAHNq/2DlcKbwCf5YGhnKOds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DMm/1HBs4OAmcP5UK0H/9sg4IVbYBGvUY9DQoPqp6hVCjWpGRlnX3wuSln3v8kAj3vBjm6MIgIMJlK2Sx4A+9CWBWNzFRrTHd3v7mgEcIdKQClmzrDYaa1+dbvBl4fzyrL6lL5dLBMVYLd95hBexdMRyHViHxWZXUx0c+52kNy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NhJZBM4+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NhJZBM4+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54281F0089A;
	Sat, 12 Sep 2026 10:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210124;
	bh=a9OMvtwiFEV74HUh6OBfg7Plt9ILGrcDvpYYVwO0OVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NhJZBM4+NvSHUnd6GDZwBRWwqZ/mJRmpL3YZIx39Whjpod4dOpYR4s0q16MKOtTk4
	 1vMMylBtRhiR4myolVPFFqEJ8XwEf2gm8d7hfNb01e0KpKdtETlGRsJQItnWux4Eym
	 cF0S46y1m+7JrfoPNApvkgiGBZBcHpvBhHWLKl8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0960/1518] phy: qcom: qmp-usb: Fix possible NULL-deref on early runtime suspend
Date: Sat, 12 Sep 2026 08:52:09 +0200
Message-ID: <20260912065645.177180068@linuxfoundation.org>
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

[ Upstream commit 142c5593379273264474f31d5956b1a0065cd576 ]

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
Signed-off-by: Loic Poulain <loic.poulain@oss.qualcomm.com>
Link: https://patch.msgid.link/20260722-qcom-usb-phy-fix-null-v6-6-534f7e61b9a6@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
index ed646a7e705ba..e7dd140ad29e7 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
@@ -1300,6 +1300,8 @@ struct qmp_usb {
 
 	enum phy_mode mode;
 
+	bool phy_initialized;
+
 	struct phy *phy;
 
 	struct clk_fixed_rate pipe_clk_fixed;
@@ -1848,6 +1850,7 @@ static int qmp_usb_power_off(struct phy *phy)
 
 static int qmp_usb_enable(struct phy *phy)
 {
+	struct qmp_usb *qmp = phy_get_drvdata(phy);
 	int ret;
 
 	ret = qmp_usb_init(phy);
@@ -1857,14 +1860,19 @@ static int qmp_usb_enable(struct phy *phy)
 	ret = qmp_usb_power_on(phy);
 	if (ret)
 		qmp_usb_exit(phy);
+	else
+		qmp->phy_initialized = true;
 
 	return ret;
 }
 
 static int qmp_usb_disable(struct phy *phy)
 {
+	struct qmp_usb *qmp = phy_get_drvdata(phy);
 	int ret;
 
+	qmp->phy_initialized = false;
+
 	ret = qmp_usb_power_off(phy);
 	if (ret)
 		return ret;
@@ -1940,7 +1948,7 @@ static int __maybe_unused qmp_usb_runtime_suspend(struct device *dev)
 
 	dev_vdbg(dev, "Suspending QMP phy, mode:%d\n", qmp->mode);
 
-	if (!qmp->phy->init_count) {
+	if (!qmp->phy_initialized) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;
 	}
@@ -1960,7 +1968,7 @@ static int __maybe_unused qmp_usb_runtime_resume(struct device *dev)
 
 	dev_vdbg(dev, "Resuming QMP phy, mode:%d\n", qmp->mode);
 
-	if (!qmp->phy->init_count) {
+	if (!qmp->phy_initialized) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;
 	}
-- 
2.53.0



