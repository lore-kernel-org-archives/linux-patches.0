Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29A55259CAD;
	Tue, 25 Mar 2025 12:29:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905762; cv=none; b=e6OqszbH6Rge/47tODRLGV+HFRhtaYxMYMoqs0lxLN/oujeQf29O0Pd8uT9Vy2G91tIKsyRu6pLftIuH1sAbp1u0z2iZFmxNU0smbUOevBQMKP84mM2y19aMzLeuihDWVCf5QpcmblH/iN50j0TRSpgy9GArGl/IKDb0HDqr5nY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905762; c=relaxed/simple;
	bh=zmMECqBU9k7nCE7GvaklHPpjBwBkklo9NWL3xoOGIRo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZVyuTo7ZFR8vFHsgPw36Q4ug0vgIhyaEIfYajo1pfAAUT7crqjWKBmYE01A4O6TZkmT4w3YV3+pi6Obj9FeMrAJBkN5eobOHVhmjCp2YexG7t3Ka1uwevwxSBrMxcRtWimo4hyAw+grT9vwi7ouATUaWTwyTksePKexHZr503w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pw/zSwUl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pw/zSwUl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFBD6C4CEE4;
	Tue, 25 Mar 2025 12:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905762;
	bh=zmMECqBU9k7nCE7GvaklHPpjBwBkklo9NWL3xoOGIRo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pw/zSwUlYeuW7J6t1vY76Vrtpw3F/Ns067gJdKtwOMo8ShlQdSUPufQnjSKVP5pJH
	 nb/j/20Iv883lXjliCWtffp5UG8hNQusivdDPK1c8jR77ZO57wY4gJNCGSpBCAdlZB
	 SB3fX7uOBXFwIYQyAqJlbz5CPyf0cig8SViJF48Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 150/198] soc: imx8m: Use devm_* to simplify probe failure handling
Date: Tue, 25 Mar 2025 08:21:52 -0400
Message-ID: <20250325122200.592008889@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marex@denx.de>

[ Upstream commit 22b03a4e957e462b380a982759ccf0f6554735d3 ]

Use device managed functions to simplify handling of failures during
probe. Remove fail paths which are no longer necessary.

Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: cf7139aac463 ("soc: imx8m: Unregister cpufreq and soc dev in cleanup path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/soc-imx8m.c | 92 ++++++++++++-------------------------
 1 file changed, 29 insertions(+), 63 deletions(-)

diff --git a/drivers/soc/imx/soc-imx8m.c b/drivers/soc/imx/soc-imx8m.c
index 9587641e0c4f9..bd62ccb935a1a 100644
--- a/drivers/soc/imx/soc-imx8m.c
+++ b/drivers/soc/imx/soc-imx8m.c
@@ -51,22 +51,20 @@ static inline u32 imx8mq_soc_revision_from_atf(void) { return 0; };
 
 static int imx8mq_soc_revision(u32 *socrev, u64 *socuid)
 {
-	struct device_node *np;
+	struct device_node *np __free(device_node) =
+		of_find_compatible_node(NULL, NULL, "fsl,imx8mq-ocotp");
 	void __iomem *ocotp_base;
 	u32 magic;
 	u32 rev;
 	struct clk *clk;
 	int ret;
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx8mq-ocotp");
 	if (!np)
 		return -EINVAL;
 
 	ocotp_base = of_iomap(np, 0);
-	if (!ocotp_base) {
-		ret = -EINVAL;
-		goto err_iomap;
-	}
+	if (!ocotp_base)
+		return -EINVAL;
 
 	clk = of_clk_get_by_name(np, NULL);
 	if (IS_ERR(clk)) {
@@ -96,35 +94,30 @@ static int imx8mq_soc_revision(u32 *socrev, u64 *socuid)
 	clk_disable_unprepare(clk);
 	clk_put(clk);
 	iounmap(ocotp_base);
-	of_node_put(np);
 
 	return 0;
 
 err_clk:
 	iounmap(ocotp_base);
-err_iomap:
-	of_node_put(np);
 	return ret;
 }
 
 static int imx8mm_soc_uid(u64 *socuid)
 {
+	struct device_node *np __free(device_node) =
+		of_find_compatible_node(NULL, NULL, "fsl,imx8mm-ocotp");
 	void __iomem *ocotp_base;
-	struct device_node *np;
 	struct clk *clk;
 	int ret = 0;
 	u32 offset = of_machine_is_compatible("fsl,imx8mp") ?
 		     IMX8MP_OCOTP_UID_OFFSET : 0;
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx8mm-ocotp");
 	if (!np)
 		return -EINVAL;
 
 	ocotp_base = of_iomap(np, 0);
-	if (!ocotp_base) {
-		ret = -EINVAL;
-		goto err_iomap;
-	}
+	if (!ocotp_base)
+		return -EINVAL;
 
 	clk = of_clk_get_by_name(np, NULL);
 	if (IS_ERR(clk)) {
@@ -143,38 +136,27 @@ static int imx8mm_soc_uid(u64 *socuid)
 
 err_clk:
 	iounmap(ocotp_base);
-err_iomap:
-	of_node_put(np);
-
 	return ret;
 }
 
 static int imx8mm_soc_revision(u32 *socrev, u64 *socuid)
 {
-	struct device_node *np;
+	struct device_node *np __free(device_node) =
+		of_find_compatible_node(NULL, NULL, "fsl,imx8mm-anatop");
 	void __iomem *anatop_base;
-	int ret;
 
-	np = of_find_compatible_node(NULL, NULL, "fsl,imx8mm-anatop");
 	if (!np)
 		return -EINVAL;
 
 	anatop_base = of_iomap(np, 0);
-	if (!anatop_base) {
-		ret = -EINVAL;
-		goto err_iomap;
-	}
+	if (!anatop_base)
+		return -EINVAL;
 
 	*socrev = readl_relaxed(anatop_base + ANADIG_DIGPROG_IMX8MM);
 
 	iounmap(anatop_base);
-	of_node_put(np);
 
 	return imx8mm_soc_uid(socuid);
-
-err_iomap:
-	of_node_put(np);
-	return ret;
 }
 
 static const struct imx8_soc_data imx8mq_soc_data = {
@@ -205,22 +187,23 @@ static __maybe_unused const struct of_device_id imx8_soc_match[] = {
 	{ }
 };
 
-#define imx8_revision(soc_rev) \
-	soc_rev ? \
-	kasprintf(GFP_KERNEL, "%d.%d", (soc_rev >> 4) & 0xf,  soc_rev & 0xf) : \
+#define imx8_revision(dev, soc_rev) \
+	(soc_rev) ? \
+	devm_kasprintf((dev), GFP_KERNEL, "%d.%d", ((soc_rev) >> 4) & 0xf, (soc_rev) & 0xf) : \
 	"unknown"
 
 static int imx8m_soc_probe(struct platform_device *pdev)
 {
 	struct soc_device_attribute *soc_dev_attr;
 	const struct imx8_soc_data *data;
+	struct device *dev = &pdev->dev;
 	const struct of_device_id *id;
 	struct soc_device *soc_dev;
 	u32 soc_rev = 0;
 	u64 soc_uid = 0;
 	int ret;
 
-	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
+	soc_dev_attr = devm_kzalloc(dev, sizeof(*soc_dev_attr), GFP_KERNEL);
 	if (!soc_dev_attr)
 		return -ENOMEM;
 
@@ -228,13 +211,11 @@ static int imx8m_soc_probe(struct platform_device *pdev)
 
 	ret = of_property_read_string(of_root, "model", &soc_dev_attr->machine);
 	if (ret)
-		goto free_soc;
+		return ret;
 
 	id = of_match_node(imx8_soc_match, of_root);
-	if (!id) {
-		ret = -ENODEV;
-		goto free_soc;
-	}
+	if (!id)
+		return -ENODEV;
 
 	data = id->data;
 	if (data) {
@@ -242,27 +223,21 @@ static int imx8m_soc_probe(struct platform_device *pdev)
 		if (data->soc_revision) {
 			ret = data->soc_revision(&soc_rev, &soc_uid);
 			if (ret)
-				goto free_soc;
+				return ret;
 		}
 	}
 
-	soc_dev_attr->revision = imx8_revision(soc_rev);
-	if (!soc_dev_attr->revision) {
-		ret = -ENOMEM;
-		goto free_soc;
-	}
+	soc_dev_attr->revision = imx8_revision(dev, soc_rev);
+	if (!soc_dev_attr->revision)
+		return -ENOMEM;
 
-	soc_dev_attr->serial_number = kasprintf(GFP_KERNEL, "%016llX", soc_uid);
-	if (!soc_dev_attr->serial_number) {
-		ret = -ENOMEM;
-		goto free_rev;
-	}
+	soc_dev_attr->serial_number = devm_kasprintf(dev, GFP_KERNEL, "%016llX", soc_uid);
+	if (!soc_dev_attr->serial_number)
+		return -ENOMEM;
 
 	soc_dev = soc_device_register(soc_dev_attr);
-	if (IS_ERR(soc_dev)) {
-		ret = PTR_ERR(soc_dev);
-		goto free_serial_number;
-	}
+	if (IS_ERR(soc_dev))
+		return PTR_ERR(soc_dev);
 
 	pr_info("SoC: %s revision %s\n", soc_dev_attr->soc_id,
 		soc_dev_attr->revision);
@@ -271,15 +246,6 @@ static int imx8m_soc_probe(struct platform_device *pdev)
 		platform_device_register_simple("imx-cpufreq-dt", -1, NULL, 0);
 
 	return 0;
-
-free_serial_number:
-	kfree(soc_dev_attr->serial_number);
-free_rev:
-	if (strcmp(soc_dev_attr->revision, "unknown"))
-		kfree(soc_dev_attr->revision);
-free_soc:
-	kfree(soc_dev_attr);
-	return ret;
 }
 
 static struct platform_driver imx8m_soc_driver = {
-- 
2.39.5



