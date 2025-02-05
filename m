Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0DF5228;
	Wed,  5 Feb 2025 14:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764144; cv=none; b=Pb8fSWAZ/5N306EWpeaup9UFbHLphL8yTwNm8w4LFxt6nsAorMtEV2pLxIdB+8lSW2rK9phAePubFmu+Q5LZXUW7lZR54jHa5Smjo+YiRM7BFoxYm1SHAOPPxMCzN8uPtMOGpNumf/ZXcaClpPS1nN45ANqKI/4zdjXi/ytt/PE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764144; c=relaxed/simple;
	bh=NKXZlCc7pFgU0icFY7UN/sjQCLQvdlfLMGN//O3bZ80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MnG7Do801SdqaHQFOXG028PEunpS28BpNrrtAvcM/o0QMPP+gVZ3S6tcH8h0LJ/vDoaH0KP2wv10ghnVfuzJlEa06Hwj9B5Qr2g20fbNYW9T76g/pIisErEDWmjrkmQD+KvcATJ2KCrThcXAZ9extCPsqYdC3Zzlzc8dMD7laW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tG3f4YuU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tG3f4YuU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068D5C4CED6;
	Wed,  5 Feb 2025 14:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764144;
	bh=NKXZlCc7pFgU0icFY7UN/sjQCLQvdlfLMGN//O3bZ80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tG3f4YuUdVppwsLfrbjmBwq+ZY+Cp6+GFaC+SWSBC0ib2xgIvcwnuH2jQ1x57qSPV
	 EsidfDoptSEvN3mGFtjiMazOERS5ZpE04dtOpAMsnl1rO5g59AG60pbhfn0BOZJldS
	 VevvI5bp18Ep9ksSYKkiYv76U8d5QaCWW4D7bYsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 093/590] wifi: rtlwifi: remove unused check_buddy_priv
Date: Wed,  5 Feb 2025 14:37:28 +0100
Message-ID: <20250205134458.814434224@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit 2fdac64c3c35858aa8ac5caa70b232e03456e120 ]

Commit 2461c7d60f9f ("rtlwifi: Update header file") introduced a global
list of private data structures.

Later on, commit 26634c4b1868 ("rtlwifi Modify existing bits to match
vendor version 2013.02.07") started adding the private data to that list at
probe time and added a hook, check_buddy_priv to find the private data from
a similar device.

However, that function was never used.

Besides, though there is a lock for that list, it is never used. And when
the probe fails, the private data is never removed from the list. This
would cause a second probe to access freed memory.

Remove the unused hook, structures and members, which will prevent the
potential race condition on the list and its corruption during a second
probe when probe fails.

Fixes: 26634c4b1868 ("rtlwifi Modify existing bits to match vendor version 2013.02.07")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241206173713.3222187-2-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/base.c |  7 ----
 drivers/net/wireless/realtek/rtlwifi/base.h |  1 -
 drivers/net/wireless/realtek/rtlwifi/pci.c  | 44 ---------------------
 drivers/net/wireless/realtek/rtlwifi/wifi.h | 12 ------
 4 files changed, 64 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index aab4605de9c47..fd28c7a722d89 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -2696,9 +2696,6 @@ MODULE_AUTHOR("Larry Finger	<Larry.FInger@lwfinger.net>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Realtek 802.11n PCI wireless core");
 
-struct rtl_global_var rtl_global_var = {};
-EXPORT_SYMBOL_GPL(rtl_global_var);
-
 static int __init rtl_core_module_init(void)
 {
 	BUILD_BUG_ON(TX_PWR_BY_RATE_NUM_RATE < TX_PWR_BY_RATE_NUM_SECTION);
@@ -2712,10 +2709,6 @@ static int __init rtl_core_module_init(void)
 	/* add debugfs */
 	rtl_debugfs_add_topdir();
 
-	/* init some global vars */
-	INIT_LIST_HEAD(&rtl_global_var.glb_priv_list);
-	spin_lock_init(&rtl_global_var.glb_list_lock);
-
 	return 0;
 }
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/base.h b/drivers/net/wireless/realtek/rtlwifi/base.h
index f081a9a90563f..f3a6a43a42eca 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.h
+++ b/drivers/net/wireless/realtek/rtlwifi/base.h
@@ -124,7 +124,6 @@ int rtl_send_smps_action(struct ieee80211_hw *hw,
 u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie);
 void rtl_recognize_peer(struct ieee80211_hw *hw, u8 *data, unsigned int len);
 u8 rtl_tid_to_ac(u8 tid);
-extern struct rtl_global_var rtl_global_var;
 void rtl_phy_scan_operation_backup(struct ieee80211_hw *hw, u8 operation);
 
 #endif
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index 40fc3c297a8ac..4388066eb9e27 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -295,46 +295,6 @@ static bool rtl_pci_get_amd_l1_patch(struct ieee80211_hw *hw)
 	return status;
 }
 
-static bool rtl_pci_check_buddy_priv(struct ieee80211_hw *hw,
-				     struct rtl_priv **buddy_priv)
-{
-	struct rtl_priv *rtlpriv = rtl_priv(hw);
-	struct rtl_pci_priv *pcipriv = rtl_pcipriv(hw);
-	struct rtl_priv *tpriv = NULL, *iter;
-	struct rtl_pci_priv *tpcipriv = NULL;
-
-	if (!list_empty(&rtlpriv->glb_var->glb_priv_list)) {
-		list_for_each_entry(iter, &rtlpriv->glb_var->glb_priv_list,
-				    list) {
-			tpcipriv = (struct rtl_pci_priv *)iter->priv;
-			rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
-				"pcipriv->ndis_adapter.funcnumber %x\n",
-				pcipriv->ndis_adapter.funcnumber);
-			rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
-				"tpcipriv->ndis_adapter.funcnumber %x\n",
-				tpcipriv->ndis_adapter.funcnumber);
-
-			if (pcipriv->ndis_adapter.busnumber ==
-			    tpcipriv->ndis_adapter.busnumber &&
-			    pcipriv->ndis_adapter.devnumber ==
-			    tpcipriv->ndis_adapter.devnumber &&
-			    pcipriv->ndis_adapter.funcnumber !=
-			    tpcipriv->ndis_adapter.funcnumber) {
-				tpriv = iter;
-				break;
-			}
-		}
-	}
-
-	rtl_dbg(rtlpriv, COMP_INIT, DBG_LOUD,
-		"find_buddy_priv %d\n", tpriv != NULL);
-
-	if (tpriv)
-		*buddy_priv = tpriv;
-
-	return tpriv != NULL;
-}
-
 static void rtl_pci_parse_configuration(struct pci_dev *pdev,
 					struct ieee80211_hw *hw)
 {
@@ -2011,7 +1971,6 @@ static bool _rtl_pci_find_adapter(struct pci_dev *pdev,
 		pcipriv->ndis_adapter.amd_l1_patch);
 
 	rtl_pci_parse_configuration(pdev, hw);
-	list_add_tail(&rtlpriv->list, &rtlpriv->glb_var->glb_priv_list);
 
 	return true;
 }
@@ -2158,7 +2117,6 @@ int rtl_pci_probe(struct pci_dev *pdev,
 	rtlpriv->rtlhal.interface = INTF_PCI;
 	rtlpriv->cfg = (struct rtl_hal_cfg *)(id->driver_data);
 	rtlpriv->intf_ops = &rtl_pci_ops;
-	rtlpriv->glb_var = &rtl_global_var;
 	rtl_efuse_ops_init(hw);
 
 	/* MEM map */
@@ -2316,7 +2274,6 @@ void rtl_pci_disconnect(struct pci_dev *pdev)
 	if (rtlpci->using_msi)
 		pci_disable_msi(rtlpci->pdev);
 
-	list_del(&rtlpriv->list);
 	if (rtlpriv->io.pci_mem_start != 0) {
 		pci_iounmap(pdev, (void __iomem *)rtlpriv->io.pci_mem_start);
 		pci_release_regions(pdev);
@@ -2375,7 +2332,6 @@ EXPORT_SYMBOL(rtl_pci_resume);
 const struct rtl_intf_ops rtl_pci_ops = {
 	.adapter_start = rtl_pci_start,
 	.adapter_stop = rtl_pci_stop,
-	.check_buddy_priv = rtl_pci_check_buddy_priv,
 	.adapter_tx = rtl_pci_tx,
 	.flush = rtl_pci_flush,
 	.reset_trx_ring = rtl_pci_reset_trx_ring,
diff --git a/drivers/net/wireless/realtek/rtlwifi/wifi.h b/drivers/net/wireless/realtek/rtlwifi/wifi.h
index ae6e351bc83c9..f1830ddcdd8c1 100644
--- a/drivers/net/wireless/realtek/rtlwifi/wifi.h
+++ b/drivers/net/wireless/realtek/rtlwifi/wifi.h
@@ -2270,8 +2270,6 @@ struct rtl_intf_ops {
 	/*com */
 	int (*adapter_start)(struct ieee80211_hw *hw);
 	void (*adapter_stop)(struct ieee80211_hw *hw);
-	bool (*check_buddy_priv)(struct ieee80211_hw *hw,
-				 struct rtl_priv **buddy_priv);
 
 	int (*adapter_tx)(struct ieee80211_hw *hw,
 			  struct ieee80211_sta *sta,
@@ -2514,14 +2512,6 @@ struct dig_t {
 	u32 rssi_max;
 };
 
-struct rtl_global_var {
-	/* from this list we can get
-	 * other adapter's rtl_priv
-	 */
-	struct list_head glb_priv_list;
-	spinlock_t glb_list_lock;
-};
-
 #define IN_4WAY_TIMEOUT_TIME	(30 * MSEC_PER_SEC)	/* 30 seconds */
 
 struct rtl_btc_info {
@@ -2667,9 +2657,7 @@ struct rtl_scan_list {
 struct rtl_priv {
 	struct ieee80211_hw *hw;
 	struct completion firmware_loading_complete;
-	struct list_head list;
 	struct rtl_priv *buddy_priv;
-	struct rtl_global_var *glb_var;
 	struct rtl_dmsp_ctl dmsp_ctl;
 	struct rtl_locks locks;
 	struct rtl_works works;
-- 
2.39.5



