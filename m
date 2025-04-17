Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 003DF261573;
	Thu, 17 Apr 2025 18:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914682; cv=none; b=lhE2yliQJ9HY1/ijeHTNlC5D468RAgsXCurWjYTIEUHkQt1eX843uz+EvK38xNq9moCMh0U7l3reJEyAniYZdWcPpjxSUZPBHns+2qEa7UdoPNWzJU4ds5NXLIKVBXo1cFhot16pwKl1dZnmpYwaS9VmSlCLZgsCgSnkjvO86Eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914682; c=relaxed/simple;
	bh=opoGHBCVSV2olQuWh5DOgRLNJvuvA5Nudq97nLOZhdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SPyS32lUhp6lJe/4K+lMwpVjPenwLEC5/rphe/zU0+eAhulOB0goX6Ez0IdwaSxxV//dlIxDcv1RV2hOLU56lnNM4MD9v9eWm8jmLOSMgdo/Mp2jx6djVMWqp2j/B5yVBpOaZZhGv7vzF9iKDEsbeUd+xYfECxzTw6QxBuctURg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iPpUD5X6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iPpUD5X6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4D1C4CEE4;
	Thu, 17 Apr 2025 18:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914681;
	bh=opoGHBCVSV2olQuWh5DOgRLNJvuvA5Nudq97nLOZhdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iPpUD5X6srBvvha4uJWWpg4snxneNNS+jn6F1eWitICnGTgvsX6HKui+nPSAmQFrV
	 BNXauzaUzeEmNlKiA39liLuewZ9PtPTWVR9Y0ih1rbO8ABh970Hta6IWKRjhyS6ZoS
	 cdPof/0TTjaGj9EBR/cMcwOFN33ERq54tnqZjFq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kartik Rajput <kkartik@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Jassi Brar <jassisinghbrar@gmail.com>
Subject: [PATCH 6.13 296/414] mailbox: tegra-hsp: Define dimensioning masks in SoC data
Date: Thu, 17 Apr 2025 19:50:54 +0200
Message-ID: <20250417175123.336682261@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -915,6 +923,16 @@ static const struct tegra_hsp_soc tegra1
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
@@ -922,6 +940,16 @@ static const struct tegra_hsp_soc tegra1
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
@@ -929,6 +957,16 @@ static const struct tegra_hsp_soc tegra2
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
@@ -936,6 +974,16 @@ static const struct tegra_hsp_soc tegra2
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


