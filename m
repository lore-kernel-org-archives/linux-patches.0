Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D667727FD74;
	Wed, 23 Apr 2025 15:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421378; cv=none; b=rLOoCTWRdAYQLv/bFldgGpCILvg7wGv1dXYsuxH2KvnesV/Ncyo1XdH1LjpIbI1t88EHueWuvpaYWLQpfyg+SpZuSFa7vAiMzpow20u3PhceOs/TSTDfaEvcBqyQHAOyD1GZaMyLI0433rSo2BxsqUR5cj50vkPXyW451gAy2dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421378; c=relaxed/simple;
	bh=30h+2vhFTvWAyK1zLXCm+hBPEwhR1yy2mOs+J5pryqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=szv1XmbG1Nd/VN5GKf+hqBmRXOeTVVt+onubHbSF1h06JAO/N11tz0K7Euei+YSirra20zmCvc8JI0wnwkSIGH9phMegHqc8kuD/Bs7acdvd34FYTQXERj1th12K+saxhdz7zckTV70s8jEJWqBGmIEnRcUEoiOeV+aSCzuDkeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kihMxulV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kihMxulV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A80BC4CEE3;
	Wed, 23 Apr 2025 15:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421378;
	bh=30h+2vhFTvWAyK1zLXCm+hBPEwhR1yy2mOs+J5pryqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kihMxulVfA0BpMq13BqMqERQrVwvd83B9yJCr2Vl3YpBY1c7rzYrIeyggH331p8Fg
	 lum7guqkj8+YE0+kh8js0bk1Fh3qcefXzxPIyfedHmhlbCjH5ORRC10bAFpL+cqtzg
	 15IuoJiL4XrGT6toJSDEBfOZ0Sp3naSqHjrZw/Dw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Jassi Brar <jassisinghbrar@gmail.com>
Subject: [PATCH 6.6 173/393] mailbox: tegra-hsp: Define dimensioning masks in SoC data
Date: Wed, 23 Apr 2025 16:41:09 +0200
Message-ID: <20250423142650.525958724@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kartik Rajput <kkartik@nvidia.com>

commit bf0c9fb462038815f5f502653fb6dba06e6af415 upstream.

Tegra264 has updated HSP_INT_DIMENSIONING register as follows:
	* nSI is now BIT17:BIT21.
	* nDB is now BIT12:BIT16.

Currently, we are using a static macro HSP_nINT_MASK to get the values
from HSP_INT_DIMENSIONING register. This results in wrong values for nSI
for HSP instances that supports 16 shared interrupts.

Define dimensioning masks in soc data and use them to parse nSI, nDB,
nAS, nSS & nSM values.

Fixes: 602dbbacc3ef ("mailbox: tegra: add support for Tegra264")
Cc: stable@vger.kernel.org
Signed-off-by: Kartik Rajput <kkartik@nvidia.com>
Acked-by: Thierry Reding <treding@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mailbox/tegra-hsp.c |   72 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 60 insertions(+), 12 deletions(-)

--- a/drivers/mailbox/tegra-hsp.c
+++ b/drivers/mailbox/tegra-hsp.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * Copyright (c) 2016-2023, NVIDIA CORPORATION.  All rights reserved.
+ * Copyright (c) 2016-2025, NVIDIA CORPORATION.  All rights reserved.
  */
 
 #include <linux/delay.h>
@@ -28,12 +28,6 @@
 #define HSP_INT_FULL_MASK	0xff
 
 #define HSP_INT_DIMENSIONING	0x380
-#define HSP_nSM_SHIFT		0
-#define HSP_nSS_SHIFT		4
-#define HSP_nAS_SHIFT		8
-#define HSP_nDB_SHIFT		12
-#define HSP_nSI_SHIFT		16
-#define HSP_nINT_MASK		0xf
 
 #define HSP_DB_TRIGGER	0x0
 #define HSP_DB_ENABLE	0x4
@@ -97,6 +91,20 @@ struct tegra_hsp_soc {
 	bool has_per_mb_ie;
 	bool has_128_bit_mb;
 	unsigned int reg_stride;
+
+	/* Shifts for dimensioning register. */
+	unsigned int si_shift;
+	unsigned int db_shift;
+	unsigned int as_shift;
+	unsigned int ss_shift;
+	unsigned int sm_shift;
+
+	/* Masks for dimensioning register. */
+	unsigned int si_mask;
+	unsigned int db_mask;
+	unsigned int as_mask;
+	unsigned int ss_mask;
+	unsigned int sm_mask;
 };
 
 struct tegra_hsp {
@@ -747,11 +755,11 @@ static int tegra_hsp_probe(struct platfo
 		return PTR_ERR(hsp->regs);
 
 	value = tegra_hsp_readl(hsp, HSP_INT_DIMENSIONING);
-	hsp->num_sm = (value >> HSP_nSM_SHIFT) & HSP_nINT_MASK;
-	hsp->num_ss = (value >> HSP_nSS_SHIFT) & HSP_nINT_MASK;
-	hsp->num_as = (value >> HSP_nAS_SHIFT) & HSP_nINT_MASK;
-	hsp->num_db = (value >> HSP_nDB_SHIFT) & HSP_nINT_MASK;
-	hsp->num_si = (value >> HSP_nSI_SHIFT) & HSP_nINT_MASK;
+	hsp->num_sm = (value >> hsp->soc->sm_shift) & hsp->soc->sm_mask;
+	hsp->num_ss = (value >> hsp->soc->ss_shift) & hsp->soc->ss_mask;
+	hsp->num_as = (value >> hsp->soc->as_shift) & hsp->soc->as_mask;
+	hsp->num_db = (value >> hsp->soc->db_shift) & hsp->soc->db_mask;
+	hsp->num_si = (value >> hsp->soc->si_shift) & hsp->soc->si_mask;
 
 	err = platform_get_irq_byname_optional(pdev, "doorbell");
 	if (err >= 0)
@@ -917,6 +925,16 @@ static const struct tegra_hsp_soc tegra1
 	.has_per_mb_ie = false,
 	.has_128_bit_mb = false,
 	.reg_stride = 0x100,
+	.si_shift = 16,
+	.db_shift = 12,
+	.as_shift = 8,
+	.ss_shift = 4,
+	.sm_shift = 0,
+	.si_mask = 0xf,
+	.db_mask = 0xf,
+	.as_mask = 0xf,
+	.ss_mask = 0xf,
+	.sm_mask = 0xf,
 };
 
 static const struct tegra_hsp_soc tegra194_hsp_soc = {
@@ -924,6 +942,16 @@ static const struct tegra_hsp_soc tegra1
 	.has_per_mb_ie = true,
 	.has_128_bit_mb = false,
 	.reg_stride = 0x100,
+	.si_shift = 16,
+	.db_shift = 12,
+	.as_shift = 8,
+	.ss_shift = 4,
+	.sm_shift = 0,
+	.si_mask = 0xf,
+	.db_mask = 0xf,
+	.as_mask = 0xf,
+	.ss_mask = 0xf,
+	.sm_mask = 0xf,
 };
 
 static const struct tegra_hsp_soc tegra234_hsp_soc = {
@@ -931,6 +959,16 @@ static const struct tegra_hsp_soc tegra2
 	.has_per_mb_ie = false,
 	.has_128_bit_mb = true,
 	.reg_stride = 0x100,
+	.si_shift = 16,
+	.db_shift = 12,
+	.as_shift = 8,
+	.ss_shift = 4,
+	.sm_shift = 0,
+	.si_mask = 0xf,
+	.db_mask = 0xf,
+	.as_mask = 0xf,
+	.ss_mask = 0xf,
+	.sm_mask = 0xf,
 };
 
 static const struct tegra_hsp_soc tegra264_hsp_soc = {
@@ -938,6 +976,16 @@ static const struct tegra_hsp_soc tegra2
 	.has_per_mb_ie = false,
 	.has_128_bit_mb = true,
 	.reg_stride = 0x1000,
+	.si_shift = 17,
+	.db_shift = 12,
+	.as_shift = 8,
+	.ss_shift = 4,
+	.sm_shift = 0,
+	.si_mask = 0x1f,
+	.db_mask = 0x1f,
+	.as_mask = 0xf,
+	.ss_mask = 0xf,
+	.sm_mask = 0xf,
 };
 
 static const struct of_device_id tegra_hsp_match[] = {


