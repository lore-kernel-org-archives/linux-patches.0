Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3DBF13F43A;
	Mon, 24 Feb 2025 14:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740407969; cv=none; b=Fj0P7onA1b2XjRDqCisViJggZQERRM7+3eO9ie4cC0J0fA512junhE0uveAhmKFYcLlltSDrubDEXpKduKqZKi2WQxeDCe0LlWj7s5Q9X+uKMWCXNW46u7/dyukPXaPdKlA6t/wg5i8p/OA3CFRKBJOlfp/QxL6JeXXqFslt+Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740407969; c=relaxed/simple;
	bh=ON75Oz6jbX9o67gFHYb4nnpD4udllXVFrDbmpMLYAEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7ULtAJT+cvAquOZiXMf9NyWNF4Ke6uoF6N0dHI6DJgauekymN4UIiumiiExJhQvZO7ap3vGV7Yd8Wj3eLgk8mMXL/Kzw3ptpzSKDiKzla0WH0TcwgzTcLywcn8hIOV2LMzy8ioda02srJ4kJZ0nWDV62QkpL23VjecPgzsId7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zgTpEaj0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zgTpEaj0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608BFC4CED6;
	Mon, 24 Feb 2025 14:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740407968;
	bh=ON75Oz6jbX9o67gFHYb4nnpD4udllXVFrDbmpMLYAEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zgTpEaj01meFR/zTky4bMcnAt0/mWwBwkLtk/IvJjenDK8pKQYt9RY8uLwWh8kdj0
	 ujwxLR/kihopJAHG8fBMDnzilk3Vj0Dc51ihCCFdHFW6ods4um5fZAojU1ROTQqWBc
	 PHW02j2SoVD/ocyUhcAVbP8nOkUfXAT02LBnulow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/140] nvmem: Move and rename ->fixup_cell_info()
Date: Mon, 24 Feb 2025 15:34:19 +0100
Message-ID: <20250224142605.372931287@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 1172460e716784ac7e1049a537bdca8edbf97360 ]

This hook is meant to be used by any provider and instantiating a layout
just for this is useless. Let's instead move this hook to the nvmem
device and add it to the config structure to be easily shared by the
providers.

While at moving this hook, rename it ->fixup_dt_cell_info() to clarify
its main intended purpose.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20231215111536.316972-6-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 391b06ecb63e ("nvmem: imx-ocotp-ele: fix MAC address byte order")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c           |  6 +++---
 drivers/nvmem/imx-ocotp.c      | 11 +++--------
 drivers/nvmem/internals.h      |  2 ++
 drivers/nvmem/mtk-efuse.c      | 11 +++--------
 include/linux/nvmem-provider.h |  9 ++++-----
 5 files changed, 15 insertions(+), 24 deletions(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index ed8a1cba361e2..3ea94bc26e800 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -674,7 +674,6 @@ static int nvmem_validate_keepouts(struct nvmem_device *nvmem)
 
 static int nvmem_add_cells_from_dt(struct nvmem_device *nvmem, struct device_node *np)
 {
-	struct nvmem_layout *layout = nvmem->layout;
 	struct device *dev = &nvmem->dev;
 	struct device_node *child;
 	const __be32 *addr;
@@ -704,8 +703,8 @@ static int nvmem_add_cells_from_dt(struct nvmem_device *nvmem, struct device_nod
 
 		info.np = of_node_get(child);
 
-		if (layout && layout->fixup_cell_info)
-			layout->fixup_cell_info(nvmem, layout, &info);
+		if (nvmem->fixup_dt_cell_info)
+			nvmem->fixup_dt_cell_info(nvmem, &info);
 
 		ret = nvmem_add_one_cell(nvmem, &info);
 		kfree(info.name);
@@ -902,6 +901,7 @@ struct nvmem_device *nvmem_register(const struct nvmem_config *config)
 
 	kref_init(&nvmem->refcnt);
 	INIT_LIST_HEAD(&nvmem->cells);
+	nvmem->fixup_dt_cell_info = config->fixup_dt_cell_info;
 
 	nvmem->owner = config->owner;
 	if (!nvmem->owner && config->dev->driver)
diff --git a/drivers/nvmem/imx-ocotp.c b/drivers/nvmem/imx-ocotp.c
index f1e202efaa497..79dd4fda03295 100644
--- a/drivers/nvmem/imx-ocotp.c
+++ b/drivers/nvmem/imx-ocotp.c
@@ -583,17 +583,12 @@ static const struct of_device_id imx_ocotp_dt_ids[] = {
 };
 MODULE_DEVICE_TABLE(of, imx_ocotp_dt_ids);
 
-static void imx_ocotp_fixup_cell_info(struct nvmem_device *nvmem,
-				      struct nvmem_layout *layout,
-				      struct nvmem_cell_info *cell)
+static void imx_ocotp_fixup_dt_cell_info(struct nvmem_device *nvmem,
+					 struct nvmem_cell_info *cell)
 {
 	cell->read_post_process = imx_ocotp_cell_pp;
 }
 
-static struct nvmem_layout imx_ocotp_layout = {
-	.fixup_cell_info = imx_ocotp_fixup_cell_info,
-};
-
 static int imx_ocotp_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -619,7 +614,7 @@ static int imx_ocotp_probe(struct platform_device *pdev)
 	imx_ocotp_nvmem_config.size = 4 * priv->params->nregs;
 	imx_ocotp_nvmem_config.dev = dev;
 	imx_ocotp_nvmem_config.priv = priv;
-	imx_ocotp_nvmem_config.layout = &imx_ocotp_layout;
+	imx_ocotp_nvmem_config.fixup_dt_cell_info = &imx_ocotp_fixup_dt_cell_info;
 
 	priv->config = &imx_ocotp_nvmem_config;
 
diff --git a/drivers/nvmem/internals.h b/drivers/nvmem/internals.h
index ce353831cd655..893553fbdf51a 100644
--- a/drivers/nvmem/internals.h
+++ b/drivers/nvmem/internals.h
@@ -23,6 +23,8 @@ struct nvmem_device {
 	struct bin_attribute	eeprom;
 	struct device		*base_dev;
 	struct list_head	cells;
+	void (*fixup_dt_cell_info)(struct nvmem_device *nvmem,
+				   struct nvmem_cell_info *cell);
 	const struct nvmem_keepout *keepout;
 	unsigned int		nkeepout;
 	nvmem_reg_read_t	reg_read;
diff --git a/drivers/nvmem/mtk-efuse.c b/drivers/nvmem/mtk-efuse.c
index 87c94686cfd21..84f05b40a4112 100644
--- a/drivers/nvmem/mtk-efuse.c
+++ b/drivers/nvmem/mtk-efuse.c
@@ -45,9 +45,8 @@ static int mtk_efuse_gpu_speedbin_pp(void *context, const char *id, int index,
 	return 0;
 }
 
-static void mtk_efuse_fixup_cell_info(struct nvmem_device *nvmem,
-				      struct nvmem_layout *layout,
-				      struct nvmem_cell_info *cell)
+static void mtk_efuse_fixup_dt_cell_info(struct nvmem_device *nvmem,
+					 struct nvmem_cell_info *cell)
 {
 	size_t sz = strlen(cell->name);
 
@@ -61,10 +60,6 @@ static void mtk_efuse_fixup_cell_info(struct nvmem_device *nvmem,
 		cell->read_post_process = mtk_efuse_gpu_speedbin_pp;
 }
 
-static struct nvmem_layout mtk_efuse_layout = {
-	.fixup_cell_info = mtk_efuse_fixup_cell_info,
-};
-
 static int mtk_efuse_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -91,7 +86,7 @@ static int mtk_efuse_probe(struct platform_device *pdev)
 	econfig.priv = priv;
 	econfig.dev = dev;
 	if (pdata->uses_post_processing)
-		econfig.layout = &mtk_efuse_layout;
+		econfig.fixup_dt_cell_info = &mtk_efuse_fixup_dt_cell_info;
 	nvmem = devm_nvmem_register(dev, &econfig);
 
 	return PTR_ERR_OR_ZERO(nvmem);
diff --git a/include/linux/nvmem-provider.h b/include/linux/nvmem-provider.h
index ecd580ee84db9..9a015e4d428cc 100644
--- a/include/linux/nvmem-provider.h
+++ b/include/linux/nvmem-provider.h
@@ -83,6 +83,8 @@ struct nvmem_cell_info {
  * @cells:	Optional array of pre-defined NVMEM cells.
  * @ncells:	Number of elements in cells.
  * @add_legacy_fixed_of_cells:	Read fixed NVMEM cells from old OF syntax.
+ * @fixup_dt_cell_info: Will be called before a cell is added. Can be
+ *		used to modify the nvmem_cell_info.
  * @keepout:	Optional array of keepout ranges (sorted ascending by start).
  * @nkeepout:	Number of elements in the keepout array.
  * @type:	Type of the nvmem storage
@@ -114,6 +116,8 @@ struct nvmem_config {
 	const struct nvmem_cell_info	*cells;
 	int			ncells;
 	bool			add_legacy_fixed_of_cells;
+	void (*fixup_dt_cell_info)(struct nvmem_device *nvmem,
+				   struct nvmem_cell_info *cell);
 	const struct nvmem_keepout *keepout;
 	unsigned int		nkeepout;
 	enum nvmem_type		type;
@@ -160,8 +164,6 @@ struct nvmem_cell_table {
  * @of_match_table:	Open firmware match table.
  * @add_cells:		Called to populate the layout using
  *			nvmem_add_one_cell().
- * @fixup_cell_info:	Will be called before a cell is added. Can be
- *			used to modify the nvmem_cell_info.
  * @owner:		Pointer to struct module.
  * @node:		List node.
  *
@@ -174,9 +176,6 @@ struct nvmem_layout {
 	const char *name;
 	const struct of_device_id *of_match_table;
 	int (*add_cells)(struct device *dev, struct nvmem_device *nvmem);
-	void (*fixup_cell_info)(struct nvmem_device *nvmem,
-				struct nvmem_layout *layout,
-				struct nvmem_cell_info *cell);
 
 	/* private */
 	struct module *owner;
-- 
2.39.5



