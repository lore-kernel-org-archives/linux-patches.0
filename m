Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6771B1E5B91;
	Tue, 25 Mar 2025 12:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742906139; cv=none; b=ZnrmZJOCM/P5KpsDkdxEyQm8iUrUwf3M+Y5ii5/y61DG0i630Xa3Qetyha3Uygg/fs232K71hm///fivhynOwhEBLUHeWYeb/e5U+weyrA9DNZUoJTX1EfyD1NNwMfP+P2PNkKK7Y1nhwyCP8hhPGCCHnPEnbVUp0qNVx4DovUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742906139; c=relaxed/simple;
	bh=DGZw2t61Oiv9JO+rUg8qsia1sEtzNCbUH8wa3zUKD+g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGl625/tEn7ca533duh/bkbdSh2Q7R0cmrScs5eI2eGdcSl9gUGDhpT7cVqh6fwtT84VloJugp28h7jvHgKx5TqAWR8tcojJEyq96p1K8fPN8lrakmKNovaTQ86VyrpHML2pDOFOpZU8lrR+I46Wh3Dp4Uo4i6cKyRidd7cowis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R5RjYdYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R5RjYdYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD385C4CEE4;
	Tue, 25 Mar 2025 12:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742906139;
	bh=DGZw2t61Oiv9JO+rUg8qsia1sEtzNCbUH8wa3zUKD+g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R5RjYdYV+eWmbvuJ/wU7vn+XipBNpFMAI5AjjykzX0FxtZy7oJaFx7BoJkSdYInlL
	 yZOP/gxoRvpl/9KM0dyuW5zfPRrQ+QaAHOHQigK7u8S8oJb7Ug93JgfQGk2qpS1lGG
	 Ujtq2//W3WCTAqFqILic+IC3OectnvTUBdj8DhyU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 05/77] soc: imx8m: Remove global soc_uid
Date: Tue, 25 Mar 2025 08:22:00 -0400
Message-ID: <20250325122144.442697759@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122144.259256924@linuxfoundation.org>
References: <20250325122144.259256924@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit 9c1c02fe8d7f33c18547b79c41f3fa41ef7bae8f ]

The static global soc_uid is only ever used as kasprintf() parameter in
imx8m_soc_probe(). Pass pointer to local u64 variable to .soc_revision()
callback instead and let the .soc_revision() callback fill in the content.
Remove the unnecessary static global variable.

Signed-off-by: Marek Vasut <marex@denx.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Stable-dep-of: cf7139aac463 ("soc: imx8m: Unregister cpufreq and soc dev in cleanup path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/soc-imx8m.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/soc/imx/soc-imx8m.c b/drivers/soc/imx/soc-imx8m.c
index 1ff8c7d847a9e..8ccd41e219044 100644
--- a/drivers/soc/imx/soc-imx8m.c
+++ b/drivers/soc/imx/soc-imx8m.c
@@ -30,11 +30,9 @@
 
 struct imx8_soc_data {
 	char *name;
-	int (*soc_revision)(u32 *socrev);
+	int (*soc_revision)(u32 *socrev, u64 *socuid);
 };
 
-static u64 soc_uid;
-
 #ifdef CONFIG_HAVE_ARM_SMCCC
 static u32 imx8mq_soc_revision_from_atf(void)
 {
@@ -51,7 +49,7 @@ static u32 imx8mq_soc_revision_from_atf(void)
 static inline u32 imx8mq_soc_revision_from_atf(void) { return 0; };
 #endif
 
-static int imx8mq_soc_revision(u32 *socrev)
+static int imx8mq_soc_revision(u32 *socrev, u64 *socuid)
 {
 	struct device_node *np;
 	void __iomem *ocotp_base;
@@ -89,9 +87,9 @@ static int imx8mq_soc_revision(u32 *socrev)
 			rev = REV_B1;
 	}
 
-	soc_uid = readl_relaxed(ocotp_base + OCOTP_UID_HIGH);
-	soc_uid <<= 32;
-	soc_uid |= readl_relaxed(ocotp_base + OCOTP_UID_LOW);
+	*socuid = readl_relaxed(ocotp_base + OCOTP_UID_HIGH);
+	*socuid <<= 32;
+	*socuid |= readl_relaxed(ocotp_base + OCOTP_UID_LOW);
 
 	*socrev = rev;
 
@@ -109,7 +107,7 @@ static int imx8mq_soc_revision(u32 *socrev)
 	return ret;
 }
 
-static int imx8mm_soc_uid(void)
+static int imx8mm_soc_uid(u64 *socuid)
 {
 	void __iomem *ocotp_base;
 	struct device_node *np;
@@ -136,9 +134,9 @@ static int imx8mm_soc_uid(void)
 
 	clk_prepare_enable(clk);
 
-	soc_uid = readl_relaxed(ocotp_base + OCOTP_UID_HIGH + offset);
-	soc_uid <<= 32;
-	soc_uid |= readl_relaxed(ocotp_base + OCOTP_UID_LOW + offset);
+	*socuid = readl_relaxed(ocotp_base + OCOTP_UID_HIGH + offset);
+	*socuid <<= 32;
+	*socuid |= readl_relaxed(ocotp_base + OCOTP_UID_LOW + offset);
 
 	clk_disable_unprepare(clk);
 	clk_put(clk);
@@ -151,7 +149,7 @@ static int imx8mm_soc_uid(void)
 	return ret;
 }
 
-static int imx8mm_soc_revision(u32 *socrev)
+static int imx8mm_soc_revision(u32 *socrev, u64 *socuid)
 {
 	struct device_node *np;
 	void __iomem *anatop_base;
@@ -172,7 +170,7 @@ static int imx8mm_soc_revision(u32 *socrev)
 	iounmap(anatop_base);
 	of_node_put(np);
 
-	return imx8mm_soc_uid();
+	return imx8mm_soc_uid(socuid);
 
 err_iomap:
 	of_node_put(np);
@@ -215,10 +213,11 @@ static __maybe_unused const struct of_device_id imx8_soc_match[] = {
 static int imx8m_soc_probe(struct platform_device *pdev)
 {
 	struct soc_device_attribute *soc_dev_attr;
-	struct soc_device *soc_dev;
+	const struct imx8_soc_data *data;
 	const struct of_device_id *id;
+	struct soc_device *soc_dev;
 	u32 soc_rev = 0;
-	const struct imx8_soc_data *data;
+	u64 soc_uid = 0;
 	int ret;
 
 	soc_dev_attr = kzalloc(sizeof(*soc_dev_attr), GFP_KERNEL);
@@ -241,7 +240,7 @@ static int imx8m_soc_probe(struct platform_device *pdev)
 	if (data) {
 		soc_dev_attr->soc_id = data->name;
 		if (data->soc_revision) {
-			ret = data->soc_revision(&soc_rev);
+			ret = data->soc_revision(&soc_rev, &soc_uid);
 			if (ret)
 				goto free_soc;
 		}
-- 
2.39.5



