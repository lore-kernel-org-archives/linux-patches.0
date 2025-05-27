Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B2A27FB02;
	Tue, 27 May 2025 17:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366401; cv=none; b=gP0bLcLwRr9Yc8tzZNKhdA7l8a8qS0aU3Or9zYRbRvvEME8eX0N2TYUdg2G8Aup+hDwT0L4KKmnmaE0AxP5uXl+a5r/8DghlSxajL6BvfMbyOA4jlZLGZfXwAJa+TTMlOG18TAnyumFRGX7tQM37GNi7AYjNXTU3hqNP8uxAa3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366401; c=relaxed/simple;
	bh=Ut+D0Xw85w4MELh3O3BiSQgjjx51VM+CAF8+FOvgoo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=El/ZUUzAMmi7NF1bSIYrOefjcxJNHNgAElcU21zvVNmmLGFhVXBsTY7OW47okkIZ7dtqqq3jJEgA9bN/7EMLVPNbPwcOVOdcpVAaqrv4nxzA52PtX3bFNuFG5bS+7wmzR1jLls394RuCQsoWFgU/9lq56/q4UdRV3H8gBwlDN7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NR70rKLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NR70rKLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C7FDC4CEE9;
	Tue, 27 May 2025 17:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366400;
	bh=Ut+D0Xw85w4MELh3O3BiSQgjjx51VM+CAF8+FOvgoo4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NR70rKLDItMq4PlmR1C/rpS55QSXoH0CY4HpJ4YsZNPWYmkloAe0C/kUyLLkKLkcx
	 nl3oZjzjLZXweANPPLwX8Y807TVB5tUaWhdrfVcRJlOiip8rr4aX8v7AR0bxeq/koH
	 LxGVoYezTaUKBypL9VdBD7VVVZFzXTSx594fy5Ko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 015/783] nvmem: qfprom: switch to 4-byte aligned reads
Date: Tue, 27 May 2025 18:16:52 +0200
Message-ID: <20250527162513.668703680@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

[ Upstream commit 3566a737db87a9bf360c2fd36433c5149f805f2e ]

All platforms since Snapdragon 8 Gen1 (SM8450) require using 4-byte
reads to access QFPROM data. While older platforms were more than happy
with 1-byte reads, change the qfprom driver to use 4-byte reads for all
the platforms. Specify stride and word size of 4 bytes. To retain
compatibility with the existing DT and to simplify porting data from
vendor kernels, use fixup_dt_cell_info in order to bump alignment
requirements.

Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20250411112251.68002-12-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/qfprom.c | 26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/nvmem/qfprom.c b/drivers/nvmem/qfprom.c
index 116a39e804c70..a872c640b8c5a 100644
--- a/drivers/nvmem/qfprom.c
+++ b/drivers/nvmem/qfprom.c
@@ -321,19 +321,32 @@ static int qfprom_reg_read(void *context,
 			unsigned int reg, void *_val, size_t bytes)
 {
 	struct qfprom_priv *priv = context;
-	u8 *val = _val;
-	int i = 0, words = bytes;
+	u32 *val = _val;
 	void __iomem *base = priv->qfpcorrected;
+	int words = DIV_ROUND_UP(bytes, sizeof(u32));
+	int i;
 
 	if (read_raw_data && priv->qfpraw)
 		base = priv->qfpraw;
 
-	while (words--)
-		*val++ = readb(base + reg + i++);
+	for (i = 0; i < words; i++)
+		*val++ = readl(base + reg + i * sizeof(u32));
 
 	return 0;
 }
 
+/* Align reads to word boundary */
+static void qfprom_fixup_dt_cell_info(struct nvmem_device *nvmem,
+				      struct nvmem_cell_info *cell)
+{
+	unsigned int byte_offset = cell->offset % sizeof(u32);
+
+	cell->bit_offset += byte_offset * BITS_PER_BYTE;
+	cell->offset -= byte_offset;
+	if (byte_offset && !cell->nbits)
+		cell->nbits = cell->bytes * BITS_PER_BYTE;
+}
+
 static void qfprom_runtime_disable(void *data)
 {
 	pm_runtime_disable(data);
@@ -358,10 +371,11 @@ static int qfprom_probe(struct platform_device *pdev)
 	struct nvmem_config econfig = {
 		.name = "qfprom",
 		.add_legacy_fixed_of_cells = true,
-		.stride = 1,
-		.word_size = 1,
+		.stride = 4,
+		.word_size = 4,
 		.id = NVMEM_DEVID_AUTO,
 		.reg_read = qfprom_reg_read,
+		.fixup_dt_cell_info = qfprom_fixup_dt_cell_info,
 	};
 	struct device *dev = &pdev->dev;
 	struct resource *res;
-- 
2.39.5



