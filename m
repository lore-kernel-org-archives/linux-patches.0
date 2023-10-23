Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3272C14282
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H/whpDk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEFFC433C7;
	Mon, 23 Oct 2023 11:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059412;
	bh=LNybofKXxPnqQx23d7BADsfwz+dOpFvRkILz0oCaWoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H/whpDk7fVdfBp64DJbWvE94NFsuZ7yz+pCHF4x/u5eC403wzxYkk0KlMlFUUM+JC
	 GumcTsYaQxyEWD11ipSNcUzbjJC7dnTC8MrrilIYJx+muoWLWYv8s2JHVzNIMzIM22
	 NyPF5sIM8IbYvbJcAP9KgZH2eqrbXOKkT6h9FNCs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rouven Czerwinski <r.czerwinski@pengutronix.de>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.5 168/241] mtd: rawnand: Ensure the nand chip supports cached reads
Date: Mon, 23 Oct 2023 12:55:54 +0200
Message-ID: <20231023104837.974287107@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rouven Czerwinski <r.czerwinski@pengutronix.de>

commit f6ca3fb6978f94d95ee79f95085fc22e71ca17cc upstream.

Both the JEDEC and ONFI specification say that read cache sequential
support is an optional command. This means that we not only need to
check whether the individual controller supports the command, we also
need to check the parameter pages for both ONFI and JEDEC NAND flashes
before enabling sequential cache reads.

This fixes support for NAND flashes which don't support enabling cache
reads, i.e. Samsung K9F4G08U0F or Toshiba TC58NVG0S3HTA00.

Sequential cache reads are now only available for ONFI and JEDEC
devices, if individual vendors implement this, it needs to be enabled
per vendor.

Tested on i.MX6Q with a Samsung NAND flash chip that doesn't support
sequential reads.

Fixes: 003fe4b9545b ("mtd: rawnand: Support for sequential cache reads")
Cc: stable@vger.kernel.org
Signed-off-by: Rouven Czerwinski <r.czerwinski@pengutronix.de>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230922141717.35977-1-r.czerwinski@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c  |    3 +++
 drivers/mtd/nand/raw/nand_jedec.c |    3 +++
 drivers/mtd/nand/raw/nand_onfi.c  |    3 +++
 include/linux/mtd/jedec.h         |    3 +++
 include/linux/mtd/onfi.h          |    1 +
 include/linux/mtd/rawnand.h       |    2 ++
 6 files changed, 15 insertions(+)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -5109,6 +5109,9 @@ static void rawnand_check_cont_read_supp
 {
 	struct mtd_info *mtd = nand_to_mtd(chip);
 
+	if (!chip->parameters.supports_read_cache)
+		return;
+
 	if (chip->read_retries)
 		return;
 
--- a/drivers/mtd/nand/raw/nand_jedec.c
+++ b/drivers/mtd/nand/raw/nand_jedec.c
@@ -94,6 +94,9 @@ int nand_jedec_detect(struct nand_chip *
 		goto free_jedec_param_page;
 	}
 
+	if (p->opt_cmd[0] & JEDEC_OPT_CMD_READ_CACHE)
+		chip->parameters.supports_read_cache = true;
+
 	memorg->pagesize = le32_to_cpu(p->byte_per_page);
 	mtd->writesize = memorg->pagesize;
 
--- a/drivers/mtd/nand/raw/nand_onfi.c
+++ b/drivers/mtd/nand/raw/nand_onfi.c
@@ -303,6 +303,9 @@ int nand_onfi_detect(struct nand_chip *c
 			   ONFI_FEATURE_ADDR_TIMING_MODE, 1);
 	}
 
+	if (le16_to_cpu(p->opt_cmd) & ONFI_OPT_CMD_READ_CACHE)
+		chip->parameters.supports_read_cache = true;
+
 	onfi = kzalloc(sizeof(*onfi), GFP_KERNEL);
 	if (!onfi) {
 		ret = -ENOMEM;
--- a/include/linux/mtd/jedec.h
+++ b/include/linux/mtd/jedec.h
@@ -21,6 +21,9 @@ struct jedec_ecc_info {
 /* JEDEC features */
 #define JEDEC_FEATURE_16_BIT_BUS	(1 << 0)
 
+/* JEDEC Optional Commands */
+#define JEDEC_OPT_CMD_READ_CACHE	BIT(1)
+
 struct nand_jedec_params {
 	/* rev info and features block */
 	/* 'J' 'E' 'S' 'D'  */
--- a/include/linux/mtd/onfi.h
+++ b/include/linux/mtd/onfi.h
@@ -55,6 +55,7 @@
 #define ONFI_SUBFEATURE_PARAM_LEN	4
 
 /* ONFI optional commands SET/GET FEATURES supported? */
+#define ONFI_OPT_CMD_READ_CACHE		BIT(1)
 #define ONFI_OPT_CMD_SET_GET_FEATURES	BIT(2)
 
 struct nand_onfi_params {
--- a/include/linux/mtd/rawnand.h
+++ b/include/linux/mtd/rawnand.h
@@ -225,6 +225,7 @@ struct gpio_desc;
  * struct nand_parameters - NAND generic parameters from the parameter page
  * @model: Model name
  * @supports_set_get_features: The NAND chip supports setting/getting features
+ * @supports_read_cache: The NAND chip supports read cache operations
  * @set_feature_list: Bitmap of features that can be set
  * @get_feature_list: Bitmap of features that can be get
  * @onfi: ONFI specific parameters
@@ -233,6 +234,7 @@ struct nand_parameters {
 	/* Generic parameters */
 	const char *model;
 	bool supports_set_get_features;
+	bool supports_read_cache;
 	DECLARE_BITMAP(set_feature_list, ONFI_FEATURE_NUMBER);
 	DECLARE_BITMAP(get_feature_list, ONFI_FEATURE_NUMBER);
 


