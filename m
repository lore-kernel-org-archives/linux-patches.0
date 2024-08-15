Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0E81AC8AE;
	Thu, 15 Aug 2024 14:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731115; cv=none; b=SmbFRDxSdEq217WmZe/GrdOHp4xx/hH9sscymarwMRvDk9gSAICghBTQRbLXT3WSIH2et6paqGmCrWyXp92ZOTTssLsgXcsCOJB5nYz+P283kB9l/el7exU5kUQjfj/SBPncmPegYjF94PmoZEsjaZdWBqp8K5zvdolxyRqSpFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731115; c=relaxed/simple;
	bh=JK+t5HYIRSNEpqFk3QjOJ6DUbN3t534LMXsSx9FtDMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vDJ9EqCXoRxiVI5Ty7F1hh5I2vNBzBK6fad3e5I99Kmlldd/KArHD9GxdZUfXNER5Vvke/7JL7ocvMPgfgADoGLrGrbZmcyNXgoNv6T3iLwBnXfgE74B428Udvfs4smD41qcz85YYzmlW38JI6Sa/mMZh8c1u0EOaD56yNnBT3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eMmqwyjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eMmqwyjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBC3C4AF0A;
	Thu, 15 Aug 2024 14:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731115;
	bh=JK+t5HYIRSNEpqFk3QjOJ6DUbN3t534LMXsSx9FtDMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eMmqwyjbQX8FIcSgTN/4wq5vbyIr0v//bcpq1QPYXuA7tSmytWS1nJSjTv9Ue40GQ
	 stVgawdkJ0Eno9Nge8Z7/GlIqT2sYQsLR4fI1uNuxm1jZSZS9ENa/2dk6hEReXdUMo
	 z696laUhdnwRestUJwMpvV5fwLiHrYZfeoy35C4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 004/259] EDAC, i10nm: make skx_common.o a separate module
Date: Thu, 15 Aug 2024 15:22:17 +0200
Message-ID: <20240815131902.958177267@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index d77200c9680bc..32cc22ed52950 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -57,11 +57,13 @@ obj-$(CONFIG_EDAC_MPC85XX)		+= mpc85xx_edac_mod.o
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
 
 obj-$(CONFIG_EDAC_MV64X60)		+= mv64x60_edac.o
 obj-$(CONFIG_EDAC_CELL)			+= cell_edac.o
diff --git a/drivers/edac/skx_common.c b/drivers/edac/skx_common.c
index 76d340db2c46b..b298b189bdf35 100644
--- a/drivers/edac/skx_common.c
+++ b/drivers/edac/skx_common.c
@@ -46,7 +46,7 @@ static u64 skx_tolm, skx_tohm;
 static LIST_HEAD(dev_edac_list);
 static bool skx_mem_cfg_2lm;
 
-int __init skx_adxl_get(void)
+int skx_adxl_get(void)
 {
 	const char * const *names;
 	int i, j;
@@ -108,12 +108,14 @@ int __init skx_adxl_get(void)
 
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
@@ -180,12 +182,14 @@ void skx_set_mem_cfg(bool mem_cfg_2lm)
 {
 	skx_mem_cfg_2lm = mem_cfg_2lm;
 }
+EXPORT_SYMBOL_GPL(skx_set_mem_cfg);
 
 void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_log)
 {
 	skx_decode = decode;
 	skx_show_retry_rd_err_log = show_retry_log;
 }
+EXPORT_SYMBOL_GPL(skx_set_decode);
 
 int skx_get_src_id(struct skx_dev *d, int off, u8 *id)
 {
@@ -199,6 +203,7 @@ int skx_get_src_id(struct skx_dev *d, int off, u8 *id)
 	*id = GET_BITFIELD(reg, 12, 14);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(skx_get_src_id);
 
 int skx_get_node_id(struct skx_dev *d, u8 *id)
 {
@@ -212,6 +217,7 @@ int skx_get_node_id(struct skx_dev *d, u8 *id)
 	*id = GET_BITFIELD(reg, 0, 2);
 	return 0;
 }
+EXPORT_SYMBOL_GPL(skx_get_node_id);
 
 static int get_width(u32 mtr)
 {
@@ -278,6 +284,7 @@ int skx_get_all_bus_mappings(unsigned int did, int off, enum type type,
 		*list = &dev_edac_list;
 	return ndev;
 }
+EXPORT_SYMBOL_GPL(skx_get_all_bus_mappings);
 
 int skx_get_hi_lo(unsigned int did, int off[], u64 *tolm, u64 *tohm)
 {
@@ -317,6 +324,7 @@ int skx_get_hi_lo(unsigned int did, int off[], u64 *tolm, u64 *tohm)
 	pci_dev_put(pdev);
 	return -ENODEV;
 }
+EXPORT_SYMBOL_GPL(skx_get_hi_lo);
 
 static int skx_get_dimm_attr(u32 reg, int lobit, int hibit, int add,
 			     int minval, int maxval, const char *name)
@@ -370,6 +378,7 @@ int skx_get_dimm_info(u32 mtr, u32 mcmtr, u32 amap, struct dimm_info *dimm,
 
 	return 1;
 }
+EXPORT_SYMBOL_GPL(skx_get_dimm_info);
 
 int skx_get_nvdimm_info(struct dimm_info *dimm, struct skx_imc *imc,
 			int chan, int dimmno, const char *mod_str)
@@ -418,6 +427,7 @@ int skx_get_nvdimm_info(struct dimm_info *dimm, struct skx_imc *imc,
 
 	return (size == 0 || size == ~0ull) ? 0 : 1;
 }
+EXPORT_SYMBOL_GPL(skx_get_nvdimm_info);
 
 int skx_register_mci(struct skx_imc *imc, struct pci_dev *pdev,
 		     const char *ctl_name, const char *mod_str,
@@ -485,6 +495,7 @@ int skx_register_mci(struct skx_imc *imc, struct pci_dev *pdev,
 	imc->mci = NULL;
 	return rc;
 }
+EXPORT_SYMBOL_GPL(skx_register_mci);
 
 static void skx_unregister_mci(struct skx_imc *imc)
 {
@@ -663,6 +674,7 @@ int skx_mce_check_error(struct notifier_block *nb, unsigned long val,
 
 	return NOTIFY_DONE;
 }
+EXPORT_SYMBOL_GPL(skx_mce_check_error);
 
 void skx_remove(void)
 {
@@ -698,3 +710,8 @@ void skx_remove(void)
 		kfree(d);
 	}
 }
+EXPORT_SYMBOL_GPL(skx_remove);
+
+MODULE_LICENSE("GPL v2");
+MODULE_AUTHOR("Tony Luck");
+MODULE_DESCRIPTION("MC Driver for Intel server processors");
diff --git a/drivers/edac/skx_common.h b/drivers/edac/skx_common.h
index deb4f21db1ab3..929cfcffcb50a 100644
--- a/drivers/edac/skx_common.h
+++ b/drivers/edac/skx_common.h
@@ -126,8 +126,8 @@ typedef int (*get_dimm_config_f)(struct mem_ctl_info *mci);
 typedef bool (*skx_decode_f)(struct decoded_addr *res);
 typedef void (*skx_show_retry_log_f)(struct decoded_addr *res, char *msg, int len);
 
-int __init skx_adxl_get(void);
-void __exit skx_adxl_put(void);
+int skx_adxl_get(void);
+void skx_adxl_put(void);
 void skx_set_decode(skx_decode_f decode, skx_show_retry_log_f show_retry_log);
 void skx_set_mem_cfg(bool mem_cfg_2lm);
 
-- 
2.43.0



