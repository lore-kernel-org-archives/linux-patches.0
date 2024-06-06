Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94E141C619B;
	Thu,  6 Jun 2024 14:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683697; cv=none; b=uq10JPJdRRUiahoMkTptqrR0PWFBfioNbKLM3L24qd853DdDPmO16CwpP+5tNeXqw/ju5qGD60HbfJqQP38BQa94ztPMYBJw8kh7fcYy0kYVY93+pNbFGddCd6ao+9fX6rF6UGkN6cSFQYInNArr/db/vMI0i6B1/nhqSdxLMis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683697; c=relaxed/simple;
	bh=6qGDsvwnG8YPaMRuoW7mznDRlJ1F6moGBVvT7seL2xE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NE7kRIcUNZ1AErd1vydcF7S0X+IvfXqE7U9qsz3w9KMtfrWT2ZGoYWNSnS2gB4cSaWK8yFLMEJSpuSe9Z0RRdauBbU8TD9bm3O9wL9MpEo/xORQ8HEAG6CedMTdzo1rUqTa+gnxVjAUKmM6Y26fRilSwiQgUEaIyRr+YjBWcr5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=16Pq2JXs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="16Pq2JXs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE51C32786;
	Thu,  6 Jun 2024 14:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683697;
	bh=6qGDsvwnG8YPaMRuoW7mznDRlJ1F6moGBVvT7seL2xE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=16Pq2JXs76PGsX5qTADBQpgVjFX6sBcroIpnw0xCGz9nH38rXZGCnxBlCpBudGzJq
	 VVWvhkboYGjeuCPR/98BKCKSieDD3eZfez9ZVXS20dbtvkMuti3evpzFOFdl7KOnW+
	 nuAzOdE3IT9ex1KpABztvuxbHxCNoBImDe1rCcfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 563/744] mmc: sdhci_am654: Add OTAP/ITAP delay enable
Date: Thu,  6 Jun 2024 16:03:55 +0200
Message-ID: <20240606131750.518316387@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit 387c1bf7dce0dfea02080c8bdb066b5209e92155 ]

Currently the OTAP/ITAP delay enable functionality is incorrect in
the am654_set_clock function. The OTAP delay is not enabled when
timing < SDR25 bus speed mode. The ITAP delay is not enabled for
timings that do not carry out tuning.

Add this OTAP/ITAP delay functionality according to the datasheet
[1] OTAPDLYENA and ITAPDLYENA for MMC0.

[1] https://www.ti.com/lit/ds/symlink/am62p.pdf

Fixes: 8ee5fc0e0b3b ("mmc: sdhci_am654: Update OTAPDLY writes")
Signed-off-by: Judith Mendez <jm@ti.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20240320223837.959900-4-jm@ti.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/sdhci_am654.c | 40 ++++++++++++++++++++++------------
 1 file changed, 26 insertions(+), 14 deletions(-)

diff --git a/drivers/mmc/host/sdhci_am654.c b/drivers/mmc/host/sdhci_am654.c
index cfb614d0b42b4..888bfda0ebc0e 100644
--- a/drivers/mmc/host/sdhci_am654.c
+++ b/drivers/mmc/host/sdhci_am654.c
@@ -143,6 +143,7 @@ struct sdhci_am654_data {
 	struct regmap *base;
 	int otap_del_sel[ARRAY_SIZE(td)];
 	int itap_del_sel[ARRAY_SIZE(td)];
+	u32 itap_del_ena[ARRAY_SIZE(td)];
 	int clkbuf_sel;
 	int trm_icp;
 	int drv_strength;
@@ -239,11 +240,13 @@ static void sdhci_am654_setup_dll(struct sdhci_host *host, unsigned int clock)
 }
 
 static void sdhci_am654_write_itapdly(struct sdhci_am654_data *sdhci_am654,
-				      u32 itapdly)
+				      u32 itapdly, u32 enable)
 {
 	/* Set ITAPCHGWIN before writing to ITAPDLY */
 	regmap_update_bits(sdhci_am654->base, PHY_CTRL4, ITAPCHGWIN_MASK,
 			   1 << ITAPCHGWIN_SHIFT);
+	regmap_update_bits(sdhci_am654->base, PHY_CTRL4, ITAPDLYENA_MASK,
+			   enable << ITAPDLYENA_SHIFT);
 	regmap_update_bits(sdhci_am654->base, PHY_CTRL4, ITAPDLYSEL_MASK,
 			   itapdly << ITAPDLYSEL_SHIFT);
 	regmap_update_bits(sdhci_am654->base, PHY_CTRL4, ITAPCHGWIN_MASK, 0);
@@ -260,8 +263,8 @@ static void sdhci_am654_setup_delay_chain(struct sdhci_am654_data *sdhci_am654,
 	mask = SELDLYTXCLK_MASK | SELDLYRXCLK_MASK;
 	regmap_update_bits(sdhci_am654->base, PHY_CTRL5, mask, val);
 
-	sdhci_am654_write_itapdly(sdhci_am654,
-				  sdhci_am654->itap_del_sel[timing]);
+	sdhci_am654_write_itapdly(sdhci_am654, sdhci_am654->itap_del_sel[timing],
+				  sdhci_am654->itap_del_ena[timing]);
 }
 
 static void sdhci_am654_set_clock(struct sdhci_host *host, unsigned int clock)
@@ -270,7 +273,6 @@ static void sdhci_am654_set_clock(struct sdhci_host *host, unsigned int clock)
 	struct sdhci_am654_data *sdhci_am654 = sdhci_pltfm_priv(pltfm_host);
 	unsigned char timing = host->mmc->ios.timing;
 	u32 otap_del_sel;
-	u32 otap_del_ena;
 	u32 mask, val;
 
 	regmap_update_bits(sdhci_am654->base, PHY_CTRL1, ENDLL_MASK, 0);
@@ -279,10 +281,9 @@ static void sdhci_am654_set_clock(struct sdhci_host *host, unsigned int clock)
 
 	/* Setup DLL Output TAP delay */
 	otap_del_sel = sdhci_am654->otap_del_sel[timing];
-	otap_del_ena = (timing > MMC_TIMING_UHS_SDR25) ? 1 : 0;
 
 	mask = OTAPDLYENA_MASK | OTAPDLYSEL_MASK;
-	val = (otap_del_ena << OTAPDLYENA_SHIFT) |
+	val = (0x1 << OTAPDLYENA_SHIFT) |
 	      (otap_del_sel << OTAPDLYSEL_SHIFT);
 
 	/* Write to STRBSEL for HS400 speed mode */
@@ -300,7 +301,8 @@ static void sdhci_am654_set_clock(struct sdhci_host *host, unsigned int clock)
 	if (timing > MMC_TIMING_UHS_SDR25 && clock >= CLOCK_TOO_SLOW_HZ) {
 		sdhci_am654_setup_dll(host, clock);
 		sdhci_am654->dll_enable = true;
-		sdhci_am654_write_itapdly(sdhci_am654, sdhci_am654->itap_del_sel[timing]);
+		sdhci_am654_write_itapdly(sdhci_am654, sdhci_am654->itap_del_sel[timing],
+					  sdhci_am654->itap_del_ena[timing]);
 	} else {
 		sdhci_am654_setup_delay_chain(sdhci_am654, timing);
 		sdhci_am654->dll_enable = false;
@@ -317,6 +319,7 @@ static void sdhci_j721e_4bit_set_clock(struct sdhci_host *host,
 	struct sdhci_am654_data *sdhci_am654 = sdhci_pltfm_priv(pltfm_host);
 	unsigned char timing = host->mmc->ios.timing;
 	u32 otap_del_sel;
+	u32 itap_del_ena;
 	u32 mask, val;
 
 	/* Setup DLL Output TAP delay */
@@ -325,6 +328,12 @@ static void sdhci_j721e_4bit_set_clock(struct sdhci_host *host,
 	mask = OTAPDLYENA_MASK | OTAPDLYSEL_MASK;
 	val = (0x1 << OTAPDLYENA_SHIFT) |
 	      (otap_del_sel << OTAPDLYSEL_SHIFT);
+
+	itap_del_ena = sdhci_am654->itap_del_ena[timing];
+
+	mask |= ITAPDLYENA_MASK;
+	val |= (itap_del_ena << ITAPDLYENA_SHIFT);
+
 	regmap_update_bits(sdhci_am654->base, PHY_CTRL4, mask, val);
 
 	regmap_update_bits(sdhci_am654->base, PHY_CTRL5, CLKBUFSEL_MASK,
@@ -478,6 +487,7 @@ static int sdhci_am654_platform_execute_tuning(struct sdhci_host *host,
 {
 	struct sdhci_pltfm_host *pltfm_host = sdhci_priv(host);
 	struct sdhci_am654_data *sdhci_am654 = sdhci_pltfm_priv(pltfm_host);
+	unsigned char timing = host->mmc->ios.timing;
 	struct window fail_window[ITAPDLY_LENGTH];
 	u8 curr_pass, itap;
 	u8 fail_index = 0;
@@ -486,11 +496,10 @@ static int sdhci_am654_platform_execute_tuning(struct sdhci_host *host,
 	memset(fail_window, 0, sizeof(fail_window));
 
 	/* Enable ITAPDLY */
-	regmap_update_bits(sdhci_am654->base, PHY_CTRL4, ITAPDLYENA_MASK,
-			   1 << ITAPDLYENA_SHIFT);
+	sdhci_am654->itap_del_ena[timing] = 0x1;
 
 	for (itap = 0; itap < ITAPDLY_LENGTH; itap++) {
-		sdhci_am654_write_itapdly(sdhci_am654, itap);
+		sdhci_am654_write_itapdly(sdhci_am654, itap, sdhci_am654->itap_del_ena[timing]);
 
 		curr_pass = !mmc_send_tuning(host->mmc, opcode, NULL);
 
@@ -514,7 +523,7 @@ static int sdhci_am654_platform_execute_tuning(struct sdhci_host *host,
 	itap = sdhci_am654_calculate_itap(host, fail_window, fail_index,
 					  sdhci_am654->dll_enable);
 
-	sdhci_am654_write_itapdly(sdhci_am654, itap);
+	sdhci_am654_write_itapdly(sdhci_am654, itap, sdhci_am654->itap_del_ena[timing]);
 
 	return 0;
 }
@@ -663,9 +672,12 @@ static int sdhci_am654_get_otap_delay(struct sdhci_host *host,
 				host->mmc->caps2 &= ~td[i].capability;
 		}
 
-		if (td[i].itap_binding)
-			device_property_read_u32(dev, td[i].itap_binding,
-						 &sdhci_am654->itap_del_sel[i]);
+		if (td[i].itap_binding) {
+			ret = device_property_read_u32(dev, td[i].itap_binding,
+						       &sdhci_am654->itap_del_sel[i]);
+			if (!ret)
+				sdhci_am654->itap_del_ena[i] = 0x1;
+		}
 	}
 
 	return 0;
-- 
2.43.0



