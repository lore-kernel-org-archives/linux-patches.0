Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AF7B478E53;
	Tue, 16 Jun 2026 16:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628966; cv=none; b=E/jVzcW46GFpGisOkZ+Llobsn2XC4Wf/hMjMxH808iRYGxm1deksJY40nZaK64kWe908aLNvWXi7GNFaXs4Z7f+L+6FOlaQaGYJx0LCI1vmyHJxNVHOckcK0FAVU4MACHKnEms7x8Y7aLDcn1/NIFvPBA4ADzbp01nAK0WaycuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628966; c=relaxed/simple;
	bh=3SiIdjqIA1AUlYVIHObTe4TycR1sSIQLvP7+Axt9nSs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A47XvCTbndEGekMR9Gb7Ei78qOnXCdFDf3edgcib+BPnTeGPcsYQydcK7qDHUnM4ujmAt286Zl/rntrqDgElCr5qfllkVC3Ys7ejxub2or8n6nijoowBlf0G0lRDYor+PgY1clKg9caBqtoawIPXY+SyHAlRtO84Auy9KMKvgHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7HlGWZc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7HlGWZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C785B1F00A3A;
	Tue, 16 Jun 2026 16:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628964;
	bh=Y4kwhRSN4t8xY4SOtFeVE8xOs3WjclirCtSaXmwnnm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c7HlGWZcnmDBbZX8/fv2Vrjg4bS/YXP05ZNTulmm+WwGjDGY7tKGrdPR3t8zCSzRT
	 FEAPcVC0SGH0SFo7m5Emi8hqymxRPGCWoHm5c6ZchL47nYworrmF0ZFlxLicetz86m
	 2KTF45sz0Cg30Gs/DRt0noZvPjAr9SdGN9w9jLWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wei-Cheng Chen <weichengc@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 196/452] xhci: tegra: Fix ghost USB device on dual-role port unplug
Date: Tue, 16 Jun 2026 20:27:03 +0530
Message-ID: <20260616145128.123261530@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wei-Cheng Chen <weichengc@nvidia.com>

[ Upstream commit 5a4c828b8b29b47534814ade26d9aee09d5101fc ]

When a USB device is unplugged from the dual-role port, the device-mode
path in tegra_xhci_id_work() explicitly clears both SS and HS port power
via direct hub_control ClearPortFeature(POWER) calls. This preempts the
xHCI controller's normal disconnect processing -- PORT_CSC is never
generated, the USB core never sees the disconnect, and the device remains
in its internal tree as a ghost visible in lsusb.

Add an otg_set_port_power flag to control whether the dual-role switch
path performs explicit port power management. SoCs that need it
(Tegra124 / Tegra210 / Tegra186) set the flag; later SoCs (Tegra194 and
beyond) rely on the PHY mode change to handle disconnect naturally and
skip all port power calls.

Within the port power path, otg_reset_sspi additionally gates the SSPI
reset sequence on host-mode entry for SoCs that require it.

Flags set per SoC:
  Tegra124, Tegra186  -> otg_set_port_power
  Tegra210            -> otg_set_port_power, otg_reset_sspi
  Tegra194 and later  -> (none)

[ Backport to 6.6.y: keep the host-mode snapshot in the existing
  tegra->lock section, retain pm_runtime_mark_last_busy() in the host
  port-power path, and resolve context around the SoC ops/Tegra234
  entries. ]

Fixes: f836e7843036 ("usb: xhci-tegra: Add OTG support")
Cc: stable@vger.kernel.org
Signed-off-by: Wei-Cheng Chen <weichengc@nvidia.com>
Link: https://patch.msgid.link/20260505112630.217704-1-weichengc@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-tegra.c | 79 ++++++++++++++++++++---------------
 1 file changed, 45 insertions(+), 34 deletions(-)

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index 89b3079194d7b3..2eb1aa25be1d37 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -243,6 +243,7 @@ struct tegra_xusb_soc {
 	bool has_ipfs;
 	bool lpm_support;
 	bool otg_reset_sspi;
+	bool otg_set_port_power;
 
 	bool has_bar2;
 };
@@ -1346,14 +1347,17 @@ static void tegra_xhci_id_work(struct work_struct *work)
 	struct tegra_xusb_mbox_msg msg;
 	struct phy *phy = tegra_xusb_get_phy(tegra, "usb2",
 						    tegra->otg_usb2_port);
+	bool host_mode;
 	u32 status;
 	int ret;
 
-	dev_dbg(tegra->dev, "host mode %s\n", tegra->host_mode ? "on" : "off");
-
 	mutex_lock(&tegra->lock);
 
-	if (tegra->host_mode)
+	host_mode = tegra->host_mode;
+
+	dev_dbg(tegra->dev, "host mode %s\n", host_mode ? "on" : "off");
+
+	if (host_mode)
 		phy_set_mode_ext(phy, PHY_MODE_USB_OTG, USB_ROLE_HOST);
 	else
 		phy_set_mode_ext(phy, PHY_MODE_USB_OTG, USB_ROLE_NONE);
@@ -1364,42 +1368,44 @@ static void tegra_xhci_id_work(struct work_struct *work)
 								    tegra->otg_usb2_port);
 
 	pm_runtime_get_sync(tegra->dev);
-	if (tegra->host_mode) {
-		/* switch to host mode */
-		if (tegra->otg_usb3_port >= 0) {
-			if (tegra->soc->otg_reset_sspi) {
-				/* set PP=0 */
-				tegra_xhci_hc_driver.hub_control(
-					xhci->shared_hcd, GetPortStatus,
-					0, tegra->otg_usb3_port+1,
-					(char *) &status, sizeof(status));
-				if (status & USB_SS_PORT_STAT_POWER)
-					tegra_xhci_set_port_power(tegra, false,
-								  false);
-
-				/* reset OTG port SSPI */
-				msg.cmd = MBOX_CMD_RESET_SSPI;
-				msg.data = tegra->otg_usb3_port+1;
-
-				ret = tegra_xusb_mbox_send(tegra, &msg);
-				if (ret < 0) {
-					dev_info(tegra->dev,
-						"failed to RESET_SSPI %d\n",
-						ret);
+	if (tegra->soc->otg_set_port_power) {
+		if (host_mode) {
+			/* switch to host mode */
+			if (tegra->otg_usb3_port >= 0) {
+				if (tegra->soc->otg_reset_sspi) {
+					/* set PP=0 */
+					tegra_xhci_hc_driver.hub_control(
+						xhci->shared_hcd, GetPortStatus,
+						0, tegra->otg_usb3_port+1,
+						(char *) &status, sizeof(status));
+					if (status & USB_SS_PORT_STAT_POWER)
+						tegra_xhci_set_port_power(tegra, false,
+									  false);
+
+					/* reset OTG port SSPI */
+					msg.cmd = MBOX_CMD_RESET_SSPI;
+					msg.data = tegra->otg_usb3_port+1;
+
+					ret = tegra_xusb_mbox_send(tegra, &msg);
+					if (ret < 0) {
+						dev_info(tegra->dev,
+							"failed to RESET_SSPI %d\n",
+							ret);
+					}
 				}
-			}
 
-			tegra_xhci_set_port_power(tegra, false, true);
-		}
+				tegra_xhci_set_port_power(tegra, false, true);
+			}
 
-		tegra_xhci_set_port_power(tegra, true, true);
-		pm_runtime_mark_last_busy(tegra->dev);
+			tegra_xhci_set_port_power(tegra, true, true);
+			pm_runtime_mark_last_busy(tegra->dev);
 
-	} else {
-		if (tegra->otg_usb3_port >= 0)
-			tegra_xhci_set_port_power(tegra, false, false);
+		} else {
+			if (tegra->otg_usb3_port >= 0)
+				tegra_xhci_set_port_power(tegra, false, false);
 
-		tegra_xhci_set_port_power(tegra, true, false);
+			tegra_xhci_set_port_power(tegra, true, false);
+		}
 	}
 	pm_runtime_put_autosuspend(tegra->dev);
 }
@@ -2497,6 +2503,7 @@ static const struct tegra_xusb_soc tegra124_soc = {
 	.scale_ss_clock = true,
 	.has_ipfs = true,
 	.otg_reset_sspi = false,
+	.otg_set_port_power = true,
 	.ops = &tegra124_ops,
 	.mbox = {
 		.cmd = 0xe4,
@@ -2535,6 +2542,7 @@ static const struct tegra_xusb_soc tegra210_soc = {
 	.scale_ss_clock = false,
 	.has_ipfs = true,
 	.otg_reset_sspi = true,
+	.otg_set_port_power = true,
 	.ops = &tegra124_ops,
 	.mbox = {
 		.cmd = 0xe4,
@@ -2578,6 +2586,7 @@ static const struct tegra_xusb_soc tegra186_soc = {
 	.scale_ss_clock = false,
 	.has_ipfs = false,
 	.otg_reset_sspi = false,
+	.otg_set_port_power = true,
 	.ops = &tegra124_ops,
 	.mbox = {
 		.cmd = 0xe4,
@@ -2611,6 +2620,7 @@ static const struct tegra_xusb_soc tegra194_soc = {
 	.scale_ss_clock = false,
 	.has_ipfs = false,
 	.otg_reset_sspi = false,
+	.otg_set_port_power = false,
 	.ops = &tegra124_ops,
 	.mbox = {
 		.cmd = 0x68,
@@ -2643,6 +2653,7 @@ static const struct tegra_xusb_soc tegra234_soc = {
 	.scale_ss_clock = false,
 	.has_ipfs = false,
 	.otg_reset_sspi = false,
+	.otg_set_port_power = false,
 	.ops = &tegra234_ops,
 	.mbox = {
 		.cmd = XUSB_BAR2_ARU_MBOX_CMD,
-- 
2.53.0



