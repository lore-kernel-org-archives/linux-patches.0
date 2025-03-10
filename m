Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 230051C9B6C;
	Mon, 10 Mar 2025 17:47:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628830; cv=none; b=oieC4d4TQwOCgq00L6/IeVMT7pYY3XWLsuNE2GElEr/4FhTyC1Gk7kil8fTgAuAKNo+6Thcgrt2HSiAaAKH6lpVU7OxE4Zb0fOkp9ZLNCi16DHGDmMwd5D75+hKuF7hrT7T0s5GQ3TazcreS998Hxbs3rJuP8DiEhDn3OGHoZuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628830; c=relaxed/simple;
	bh=WXUHhUlCVrbaw9B/omW7h1maWIYBb0J1v88xj1lUGk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CvnWZOH98tealqGzSHws2/7/JdxP72ZUNIkJxWwTj9zZ4ZTrT2sjy6yhIc+ZOUFenXIqD4PxOVLVa+YgUaoEWe6Rs5pK4H+TnP5koWSwvyPMmbs9Jf5F68uLpdu0HOr7ZPvtt3G8FbOH0uiPLl9GIJNLpBQ2d3MMe9blp01jXPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nfBDh0dX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nfBDh0dX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39C93C4CEE5;
	Mon, 10 Mar 2025 17:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628829;
	bh=WXUHhUlCVrbaw9B/omW7h1maWIYBb0J1v88xj1lUGk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nfBDh0dXUbJ9wuyZtlaJZYAb7IMkHN9sKYY3zBsyq4QAPmerAk7W+FPjD/WhP00Dy
	 x6QqzR4p/zojzxCewprFrQrRewPrr8eS5KQplhmXUQaeJR7NYZ3Wkg0uyy1p4r9OgB
	 5zRN3UaC+zF+L7Zn0PmNKzg+mtFmq07uA6nR0i+4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 042/620] wifi: rtlwifi: destroy workqueue at rtl_deinit_core
Date: Mon, 10 Mar 2025 17:58:08 +0100
Message-ID: <20250310170547.241417414@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>

[ Upstream commit d8ece6fc3694657e4886191b32ca1690af11adda ]

rtl_wq is allocated at rtl_init_core, so it makes more sense to destroy it
at rtl_deinit_core. In the case of USB, where _rtl_usb_init does not
require anything to be undone, that is fine. But for PCI, rtl_pci_init,
which is called after rtl_init_core, needs to deallocate data, but only if
it has been called.

That means that destroying the workqueue needs to be done whether
rtl_pci_init has been called or not. And since rtl_pci_deinit was doing it,
it has to be moved out of there.

It makes more sense to move it to rtl_deinit_core and have it done in both
cases, USB and PCI.

Since this is a requirement for a followup memory leak fix, mark this as
fixing such memory leak.

Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20241206173713.3222187-3-cascardo@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtlwifi/base.c | 6 ++++++
 drivers/net/wireless/realtek/rtlwifi/pci.c  | 2 --
 drivers/net/wireless/realtek/rtlwifi/usb.c  | 5 -----
 3 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/base.c b/drivers/net/wireless/realtek/rtlwifi/base.c
index f424d495305a8..1d6f46f521539 100644
--- a/drivers/net/wireless/realtek/rtlwifi/base.c
+++ b/drivers/net/wireless/realtek/rtlwifi/base.c
@@ -575,9 +575,15 @@ static void rtl_free_entries_from_ack_queue(struct ieee80211_hw *hw,
 
 void rtl_deinit_core(struct ieee80211_hw *hw)
 {
+	struct rtl_priv *rtlpriv = rtl_priv(hw);
+
 	rtl_c2hcmd_launcher(hw, 0);
 	rtl_free_entries_from_scan_list(hw);
 	rtl_free_entries_from_ack_queue(hw, false);
+	if (rtlpriv->works.rtl_wq) {
+		destroy_workqueue(rtlpriv->works.rtl_wq);
+		rtlpriv->works.rtl_wq = NULL;
+	}
 }
 EXPORT_SYMBOL_GPL(rtl_deinit_core);
 
diff --git a/drivers/net/wireless/realtek/rtlwifi/pci.c b/drivers/net/wireless/realtek/rtlwifi/pci.c
index c0a201f1b74e5..84f2669f201ab 100644
--- a/drivers/net/wireless/realtek/rtlwifi/pci.c
+++ b/drivers/net/wireless/realtek/rtlwifi/pci.c
@@ -1657,8 +1657,6 @@ static void rtl_pci_deinit(struct ieee80211_hw *hw)
 	synchronize_irq(rtlpci->pdev->irq);
 	tasklet_kill(&rtlpriv->works.irq_tasklet);
 	cancel_work_sync(&rtlpriv->works.lps_change_work);
-
-	destroy_workqueue(rtlpriv->works.rtl_wq);
 }
 
 static int rtl_pci_init(struct ieee80211_hw *hw, struct pci_dev *pdev)
diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 04590d16874c4..68dc0e6af6b1b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -679,11 +679,6 @@ static void _rtl_usb_cleanup_rx(struct ieee80211_hw *hw)
 	tasklet_kill(&rtlusb->rx_work_tasklet);
 	cancel_work_sync(&rtlpriv->works.lps_change_work);
 
-	if (rtlpriv->works.rtl_wq) {
-		destroy_workqueue(rtlpriv->works.rtl_wq);
-		rtlpriv->works.rtl_wq = NULL;
-	}
-
 	skb_queue_purge(&rtlusb->rx_queue);
 
 	while ((urb = usb_get_from_anchor(&rtlusb->rx_cleanup_urbs))) {
-- 
2.39.5



