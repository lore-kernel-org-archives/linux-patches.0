Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E4F1D90DB;
	Tue, 15 Oct 2024 11:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992358; cv=none; b=tdqZiVT7g6bVKnfndhsAw/E0BTetj+jJE2PIbUpKvJK1z728p34hMli51KZPP8JXBTskPuCKN+WgX5mAhjfswoHHuqIXRbf4T03BPkG1OvT4fpllloCoGypFTkiIe7id9/gFt228wQIXJAAn5xlWtSEI7BchtyocK6XL4x7+S9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992358; c=relaxed/simple;
	bh=sdwX8YfcylWKQOWcPS8Bb0Pmnk3MIqIsreSFvMLj19Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YvhKl/e9vGDWFQjqq2LrYrSBlZ8LQwWKcBYw+waWfmELrO5xmoNI7TM1U+fVcge/5UORxX0BKzV0SuHHiEQ10EooJNp37PUD54+dfi0ydA0LM6tiiS/WtE2gvoLdVRZ5trn9VCdQfYNZspfxiMo7y0Ir1x8OKrPgZfmz7K5yLwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0DoklAR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0DoklAR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD612C4CEC6;
	Tue, 15 Oct 2024 11:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992358;
	bh=sdwX8YfcylWKQOWcPS8Bb0Pmnk3MIqIsreSFvMLj19Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0DoklARE6eyG1cKTZsjq1Hvl0HoC8QyPQ7xzqomoujCmxr8tWjKGahfvLXOqkLCF
	 hqHenOe1v5TQoZN4tljwbb8Xo/J6wOz/md9DnH00qIb7mRtigNg4LzB1DUTU/+65a2
	 9C5CJKKa51+N1tCwLcrcPPgs7fmw96VTKS7FyEWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 094/691] EDAC/synopsys: Fix error injection on Zynq UltraScale+
Date: Tue, 15 Oct 2024 13:20:42 +0200
Message-ID: <20241015112444.094182524@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>

[ Upstream commit 35e6dbfe1846caeafabb49b7575adb36b0aa2269 ]

The Zynq UltraScale+ MPSoC DDR has a disjoint memory from 2GB to 32GB.
The DDR host interface has a contiguous memory so while injecting
errors, the driver should remove the hole else the injection fails as
the address translation is incorrect.

Introduce a get_mem_info() function pointer and set it for Zynq
UltraScale+ platform to return host address.

Fixes: 1a81361f75d8 ("EDAC, synopsys: Add Error Injection support for ZynqMP DDR controller")
Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20240711100656.31376-1-shubhrajyoti.datta@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/synopsys_edac.c | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/drivers/edac/synopsys_edac.c b/drivers/edac/synopsys_edac.c
index feb203efcffff..e8ddb029f10d8 100644
--- a/drivers/edac/synopsys_edac.c
+++ b/drivers/edac/synopsys_edac.c
@@ -23,6 +23,7 @@
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
+#include <linux/sizes.h>
 #include <linux/interrupt.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
@@ -351,6 +352,7 @@ struct synps_edac_priv {
  * @get_mtype:		Get mtype.
  * @get_dtype:		Get dtype.
  * @get_ecc_state:	Get ECC state.
+ * @get_mem_info:	Get EDAC memory info
  * @quirks:		To differentiate IPs.
  */
 struct synps_platform_data {
@@ -358,6 +360,9 @@ struct synps_platform_data {
 	enum mem_type (*get_mtype)(const void __iomem *base);
 	enum dev_type (*get_dtype)(const void __iomem *base);
 	bool (*get_ecc_state)(void __iomem *base);
+#ifdef CONFIG_EDAC_DEBUG
+	u64 (*get_mem_info)(struct synps_edac_priv *priv);
+#endif
 	int quirks;
 };
 
@@ -416,6 +421,25 @@ static int zynq_get_error_info(struct synps_edac_priv *priv)
 	return 0;
 }
 
+#ifdef CONFIG_EDAC_DEBUG
+/**
+ * zynqmp_get_mem_info - Get the current memory info.
+ * @priv:	DDR memory controller private instance data.
+ *
+ * Return: host interface address.
+ */
+static u64 zynqmp_get_mem_info(struct synps_edac_priv *priv)
+{
+	u64 hif_addr = 0, linear_addr;
+
+	linear_addr = priv->poison_addr;
+	if (linear_addr >= SZ_32G)
+		linear_addr = linear_addr - SZ_32G + SZ_2G;
+	hif_addr = linear_addr >> 3;
+	return hif_addr;
+}
+#endif
+
 /**
  * zynqmp_get_error_info - Get the current ECC error info.
  * @priv:	DDR memory controller private instance data.
@@ -936,6 +960,9 @@ static const struct synps_platform_data zynqmp_edac_def = {
 	.get_mtype	= zynqmp_get_mtype,
 	.get_dtype	= zynqmp_get_dtype,
 	.get_ecc_state	= zynqmp_get_ecc_state,
+#ifdef CONFIG_EDAC_DEBUG
+	.get_mem_info	= zynqmp_get_mem_info,
+#endif
 	.quirks         = (DDR_ECC_INTR_SUPPORT
 #ifdef CONFIG_EDAC_DEBUG
 			  | DDR_ECC_DATA_POISON_SUPPORT
@@ -989,10 +1016,16 @@ MODULE_DEVICE_TABLE(of, synps_edac_match);
 static void ddr_poison_setup(struct synps_edac_priv *priv)
 {
 	int col = 0, row = 0, bank = 0, bankgrp = 0, rank = 0, regval;
+	const struct synps_platform_data *p_data;
 	int index;
 	ulong hif_addr = 0;
 
-	hif_addr = priv->poison_addr >> 3;
+	p_data = priv->p_data;
+
+	if (p_data->get_mem_info)
+		hif_addr = p_data->get_mem_info(priv);
+	else
+		hif_addr = priv->poison_addr >> 3;
 
 	for (index = 0; index < DDR_MAX_ROW_SHIFT; index++) {
 		if (priv->row_shift[index])
-- 
2.43.0



