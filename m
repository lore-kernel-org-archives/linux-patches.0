Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA85C17C21C;
	Mon, 24 Feb 2025 14:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408112; cv=none; b=CbBoi5bxOWCxsUH2InsYL5M8o19Q5gyxd/e4KzCFo7vJcr2Du16IiTvPYWkZMxh3Dhd0V6o3r46aaDclHTOZOX3kP7rm4RcVph1D8DVAgoSbzWw9QE0IJZr4aza8s3+OY/KOe92Kskx7vh7NjywTtQYlOW6eEdAxDt0j3C4FnWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408112; c=relaxed/simple;
	bh=9ZchoO7qo9/joQiQbPghO1o4qXZqtYuoUX/FjVoBuf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tUURtANm4ZKxUrgh8B43EHmI3V56XRIm32RDT9QdzyNyQqGMnzJZJjlKIIlfhv3HuYQQyYRuCC64s+SzLTmKaMNaX9Fblh4Vo0u6ojXDtnzyFe+4gEM3G/3CHPRK45XeY+zMRLw6iZZOAsYwU/DlWk9xYhYcrS5AZ+9Jy+L3Les=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EehrrO/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EehrrO/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44289C4CEE8;
	Mon, 24 Feb 2025 14:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408112;
	bh=9ZchoO7qo9/joQiQbPghO1o4qXZqtYuoUX/FjVoBuf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EehrrO/R+Q37E/JYXFFs/oQTaMsCLmpSS53BfaeIaAJoA21wTdXC2FS90Hh9oMwTm
	 vloKMLYpTwQyvTJy/Q7QrSpKKb5bz+tiYNVsWmEnFsriVBOgftwADo8vV3AG0WdFEK
	 hwZxjObzuK+RMP8FBVinbhwmyNzgb4VBYrtSUhS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	stable <stable@kernel.org>,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 061/140] nvmem: imx-ocotp-ele: fix MAC address byte order
Date: Mon, 24 Feb 2025 15:34:20 +0100
Message-ID: <20250224142605.412057956@linuxfoundation.org>
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

From: Sascha Hauer <s.hauer@pengutronix.de>

[ Upstream commit 391b06ecb63e6eacd054582cb4eb738dfbf5eb77 ]

According to the i.MX93 Fusemap the two MAC addresses are stored in
words 315 to 317 like this:

315	MAC1_ADDR_31_0[31:0]
316	MAC1_ADDR_47_32[47:32]
	MAC2_ADDR_15_0[15:0]
317	MAC2_ADDR_47_16[31:0]

This means the MAC addresses are stored in reverse byte order. We have
to swap the bytes before passing them to the upper layers. The storage
format is consistent to the one used on i.MX6 using imx-ocotp driver
which does the same byte swapping as introduced here.

With this patch the MAC address on my i.MX93 TQ board correctly reads as
00:d0:93:6b:27:b8 instead of b8:27:6b:93:d0:00.

Fixes: 22e9e6fcfb50 ("nvmem: imx: support i.MX93 OCOTP")
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Cc: stable <stable@kernel.org>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20241230141901.263976-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/imx-ocotp-ele.c | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/drivers/nvmem/imx-ocotp-ele.c b/drivers/nvmem/imx-ocotp-ele.c
index dfc925edfc83e..1356ec93bfd00 100644
--- a/drivers/nvmem/imx-ocotp-ele.c
+++ b/drivers/nvmem/imx-ocotp-ele.c
@@ -107,6 +107,26 @@ static int imx_ocotp_reg_read(void *context, unsigned int offset, void *val, siz
 	return 0;
 };
 
+static int imx_ocotp_cell_pp(void *context, const char *id, int index,
+			     unsigned int offset, void *data, size_t bytes)
+{
+	u8 *buf = data;
+	int i;
+
+	/* Deal with some post processing of nvmem cell data */
+	if (id && !strcmp(id, "mac-address"))
+		for (i = 0; i < bytes / 2; i++)
+			swap(buf[i], buf[bytes - i - 1]);
+
+	return 0;
+}
+
+static void imx_ocotp_fixup_dt_cell_info(struct nvmem_device *nvmem,
+					 struct nvmem_cell_info *cell)
+{
+	cell->read_post_process = imx_ocotp_cell_pp;
+}
+
 static int imx_ele_ocotp_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -133,6 +153,8 @@ static int imx_ele_ocotp_probe(struct platform_device *pdev)
 	priv->config.stride = 1;
 	priv->config.priv = priv;
 	priv->config.read_only = true;
+	priv->config.add_legacy_fixed_of_cells = true;
+	priv->config.fixup_dt_cell_info = imx_ocotp_fixup_dt_cell_info;
 	mutex_init(&priv->lock);
 
 	nvmem = devm_nvmem_register(dev, &priv->config);
-- 
2.39.5



