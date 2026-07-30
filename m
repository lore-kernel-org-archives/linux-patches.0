Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434DC442FC1;
	Thu, 30 Jul 2026 14:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422010; cv=none; b=WAtL0ixX8HAH2l6k3TSzuC3ty4/V9Qi8sxKfo89R8gg8pt57Vzx4WAph2xkMcodTdOcdpaKs3d+uemT80C7K7p69Wg0nngGLBtx2yKNZB8jbCMx6Sdp71EdWcE2FwGEEyWHD4ojqmR1g0KLfOvE8gd9t54vAzsjM+/jmmUbCZGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422010; c=relaxed/simple;
	bh=Va644u75uduNee01FUoKFMa+9csynoTbrqTwbU0YN5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jjprntR3a7zHTIvJL7ej0Z3hQMLzfdoQCxR7GtGQZz0aZZQKhNzOe1OvCnDhbVJGDQIjZefQb6HDXBej6qnTrkae4zV6Lc9duR3dCYc8sOzfyrxoa4tnnAxYWu5AQKFc/rfLSdAbbwZIHiHGZdH1t39mN9hs7cAEI8XfdWSbfKY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YGE6QU81; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YGE6QU81"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D6DA1F00A3D;
	Thu, 30 Jul 2026 14:33:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422008;
	bh=nXMMswF9G+UHv/BTJXZwhN3waXXeu/LtbVpft9OZiTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YGE6QU81Xsd/eD7VJ9j4siKdbWS6uCj3NOf+7Z2xniUGns079qhKw1P2DT3PvpTaQ
	 FgcjHT76t8h4/cxbSWE0l6IhxYryYeP6dE/OR4dyfcS559VTLe7oP1LAMIrhxBRN+I
	 v6kwZNrraQpPT7dC8f0GLTnFqV17dzSDihCxIE1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 294/744] wifi: mt76: fix airoha_npu dependency tracking
Date: Thu, 30 Jul 2026 16:09:27 +0200
Message-ID: <20260730141450.540585076@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 7cd57ff6c6263519e6e463cbc2e0898828a70c42 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/Kconfig        | 4 ++--
 drivers/net/wireless/mediatek/mt76/Makefile       | 6 +++++-
 drivers/net/wireless/mediatek/mt76/mt76.h         | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7996/Kconfig | 2 +-
 4 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/Kconfig b/drivers/net/wireless/mediatek/mt76/Kconfig
index 502303622a5382..2ca96e0527c029 100644
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
diff --git a/drivers/net/wireless/mediatek/mt76/Makefile b/drivers/net/wireless/mediatek/mt76/Makefile
index 1d42adfe803044..cacdd2b13d05bf 100644
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
 
diff --git a/drivers/net/wireless/mediatek/mt76/mt76.h b/drivers/net/wireless/mediatek/mt76/mt76.h
index 527bef97e122a1..0eea08553069cb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76.h
+++ b/drivers/net/wireless/mediatek/mt76/mt76.h
@@ -1646,7 +1646,7 @@ int mt76_testmode_dump(struct ieee80211_hw *hw, struct sk_buff *skb,
 int mt76_testmode_set_state(struct mt76_phy *phy, enum mt76_testmode_state state);
 int mt76_testmode_alloc_skb(struct mt76_phy *phy, u32 len);
 
-#ifdef CONFIG_MT76_NPU
+#if IS_ENABLED(CONFIG_MT76_NPU)
 void mt76_npu_check_ppe(struct mt76_dev *dev, struct sk_buff *skb,
 			u32 info);
 int mt76_npu_dma_add_buf(struct mt76_phy *phy, struct mt76_queue *q,
diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig b/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
index 5503d03bf62c65..5742bce12fbb58 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/Kconfig
@@ -16,6 +16,6 @@ config MT7996E
 config MT7996_NPU
 	bool "MT7996 (PCIe) NPU support"
 	depends on MT7996E
-	depends on NET_AIROHA_NPU=y || MT7996E=NET_AIROHA_NPU
+	depends on NET_AIROHA_NPU=y || MT76_CORE=NET_AIROHA_NPU
 	select MT76_NPU
 	default n
-- 
2.53.0



