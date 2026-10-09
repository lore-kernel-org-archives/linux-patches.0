Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0B3B4E0B91;
	Fri,  9 Oct 2026 14:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556968; cv=none; b=FewOqjzQFeO49lym/C+tPj4oL/u2thSbLN7CJ6PDhp0FJE3XrO2Ucyyuiwg1rUHPFRnRT6xicOcBUBYX2psxHtS6FT7P3XetU3iPlLvEG2aLw4izzhd1ZfCTScEKBV1a3Ax72MQjPc4uj3qQAThP4jnZx30fbieqdTuQVsoOmSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556968; c=relaxed/simple;
	bh=7/aedtEqKhh4OVtxLEQU8/EP3kAuV/y+9oRAyq1dCo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BbgN5fH8tOPRx4lPZcsPu0tWJlXHhVMDzzzdRFpYkJosTZc+4WSr70thf3QONXWwuHGKVyn9OTwYzNoeVATBbPS/pOw8hRRD0L03Caq7kbMV7uBjOHnQzUtf4GYamrJFh8KmUH9nu8FD+vDB7MHWo58GxEm32q5MdvneO1WdZSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H6SFF+9K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H6SFF+9K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 411E51F000FF;
	Fri,  9 Oct 2026 14:42:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556967;
	bh=SBl5PMbDnD152Y1oRpS5WXPljKX5E+mw0snUhYhHToA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H6SFF+9KpM8/CBhTXYgQkHuKObsC623bfSQjgevjyNtwq7PQmDXFn//Wa8SRCyFb2
	 mb3FOd89QdaGO8VGzFbKWfZ/q58ntKdp6MA8CbxsoPbtASXJFbq/vpyFmANTUMl0yI
	 kOkBXzcEOj2YBmk6FkYIREbxpMRcgVz3cXlh8gzM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 7.2 275/428] EDAC/altera: Drop __init from ECC setup paths for re-probe safety
Date: Fri,  9 Oct 2026 16:10:12 +0200
Message-ID: <20261009140952.131759156@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinh Nguyen <dinguyen@kernel.org>

commit b62a264163ca51bee04785c581344751812395df upstream.

Sashiko reports:

"Does suppressing sysfs unbinding fully prevent the execution of freed __init
memory? If altr_sysmgr_regmap_lookup_by_phandle() returns -EPROBE_DEFER, the
probe is deferred until after __init memory is freed."

The a10 EDAC .setup callbacks (sdmmc, ethernet, nand, dma, usb, qspi) and
their helpers (altr_init_a10_ecc_device_type, altr_init_a10_ecc_block) were
marked __init. These run from the probe path, which may execute after init
memory is freed -- e.g. a probe deferred via -EPROBE_DEFER that only succeeds
once a late/module dependency appears, or a manual unbind/rebind. Calling
__init code then dereferences freed memory. Remove __init so these functions
remain valid at runtime.

Fixes: 788586efd116 ("EDAC/altera: Initialize peripheral FIFOs in probe()")
Assisted-by: LLM
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org # 6.18+
Link: https://patch.msgid.link/20260911120627.2634225-3-dinguyen@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/altera_edac.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/drivers/edac/altera_edac.c
+++ b/drivers/edac/altera_edac.c
@@ -926,7 +926,7 @@ static int __maybe_unused altr_init_memo
 	return ret;
 }
 
-static __init int __maybe_unused
+static int __maybe_unused
 altr_init_a10_ecc_block(struct device_node *np, u32 irq_mask,
 			u32 ecc_ctrl_en_mask, bool dual_port)
 {
@@ -1001,7 +1001,7 @@ out:
 
 static int validate_parent_available(struct device_node *np);
 static const struct of_device_id altr_edac_a10_device_of_match[];
-static int __init __maybe_unused altr_init_a10_ecc_device_type(char *compat)
+static int __maybe_unused altr_init_a10_ecc_device_type(char *compat)
 {
 	int irq;
 	struct device_node *child, *np;
@@ -1330,7 +1330,7 @@ static const struct edac_device_prv_data
 
 #ifdef CONFIG_EDAC_ALTERA_ETHERNET
 
-static int __init socfpga_init_ethernet_ecc(struct altr_edac_device_dev *dev)
+static int socfpga_init_ethernet_ecc(struct altr_edac_device_dev *dev)
 {
 	int ret;
 
@@ -1360,7 +1360,7 @@ static const struct edac_device_prv_data
 
 #ifdef CONFIG_EDAC_ALTERA_NAND
 
-static int __init socfpga_init_nand_ecc(struct altr_edac_device_dev *device)
+static int socfpga_init_nand_ecc(struct altr_edac_device_dev *device)
 {
 	int ret;
 
@@ -1390,7 +1390,7 @@ static const struct edac_device_prv_data
 
 #ifdef CONFIG_EDAC_ALTERA_DMA
 
-static int __init socfpga_init_dma_ecc(struct altr_edac_device_dev *device)
+static int socfpga_init_dma_ecc(struct altr_edac_device_dev *device)
 {
 	int ret;
 
@@ -1420,7 +1420,7 @@ static const struct edac_device_prv_data
 
 #ifdef CONFIG_EDAC_ALTERA_USB
 
-static int __init socfpga_init_usb_ecc(struct altr_edac_device_dev *device)
+static int socfpga_init_usb_ecc(struct altr_edac_device_dev *device)
 {
 	int ret;
 
@@ -1450,7 +1450,7 @@ static const struct edac_device_prv_data
 
 #ifdef CONFIG_EDAC_ALTERA_QSPI
 
-static int __init socfpga_init_qspi_ecc(struct altr_edac_device_dev *device)
+static int socfpga_init_qspi_ecc(struct altr_edac_device_dev *device)
 {
 	int ret;
 
@@ -1599,7 +1599,7 @@ err_release_group_1:
 	return rc;
 }
 
-static int __init socfpga_init_sdmmc_ecc(struct altr_edac_device_dev *device)
+static int socfpga_init_sdmmc_ecc(struct altr_edac_device_dev *device)
 {
 	int rc = -ENODEV;
 	struct device_node *child;


