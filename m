Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24B6919D8BC;
	Sat, 12 Sep 2026 09:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207048; cv=none; b=O/1N4K1/6Bz0A097XbArxxQdngzVnn8O7XSa3C0EjW/VMLYQXF3HtWNBwMWP63xbVnp01L+IgTzpdXkdaXQcxdhkVOOAJ10UEHyY8PR5uUclPH7QTV5RSwhhjfEI9pch6wou9KECjrFEEi/uvFIGNcMqQBr9x9c6l2+u0fQSvTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207048; c=relaxed/simple;
	bh=pZJyoKq1ZWlas+9xMtY27518d1M34P1/wX35gLf9hOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jASheiJhbdL2upaukFrC3Qy6FyL4PGwKK8UVK84EteLFPl+HHlQPAM8eaX6VI+/0uumOcLnhhPy88JYqihEH97XA9pSTcLWc/l+vX/gyUnJ+04SIvI/8bxysAkPtTVNeNZBLiDyhSAHEmnZpdGgFz19NXPCqyNar6Ihfhv32zzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3cNKz8o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3cNKz8o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22F11F000FF;
	Sat, 12 Sep 2026 09:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207047;
	bh=O2e6m6kKHsWwH31jf0Zv7up7jfPDinYrZzf7pGQVgwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s3cNKz8owQ1jLgRSusJyzlbSJbbB58HsbCgjTZcHIrX5p1cMLqB2LCmINnRBeYNCF
	 kyCrUhJ7y7WeLqCxYnWobFCE9bSPuY/Kj8UsJlyf0c4Vg7RwKff+8tNYN6lL4pX4/F
	 fcROBaLbm7wnAxZfBd8FljyFSR/qwHP5D8lusxCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0333/1518] wifi: rtw89: pci: add to read PCI configuration space from common code
Date: Sat, 12 Sep 2026 08:41:42 +0200
Message-ID: <20260912065631.003955667@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ping-Ke Shih <pkshih@realtek.com>

[ Upstream commit dae8d7d63b740d8f5972b8438b139a6488e0f9fa ]

Normally only access PCI device in pci.c. However for debug purpose,
a set of registers predefined in firmware element including PCI
configuration space should be read for diagnosis.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20251111022452.28093-2-pkshih@realtek.com
Stable-dep-of: 9bf6bd6ed5ac ("wifi: rtw89: 8852a: fix RSSI report when average beacon RSSI is not ready")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/core.h | 13 +++++++++++++
 drivers/net/wireless/realtek/rtw89/mac.h  |  2 --
 drivers/net/wireless/realtek/rtw89/pci.c  | 16 ++++++++++++++++
 3 files changed, 29 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/core.h b/drivers/net/wireless/realtek/rtw89/core.h
index 30bc177808352..d3531630a7023 100644
--- a/drivers/net/wireless/realtek/rtw89/core.h
+++ b/drivers/net/wireless/realtek/rtw89/core.h
@@ -38,6 +38,8 @@ extern const struct ieee80211_ops rtw89_ops;
 #define RFREG_MASK 0xfffff
 #define INV_RF_DATA 0xffffffff
 #define BYPASS_CR_DATA 0xbabecafe
+#define RTW89_R32_EA 0xEAEAEAEA
+#define RTW89_R32_DEAD 0xDEADBEEF
 
 #define RTW89_TRACK_WORK_PERIOD	round_jiffies_relative(HZ * 2)
 #define RTW89_TRACK_PS_WORK_PERIOD msecs_to_jiffies(100)
@@ -3652,6 +3654,8 @@ struct rtw89_hci_ops {
 	void (*write16)(struct rtw89_dev *rtwdev, u32 addr, u16 data);
 	void (*write32)(struct rtw89_dev *rtwdev, u32 addr, u32 data);
 
+	u32 (*read32_pci_cfg)(struct rtw89_dev *rtwdev, u32 addr);
+
 	int (*mac_pre_init)(struct rtw89_dev *rtwdev);
 	int (*mac_pre_deinit)(struct rtw89_dev *rtwdev);
 	int (*mac_post_init)(struct rtw89_dev *rtwdev);
@@ -6626,6 +6630,15 @@ rtw89_write_rf(struct rtw89_dev *rtwdev, enum rtw89_rf_path rf_path,
 	mutex_unlock(&rtwdev->rf_mutex);
 }
 
+static inline u32 rtw89_read32_pci_cfg(struct rtw89_dev *rtwdev, u32 addr)
+{
+	if (rtwdev->hci.type != RTW89_HCI_TYPE_PCIE ||
+	    !rtwdev->hci.ops->read32_pci_cfg)
+		return RTW89_R32_EA;
+
+	return rtwdev->hci.ops->read32_pci_cfg(rtwdev, addr);
+}
+
 static inline struct ieee80211_txq *rtw89_txq_to_txq(struct rtw89_txq *rtwtxq)
 {
 	void *p = rtwtxq;
diff --git a/drivers/net/wireless/realtek/rtw89/mac.h b/drivers/net/wireless/realtek/rtw89/mac.h
index 51e37c183a35e..1ac1d0cd79594 100644
--- a/drivers/net/wireless/realtek/rtw89/mac.h
+++ b/drivers/net/wireless/realtek/rtw89/mac.h
@@ -574,8 +574,6 @@ enum rtw89_mac_bf_rrsc_rate {
 	RTW89_MAC_BF_RRSC_MAX = 32
 };
 
-#define RTW89_R32_EA		0xEAEAEAEA
-#define RTW89_R32_DEAD		0xDEADBEEF
 #define MAC_REG_POOL_COUNT	10
 #define ACCESS_CMAC(_addr) \
 	({typeof(_addr) __addr = (_addr); \
diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 6c1f66e65497f..b24237c1e7df7 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -2071,6 +2071,20 @@ static void rtw89_pci_ops_write32(struct rtw89_dev *rtwdev, u32 addr, u32 data)
 	writel(data, rtwpci->mmap + addr);
 }
 
+static u32 rtw89_pci_ops_read32_pci_cfg(struct rtw89_dev *rtwdev, u32 addr)
+{
+	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
+	struct pci_dev *pdev = rtwpci->pdev;
+	u32 value;
+	int ret;
+
+	ret = pci_read_config_dword(pdev, addr, &value);
+	if (ret)
+		return RTW89_R32_EA;
+
+	return value;
+}
+
 static void rtw89_pci_ctrl_dma_trx(struct rtw89_dev *rtwdev, bool enable)
 {
 	const struct rtw89_pci_info *info = rtwdev->pci_info;
@@ -4691,6 +4705,8 @@ static const struct rtw89_hci_ops rtw89_pci_ops = {
 	.write16	= rtw89_pci_ops_write16,
 	.write32	= rtw89_pci_ops_write32,
 
+	.read32_pci_cfg	= rtw89_pci_ops_read32_pci_cfg,
+
 	.mac_pre_init	= rtw89_pci_ops_mac_pre_init,
 	.mac_pre_deinit	= rtw89_pci_ops_mac_pre_deinit,
 	.mac_post_init	= rtw89_pci_ops_mac_post_init,
-- 
2.53.0



