Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4271B26B94F;
	Tue,  8 Apr 2025 12:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115856; cv=none; b=JdhD7ADZ/Z2ChJPbdeKuKtmoOyzAP866COnWTUfhcZkCxwVDZx4orIi1Egqu30S9t873ew4R0hwzLEYrIaeMEKXqYMzQXE3Ztz6KOYs2MWQr2n9ahiWazmt3ZVjpVzVjCcvjLcNh+diLY7Ts5xd2cF82liudxhkVsp4hgtGCOrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115856; c=relaxed/simple;
	bh=WnvVL7T1rXhdmA5gy7PIlRiyus1hgI8qMTRDp0JFGbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IpXTrW8PJ88Ee7k8g5qhdIBVDjlKpMYdEjIHq7cuGGef/IIc+mhnPQ1jEnQMJ/+TXzcUP2udB5kjPmFjg9EKgyJvwiQAjRmfZm3p1f3pvcw8QIx1fs6CQ/208b678NNCIWFD0gO3paxUQaSbHMNjcDBbOUvuSl2Eqv8QQ8gZIr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2ckGRiC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2ckGRiC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C62F6C4CEE5;
	Tue,  8 Apr 2025 12:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115856;
	bh=WnvVL7T1rXhdmA5gy7PIlRiyus1hgI8qMTRDp0JFGbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A2ckGRiCU0bsckW1XyJOobO4axJeiIbiuhPsz/pK2pN252L9ClyMjbngOBDtepRjb
	 WBCDO8iaOT6a26Z/RMfuJBtjk26vl5ouOEkZPiaYvWFmg4G3ZTCDlGLWlp6wTLETXt
	 u43EHIQbu3rPMPPo4Nj8tS2ZZXgzPu0EG4QTzfYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthias Proske <email@matthias-proske.de>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 131/204] wifi: brcmfmac: keep power during suspend if board requires it
Date: Tue,  8 Apr 2025 12:51:01 +0200
Message-ID: <20250408104824.143072158@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Proske <email@matthias-proske.de>

[ Upstream commit 8c3170628a9ce24a59647bd24f897e666af919b8 ]

After commit 92cadedd9d5f ("brcmfmac: Avoid keeping power to SDIO card
unless WOWL is used"), the wifi adapter by default is turned off on
suspend and then re-probed on resume.

This conflicts with some embedded boards that require to remain powered.
They will fail on resume with:

brcmfmac: brcmf_sdio_bus_rxctl: resumed on timeout
ieee80211 phy1: brcmf_bus_started: failed: -110
ieee80211 phy1: brcmf_attach: dongle is not responding: err=-110
brcmfmac: brcmf_sdio_firmware_callback: brcmf_attach failed

This commit checks for the Device Tree property 'cap-power-off-cards'.
If this property is not set, it means that we do not have the capability
to power off and should therefore remain powered.

Signed-off-by: Matthias Proske <email@matthias-proske.de>
Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Link: https://patch.msgid.link/20250212185941.146958-2-email@matthias-proske.de
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      | 20 ++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
index 9217e9f6e9076..7cd8ec6f515a4 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c
@@ -1151,6 +1151,7 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 	struct brcmf_bus *bus_if;
 	struct brcmf_sdio_dev *sdiodev;
 	mmc_pm_flag_t sdio_flags;
+	bool cap_power_off;
 	int ret = 0;
 
 	func = container_of(dev, struct sdio_func, dev);
@@ -1158,19 +1159,23 @@ static int brcmf_ops_sdio_suspend(struct device *dev)
 	if (func->num != 1)
 		return 0;
 
+	cap_power_off = !!(func->card->host->caps & MMC_CAP_POWER_OFF_CARD);
 
 	bus_if = dev_get_drvdata(dev);
 	sdiodev = bus_if->bus_priv.sdio;
 
-	if (sdiodev->wowl_enabled) {
+	if (sdiodev->wowl_enabled || !cap_power_off) {
 		brcmf_sdiod_freezer_on(sdiodev);
 		brcmf_sdio_wd_timer(sdiodev->bus, 0);
 
 		sdio_flags = MMC_PM_KEEP_POWER;
-		if (sdiodev->settings->bus.sdio.oob_irq_supported)
-			enable_irq_wake(sdiodev->settings->bus.sdio.oob_irq_nr);
-		else
-			sdio_flags |= MMC_PM_WAKE_SDIO_IRQ;
+
+		if (sdiodev->wowl_enabled) {
+			if (sdiodev->settings->bus.sdio.oob_irq_supported)
+				enable_irq_wake(sdiodev->settings->bus.sdio.oob_irq_nr);
+			else
+				sdio_flags |= MMC_PM_WAKE_SDIO_IRQ;
+		}
 
 		if (sdio_set_host_pm_flags(sdiodev->func1, sdio_flags))
 			brcmf_err("Failed to set pm_flags %x\n", sdio_flags);
@@ -1192,18 +1197,19 @@ static int brcmf_ops_sdio_resume(struct device *dev)
 	struct brcmf_sdio_dev *sdiodev = bus_if->bus_priv.sdio;
 	struct sdio_func *func = container_of(dev, struct sdio_func, dev);
 	int ret = 0;
+	bool cap_power_off = !!(func->card->host->caps & MMC_CAP_POWER_OFF_CARD);
 
 	brcmf_dbg(SDIO, "Enter: F%d\n", func->num);
 	if (func->num != 2)
 		return 0;
 
-	if (!sdiodev->wowl_enabled) {
+	if (!sdiodev->wowl_enabled && cap_power_off) {
 		/* bus was powered off and device removed, probe again */
 		ret = brcmf_sdiod_probe(sdiodev);
 		if (ret)
 			brcmf_err("Failed to probe device on resume\n");
 	} else {
-		if (sdiodev->settings->bus.sdio.oob_irq_supported)
+		if (sdiodev->wowl_enabled && sdiodev->settings->bus.sdio.oob_irq_supported)
 			disable_irq_wake(sdiodev->settings->bus.sdio.oob_irq_nr);
 
 		brcmf_sdiod_freezer_off(sdiodev);
-- 
2.39.5



