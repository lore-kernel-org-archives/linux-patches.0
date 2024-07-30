Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05BD91BA882;
	Tue, 30 Jul 2024 15:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354740; cv=none; b=GPKpN5jzZkK0AvLQweVn4++kuIhnxBEd8R+uEXC/3KJjcY1OzBp864gB3mYF6s5clYnvBD+vGXIKszyg9Y05Ouybz5DpSfGjv9VtopQfofMwY5KJNie7dm2Av5Q8EzXtAMGXvxtzTLHehgJw1gNYSUwjH+M6aBrxP8QPNMzT3YA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354740; c=relaxed/simple;
	bh=kJ/t0MYD9NMPlbrU9FONiTHAhhbA3xk37ZYG9KjBY18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6q/8Rf7OGrM21O1dXbOFG1fYNSND25qhTnkc2GZ+hwAkOFDHfrdsRnhHd9MF/Mym7AMXY5iyF2TEL4LqIpOT4APBtBoAIrRnZs9b++UErDTwC7Ho7d+mSoXWkDoaZvhDB4oCsbaxCHcMp9Y07NllHguOaATlqAEVjOwShybwxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTV/rxO8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTV/rxO8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA28C32782;
	Tue, 30 Jul 2024 15:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354739;
	bh=kJ/t0MYD9NMPlbrU9FONiTHAhhbA3xk37ZYG9KjBY18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pTV/rxO8mP2IJBQsMIQaNQwpY6Lxv1/RkHEvGW83N5AgQAFdeUQfvdyTYJ5Uq8XzS
	 kOctlpku901UE3JtgMwruuN9Y86fzYlWKhw12hP7Kf3lBbilBOaic/U0K/7rlb6NBL
	 zAMKFIwSWNYxfFGujxEWLJ0qyUn9JNRpx8Hr+JKU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 003/440] EDAC, i10nm: make skx_common.o a separate module
Date: Tue, 30 Jul 2024 17:43:56 +0200
Message-ID: <20240730151615.893368470@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 123b158635505c89ed0d3ef45c5845ff9030a466 ]

Commit 598afa050403 ("kbuild: warn objects shared among multiple modules")
was added to track down cases where the same object is linked into
multiple modules. This can cause serious problems if some modules are
builtin while others are not.

That test triggers this warning:

scripts/Makefile.build:236: drivers/edac/Makefile: skx_common.o is added to multiple modules: i10nm_edac skx_edac

Make this a separate module instead.

[Tony: Added more background details to commit message]

Fixes: d4dc89d069aa ("EDAC, i10nm: Add a driver for Intel 10nm server processors")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Link: https://lore.kernel.org/all/20240529095132.1929397-1-arnd@kernel.org/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/Makefile     | 10 ++++++----
 drivers/edac/skx_common.c | 21 +++++++++++++++++++--
 drivers/edac/skx_common.h |  4 ++--
 3 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 2d1641a27a28f..a98e1981df157 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -54,11 +54,13 @@ obj-$(CONFIG_EDAC_MPC85XX)		+= mpc85xx_edac_mod.o
 layerscape_edac_mod-y			:= fsl_ddr_edac.o layerscape_edac.o
 obj-$(CONFIG_EDAC_LAYERSCAPE)		+= layerscape_edac_mod.o
 
-skx_edac-y				:= skx_common.o skx_base.o
-obj-$(CONFIG_EDAC_SKX)			+= skx_edac.o
+skx_edac_common-y			:= skx_common.o
 
-i10nm_edac-y				:= skx_common.o i10nm_base.o
-obj-$(CONFIG_EDAC_I10NM)		+= i10nm_edac.o
+skx_edac-y				:= skx_base.o
+obj-$(CONFIG_EDAC_SKX)			+= skx_edac.o skx_edac_common.o
+
+i10nm_edac-y				:= i10nm_base.o
+obj-$(CONFIG_EDAC_I10NM)		+= i10nm_edac.o skx_edac_common.o
 
 obj-$(CONFIG_EDAC_CELL)			+= cell_edac.o
 obj-$(CONFIG_EDAC_PPC4XX)		+= ppc4xx_edac.o
diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index f0f8e98f6efb2..e218909f9f9e8 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -48,7 +48,7 @@ static u64 skx_tolm, skx_tohm;
 static LIST_HEAD(dev_edac_list);
 static bool skx_mem_cfg_2lm;
 
-int __init skx_adxl_get(void)
+int skx_adxl_get(void)
 {
 	const char * const *names;
 	int i, j;
@@ -110,12 +110,14 @@ int __init skx_adxl_get(void)
 
 	return -ENODEV;
 }
+EXPORT_SYMBOL_GPL(skx_adxl_get);
 
-void __exit skx_adxl_put(void)
+void skx_adxl_put(void)
 {
 	kfree(adxl_values);
 	kfree(adxl_msg);
 }
+EXPORT_SYMBOL_GPL(skx_adxl_put);
 
 static bool skx_adxl_decode(struct decoded_addr *res, bool error_in_1st_level_mem)
 {
@@ -187,12 +189,14 @@ void skx_set_mem_cfg(bool mem_cfg_2lm)
 {
 	skx_mem_cfg_2lm = mem_cfg_2lm;
 }
+EXPORT_SYMBOL_GPL(skx_set_mem_cfg);
 
 void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_log)
 {
 	driver_decode = decode;
 	skx_show_retry_rd_err_log = show_retry_log;
 }
+EXPORT_SYMBOL_GPL(skx_set_decode);
 
 int skx_get_src_id(struct skx_dev *d, int off, u8 *id)
 {
@@ -206,6 +210,7 @@ int skx_get_src_id(struct skx_dev *d, int off, u8 *id)
 	*id = GET_BITFIELD(reg, 12, 14);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(skx_get_src_id);
 
 int skx_get_node_id(struct skx_dev *d, u8 *id)
 {
@@ -219,6 +224,7 @@ int skx_get_node_id(struct skx_dev *d, u8 *id)
 	*id = GET_BITFIELD(reg, 0, 2);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(skx_get_node_id);
 
 static int get_width(u32 mtr)
 {
@@ -284,6 +290,7 @@ int skx_get_all_bus_mappings(struct res_config *cfg, struct list_head **list)
 		*list = &dev_edac_list;
 	return ndev;
 }
+EXPORT_SYMBOL_GPL(skx_get_all_bus_mappings);
 
 int skx_get_hi_lo(unsigned int did, int off[], u64 *tolm, u64 *tohm)
 {
@@ -323,6 +330,7 @@ int skx_get_hi_lo(unsigned int did, int off[], u64 *tolm, u64 *tohm)
 	pci_dev_put(pdev);
 	return -ENODEV;
 }
+EXPORT_SYMBOL_GPL(skx_get_hi_lo);
 
 static int skx_get_dimm_attr(u32 reg, int lobit, int hibit, int add,
 			     int minval, int maxval, const char *name)
@@ -394,6 +402,7 @@ int skx_get_dimm_info(u32 mtr, u32 mcmtr, u32 amap, struct dimm_info *dimm,
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(skx_get_dimm_info);
 
 int skx_get_nvdimm_info(struct dimm_info *dimm, struct skx_imc *imc,
 			int chan, int dimmno, const char *mod_str)
@@ -442,6 +451,7 @@ int skx_get_nvdimm_info(struct dimm_info *dimm, struct skx_imc *imc,
 
 	return (size == 0 || size == ~0ull) ? 0 : 1;
 }
+EXPORT_SYMBOL_GPL(skx_get_nvdimm_info);
 
 int skx_register_mci(struct skx_imc *imc, struct pci_dev *pdev,
 		     const char *ctl_name, const char *mod_str,
@@ -512,6 +522,7 @@ int skx_register_mci(struct skx_imc *imc, struct pci_dev *pdev,
 	imc->mci = NULL;
 	return rc;
 }
+EXPORT_SYMBOL_GPL(skx_register_mci);
 
 static void skx_unregister_mci(struct skx_imc *imc)
 {
@@ -694,6 +705,7 @@ int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
 	mce->kflags |= MCE_HANDLED_EDAC;
 	return NOTIFY_DONE;
 }
+EXPORT_SYMBOL_GPL(skx_mce_check_error);
 
 void skx_remove(void)
 {
@@ -731,3 +743,8 @@ void skx_remove(void)
 		kfree(d);
 	}
 }
+EXPORT_SYMBOL_GPL(skx_remove);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Tony Luck");
+MODULE_DESCRIPTION("MC Driver for Intel server processors");
diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index 0cbadd3d2cd39..c0c174c101d2c 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -178,8 +178,8 @@ typedef int (*get_dimm_config_f)(struct mem_ctl_info *mci,
 typedef bool (*skx_decode_f)(struct decoded_addr *res);
 typedef void (*skx_show_retry_log_f)(struct decoded_addr *res, char *msg, int len, bool scrub_err);
 
-int __init skx_adxl_get(void);
-void __exit skx_adxl_put(void);
+int skx_adxl_get(void);
+void skx_adxl_put(void);
 void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_log);
 void skx_set_mem_cfg(bool mem_cfg_2lm);
 
-- 
2.43.0



