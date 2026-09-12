Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99BF1A9F83;
	Sat, 12 Sep 2026 11:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212873; cv=none; b=cJETzMPWIzi7fkJDQoCVnGjd3EhoW7+SVVKfjhG4wAPF1sBd21BEWBVO4ROczA1Mnk6Aa6aGIfuzJzVS+lrN/1Wvaurq9y7ct7ZeAcOPtZw6kIaFiMUhgvNXeKiYxfgidpzJ7/py2aqdbxJEpD5i5ueqXrUva6sB7tBkpCChE/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212873; c=relaxed/simple;
	bh=z1u/aB+PMQZQ9RMplEWvfmFb7H3McrhUzY6CkkY2jkE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BOILiWzEdkw4vt1x0b6hfoXB2V7SrVqG0nBRcBkEV4n/TP6ja9jj5h4lTRIO64xUDIRmvQgGruQmsjXNRbPRHl3LQr79+7IfH4+gkOQvNLnNbLuXT6RljWQmA+qA/1DReBt9zi7vgizwYV6O9h8yQ1BZeIdj9UlwFCxfFgN3L1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GpXHrnp+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GpXHrnp+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87851F00893;
	Sat, 12 Sep 2026 11:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212871;
	bh=TvpxSXhUA+WRq4EYz1UULrPK3HMDSTUEHBHx3TKADNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GpXHrnp+pJ/xOUUoFlkLv9yqHE2V92DgoKg8Td5LUm03GTyMBQS8gU+UHtWMb742k
	 rmzwnRaf0gj95425nw2+kTvkzcrvN2ep/2Wk4g/t0m5r5PTE+jit9u5vG53v44jkzW
	 VPYA4wUkomXAOe30LwjLQSYf5P+l3mgQNY5KHNnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 1518/1518] wifi: mt76: fix airoha_npu dependency tracking
Date: Sat, 12 Sep 2026 09:01:27 +0200
Message-ID: <20260912065657.905984722@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 7cd57ff6c6263519e6e463cbc2e0898828a70c42 upstream.

There is a new build failure with MT7996E=m MT76_CORE=y and NET_AIROHA_NPU=m:

ld.lld: error: undefined symbol: airoha_npu_get
ld.lld: error: undefined symbol: airoha_npu_put
>>> referenced by npu.c
>>>               drivers/net/wireless/mediatek/mt76/npu.o:(mt76_npu_init) in archive vmlinux.a

Fix this by reworking the dependency for the MT7996_NPU to only
allow enabling that when mt76_core can link against the npu driver.

To make sure this gets caught more easily in the future when additional
mt76 variants need the same dependency, also turn CONFIG_MT76_NPU into
a tristate symbol that has the same dependency.

Fixes: 7fb554b1b623 ("wifi: mt76: Introduce the NPU generic layer")
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260612201519.4054683-1-arnd@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/Kconfig  |    4 ++--
 drivers/net/wireless/mediatek/mt76/Makefile |    6 +++++-
 drivers/net/wireless/mediatek/mt76/mt76.h   |    2 +-
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/Kconfig
@@ -38,8 +38,8 @@ config MT792x_USB
 	select MT76_USB
 
 config MT76_NPU
-	bool
-	depends on MT76_CORE
+	tristate
+	depends on NET_AIROHA_NPU=y || MT76_CORE=NET_AIROHA_NPU
 
 source "drivers/net/wireless/mediatek/mt76/mt76x0/Kconfig"
 source "drivers/net/wireless/mediatek/mt76/mt76x2/Kconfig"
--- a/drivers/net/wireless/mediatek/mt76/Makefile
+++ b/drivers/net/wireless/mediatek/mt76/Makefile
@@ -12,7 +12,11 @@ mt76-y := \
 	mmio.o util.o trace.o dma.o mac80211.o debugfs.o eeprom.o \
 	tx.o agg-rx.o mcu.o wed.o scan.o channel.o
 
-mt76-$(CONFIG_MT76_NPU) += npu.o
+ifdef CONFIG_MT76_NPU
+# CONFIG_MT76_NPU is tristate to simplify dependency tracking,
+# but it behaves as a bool symbol here.
+mt76-y += npu.o
+endif
 mt76-$(CONFIG_PCI) += pci.o
 mt76-$(CONFIG_NL80211_TESTMODE) += testmode.o
 
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1626,7 +1626,7 @@ int mt76_testmode_dump(struct ieee80211_
 int mt76_testmode_set_state(struct mt76_phy *phy, enum mt76_testmode_state state);
 int mt76_testmode_alloc_skb(struct mt76_phy *phy, u32 len);
 
-#ifdef CONFIG_MT76_NPU
+#if IS_ENABLED(CONFIG_MT76_NPU)
 void mt76_npu_check_ppe(struct mt76_dev *dev, struct sk_buff *skb,
 			u32 info);
 int mt76_npu_dma_add_buf(struct mt76_phy *phy, struct mt76_queue *q,


