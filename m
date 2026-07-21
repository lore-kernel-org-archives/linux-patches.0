Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48B44D990C;
	Tue, 21 Jul 2026 15:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649146; cv=none; b=SgwtGrHXWpD58RVba6FB6p/zPK5J/769QUCioK6G2txzjl3FDd6UaNzCQg9rUTC2hSheNkeCO1aQcoJN3DchRaKt85y/PAkM0lFwfu0EYOtUgFKQ3yCBiajdvVxlWrLE2F3Y58s6srI6TM90yCJirrPDHW4sdjeePOqOZkhc+aQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649146; c=relaxed/simple;
	bh=RmYFazvvVvOeO1dRiUE2n2v3cP/vfvWNMXojE84RURY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R+IYRGjlY2THA6du0h4dWkeAY5/5J6xosBXsSzHC4BxNne5B62slcnPWX+DuxUasfuP7F1obKh2pPUslrSbcTqQG7zmoAcl1gtG0iPymr5P7TRoyG21bBC/YTjvDYlOP2U+5WhfJ6Fj5vDMycinlIihYnIhggIQ65f1z5DEYOHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NcOCgDG3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NcOCgDG3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569B61F00A3A;
	Tue, 21 Jul 2026 15:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649144;
	bh=GBkqd0diVYhw15TGTZBs37mjhgTgnZSCZjyV1r4u+ow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NcOCgDG3UQA5p5rCabIRLVI5/sQREQYUh7gw9qP1xAM1DL2lHjynozV+0Ve+etwty
	 bTrmnI3p1dGKpHDMZQ9XF0ZeGBpgB1/TCb5yzHjH0Ef56Nxe51mzWcu2gXRjn2Vcaq
	 eCH9oO/dWn96XFN0H3te09KNE3GkLSeEoA48eBHw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0468/2077] wifi: wlcore: enable the right set of ciphers
Date: Tue, 21 Jul 2026 17:02:21 +0200
Message-ID: <20260721152603.832326580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit 7495adaa0e45e180f4b6b7436675c6266edff1ff ]

The firmware version number check for IGTK introduced in
commit c34dbc5900b0 ("wifi: wlcore: Add support for IGTK key")

lets the amount of ciphers decrease on every boot of a too old firmware and
that is practically happening. It also does not take into account other
chips than the wl18xx. On some wl128x, the following can be observed
when connecting via nm to a common ap:

[  484.113311] wlcore: WARNING could not set keys
[  484.117828] wlcore: ERROR Could not add or replace key
[  484.123016] wlan0: failed to set key (5, ff:ff:ff:ff:ff:ff) to hardware (-5)
[  484.123046] wlcore: Hardware recovery in progress. FW ver: Rev 7.3.10.0.142
[  484.139923] wlcore: pc: 0x0, hint_sts: 0x00000048 count: 1
[  484.145721] wlcore: down
[  484.148986] ieee80211 phy0: Hardware restart was requested
[  484.610473] wlcore: firmware booted (Rev 7.3.10.0.142)
[  484.633758] wlcore: Association completed.
[  484.690490] wlcore: ERROR command execute failure 14
[  484.690490] ------------[ cut here ]------------
[  484.700195] WARNING: drivers/net/wireless/ti/wlcore/main.c:872 at wl12xx_queue_recovery_work+0x64/0x74 [wlcore], CPU#0: kworker/0:0/892

This repeats endlessly.
Always disable IGTK on wl12xx and fix the decrementing mess.

Fixes: c34dbc5900b0 ("wifi: wlcore: Add support for IGTK key")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20260604103316.377251-1-andreas@kemnade.info
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ti/wlcore/main.c | 23 +++++++++++++----------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/ti/wlcore/main.c b/drivers/net/wireless/ti/wlcore/main.c
index 1c340a4a09308f..be583ae331c03b 100644
--- a/drivers/net/wireless/ti/wlcore/main.c
+++ b/drivers/net/wireless/ti/wlcore/main.c
@@ -32,6 +32,15 @@
 #define WL1271_BOOT_RETRIES 3
 #define WL1271_WAKEUP_TIMEOUT 500
 
+static const u32 cipher_suites[] = {
+	WLAN_CIPHER_SUITE_WEP40,
+	WLAN_CIPHER_SUITE_WEP104,
+	WLAN_CIPHER_SUITE_TKIP,
+	WLAN_CIPHER_SUITE_CCMP,
+	WL1271_CIPHER_SUITE_GEM,
+	WLAN_CIPHER_SUITE_AES_CMAC,
+};
+
 static char *fwlog_param;
 static int fwlog_mem_blocks = -1;
 static int bug_on_recovery = -1;
@@ -2367,6 +2376,7 @@ static int wl12xx_init_vif_data(struct wl1271 *wl, struct ieee80211_vif *vif)
 
 static int wl12xx_init_fw(struct wl1271 *wl)
 {
+	struct wlcore_platdev_data *pdev_data = dev_get_platdata(&wl->pdev->dev);
 	int retries = WL1271_BOOT_RETRIES;
 	bool booted = false;
 	struct wiphy *wiphy = wl->hw->wiphy;
@@ -2421,8 +2431,9 @@ static int wl12xx_init_fw(struct wl1271 *wl)
 
 	/* WLAN_CIPHER_SUITE_AES_CMAC must be last in cipher_suites;
 	   support only with firmware 8.9.1 and newer */
-	if (wl->chip.fw_ver[FW_VER_MAJOR] < 1)
-		wl->hw->wiphy->n_cipher_suites--;
+	if (wl->chip.fw_ver[FW_VER_MAJOR] < 1  ||
+	    (!strncmp(pdev_data->family->name, "wl12", 4)))
+		wl->hw->wiphy->n_cipher_suites = ARRAY_SIZE(cipher_suites) - 1;
 
 	/*
 	 * Now we know if 11a is supported (info from the NVS), so disable
@@ -6198,14 +6209,6 @@ static void wl1271_unregister_hw(struct wl1271 *wl)
 static int wl1271_init_ieee80211(struct wl1271 *wl)
 {
 	int i;
-	static const u32 cipher_suites[] = {
-		WLAN_CIPHER_SUITE_WEP40,
-		WLAN_CIPHER_SUITE_WEP104,
-		WLAN_CIPHER_SUITE_TKIP,
-		WLAN_CIPHER_SUITE_CCMP,
-		WL1271_CIPHER_SUITE_GEM,
-		WLAN_CIPHER_SUITE_AES_CMAC,
-	};
 
 	/* The tx descriptor buffer */
 	wl->hw->extra_tx_headroom = sizeof(struct wl1271_tx_hw_descr);
-- 
2.53.0



