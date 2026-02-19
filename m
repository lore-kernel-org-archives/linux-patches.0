Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7427B27B35B;
	Thu, 19 Feb 2026 02:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771466685; cv=none; b=SoVIhOiyRuXfDJ5qzGl8Fq6fcQv3kcoXJG2IMsdN0KeiDwzQ9x4P/SOm1kqX1Fur4MVl7dBhjeyHz3ZtRTBeTt/Mi97tmCXRl56GRrIeFV89O19z0rGo3auEDfi4rXyU99OQDImD0n9xhpFCwE2GzbBxnK/o6WDQYADeli5nDXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771466685; c=relaxed/simple;
	bh=tWd3nYljE5C0DdvH//bhaWqP3c5xubS259NXSxl+bX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoqOny0KipcS7aBHVfuPfattp1gf7Fh/OoH3LKftTxOzcUn9F3XOTQtUgJ1coDjrKnnWrrD77m8ZbAJPhPoifwkqKjT3S2O5zU0zfoH+tYh6RRzlojaS/tM8pJWXkbxCez4LPZ24eN6rBOVexljy+w/fqYdvuY2K3vXIzhX8NPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kdphkx7k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kdphkx7k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83D72C2BC86;
	Thu, 19 Feb 2026 02:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771466685;
	bh=tWd3nYljE5C0DdvH//bhaWqP3c5xubS259NXSxl+bX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kdphkx7kPawcD+xEv3s+0q6bKNeiUG+UAUUKIXyuEYcMozTpEZfaVeTOwhminDTla
	 KRPtZwy8Syg0xAPaKOr8GAVjCtlHYerW5y3LY2YKdiffGFGk5lUin+heVAjQ5vms7Q
	 GjzkjrHbSRe6mLKOi4wY7ZXMRqn92kZem5Y5k0LT0T9hUDU9VlclNRhejxNGhyOdkt
	 yoCxexjkxanu7N49Jief0GALxWbhL0nTIi4GttVAdrjRG7KAz4vUOHZOxkT1fxySm3
	 J4WqWFOTZ5lxj206hI5kxPyuZTdsKXHNeODiSwZZXOQEH335+ziO3TW5zOV1XQXk42
	 AcI5MpzNsJAuw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Matthew Schwartz <matthew.schwartz@linux.dev>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	ulf.hansson@linaro.org,
	linux-kernel@vger.kernel.org,
	linux-mmc@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-6.1] mmc: rtsx: reset power state on suspend
Date: Wed, 18 Feb 2026 21:03:53 -0500
Message-ID: <20260219020422.1539798-17-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260219020422.1539798-1-sashal@kernel.org>
References: <20260219020422.1539798-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.2
Content-Transfer-Encoding: 8bit

From: Matthew Schwartz <matthew.schwartz@linux.dev>

[ Upstream commit eac85fbd0867c25ac517f58fae401d65c627edff ]

When rtsx_pci suspends, the card reader hardware powers off but the sdmmc
driver's prev_power_state remains as MMC_POWER_ON. This causes sd_power_on
to skip reinitialization on the next I/O request, leading to DMA transfer
timeouts and errors on resume 20% of the time.

Add a power_off slot callback so the PCR can notify the sdmmc driver
during suspend. The sdmmc driver resets prev_power_state, and sd_request
checks this to reinitialize the card before the next I/O.

Signed-off-by: Matthew Schwartz <matthew.schwartz@linux.dev>
Link: https://patch.msgid.link/20260105060236.400366-2-matthew.schwartz@linux.dev
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Good - `sd_power_on` has been part of this file since initial creation.
The forward declaration added in the patch is just to allow the function
(defined later in the file) to be called from `sd_request` (defined
earlier).

### Analysis Summary

**What problem the commit solves:**

This commit fixes a suspend/resume regression in Realtek PCI-E SD card
readers where, after suspend, 20% of resume attempts fail with DMA
transfer timeouts because:

1. During suspend, `rtsx_pci_power_off()` powers down the card reader
   hardware
2. But the sdmmc driver's `prev_power_state` remains `MMC_POWER_ON`
3. On resume, when `sd_power_on()` is called, it sees `prev_power_state
   == MMC_POWER_ON` at line 912 and returns immediately without
   reinitializing the hardware
4. The first I/O attempt then fails with DMA timeout because the
   hardware was never re-powered

**The fix has three parts:**
1. Adds a `power_off` callback to `struct rtsx_slot` (1 line in header)
2. In the PCR suspend paths (both system and runtime), calls
   `slot->power_off()` to notify the sdmmc driver before powering off
   hardware
3. In the sdmmc driver: implements `rtsx_pci_sdmmc_power_off()` to reset
   `prev_power_state = MMC_POWER_OFF`, and adds a check in
   `sd_request()` to call `sd_power_on()` if `prev_power_state ==
   MMC_POWER_OFF`

**Stable kernel criteria assessment:**
- **Fixes a real bug:** Yes - 20% failure rate on resume with SD card
  operations
- **Obviously correct:** Yes - the logic is straightforward: notify the
  driver that hardware was powered off so it reinitializes properly
- **Small and contained:** Yes - 32 lines of insertion across 3 files,
  all within the rtsx subsystem
- **No new features:** Correct - this adds only internal plumbing to fix
  power state tracking
- **Tested:** Author tested 300+ s2idle cycles
- **Impact:** Users with Realtek card readers experience I/O errors,
  filesystem journal failures, and card detection loss after
  suspend/resume

**Risk assessment:**
- Low risk - the changes are confined to the rtsx card reader subsystem
- The `power_off` callback is properly guarded with NULL checks (`if
  (slot->p_dev && slot->power_off)`)
- The `sd_request` power-on check has proper error handling
- The drv_remove function properly clears the callback
- No impact on other subsystems

**Dependencies:**
- Self-contained - no dependencies on other commits
- The companion delay patch (aced969e9bf37) has already been selected
  for stable and is independent
- The code being modified (`rtsx_slot`, `rtsx_pci_suspend`,
  `sd_request`) exists in all recent stable trees

### Verification

- **Verified** that `sd_power_on()` at line 912 returns early when
  `prev_power_state == MMC_POWER_ON`, confirming the bug mechanism
- **Verified** via `git show aced969e9bf37` that the companion patch
  (delay increase) has a Fixes: tag and was independently picked for
  stable
- **Verified** via `git show ed0d7f8559dbd` (stable branch version) that
  the delay patch was already applied to stable with `[Upstream commit
  ...]` marker
- **Verified** via lore.kernel.org that this is a 2-patch series (0/2
  cover letter), both fixing suspend/resume failures, with testing
  showing patch 1 reduces failures from 20% to 4%
- **Verified** that `struct rtsx_slot` currently only has `p_dev` and
  `card_event` fields by reading `include/linux/rtsx_common.h`
- **Verified** that the suspend paths properly hold `pcr->pcr_mutex`
  when calling the callback
- **Verified** the NULL check guards (`slot->p_dev && slot->power_off`)
  in both suspend functions
- **Verified** that `sd_power_on()` has existed since the driver was
  created (`ff984e57d36e8`) - the forward declaration is just for
  compilation order
- **Verified** that `rtsx_pci_sdmmc_drv_remove` properly clears
  `power_off = NULL` to prevent stale callbacks

This is a clear, well-tested bug fix for a user-impactful suspend/resume
issue. It's small, contained, properly guarded, and fixes a 20% failure
rate. It meets all stable kernel criteria.

**YES**

 drivers/misc/cardreader/rtsx_pcr.c |  9 +++++++++
 drivers/mmc/host/rtsx_pci_sdmmc.c  | 22 ++++++++++++++++++++++
 include/linux/rtsx_common.h        |  1 +
 3 files changed, 32 insertions(+)

diff --git a/drivers/misc/cardreader/rtsx_pcr.c b/drivers/misc/cardreader/rtsx_pcr.c
index f9952d76d6ed7..f1f4d8ed544d6 100644
--- a/drivers/misc/cardreader/rtsx_pcr.c
+++ b/drivers/misc/cardreader/rtsx_pcr.c
@@ -1654,6 +1654,7 @@ static int __maybe_unused rtsx_pci_suspend(struct device *dev_d)
 	struct pci_dev *pcidev = to_pci_dev(dev_d);
 	struct pcr_handle *handle = pci_get_drvdata(pcidev);
 	struct rtsx_pcr *pcr = handle->pcr;
+	struct rtsx_slot *slot = &pcr->slots[RTSX_SD_CARD];
 
 	dev_dbg(&(pcidev->dev), "--> %s\n", __func__);
 
@@ -1661,6 +1662,9 @@ static int __maybe_unused rtsx_pci_suspend(struct device *dev_d)
 
 	mutex_lock(&pcr->pcr_mutex);
 
+	if (slot->p_dev && slot->power_off)
+		slot->power_off(slot->p_dev);
+
 	rtsx_pci_power_off(pcr, HOST_ENTER_S3, false);
 
 	mutex_unlock(&pcr->pcr_mutex);
@@ -1772,12 +1776,17 @@ static int rtsx_pci_runtime_suspend(struct device *device)
 	struct pci_dev *pcidev = to_pci_dev(device);
 	struct pcr_handle *handle = pci_get_drvdata(pcidev);
 	struct rtsx_pcr *pcr = handle->pcr;
+	struct rtsx_slot *slot = &pcr->slots[RTSX_SD_CARD];
 
 	dev_dbg(device, "--> %s\n", __func__);
 
 	cancel_delayed_work_sync(&pcr->carddet_work);
 
 	mutex_lock(&pcr->pcr_mutex);
+
+	if (slot->p_dev && slot->power_off)
+		slot->power_off(slot->p_dev);
+
 	rtsx_pci_power_off(pcr, HOST_ENTER_S3, true);
 
 	mutex_unlock(&pcr->pcr_mutex);
diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 8df60000b5b41..34343b5d5823d 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -47,6 +47,7 @@ struct realtek_pci_sdmmc {
 };
 
 static int sdmmc_init_sd_express(struct mmc_host *mmc, struct mmc_ios *ios);
+static int sd_power_on(struct realtek_pci_sdmmc *host, unsigned char power_mode);
 
 static inline struct device *sdmmc_dev(struct realtek_pci_sdmmc *host)
 {
@@ -821,6 +822,15 @@ static void sd_request(struct work_struct *work)
 
 	rtsx_pci_start_run(pcr);
 
+	if (host->prev_power_state == MMC_POWER_OFF) {
+		err = sd_power_on(host, MMC_POWER_ON);
+		if (err) {
+			cmd->error = err;
+			mutex_unlock(&pcr->pcr_mutex);
+			goto finish;
+		}
+	}
+
 	rtsx_pci_switch_clock(pcr, host->clock, host->ssc_depth,
 			host->initial_mode, host->double_clk, host->vpclk);
 	rtsx_pci_write_register(pcr, CARD_SELECT, 0x07, SD_MOD_SEL);
@@ -1522,6 +1532,16 @@ static void rtsx_pci_sdmmc_card_event(struct platform_device *pdev)
 	mmc_detect_change(host->mmc, 0);
 }
 
+static void rtsx_pci_sdmmc_power_off(struct platform_device *pdev)
+{
+	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
+
+	if (!host)
+		return;
+
+	host->prev_power_state = MMC_POWER_OFF;
+}
+
 static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 {
 	struct mmc_host *mmc;
@@ -1554,6 +1574,7 @@ static int rtsx_pci_sdmmc_drv_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, host);
 	pcr->slots[RTSX_SD_CARD].p_dev = pdev;
 	pcr->slots[RTSX_SD_CARD].card_event = rtsx_pci_sdmmc_card_event;
+	pcr->slots[RTSX_SD_CARD].power_off = rtsx_pci_sdmmc_power_off;
 
 	mutex_init(&host->host_mutex);
 
@@ -1585,6 +1606,7 @@ static void rtsx_pci_sdmmc_drv_remove(struct platform_device *pdev)
 	pcr = host->pcr;
 	pcr->slots[RTSX_SD_CARD].p_dev = NULL;
 	pcr->slots[RTSX_SD_CARD].card_event = NULL;
+	pcr->slots[RTSX_SD_CARD].power_off = NULL;
 	mmc = host->mmc;
 
 	cancel_work_sync(&host->work);
diff --git a/include/linux/rtsx_common.h b/include/linux/rtsx_common.h
index da9c8c6b5d50f..f294f478f0c0e 100644
--- a/include/linux/rtsx_common.h
+++ b/include/linux/rtsx_common.h
@@ -32,6 +32,7 @@ struct platform_device;
 struct rtsx_slot {
 	struct platform_device	*p_dev;
 	void			(*card_event)(struct platform_device *p_dev);
+	void			(*power_off)(struct platform_device *p_dev);
 };
 
 #endif
-- 
2.51.0

