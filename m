Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C2E3D961;
	Mon,  1 Apr 2024 16:29:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711988982; cv=none; b=cy3V6LVVwUd28sEfOSLRn+fAwHntqj3+F5ER4Dopi/iFlAEWdVVi8/F4S8mvQI/8G5hLECJJVO6FP2aepF3CmRGYirUqTMPLidZ+BXsaSZu3hlhuF/jF2LkehB9Clz32fq0aR+98JjqELg6mvZEVjzqGrtqzPdZHVSE4YNgwb9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711988982; c=relaxed/simple;
	bh=FFK8t2moLStvmfHYKr0OEZE7PhTYvADZmNWR+fzaF+A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HHYTWboC/pCnP0ON+U8sSUeHFrbvFQohfTicp8dSSjL5KZc/wR03YVPiD1GA4sU7jISMvyJk3pTOK1t7nSUywKkv+KWbng2n0TdepFIvB5JOP2JtyduZxWqqJYQPRTnbpy0RVNRWIkivMogfy7H7LL7oWue/8bq/e1BfHbeBwSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKsKGAkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKsKGAkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528DEC43390;
	Mon,  1 Apr 2024 16:29:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711988981;
	bh=FFK8t2moLStvmfHYKr0OEZE7PhTYvADZmNWR+fzaF+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKsKGAkltXMYrSZfnrpSnTtXcJkWflhd8PCzWA+mE+x3m1mjDo4ivDZY6GrA0NMe4
	 oOsCL51oiQ7dsUUBtQGlQUvkOs/nArMzm5kV85CBsP+oaRfoR/nKuilvIC3jIydsxa
	 RytQlN4XgyBnQ8qAoYMvShHCeXvpQrqp+iHB8F5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.7 346/432] wifi: cfg80211: add a flag to disable wireless extensions
Date: Mon,  1 Apr 2024 17:45:33 +0200
Message-ID: <20240401152603.560746409@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4914,6 +4914,7 @@ struct cfg80211_ops {
  *	NL80211_REGDOM_SET_BY_DRIVER.
  * @WIPHY_FLAG_CHANNEL_CHANGE_ON_BEACON: reg_call_notifier() is called if driver
  *	set this flag to update channels on beacon hints.
+ * @WIPHY_FLAG_DISABLE_WEXT: disable wireless extensions for this device
  */
 enum wiphy_flags {
 	WIPHY_FLAG_SUPPORTS_EXT_KEK_KCK		= BIT(0),
@@ -4925,6 +4926,7 @@ enum wiphy_flags {
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


