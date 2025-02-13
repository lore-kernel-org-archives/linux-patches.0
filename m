Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246FB24168C;
	Thu, 13 Feb 2025 14:51:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458284; cv=none; b=k6iYq2wZ/WKNUCljH5NR+08MlTpq90VcT8VLYkZBGkbobxq8nbSyLqyuL35NKM/A754JNXwDfpKmvfbexZZy9sgzR9iXyo5Q60px67E+W/9ssfnl2g5a6pTrr3bxvWE+oefHmhHbdtyhWzELv/mdfGKNs1Wr5/hz4zOJOCo7pzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458284; c=relaxed/simple;
	bh=tvo/38T0pzA/27QJIe46Lb1GBghv8bqnpiLmWcck2Bw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LQf3lDGZYnSnDERpAZvB28XOo7veuFF5pCXbhdRVyQPQ+QaNCi4B72RwRAt311Y/aQr+kx2dh26iCprYuBQ/jNH2FbqvdzFaa9FG7eSnBb30JaMSbsQOxAhNRCcvk1iAA4KojkvCVPbQ9gd+EUhuyrpAUc58WvgjHNZ1sP7QmSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5Uqkb3P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5Uqkb3P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89333C4CED1;
	Thu, 13 Feb 2025 14:51:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458284;
	bh=tvo/38T0pzA/27QJIe46Lb1GBghv8bqnpiLmWcck2Bw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f5Uqkb3PAhiTG57hqaZd2YTdHS6Ipf2nT7HD+HbL8hMmL6bRiREVep/5M9nktaeeT
	 PB1gDqtWnjNv3JUYdk0GJK2bnZgA6zi9ChzxWIaYlDU9FpEZMGxQRrJFxqlcq/U8hC
	 mxL8SeMBCW/7yjTmv/c+34nrUccxklNxVU24XobI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sascha Hauer <s.hauer@pengutronix.de>,
	stable <stable@kernel.org>,
	Peng Fan <peng.fan@nxp.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Subject: [PATCH 6.12 354/422] nvmem: imx-ocotp-ele: fix MAC address byte order
Date: Thu, 13 Feb 2025 15:28:23 +0100
Message-ID: <20250213142450.214931566@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit 391b06ecb63e6eacd054582cb4eb738dfbf5eb77 upstream.

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
---
 drivers/nvmem/imx-ocotp-ele.c |   22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/nvmem/imx-ocotp-ele.c
+++ b/drivers/nvmem/imx-ocotp-ele.c
@@ -109,6 +109,26 @@ static int imx_ocotp_reg_read(void *cont
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
@@ -135,6 +155,8 @@ static int imx_ele_ocotp_probe(struct pl
 	priv->config.stride = 1;
 	priv->config.priv = priv;
 	priv->config.read_only = true;
+	priv->config.add_legacy_fixed_of_cells = true;
+	priv->config.fixup_dt_cell_info = imx_ocotp_fixup_dt_cell_info;
 	mutex_init(&priv->lock);
 
 	nvmem = devm_nvmem_register(dev, &priv->config);


