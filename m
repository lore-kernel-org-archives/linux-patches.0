Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6627231C91;
	Fri,  9 Oct 2026 14:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556346; cv=none; b=D7uYqjeCI2xoZutPD8N3EGoquOVVLgnrRljSsinQgPwfUXLmbaaAx1wBykZzgAuXTKY+YdwUsa6HZZhlZrfTqfIBWxVj5+flzgaUUjXqh37B6KeWQYz2KqnzsqC3rqP4ASB243XHIXwE9dnPCGFq1YHOSOjEvlyHQVb56vyrh8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556346; c=relaxed/simple;
	bh=mGi3J0JULDJda6UNWnXgj+MNTBiQtE1lvz/WLq1H3l0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnN1jM0mdilrGM4p+fwOZ9d5Nd8FYjkSv1zEcSOIANOdEEtEuoqTUHPSrItRXa4B0ddWjWDQt+dYeLGevK/K2mJX829+L7k8YKT8lh7aYER+4a4Cy/0G7MMTd0dlnfNG9yL+zJWSfTFm1k273ZXplm31fKJQG/JW5uE3ftyUSCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VDLQ4bpN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VDLQ4bpN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 410E21F000FF;
	Fri,  9 Oct 2026 14:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556345;
	bh=jXF85KiRGydxSW2udS1i5LjBS7FU68lUVA0DLlm9MtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VDLQ4bpNtiCPDT9gC+jifx4XSp41B3VR7Kgxd8U7vdH28RHE5DSQxfj2dhk6p4cdH
	 T1ioHD3uYb3LwnrLzLsVGzQFx+BHobZRsAVidjCEGnSh/te6OVmQkXgy2qlRFpFSJh
	 E4uX0kuP5whbUpOvrIKOY7JhcADx02PX49Ed00Ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinh Nguyen <dinguyen@kernel.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.18 219/403] EDAC/altera: Drop __init from ECC setup paths for re-probe safety
Date: Fri,  9 Oct 2026 16:09:40 +0200
Message-ID: <20261009140957.266515647@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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
 
@@ -1598,7 +1598,7 @@ err_release_group_1:
 	return rc;
 }
 
-static int __init socfpga_init_sdmmc_ecc(struct altr_edac_device_dev *device)
+static int socfpga_init_sdmmc_ecc(struct altr_edac_device_dev *device)
 {
 	int rc = -ENODEV;
 	struct device_node *child;


