Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 675A0149C57;
	Mon, 16 Sep 2024 12:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488515; cv=none; b=cBbUgxFZl8aT1HfOSzS/GTJQRApjZKujdCT1W+TYchktykSQ3Jq7P0SIx/0+dTVHnqMJf6LnTI8Dwl8BORAdZMLJ6ac5ZJaaG8NZMz5KznZGHLhYzalx+8UidJT0VTH1Ff84ciQKIsjdWGOLYVZ80NxJ76s/yXBnuiJ0zGLIBbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488515; c=relaxed/simple;
	bh=cwqLtmDxj+ctWl+zImvBIgtKbbKUfSgsAH1yVX+eKfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sMA6TsAXxhNbCcjZD9M3vdUdN5w+qvgj/0C/RlMdgaTQ81DGc1GZIrweqkZi/eG07Xry2XNgyXYlNXqfBai7N1XcYsXyIKYXOXY28/KZOVgBTBz4rlFiepCZR4ewZkazQgMj+jiLB/eiUsu/k9w8ETGzHp9BDHgdHzI8RTi2Wmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MXgN57fO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MXgN57fO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4728C4CECF;
	Mon, 16 Sep 2024 12:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488515;
	bh=cwqLtmDxj+ctWl+zImvBIgtKbbKUfSgsAH1yVX+eKfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MXgN57fODwYBfPXvE2wYeK7Us2BAR0odYsV8Fkifws4ShUxYijicnCFqYNzmG2Z6f
	 QPAckbbKUBkiz7H1gIdjQwqf3ParLEi4uwVxHhb3IBOpR7QxIUD6jpHRWAqOEaLBFN
	 sM6nWyUr4shipuN46skVNj/Ssn8+Dzlh0R6FqAKQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 06/91] nvmem: u-boot-env: use nvmem_add_one_cell() nvmem subsystem helper
Date: Mon, 16 Sep 2024 13:43:42 +0200
Message-ID: <20240916114224.729288400@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 7c8979b42b1a9c5604f431ba804928e55919263c ]

Simplify adding NVMEM cells.

Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20231221173421.13737-3-zajec5@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 8679e8b4a1eb ("nvmem: u-boot-env: error if NVMEM device is too small")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/u-boot-env.c | 55 +++++++++++++++-----------------------
 1 file changed, 21 insertions(+), 34 deletions(-)

diff --git a/drivers/nvmem/u-boot-env.c b/drivers/nvmem/u-boot-env.c
index c4ae94af4af7..dd9d0ad22712 100644
--- a/drivers/nvmem/u-boot-env.c
+++ b/drivers/nvmem/u-boot-env.c
@@ -23,13 +23,10 @@ enum u_boot_env_format {
 
 struct u_boot_env {
 	struct device *dev;
+	struct nvmem_device *nvmem;
 	enum u_boot_env_format format;
 
 	struct mtd_info *mtd;
-
-	/* Cells */
-	struct nvmem_cell_info *cells;
-	int ncells;
 };
 
 struct u_boot_env_image_single {
@@ -94,43 +91,36 @@ static int u_boot_env_read_post_process_ethaddr(void *context, const char *id, i
 static int u_boot_env_add_cells(struct u_boot_env *priv, uint8_t *buf,
 				size_t data_offset, size_t data_len)
 {
+	struct nvmem_device *nvmem = priv->nvmem;
 	struct device *dev = priv->dev;
 	char *data = buf + data_offset;
 	char *var, *value, *eq;
-	int idx;
-
-	priv->ncells = 0;
-	for (var = data; var < data + data_len && *var; var += strlen(var) + 1)
-		priv->ncells++;
-
-	priv->cells = devm_kcalloc(dev, priv->ncells, sizeof(*priv->cells), GFP_KERNEL);
-	if (!priv->cells)
-		return -ENOMEM;
 
-	for (var = data, idx = 0;
+	for (var = data;
 	     var < data + data_len && *var;
-	     var = value + strlen(value) + 1, idx++) {
+	     var = value + strlen(value) + 1) {
+		struct nvmem_cell_info info = {};
+
 		eq = strchr(var, '=');
 		if (!eq)
 			break;
 		*eq = '\0';
 		value = eq + 1;
 
-		priv->cells[idx].name = devm_kstrdup(dev, var, GFP_KERNEL);
-		if (!priv->cells[idx].name)
+		info.name = devm_kstrdup(dev, var, GFP_KERNEL);
+		if (!info.name)
 			return -ENOMEM;
-		priv->cells[idx].offset = data_offset + value - data;
-		priv->cells[idx].bytes = strlen(value);
-		priv->cells[idx].np = of_get_child_by_name(dev->of_node, priv->cells[idx].name);
+		info.offset = data_offset + value - data;
+		info.bytes = strlen(value);
+		info.np = of_get_child_by_name(dev->of_node, info.name);
 		if (!strcmp(var, "ethaddr")) {
-			priv->cells[idx].raw_len = strlen(value);
-			priv->cells[idx].bytes = ETH_ALEN;
-			priv->cells[idx].read_post_process = u_boot_env_read_post_process_ethaddr;
+			info.raw_len = strlen(value);
+			info.bytes = ETH_ALEN;
+			info.read_post_process = u_boot_env_read_post_process_ethaddr;
 		}
-	}
 
-	if (WARN_ON(idx != priv->ncells))
-		priv->ncells = idx;
+		nvmem_add_one_cell(nvmem, &info);
+	}
 
 	return 0;
 }
@@ -209,7 +199,6 @@ static int u_boot_env_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct device_node *np = dev->of_node;
 	struct u_boot_env *priv;
-	int err;
 
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
@@ -224,17 +213,15 @@ static int u_boot_env_probe(struct platform_device *pdev)
 		return PTR_ERR(priv->mtd);
 	}
 
-	err = u_boot_env_parse(priv);
-	if (err)
-		return err;
-
 	config.dev = dev;
-	config.cells = priv->cells;
-	config.ncells = priv->ncells;
 	config.priv = priv;
 	config.size = priv->mtd->size;
 
-	return PTR_ERR_OR_ZERO(devm_nvmem_register(dev, &config));
+	priv->nvmem = devm_nvmem_register(dev, &config);
+	if (IS_ERR(priv->nvmem))
+		return PTR_ERR(priv->nvmem);
+
+	return u_boot_env_parse(priv);
 }
 
 static const struct of_device_id u_boot_env_of_match_table[] = {
-- 
2.43.0



