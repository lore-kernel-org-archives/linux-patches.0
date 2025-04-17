Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 328362566C4;
	Thu, 17 Apr 2025 17:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912678; cv=none; b=K6kYDtShyEfOg9ALNdlgL+vMi4n0CZBhuEUW3mNCFKaDE18mDx/UrkgCcxbQrh2q+V6XfaPp/LQdWqJpP9zx4NJHGWO8BB8M2vt580TcT4Ckje+O4QperYqlPLK8/ccS2dVBF2UMo4zAnLHgOLdWcfCP7koerOfwB0xfkb61IB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912678; c=relaxed/simple;
	bh=viIYxlmnx1FM8vmbZYkAjti/AVxUHnyQRkTTVYpWd18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rcp+b7KYSD9hPPbWyD8lbfQ+LG+T9Rq0Z7rAwh1Fv44MZz3rPGcvW6Krrtxz8lIelxm0BcxWUKmnYDt4y+9rAe+r9alRDlDw+7S5BwZ1JIxQp5n/BvyBYFLoXcnhiJwPR0R67AT3QeaR/iq9QeyThg3LGroROEjfAEEh9nLnHGs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2r3zWkB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2r3zWkB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3ADC4CEE4;
	Thu, 17 Apr 2025 17:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912678;
	bh=viIYxlmnx1FM8vmbZYkAjti/AVxUHnyQRkTTVYpWd18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2r3zWkB6reoKVSVDXdLVjGZPDE3U3y4DNhZsm+OmMo6d4jCSuBGkUJRNRkwm1WZs
	 BJ/dhWUIErC45OLtlSejbeAFsQr2iEBWzTI87LxLlcW4DbuP5vA71Wa/ZKFyNwzOQV
	 benacd+SI8zu3grBCmdS/l/WbLaRrn7R8AFwd5l8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaustabh Chakraborty <kauschluss@disroot.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 088/449] mmc: dw_mmc: add a quirk for accessing 64-bit FIFOs in two halves
Date: Thu, 17 Apr 2025 19:46:16 +0200
Message-ID: <20250417175121.512078152@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

From: Kaustabh Chakraborty <kauschluss@disroot.org>

[ Upstream commit 57c0902f8bec51add5a1eb908d8b876592725d81 ]

In certain DW MMC implementations (such as in some Exynos7870
controllers), 64-bit read/write is not allowed from a 64-bit FIFO.
Add a quirk which facilitates accessing the 64-bit FIFO registers in two
32-bit halves.

Signed-off-by: Kaustabh Chakraborty <kauschluss@disroot.org>
Link: https://lore.kernel.org/r/20250219-exynos7870-mmc-v2-2-b4255a3e39ed@disroot.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/host/dw_mmc.c | 94 ++++++++++++++++++++++++++++++++++++++-
 drivers/mmc/host/dw_mmc.h | 27 +++++++++++
 2 files changed, 119 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/dw_mmc.c b/drivers/mmc/host/dw_mmc.c
index 3cbda98d08d28..74f224647bf1e 100644
--- a/drivers/mmc/host/dw_mmc.c
+++ b/drivers/mmc/host/dw_mmc.c
@@ -2579,6 +2579,91 @@ static void dw_mci_pull_data64(struct dw_mci *host, void *buf, int cnt)
 	}
 }
 
+static void dw_mci_push_data64_32(struct dw_mci *host, void *buf, int cnt)
+{
+	struct mmc_data *data = host->data;
+	int init_cnt = cnt;
+
+	/* try and push anything in the part_buf */
+	if (unlikely(host->part_buf_count)) {
+		int len = dw_mci_push_part_bytes(host, buf, cnt);
+
+		buf += len;
+		cnt -= len;
+
+		if (host->part_buf_count == 8) {
+			mci_fifo_l_writeq(host->fifo_reg, host->part_buf);
+			host->part_buf_count = 0;
+		}
+	}
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (unlikely((unsigned long)buf & 0x7)) {
+		while (cnt >= 8) {
+			u64 aligned_buf[16];
+			int len = min(cnt & -8, (int)sizeof(aligned_buf));
+			int items = len >> 3;
+			int i;
+			/* memcpy from input buffer into aligned buffer */
+			memcpy(aligned_buf, buf, len);
+			buf += len;
+			cnt -= len;
+			/* push data from aligned buffer into fifo */
+			for (i = 0; i < items; ++i)
+				mci_fifo_l_writeq(host->fifo_reg, aligned_buf[i]);
+		}
+	} else
+#endif
+	{
+		u64 *pdata = buf;
+
+		for (; cnt >= 8; cnt -= 8)
+			mci_fifo_l_writeq(host->fifo_reg, *pdata++);
+		buf = pdata;
+	}
+	/* put anything remaining in the part_buf */
+	if (cnt) {
+		dw_mci_set_part_bytes(host, buf, cnt);
+		/* Push data if we have reached the expected data length */
+		if ((data->bytes_xfered + init_cnt) ==
+		    (data->blksz * data->blocks))
+			mci_fifo_l_writeq(host->fifo_reg, host->part_buf);
+	}
+}
+
+static void dw_mci_pull_data64_32(struct dw_mci *host, void *buf, int cnt)
+{
+#ifndef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+	if (unlikely((unsigned long)buf & 0x7)) {
+		while (cnt >= 8) {
+			/* pull data from fifo into aligned buffer */
+			u64 aligned_buf[16];
+			int len = min(cnt & -8, (int)sizeof(aligned_buf));
+			int items = len >> 3;
+			int i;
+
+			for (i = 0; i < items; ++i)
+				aligned_buf[i] = mci_fifo_l_readq(host->fifo_reg);
+
+			/* memcpy from aligned buffer into output buffer */
+			memcpy(buf, aligned_buf, len);
+			buf += len;
+			cnt -= len;
+		}
+	} else
+#endif
+	{
+		u64 *pdata = buf;
+
+		for (; cnt >= 8; cnt -= 8)
+			*pdata++ = mci_fifo_l_readq(host->fifo_reg);
+		buf = pdata;
+	}
+	if (cnt) {
+		host->part_buf = mci_fifo_l_readq(host->fifo_reg);
+		dw_mci_pull_final_bytes(host, buf, cnt);
+	}
+}
+
 static void dw_mci_pull_data(struct dw_mci *host, void *buf, int cnt)
 {
 	int len;
@@ -3379,8 +3464,13 @@ int dw_mci_probe(struct dw_mci *host)
 		width = 16;
 		host->data_shift = 1;
 	} else if (i == 2) {
-		host->push_data = dw_mci_push_data64;
-		host->pull_data = dw_mci_pull_data64;
+		if ((host->quirks & DW_MMC_QUIRK_FIFO64_32)) {
+			host->push_data = dw_mci_push_data64_32;
+			host->pull_data = dw_mci_pull_data64_32;
+		} else {
+			host->push_data = dw_mci_push_data64;
+			host->pull_data = dw_mci_pull_data64;
+		}
 		width = 64;
 		host->data_shift = 3;
 	} else {
diff --git a/drivers/mmc/host/dw_mmc.h b/drivers/mmc/host/dw_mmc.h
index 6447b916990dc..5463392dc8110 100644
--- a/drivers/mmc/host/dw_mmc.h
+++ b/drivers/mmc/host/dw_mmc.h
@@ -281,6 +281,8 @@ struct dw_mci_board {
 
 /* Support for longer data read timeout */
 #define DW_MMC_QUIRK_EXTENDED_TMOUT            BIT(0)
+/* Force 32-bit access to the FIFO */
+#define DW_MMC_QUIRK_FIFO64_32                 BIT(1)
 
 #define DW_MMC_240A		0x240a
 #define DW_MMC_280A		0x280a
@@ -472,6 +474,31 @@ struct dw_mci_board {
 #define mci_fifo_writel(__value, __reg)	__raw_writel(__reg, __value)
 #define mci_fifo_writeq(__value, __reg)	__raw_writeq(__reg, __value)
 
+/*
+ * Some dw_mmc devices have 64-bit FIFOs, but expect them to be
+ * accessed using two 32-bit accesses. If such controller is used
+ * with a 64-bit kernel, this has to be done explicitly.
+ */
+static inline u64 mci_fifo_l_readq(void __iomem *addr)
+{
+	u64 ans;
+	u32 proxy[2];
+
+	proxy[0] = mci_fifo_readl(addr);
+	proxy[1] = mci_fifo_readl(addr + 4);
+	memcpy(&ans, proxy, 8);
+	return ans;
+}
+
+static inline void mci_fifo_l_writeq(void __iomem *addr, u64 value)
+{
+	u32 proxy[2];
+
+	memcpy(proxy, &value, 8);
+	mci_fifo_writel(addr, proxy[0]);
+	mci_fifo_writel(addr + 4, proxy[1]);
+}
+
 /* Register access macros */
 #define mci_readl(dev, reg)			\
 	readl_relaxed((dev)->regs + SDMMC_##reg)
-- 
2.39.5



