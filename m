Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 665733C0630;
	Sat, 17 Oct 2026 17:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258251; cv=none; b=FpT1I+s/R2xaQmxYD8DGrLFdn4Al0eTAYis4pO+6c7g8WqCgnxoogJKhBov15UlDied2qnxu8gouq16AdWRZeo49nlcZ7LeqIT1LZfuMWMINdSdS3X3chzuhwegmMFlGVQH/F0VUZDxXH6DrTp0BRJfmE4TxymH6G7czFrYlrX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258251; c=relaxed/simple;
	bh=xkaaNO5irvuLFE4aSmY7l5Oth4etFefEvcWF0r1CxZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KBP/oZG2Hm9AzE8CygvBmjSb8ZZWXxYvhgRyWo5Mmqq3W4znJcBAXgg1osZJIC1pjvVFPCgopnU923KbCpdfhJIAre06piSMD97E06Y4Ahw8+y7f9752RzzZh2WYWw0zGyvmcNSY3VRuzSXba3+Ys812aK0xnmUfXCVoH/tbQUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xVRLeQms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xVRLeQms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B219E1F000C4;
	Sat, 17 Oct 2026 17:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258250;
	bh=6qmUgTAbh4J6+1HwaOxQeBAOmAgc430uM4IdqIlWGdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xVRLeQmshDOZ1dwOLD2P7FuqLuEmiQ/9GRlbbBWgMjfH9EUCRe/nPZn+WhLzFE/XT
	 qG/QDnAm9nC8bdrX/Dtf1f+yP3irGpxaah3YVuI2NiucTxF87dbUZbX2Q9dU+2gdjV
	 F0BC0vSFtFVDZuh4zMSrKwoxfYoA80CR5fsAT59A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Can Guo <quic_cang@quicinc.com>,
	Nitin Rawat <quic_nitirawa@quicinc.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0822/1674] scsi: ufs: qcom : Refactor phy_power_on/off calls
Date: Sat, 17 Oct 2026 17:51:34 +0200
Message-ID: <20261017160452.227184867@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Nitin Rawat <quic_nitirawa@quicinc.com>

[ Upstream commit 77d2fa54a94574f767d5fb296b6b8e011eba0c8e ]

Commit 3f6d1767b1a0 ("phy: ufs-qcom: Refactor all init steps into
phy_poweron") moved the phy_power_on/off from ufs_qcom_setup_clocks
to suspend/resume func.

To have a better power saving, remove the phy_power_on/off calls from
resume/suspend path and put them back to ufs_qcom_setup_clocks, so that
PHY regulators & clks can be turned on/off along with UFS's clocks.

Since phy phy_power_on is separated out from phy calibrate, make
separate calls to phy_power_on calls from ufs qcom driver.

Co-developed-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Can Guo <quic_cang@quicinc.com>
Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
Link: https://lore.kernel.org/r/20250526153821.7918-11-quic_nitirawa@quicinc.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 5127be409c6c ("scsi: ufs: ufs-qcom: Fix UFS OCP issue during UFS power down (PC=3)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-qcom.c | 58 +++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 31 deletions(-)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index c94824c999ccd..c9bd44ef64870 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -731,26 +731,17 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 	enum ufs_notify_change_status status)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
-	struct phy *phy = host->generic_phy;
 
 	if (status == PRE_CHANGE)
 		return 0;
 
-	if (ufs_qcom_is_link_off(hba)) {
-		/*
-		 * Disable the tx/rx lane symbol clocks before PHY is
-		 * powered down as the PLL source should be disabled
-		 * after downstream clocks are disabled.
-		 */
+	if (!ufs_qcom_is_link_active(hba))
 		ufs_qcom_disable_lane_clks(host);
-		phy_power_off(phy);
 
-		/* reset the connected UFS device during power down */
-		ufs_qcom_device_reset_ctrl(hba, true);
 
-	} else if (!ufs_qcom_is_link_active(hba)) {
-		ufs_qcom_disable_lane_clks(host);
-	}
+	/* reset the connected UFS device during power down */
+	if (ufs_qcom_is_link_off(hba) && host->device_reset)
+		ufs_qcom_device_reset_ctrl(hba, true);
 
 	return ufs_qcom_ice_suspend(host);
 }
@@ -758,26 +749,11 @@ static int ufs_qcom_suspend(struct ufs_hba *hba, enum ufs_pm_op pm_op,
 static int ufs_qcom_resume(struct ufs_hba *hba, enum ufs_pm_op pm_op)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
-	struct phy *phy = host->generic_phy;
 	int err;
 
-	if (ufs_qcom_is_link_off(hba)) {
-		err = phy_power_on(phy);
-		if (err) {
-			dev_err(hba->dev, "%s: failed PHY power on: %d\n",
-				__func__, err);
-			return err;
-		}
-
-		err = ufs_qcom_enable_lane_clks(host);
-		if (err)
-			return err;
-
-	} else if (!ufs_qcom_is_link_active(hba)) {
-		err = ufs_qcom_enable_lane_clks(host);
-		if (err)
-			return err;
-	}
+	err = ufs_qcom_enable_lane_clks(host);
+	if (err)
+		return err;
 
 	return ufs_qcom_ice_resume(host);
 }
@@ -1065,12 +1041,20 @@ static void ufs_qcom_set_caps(struct ufs_hba *hba)
  * @on: If true, enable clocks else disable them.
  * @status: PRE_CHANGE or POST_CHANGE notify
  *
+ * There are certain clocks which comes from the PHY so it needs
+ * to be managed together along with controller clocks which also
+ * provides a better power saving. Hence keep phy_power_off/on calls
+ * in ufs_qcom_setup_clocks, so that PHY's regulators & clks can be
+ * turned on/off along with UFS's clocks.
+ *
  * Return: 0 on success, non-zero on failure.
  */
 static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 				 enum ufs_notify_change_status status)
 {
 	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
+	struct phy *phy = host->generic_phy;
+	int err;
 
 	/*
 	 * In case ufs_qcom_init() is not yet done, simply ignore.
@@ -1089,10 +1073,22 @@ static int ufs_qcom_setup_clocks(struct ufs_hba *hba, bool on,
 				/* disable device ref_clk */
 				ufs_qcom_dev_ref_clk_ctrl(host, false);
 			}
+
+			err = phy_power_off(phy);
+			if (err) {
+				dev_err(hba->dev, "phy power off failed, ret=%d\n", err);
+				return err;
+			}
 		}
 		break;
 	case POST_CHANGE:
 		if (on) {
+			err = phy_power_on(phy);
+			if (err) {
+				dev_err(hba->dev, "phy power on failed, ret = %d\n", err);
+				return err;
+			}
+
 			/* enable the device ref clock for HS mode*/
 			if (ufshcd_is_hs_mode(&hba->pwr_info))
 				ufs_qcom_dev_ref_clk_ctrl(host, true);
-- 
2.53.0



