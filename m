Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F09061F91E3;
	Mon, 22 Sep 2025 19:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570321; cv=none; b=eR1M8SBZtxBNKhkxe2qQAOwviLoaN0wOOxjIiTBNh17CddDW/20NOg9et06NG8j5bMzXHuNskWGZah+UCsJK/7WZlf9mj+ELbSbR3/Yn0udSqG12HiE1OVrEvBjFaa0UicAMmoN7akpRMBA1Rj0IkY8D1f1hZUPiA+gFrO7JnB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570321; c=relaxed/simple;
	bh=IvmhSVm0/C8LLsKEBqSfipVsQEMe3X76xK4C+7y+RfM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n7gnxgy/B6z5/L5iSJhB5jxDgPp9SgX6XrYxwxmvvyjdeGd9idTRlV4L9bg9LtB24ptyTYoNjBXawjB9L/59ukWe/2jd/t3lmasKNZveXZ/nIBUMf1UrQgJDWrxoJYbPtINQhdBlQzi8R4umI5W79Z4FYYL5nYjR07PH442kqN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zh8/MePL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zh8/MePL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D73CC4CEF0;
	Mon, 22 Sep 2025 19:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570320;
	bh=IvmhSVm0/C8LLsKEBqSfipVsQEMe3X76xK4C+7y+RfM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zh8/MePLEBDaLf850ynj9ihDZdx6Yh05XkbY4VdgbWjj2ePA6ADMj3JyuwASwHEp4
	 rYNCLHpnxD4xN3yjzg4rpSTCD6XGmC9GKXkiKkkQ0CvKiLpBrWSL5AoAzidUPaFgLB
	 R1UTEWYZckFPCsdpnsvO+0sX7/F0x6shcvz58WEQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Chuang <ben.chuang@genesyslogic.com.tw>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.16 089/149] mmc: sdhci: Move the code related to setting the clock from sdhci_set_ios_common() into sdhci_set_ios()
Date: Mon, 22 Sep 2025 21:29:49 +0200
Message-ID: <20250922192415.128920824@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Chuang <ben.chuang@genesyslogic.com.tw>

commit 7b7e71683b4ccbe0dbd7d434707623327e852f20 upstream.

The sdhci_set_clock() is called in sdhci_set_ios_common() and
__sdhci_uhs2_set_ios(). According to Section 3.13.2 "Card Interface
Detection Sequence" of the SD Host Controller Standard Specification
Version 7.00, the SD clock is supplied after power is supplied, so we only
need one in __sdhci_uhs2_set_ios(). Let's move the code related to setting
the clock from sdhci_set_ios_common() into sdhci_set_ios() and modify
the parameters passed to sdhci_set_clock() in __sdhci_uhs2_set_ios().

Fixes: 10c8298a052b ("mmc: sdhci-uhs2: add set_ios()")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.tw>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-uhs2.c |    3 ++-
 drivers/mmc/host/sdhci.c      |   34 +++++++++++++++++-----------------
 2 files changed, 19 insertions(+), 18 deletions(-)

--- a/drivers/mmc/host/sdhci-uhs2.c
+++ b/drivers/mmc/host/sdhci-uhs2.c
@@ -295,7 +295,8 @@ static void __sdhci_uhs2_set_ios(struct
 	else
 		sdhci_uhs2_set_power(host, ios->power_mode, ios->vdd);
 
-	sdhci_set_clock(host, host->clock);
+	sdhci_set_clock(host, ios->clock);
+	host->clock = ios->clock;
 }
 
 static int sdhci_uhs2_set_ios(struct mmc_host *mmc, struct mmc_ios *ios)
--- a/drivers/mmc/host/sdhci.c
+++ b/drivers/mmc/host/sdhci.c
@@ -2367,23 +2367,6 @@ void sdhci_set_ios_common(struct mmc_hos
 		(ios->power_mode == MMC_POWER_UP) &&
 		!(host->quirks2 & SDHCI_QUIRK2_PRESET_VALUE_BROKEN))
 		sdhci_enable_preset_value(host, false);
-
-	if (!ios->clock || ios->clock != host->clock) {
-		host->ops->set_clock(host, ios->clock);
-		host->clock = ios->clock;
-
-		if (host->quirks & SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK &&
-		    host->clock) {
-			host->timeout_clk = mmc->actual_clock ?
-						mmc->actual_clock / 1000 :
-						host->clock / 1000;
-			mmc->max_busy_timeout =
-				host->ops->get_max_timeout_count ?
-				host->ops->get_max_timeout_count(host) :
-				1 << 27;
-			mmc->max_busy_timeout /= host->timeout_clk;
-		}
-	}
 }
 EXPORT_SYMBOL_GPL(sdhci_set_ios_common);
 
@@ -2410,6 +2393,23 @@ void sdhci_set_ios(struct mmc_host *mmc,
 
 	sdhci_set_ios_common(mmc, ios);
 
+	if (!ios->clock || ios->clock != host->clock) {
+		host->ops->set_clock(host, ios->clock);
+		host->clock = ios->clock;
+
+		if (host->quirks & SDHCI_QUIRK_DATA_TIMEOUT_USES_SDCLK &&
+		    host->clock) {
+			host->timeout_clk = mmc->actual_clock ?
+						mmc->actual_clock / 1000 :
+						host->clock / 1000;
+			mmc->max_busy_timeout =
+				host->ops->get_max_timeout_count ?
+				host->ops->get_max_timeout_count(host) :
+				1 << 27;
+			mmc->max_busy_timeout /= host->timeout_clk;
+		}
+	}
+
 	if (host->ops->set_power)
 		host->ops->set_power(host, ios->power_mode, ios->vdd);
 	else


