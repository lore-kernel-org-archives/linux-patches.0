Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C185187EA;
	Wed, 30 Sep 2026 17:19:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788748; cv=none; b=O1r3LN1MbMURu/Ae59GK5QUtP+jnYp+9x+XAfDJpbSTU2CrGzwEUQUAidAmcNYp8s3qQhyKaeD86F2TxUW29DSBfZBFapvvOF7WH42JuETU2bfxH4OGq4P54QO3EaVSDleNRmh9cBfACyjY9u2mAuARdc+ALO7G5HR5PF+BLHis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788748; c=relaxed/simple;
	bh=cz84LdByQJT3JKmIajhX+NPvX5iJaD5YUjmxBKNU248=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Klu+rF3230QfBmWxAVMmLXsw49mLNrI6K8vVr7GGCgIrblbqGeyW0kLyCfI5rxBTNKOCi9oPJfbbo2LZFPnwdhXzAlYtz/6PK9KMf5UD0HZfmz3TX8PkyownDtA0+o3JgGWX7J7w7tu3mVWw6bks3h41AtE+fU3SBrqZ0/bxePo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=quLa4nPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="quLa4nPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE621F000FF;
	Wed, 30 Sep 2026 17:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788747;
	bh=DIUec02/jgGH+YERgVBICAfTCccSDErhsm4n+9pFrBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=quLa4nPudIbxKjYkAiWKfHucmmQVJz38be4kluEKah0pPHC4catT9ADzV/dEEadtZ
	 /wDuCmQhyjELqg92EnfwmWiofcM45HWmgKey1vVW0qARHMNwT4ClvsvKqAnYMTTiWN
	 4l36RIy0KPsHW/ImTkDpyB+PGDDysXGntr9aIOrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Diogo Ivo (Schneider Electric)" <diogo.ivo@bootlin.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Judith Mendez <jm@ti.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.12 234/877] mmc: sdhci_am654: Fallback to DT-provided itap delay on DDR50 tuning failure
Date: Wed, 30 Sep 2026 17:19:05 +0200
Message-ID: <20260930152419.776789321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>

commit 308d05225281d86150d88141990d6caf8c902349 upstream.

DDR50 mode is not required to support the tuning command CMD19, meaning
that calibration may fail on cards that do not implement it, in which
case a known-good itap delay value should be programmed into the host
controller.

Do this by reading the (already defined) itap delay DT property for DDR50
and, if tuning fails for this mode, fall back to the DT-provided itap delay
value. If the DT does not provide a value for DDR50 fallback then this
simply disables using itapdly.

Fixes: 901d16e46296 ("mmc: sdhci_am654: Add retry tuning")
Cc: stable@vger.kernel.org
Signed-off-by: Diogo Ivo (Schneider Electric) <diogo.ivo@bootlin.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Reviewed-by: Judith Mendez <jm@ti.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci_am654.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -127,7 +127,7 @@ static const struct timing_data td[] = {
 				   NULL,
 				   MMC_CAP_UHS_SDR104},
 	[MMC_TIMING_UHS_DDR50]	= {"ti,otap-del-sel-ddr50",
-				   NULL,
+				   "ti,itap-del-sel-ddr50",
 				   MMC_CAP_UHS_DDR50},
 	[MMC_TIMING_MMC_DDR52]	= {"ti,otap-del-sel-ddr52",
 				   "ti,itap-del-sel-ddr52",
@@ -145,6 +145,8 @@ struct sdhci_am654_data {
 	u32 otap_del_sel[ARRAY_SIZE(td)];
 	u32 itap_del_sel[ARRAY_SIZE(td)];
 	u32 itap_del_ena[ARRAY_SIZE(td)];
+	u32 itap_del_sel_dt_ddr50;
+	u32 itap_del_ena_dt_ddr50;
 	int clkbuf_sel;
 	int trm_icp;
 	int drv_strength;
@@ -555,10 +557,19 @@ static int sdhci_am654_platform_execute_
 	} while (++tuning_loop < RETRY_TUNING_MAX);
 
 	if (itapdly < 0) {
-		dev_err(dev, "Failed to find itapdly, fail tuning\n");
-		sdhci_am654_write_itapdly(sdhci_am654, 0, 0);
-		sdhci_am654->itap_del_ena[timing] = 0;
-		sdhci_am654->itap_del_sel[timing] = 0;
+		if (timing == MMC_TIMING_UHS_DDR50) {
+			dev_dbg(dev, "Failed DDR50 tuning, fallback to DT ITAP\n");
+			sdhci_am654->itap_del_sel[timing] = sdhci_am654->itap_del_sel_dt_ddr50;
+			sdhci_am654->itap_del_ena[timing] = sdhci_am654->itap_del_ena_dt_ddr50;
+		} else {
+			dev_err(dev, "Failed to find itapdly, fail tuning\n");
+			sdhci_am654->itap_del_ena[timing] = 0;
+			sdhci_am654->itap_del_sel[timing] = 0;
+		}
+
+		sdhci_am654_write_itapdly(sdhci_am654,
+					  sdhci_am654->itap_del_sel[timing],
+					  sdhci_am654->itap_del_ena[timing]);
 		return -1;
 	}
 
@@ -728,6 +739,11 @@ static int sdhci_am654_get_otap_delay(st
 		}
 	}
 
+	sdhci_am654->itap_del_sel_dt_ddr50 =
+		sdhci_am654->itap_del_sel[MMC_TIMING_UHS_DDR50];
+	sdhci_am654->itap_del_ena_dt_ddr50 =
+		sdhci_am654->itap_del_ena[MMC_TIMING_UHS_DDR50];
+
 	return 0;
 }
 


