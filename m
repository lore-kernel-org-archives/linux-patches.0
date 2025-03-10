Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CA3522DFF3;
	Mon, 10 Mar 2025 17:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628994; cv=none; b=ulVfkEdNmNPOa2V0/904rAhx0EyGZ+9LU3Bth8vsAvtjla2qjz2CAILULfjUGwTAqi9Fvqw1bNbmZwFz+I9G9scQ/pYqzUIfkCk1var5qY89yF8c6R/KlYUBum4wZga1rOpGn1I1vZd2vRKfOZsCh40I56D1V5lChxnVpzR+T+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628994; c=relaxed/simple;
	bh=IdQ+XAAJ16wZMkf0v2jB/9qsBRATFe988L0mPeDttmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Yz74TnrhIVHjWF+R7VO/j7KTnBO6GuwTA60DOvGnEGmNwR7o9qnK1Vd4lcWcNR8eTdT2esihhAlJ8yylIJiR+6lGLB6MGF9WhJJuCZFPRhzqCeLkux5xp95GYpxQYUN4oFH9rKSNKVQCl+E+FBn0TTNSiUEkcQzueElV8QTvoJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2o6AdXaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2o6AdXaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24F7BC4CEE5;
	Mon, 10 Mar 2025 17:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628994;
	bh=IdQ+XAAJ16wZMkf0v2jB/9qsBRATFe988L0mPeDttmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2o6AdXaDvfirBYCCPCbsMw9aCQbbdJlfbXKvwFhnCoWrq/v3/Gn3aA+XALvzv/fOa
	 pEIrNOhoH1vBfpXWrLJKHBWdkRA7lX/FHkZKNLIp58G9JqvzNgiWorr1829v/HQUHX
	 i22+nKH9Se4xQGT8qgkhWnQZM/kCUnRNK0NAe/D0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Osipenko <digetx@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 113/620] memory: Add LPDDR2-info helpers
Date: Mon, 10 Mar 2025 17:59:19 +0100
Message-ID: <20250310170550.066265401@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Osipenko <digetx@gmail.com>

[ Upstream commit 38322cf423f69b89b6e0eaad4017ab41cfe45b45 ]

Add common helpers for reading and parsing standard LPDDR2 configuration
properties.

Signed-off-by: Dmitry Osipenko <digetx@gmail.com>
Link: https://lore.kernel.org/r/20211006224659.21434-9-digetx@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Stable-dep-of: b9784e5cde1f ("memory: tegra20-emc: fix an OF node reference bug in tegra_emc_find_node_by_ram_code()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/jedec_ddr.h      | 47 ++++++++++++++++++
 drivers/memory/jedec_ddr_data.c | 41 ++++++++++++++++
 drivers/memory/of_memory.c      | 87 +++++++++++++++++++++++++++++++++
 drivers/memory/of_memory.h      |  9 ++++
 4 files changed, 184 insertions(+)

diff --git a/drivers/memory/jedec_ddr.h b/drivers/memory/jedec_ddr.h
index e59ccbd982d02..6cd508478b146 100644
--- a/drivers/memory/jedec_ddr.h
+++ b/drivers/memory/jedec_ddr.h
@@ -112,6 +112,26 @@
 #define NUM_DDR_ADDR_TABLE_ENTRIES			11
 #define NUM_DDR_TIMING_TABLE_ENTRIES			4
 
+#define LPDDR2_MANID_SAMSUNG				1
+#define LPDDR2_MANID_QIMONDA				2
+#define LPDDR2_MANID_ELPIDA				3
+#define LPDDR2_MANID_ETRON				4
+#define LPDDR2_MANID_NANYA				5
+#define LPDDR2_MANID_HYNIX				6
+#define LPDDR2_MANID_MOSEL				7
+#define LPDDR2_MANID_WINBOND				8
+#define LPDDR2_MANID_ESMT				9
+#define LPDDR2_MANID_SPANSION				11
+#define LPDDR2_MANID_SST				12
+#define LPDDR2_MANID_ZMOS				13
+#define LPDDR2_MANID_INTEL				14
+#define LPDDR2_MANID_NUMONYX				254
+#define LPDDR2_MANID_MICRON				255
+
+#define LPDDR2_TYPE_S4					0
+#define LPDDR2_TYPE_S2					1
+#define LPDDR2_TYPE_NVM					2
+
 /* Structure for DDR addressing info from the JEDEC spec */
 struct lpddr2_addressing {
 	u32 num_banks;
@@ -170,6 +190,33 @@ extern const struct lpddr2_timings
 	lpddr2_jedec_timings[NUM_DDR_TIMING_TABLE_ENTRIES];
 extern const struct lpddr2_min_tck lpddr2_jedec_min_tck;
 
+/* Structure of MR8 */
+union lpddr2_basic_config4 {
+	u32 value;
+
+	struct {
+		unsigned int arch_type : 2;
+		unsigned int density : 4;
+		unsigned int io_width : 2;
+	} __packed;
+};
+
+/*
+ * Structure for information about LPDDR2 chip. All parameters are
+ * matching raw values of standard mode register bitfields or set to
+ * -ENOENT if info unavailable.
+ */
+struct lpddr2_info {
+	int arch_type;
+	int density;
+	int io_width;
+	int manufacturer_id;
+	int revision_id1;
+	int revision_id2;
+};
+
+const char *lpddr2_jedec_manufacturer(unsigned int manufacturer_id);
+
 /*
  * Structure for timings for LPDDR3 based on LPDDR2 plus additional fields.
  * All parameters are in pico seconds(ps) excluding max_freq, min_freq which
diff --git a/drivers/memory/jedec_ddr_data.c b/drivers/memory/jedec_ddr_data.c
index ed601d813175e..2cca4fa188f92 100644
--- a/drivers/memory/jedec_ddr_data.c
+++ b/drivers/memory/jedec_ddr_data.c
@@ -131,3 +131,44 @@ const struct lpddr2_min_tck lpddr2_jedec_min_tck = {
 	.tFAW		= 8
 };
 EXPORT_SYMBOL_GPL(lpddr2_jedec_min_tck);
+
+const char *lpddr2_jedec_manufacturer(unsigned int manufacturer_id)
+{
+	switch (manufacturer_id) {
+	case LPDDR2_MANID_SAMSUNG:
+		return "Samsung";
+	case LPDDR2_MANID_QIMONDA:
+		return "Qimonda";
+	case LPDDR2_MANID_ELPIDA:
+		return "Elpida";
+	case LPDDR2_MANID_ETRON:
+		return "Etron";
+	case LPDDR2_MANID_NANYA:
+		return "Nanya";
+	case LPDDR2_MANID_HYNIX:
+		return "Hynix";
+	case LPDDR2_MANID_MOSEL:
+		return "Mosel";
+	case LPDDR2_MANID_WINBOND:
+		return "Winbond";
+	case LPDDR2_MANID_ESMT:
+		return "ESMT";
+	case LPDDR2_MANID_SPANSION:
+		return "Spansion";
+	case LPDDR2_MANID_SST:
+		return "SST";
+	case LPDDR2_MANID_ZMOS:
+		return "ZMOS";
+	case LPDDR2_MANID_INTEL:
+		return "Intel";
+	case LPDDR2_MANID_NUMONYX:
+		return "Numonyx";
+	case LPDDR2_MANID_MICRON:
+		return "Micron";
+	default:
+		break;
+	}
+
+	return "invalid";
+}
+EXPORT_SYMBOL_GPL(lpddr2_jedec_manufacturer);
diff --git a/drivers/memory/of_memory.c b/drivers/memory/of_memory.c
index 1791614f324b7..755ce416fbbad 100644
--- a/drivers/memory/of_memory.c
+++ b/drivers/memory/of_memory.c
@@ -300,3 +300,90 @@ const struct lpddr3_timings
 	return NULL;
 }
 EXPORT_SYMBOL(of_lpddr3_get_ddr_timings);
+
+/**
+ * of_lpddr2_get_info() - extracts information about the lpddr2 chip.
+ * @np: Pointer to device tree node containing lpddr2 info
+ * @dev: Device requesting info
+ *
+ * Populates lpddr2_info structure by extracting data from device
+ * tree node. Returns pointer to populated structure. If error
+ * happened while populating, returns NULL. If property is missing
+ * in a device-tree, then the corresponding value is set to -ENOENT.
+ */
+const struct lpddr2_info
+*of_lpddr2_get_info(struct device_node *np, struct device *dev)
+{
+	struct lpddr2_info *ret_info, info = {};
+	struct property *prop;
+	const char *cp;
+	int err;
+
+	err = of_property_read_u32(np, "revision-id1", &info.revision_id1);
+	if (err)
+		info.revision_id1 = -ENOENT;
+
+	err = of_property_read_u32(np, "revision-id2", &info.revision_id2);
+	if (err)
+		info.revision_id2 = -ENOENT;
+
+	err = of_property_read_u32(np, "io-width", &info.io_width);
+	if (err)
+		return NULL;
+
+	info.io_width = 32 / info.io_width - 1;
+
+	err = of_property_read_u32(np, "density", &info.density);
+	if (err)
+		return NULL;
+
+	info.density = ffs(info.density) - 7;
+
+	if (of_device_is_compatible(np, "jedec,lpddr2-s4"))
+		info.arch_type = LPDDR2_TYPE_S4;
+	else if (of_device_is_compatible(np, "jedec,lpddr2-s2"))
+		info.arch_type = LPDDR2_TYPE_S2;
+	else if (of_device_is_compatible(np, "jedec,lpddr2-nvm"))
+		info.arch_type = LPDDR2_TYPE_NVM;
+	else
+		return NULL;
+
+	prop = of_find_property(np, "compatible", NULL);
+	for (cp = of_prop_next_string(prop, NULL); cp;
+	     cp = of_prop_next_string(prop, cp)) {
+
+#define OF_LPDDR2_VENDOR_CMP(compat, ID) \
+		if (!of_compat_cmp(cp, compat ",", strlen(compat ","))) { \
+			info.manufacturer_id = LPDDR2_MANID_##ID; \
+			break; \
+		}
+
+		OF_LPDDR2_VENDOR_CMP("samsung", SAMSUNG)
+		OF_LPDDR2_VENDOR_CMP("qimonda", QIMONDA)
+		OF_LPDDR2_VENDOR_CMP("elpida", ELPIDA)
+		OF_LPDDR2_VENDOR_CMP("etron", ETRON)
+		OF_LPDDR2_VENDOR_CMP("nanya", NANYA)
+		OF_LPDDR2_VENDOR_CMP("hynix", HYNIX)
+		OF_LPDDR2_VENDOR_CMP("mosel", MOSEL)
+		OF_LPDDR2_VENDOR_CMP("winbond", WINBOND)
+		OF_LPDDR2_VENDOR_CMP("esmt", ESMT)
+		OF_LPDDR2_VENDOR_CMP("spansion", SPANSION)
+		OF_LPDDR2_VENDOR_CMP("sst", SST)
+		OF_LPDDR2_VENDOR_CMP("zmos", ZMOS)
+		OF_LPDDR2_VENDOR_CMP("intel", INTEL)
+		OF_LPDDR2_VENDOR_CMP("numonyx", NUMONYX)
+		OF_LPDDR2_VENDOR_CMP("micron", MICRON)
+
+#undef OF_LPDDR2_VENDOR_CMP
+	}
+
+	if (!info.manufacturer_id)
+		info.manufacturer_id = -ENOENT;
+
+	ret_info = devm_kzalloc(dev, sizeof(*ret_info), GFP_KERNEL);
+	if (ret_info)
+		*ret_info = info;
+
+	return ret_info;
+}
+EXPORT_SYMBOL(of_lpddr2_get_info);
diff --git a/drivers/memory/of_memory.h b/drivers/memory/of_memory.h
index 4a99b232ab0a8..1c4e47fede8ae 100644
--- a/drivers/memory/of_memory.h
+++ b/drivers/memory/of_memory.h
@@ -20,6 +20,9 @@ const struct lpddr3_min_tck *of_lpddr3_get_min_tck(struct device_node *np,
 const struct lpddr3_timings *
 of_lpddr3_get_ddr_timings(struct device_node *np_ddr,
 			  struct device *dev, u32 device_type, u32 *nr_frequencies);
+
+const struct lpddr2_info *of_lpddr2_get_info(struct device_node *np,
+					     struct device *dev);
 #else
 static inline const struct lpddr2_min_tck
 	*of_get_min_tck(struct device_node *np, struct device *dev)
@@ -46,6 +49,12 @@ static inline const struct lpddr3_timings
 {
 	return NULL;
 }
+
+static inline const struct lpddr2_info
+	*of_lpddr2_get_info(struct device_node *np, struct device *dev)
+{
+	return NULL;
+}
 #endif /* CONFIG_OF && CONFIG_DDR */
 
 #endif /* __LINUX_MEMORY_OF_REG_ */
-- 
2.39.5



