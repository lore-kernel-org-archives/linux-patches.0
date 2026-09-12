Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C8B0430311;
	Sat, 12 Sep 2026 08:43:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202615; cv=none; b=XbcNlCOr5YHUCTgklMvdLgUjPG2iXN2d/mdxZHL+n/5EITL4fdevNvtPaWqLyJSox5nJv+aHPt3rzvv4/nuwoi9pcsR8ctAfgiorQpjmSrsiFTi4IHbuYZN00v/RMSwPAYVLZuSQB2tamuQEEJUjfY85qLKGx/FhJfPNw5EVmSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202615; c=relaxed/simple;
	bh=MuHjWsn4hdk9nekmWp/f5XCxa7+8KelKa434XPttbZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ercTK6xT8LBo6yr/VApLyvu8lGWVtf5tL+U1Y1G5TGNaVB9qP/JHM0yIOOR0jid9yJV2DvyjpgAWuGoPWFtS3pNpizLjk0Ox9x2GoQMMJILuaFfWWx7bCjpcJHCWtR5/cx91O12Vnk8f99JbGGGtPrkiXmuunOOUgihi1xwM0TQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmbS1oR/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmbS1oR/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DD3B1F0089B;
	Sat, 12 Sep 2026 08:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202614;
	bh=JxnalPuIs/WUWyUq8Jlq8c1GKHJV/1ryCrpt25ZT+NM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xmbS1oR/6roQuypciH54TZ39tJ4/XvM+CMKY+UlQUOnIYF53xXq57TQdRikRSFfMj
	 AzQzmxQMCpvAYrnZPCJcGI/78uBDXHEAIT84et55lDOvf8Zg6w/BGGb8Y7J7OyWUtW
	 ivmW9pqkIkV4E8g/900yQBAq1R7DbQT3FxbwAufU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Loic Poulain <loic.poulain@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1186/1815] phy: qcom: qmp-usb: Fix possible NULL-deref on early runtime suspend
Date: Sat, 12 Sep 2026 08:48:56 +0200
Message-ID: <20260912065716.855086060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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
index c5507168e1354..bb905c437a01e 100644
--- a/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
+++ b/drivers/phy/qualcomm/phy-qcom-qmp-usb.c
@@ -1434,6 +1434,8 @@ struct qmp_usb {
 
 	enum phy_mode mode;
 
+	bool phy_initialized;
+
 	struct phy *phy;
 
 	struct clk_fixed_rate pipe_clk_fixed;
@@ -2009,6 +2011,7 @@ static int qmp_usb_power_off(struct phy *phy)
 
 static int qmp_usb_enable(struct phy *phy)
 {
+	struct qmp_usb *qmp = phy_get_drvdata(phy);
 	int ret;
 
 	ret = qmp_usb_init(phy);
@@ -2018,14 +2021,19 @@ static int qmp_usb_enable(struct phy *phy)
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
@@ -2101,7 +2109,7 @@ static int __maybe_unused qmp_usb_runtime_suspend(struct device *dev)
 
 	dev_vdbg(dev, "Suspending QMP phy, mode:%d\n", qmp->mode);
 
-	if (!qmp->phy->init_count) {
+	if (!qmp->phy_initialized) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;
 	}
@@ -2121,7 +2129,7 @@ static int __maybe_unused qmp_usb_runtime_resume(struct device *dev)
 
 	dev_vdbg(dev, "Resuming QMP phy, mode:%d\n", qmp->mode);
 
-	if (!qmp->phy->init_count) {
+	if (!qmp->phy_initialized) {
 		dev_vdbg(dev, "PHY not initialized, bailing out\n");
 		return 0;
 	}
-- 
2.53.0



