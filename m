Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7901C3368A4;
	Thu, 20 Aug 2026 15:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238884; cv=none; b=C65QqRami0yjUWw81/rMsXRHdHPa4hsQhiukqfzkvTFJzOWW+yqYdy+BGlRUWBWFfywoCsggA5jz7XqmFYWOlb8jth0KTHG9IzwbhoesBkEgZWVzGawb95J3yRRgOMdXBYqDPK8rgd0D3ADsL4mzK8WjBEl6clpyyqfZWj2Cx9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238884; c=relaxed/simple;
	bh=O7lspJy6Puqg7pfdJe7n9f/7u/8MCPTh7FsDaGexMMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u6pK/nuqoqqoE3I6XpI8u3fgfvf1V79woonmH1OKdXdcVDVTM1rX893XBlVPEs9qt/Yoyuzgo4lZagZbhRIDhb2zvgtp4qrfgQ74DyLDtbv9W6wxj2PJO72+5+EvLxNO32n1JDyea2a4YpahhtIEZaONk6kW5aja3fBwaOZbIq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rw98lDsv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rw98lDsv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3BA71F000E9;
	Thu, 20 Aug 2026 15:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238883;
	bh=4EgdbgU6CRnPJFAaAzaAN899OmZfREN5xWRtJMkDE2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rw98lDsv+Z50pYLqBSeCzjNXxl8ddx/dzBs1OJIS/y9vSMnaShrcBs6vCqwlWWjr8
	 N8whNMk0nZnGXAS5o6xZKtQTd3zVP0t2NYGniCp4oqT4N4gHzD+Mcc0hFFVPKNaKYl
	 iMsyjRUW7qXSNfny1vdNOaKf7zE69ysLouTaZeeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Dmitry Osipenko <dmitry.osipenko@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 073/217] pmdomain: mediatek: Fix mt8183 hang on boot
Date: Thu, 20 Aug 2026 16:54:01 +0200
Message-ID: <20260820145239.820311372@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Dmitry Osipenko <dmitry.osipenko@collabora.com>

commit 818d56ac1d08b68a4c42d0326786f030cc640722 upstream.

Depending on firmware, part of the MFG domains may be partially left ON
at boot time with kernel detecting PD as ON, while it's OFF.

Some of MFG cores may be left powered after bootloader, to let the ACP to
prefetch the GPU region when the display controller is brought up for a
continuous splash animation performed by downstream stack.

This doesn't play well with an eventual delay in probing upstream Panfrost
driver when the display controller is fully set up, as that would make
genpd's sync_state() to power off the domain while ACP tries to prefetch:
this is causing an AXI stall, effectively freezing the AP indefinitely.

In order to prevent trouble from happening, the sync_state() functionality
must be obliterated on all of the MFG domains: while this guarantees a
power leakage if the bootloader boots the kernel with MFG PDs partially
powered on, this is the only way to ensure stable operation of the SoC
during boot on devices with such firmware because, of course, those will
never officially receive a firmware update.

Fixes Kappa Chromebook hanging during system boot.

Fixes: 0e789b491ba0 ("pmdomain: core: Leave powered-on genpds on until sync_state")
Fixes: 13a4b7fb6260 ("pmdomain: core: Leave powered-on genpds on until late_initcall_sync")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Dmitry Osipenko <dmitry.osipenko@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/mediatek/mt8183-pm-domains.h | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/pmdomain/mediatek/mt8183-pm-domains.h b/drivers/pmdomain/mediatek/mt8183-pm-domains.h
index 3742782a2702..5e33b8628e85 100644
--- a/drivers/pmdomain/mediatek/mt8183-pm-domains.h
+++ b/drivers/pmdomain/mediatek/mt8183-pm-domains.h
@@ -47,7 +47,7 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8183[] = {
 		.pwr_sta2nd_offs = 0x0184,
 		.sram_pdn_bits = 0,
 		.sram_pdn_ack_bits = 0,
-		.caps = MTK_SCPD_DOMAIN_SUPPLY,
+		.caps = MTK_SCPD_DOMAIN_SUPPLY | MTK_SCPD_KEEP_DEFAULT_OFF,
 	},
 	[MT8183_POWER_DOMAIN_MFG] = {
 		.name = "mfg",
@@ -57,7 +57,7 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8183[] = {
 		.pwr_sta2nd_offs = 0x0184,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
-		.caps = MTK_SCPD_DOMAIN_SUPPLY,
+		.caps = MTK_SCPD_DOMAIN_SUPPLY | MTK_SCPD_KEEP_DEFAULT_OFF,
 	},
 	[MT8183_POWER_DOMAIN_MFG_CORE0] = {
 		.name = "mfg_core0",
@@ -67,6 +67,7 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8183[] = {
 		.pwr_sta2nd_offs = 0x0184,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
+		.caps = MTK_SCPD_KEEP_DEFAULT_OFF,
 	},
 	[MT8183_POWER_DOMAIN_MFG_CORE1] = {
 		.name = "mfg_core1",
@@ -76,6 +77,7 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8183[] = {
 		.pwr_sta2nd_offs = 0x0184,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
+		.caps = MTK_SCPD_KEEP_DEFAULT_OFF,
 	},
 	[MT8183_POWER_DOMAIN_MFG_2D] = {
 		.name = "mfg_2d",
@@ -85,6 +87,7 @@ static const struct scpsys_domain_data scpsys_domain_data_mt8183[] = {
 		.pwr_sta2nd_offs = 0x0184,
 		.sram_pdn_bits = GENMASK(8, 8),
 		.sram_pdn_ack_bits = GENMASK(12, 12),
+		.caps = MTK_SCPD_KEEP_DEFAULT_OFF,
 		.bp_cfg = {
 			BUS_PROT_WR(INFRA,
 				    MT8183_TOP_AXI_PROT_EN_1_MFG,
-- 
2.55.0



