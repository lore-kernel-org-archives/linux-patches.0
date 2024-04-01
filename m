Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A0244D9EF;
	Mon,  1 Apr 2024 16:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990337; cv=none; b=FYyXDclfxysbFaLCJBMZU/RKyvvradLzgH9b8ztKHpSz6e0JEEgkPPjgpUhFb2T4XeETPRbh3as6V7jVPSPUNFkSaUi1JUYat8s7qeNaWvdG1BsjFU5eEPFcBlKs4/fTc2BkzynWWJsw8QQc62xhYPoE/mRNqJN5znEPnp0vmfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990337; c=relaxed/simple;
	bh=ZTkaVG/QUTpCDvarCwbkRUA0mlInjxWu0Q5y/cN20wM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NKBWZk5ZGAJxJSgSb4JcBkZhk/DHpJhOpQvWSVne1DTkSRMiNBDKjMTspPRCbOpkGa+cQ2VyIYXXeMd5Nk0WvHTKDWHbHJT4BCiXZqPd3Mxi0nDcqFR2M6/JfxLrxEDo27eo+rq1aq09A/kNlmTvqzGvr6T/3F+fKP6Mb7AEWg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pWyr7FWJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pWyr7FWJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22A4EC433F1;
	Mon,  1 Apr 2024 16:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990337;
	bh=ZTkaVG/QUTpCDvarCwbkRUA0mlInjxWu0Q5y/cN20wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pWyr7FWJxC4Kt99a4b3hGDyoWvbI2udp3o2i1MaZekSReSVHQZ0eSyAdEJWsrdZ6c
	 c6TKdBcSKHRcLQ9wgkcOOapdiSQ5pUdQsbcd2ZiL/uYeoCX9NmL/+Mhe9sXRHU7LbE
	 uUoADH1eWpEq4ZaQ+8T6IOkpccfcqdsEH2TaL+fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.6 321/396] wifi: cfg80211: add a flag to disable wireless extensions
Date: Mon,  1 Apr 2024 17:46:10 +0200
Message-ID: <20240401152557.483743114@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit be23b2d7c3b7c8bf57b1cf0bf890bd65df9d0186 upstream.

Wireless extensions are already disabled if MLO is enabled,
given that we cannot support MLO there with all the hard-
coded assumptions about BSSID etc.

However, the WiFi7 ecosystem is still stabilizing, and some
devices may need MLO disabled while that happens. In that
case, we might end up with a device that supports wext (but
not MLO) in one kernel, and then breaks wext in the future
(by enabling MLO), which is not desirable.

Add a flag to let such drivers/devices disable wext even if
MLO isn't yet enabled.

Cc: stable@vger.kernel.org
Link: https://msgid.link/20240314110951.b50f1dc4ec21.I656ddd8178eedb49dc5c6c0e70f8ce5807afb54f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/cfg80211.h   |    2 ++
 net/wireless/wext-core.c |    7 +++++--
 2 files changed, 7 insertions(+), 2 deletions(-)

--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -4816,6 +4816,7 @@ struct cfg80211_ops {
  * @WIPHY_FLAG_SUPPORTS_EXT_KCK_32: The device supports 32-byte KCK keys.
  * @WIPHY_FLAG_NOTIFY_REGDOM_BY_DRIVER: The device could handle reg notify for
  *	NL80211_REGDOM_SET_BY_DRIVER.
+ * @WIPHY_FLAG_DISABLE_WEXT: disable wireless extensions for this device
  */
 enum wiphy_flags {
 	WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK		= BIT(0),
@@ -4827,6 +4828,7 @@ enum wiphy_flags {
 	WIPHY_FLAG_4ADDR_STATION		= BIT(6),
 	WIPHY_FLAG_CONTROL_PORT_PROTOCOL	= BIT(7),
 	WIPHY_FLAG_IBSS_RSN			= BIT(8),
+	WIPHY_FLAG_DISABLE_WEXT			= BIT(9),
 	WIPHY_FLAG_MESH_AUTH			= BIT(10),
 	WIPHY_FLAG_SUPPORTS_EXT_KCK_32          = BIT(11),
 	/* use hole at 12 */
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -4,6 +4,7 @@
  * Authors :	Jean Tourrilhes - HPL - <jt@hpl.hp.com>
  * Copyright (c) 1997-2007 Jean Tourrilhes, All Rights Reserved.
  * Copyright	2009 Johannes Berg <johannes@sipsolutions.net>
+ * Copyright (C) 2024 Intel Corporation
  *
  * (As all part of the Linux kernel, this file is GPL)
  */
@@ -662,7 +663,8 @@ struct iw_statistics *get_wireless_stats
 	    dev->ieee80211_ptr->wiphy->wext &&
 	    dev->ieee80211_ptr->wiphy->wext->get_wireless_stats) {
 		wireless_warn_cfg80211_wext();
-		if (dev->ieee80211_ptr->wiphy->flags & WIPHY_FLAG_SUPPORTS_MLO)
+		if (dev->ieee80211_ptr->wiphy->flags & (WIPHY_FLAG_SUPPORTS_MLO |
+							WIPHY_FLAG_DISABLE_WEXT))
 			return NULL;
 		return dev->ieee80211_ptr->wiphy->wext->get_wireless_stats(dev);
 	}
@@ -704,7 +706,8 @@ static iw_handler get_handler(struct net
 #ifdef CONFIG_CFG80211_WEXT
 	if (dev->ieee80211_ptr && dev->ieee80211_ptr->wiphy) {
 		wireless_warn_cfg80211_wext();
-		if (dev->ieee80211_ptr->wiphy->flags & WIPHY_FLAG_SUPPORTS_MLO)
+		if (dev->ieee80211_ptr->wiphy->flags & (WIPHY_FLAG_SUPPORTS_MLO |
+							WIPHY_FLAG_DISABLE_WEXT))
 			return NULL;
 		handlers = dev->ieee80211_ptr->wiphy->wext;
 	}


