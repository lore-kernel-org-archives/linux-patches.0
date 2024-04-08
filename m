Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D77127B3F3;
	Mon,  8 Apr 2024 13:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712582086; cv=none; b=cVLZ67Cjsv+/osUDz3ld1t2aaPItDE1ZnIn84KlP84mH3EU19nr1dGGK7XxZdhmCzkspEcFIr3oH3woG2ZvaedioKW7rUwTrfc+xAgPQw2QBN5v2l9B6K9vfbG9mcG6K1XXfGQ063MseANF5DWxWhwhRqj4xGrJY4InD6sTel6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712582086; c=relaxed/simple;
	bh=rj8J9uxGZI9KTqarcIxv6K+TFNg9QicHSGqTdLSQgMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tdjLjIgrOtBYmFrKggnfmBOPDvPok62ONqFnvQmlVNwO7SBUcNL9CalrwEVFjzWI5rS8d7HPKlJW6qi7l6BwwBhY7rMMnro6t5hTjyYlGvLnfte8dqSL8XH0jW6E8krGqjbzVAVvW4iniabMb9QytLGwwolPiRLufSxTv/WNb4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AUU7T1H+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AUU7T1H+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFCAC433C7;
	Mon,  8 Apr 2024 13:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712582086;
	bh=rj8J9uxGZI9KTqarcIxv6K+TFNg9QicHSGqTdLSQgMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AUU7T1H+TQtB+P8Rdco68G5ysrYMDEDsrAERYenrMR3si7vH6XlEnBFve/j2uH4Fu
	 RTWrwGuzb56m9222ns/IyOyGkKl1WK/uAIWiMCDJ2TT+vv3487ohg1gdl8T87bOpmg
	 ENtrbk55ZUOeyu7GnwIPADKY1cLfxbAzleklhpzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <simon.horman@corigine.com>,
	Kai-Heng Feng <kai.heng.feng@canonical.com>,
	=?UTF-8?q?Holger=20Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/138] r8169: use spinlock to protect access to registers Config2 and Config5
Date: Mon,  8 Apr 2024 14:58:11 +0200
Message-ID: <20240408125258.621812011@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 6bc6c4e6893ee79a9862c61d1635e7da6d5a3333 ]

For disabling ASPM during NAPI poll we'll have to access both registers
in atomic context. Use a spinlock to protect access.

Reviewed-by: Simon Horman <simon.horman@corigine.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5e864d90b208 ("r8169: skip DASH fw status checks when DASH is disabled")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_main.c | 47 ++++++++++++++++++-----
 1 file changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index c7dd0eb94817f..4a1710b2726ce 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -615,6 +615,7 @@ struct rtl8169_private {
 		struct work_struct work;
 	} wk;
 
+	spinlock_t config25_lock;
 	spinlock_t mac_ocp_lock;
 
 	unsigned supports_gmii:1;
@@ -680,6 +681,28 @@ static void rtl_pci_commit(struct rtl8169_private *tp)
 	RTL_R8(tp, ChipCmd);
 }
 
+static void rtl_mod_config2(struct rtl8169_private *tp, u8 clear, u8 set)
+{
+	unsigned long flags;
+	u8 val;
+
+	spin_lock_irqsave(&tp->config25_lock, flags);
+	val = RTL_R8(tp, Config2);
+	RTL_W8(tp, Config2, (val & ~clear) | set);
+	spin_unlock_irqrestore(&tp->config25_lock, flags);
+}
+
+static void rtl_mod_config5(struct rtl8169_private *tp, u8 clear, u8 set)
+{
+	unsigned long flags;
+	u8 val;
+
+	spin_lock_irqsave(&tp->config25_lock, flags);
+	val = RTL_R8(tp, Config5);
+	RTL_W8(tp, Config5, (val & ~clear) | set);
+	spin_unlock_irqrestore(&tp->config25_lock, flags);
+}
+
 static bool rtl_is_8125(struct rtl8169_private *tp)
 {
 	return tp->mac_version >= RTL_GIGA_MAC_VER_61;
@@ -1401,6 +1424,7 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 		{ WAKE_MAGIC, Config3, MagicPacket }
 	};
 	unsigned int i, tmp = ARRAY_SIZE(cfg);
+	unsigned long flags;
 	u8 options;
 
 	rtl_unlock_config_regs(tp);
@@ -1419,12 +1443,14 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 			r8168_mac_ocp_modify(tp, 0xc0b6, BIT(0), 0);
 	}
 
+	spin_lock_irqsave(&tp->config25_lock, flags);
 	for (i = 0; i < tmp; i++) {
 		options = RTL_R8(tp, cfg[i].reg) & ~cfg[i].mask;
 		if (wolopts & cfg[i].opt)
 			options |= cfg[i].mask;
 		RTL_W8(tp, cfg[i].reg, options);
 	}
+	spin_unlock_irqrestore(&tp->config25_lock, flags);
 
 	switch (tp->mac_version) {
 	case RTL_GIGA_MAC_VER_02 ... RTL_GIGA_MAC_VER_06:
@@ -1436,10 +1462,10 @@ static void __rtl8169_set_wol(struct rtl8169_private *tp, u32 wolopts)
 	case RTL_GIGA_MAC_VER_34:
 	case RTL_GIGA_MAC_VER_37:
 	case RTL_GIGA_MAC_VER_39 ... RTL_GIGA_MAC_VER_63:
-		options = RTL_R8(tp, Config2) & ~PME_SIGNAL;
 		if (wolopts)
-			options |= PME_SIGNAL;
-		RTL_W8(tp, Config2, options);
+			rtl_mod_config2(tp, 0, PME_SIGNAL);
+		else
+			rtl_mod_config2(tp, PME_SIGNAL, 0);
 		break;
 	default:
 		break;
@@ -2748,8 +2774,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 {
 	/* Don't enable ASPM in the chip if OS can't control ASPM */
 	if (enable && tp->aspm_manageable) {
-		RTL_W8(tp, Config5, RTL_R8(tp, Config5) | ASPM_en);
-		RTL_W8(tp, Config2, RTL_R8(tp, Config2) | ClkReqEn);
+		rtl_mod_config5(tp, 0, ASPM_en);
+		rtl_mod_config2(tp, 0, ClkReqEn);
 
 		switch (tp->mac_version) {
 		case RTL_GIGA_MAC_VER_46 ... RTL_GIGA_MAC_VER_48:
@@ -2772,8 +2798,8 @@ static void rtl_hw_aspm_clkreq_enable(struct rtl8169_private *tp, bool enable)
 			break;
 		}
 
-		RTL_W8(tp, Config2, RTL_R8(tp, Config2) & ~ClkReqEn);
-		RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~ASPM_en);
+		rtl_mod_config2(tp, ClkReqEn, 0);
+		rtl_mod_config5(tp, ASPM_en, 0);
 	}
 
 	udelay(10);
@@ -2934,7 +2960,7 @@ static void rtl_hw_start_8168e_1(struct rtl8169_private *tp)
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | TXPLA_RST);
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~TXPLA_RST);
 
-	RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~Spi_en);
+	rtl_mod_config5(tp, Spi_en, 0);
 }
 
 static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
@@ -2967,7 +2993,7 @@ static void rtl_hw_start_8168e_2(struct rtl8169_private *tp)
 
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) | PFM_EN);
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | PWM_EN);
-	RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~Spi_en);
+	rtl_mod_config5(tp, Spi_en, 0);
 
 	rtl_hw_aspm_clkreq_enable(tp, true);
 }
@@ -2990,7 +3016,7 @@ static void rtl_hw_start_8168f(struct rtl8169_private *tp)
 	RTL_W8(tp, MCU, RTL_R8(tp, MCU) & ~NOW_IS_OOB);
 	RTL_W8(tp, DLLPR, RTL_R8(tp, DLLPR) | PFM_EN);
 	RTL_W32(tp, MISC, RTL_R32(tp, MISC) | PWM_EN);
-	RTL_W8(tp, Config5, RTL_R8(tp, Config5) & ~Spi_en);
+	rtl_mod_config5(tp, Spi_en, 0);
 
 	rtl8168_config_eee_mac(tp);
 }
@@ -5259,6 +5285,7 @@ static int rtl_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	tp->eee_adv = -1;
 	tp->ocp_base = OCP_STD_PHY_BASE;
 
+	spin_lock_init(&tp->config25_lock);
 	spin_lock_init(&tp->mac_ocp_lock);
 
 	dev->tstats = devm_netdev_alloc_pcpu_stats(&pdev->dev,
-- 
2.43.0



