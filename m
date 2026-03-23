Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E448E3AE6FB;
	Mon, 23 Mar 2026 14:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275607; cv=none; b=ZTklPld5su1WWHz0zJ5+K2nDI/cYt8X4dZ1+83MIBf7Nh5SBQGhmL+atnGDay8j0yCy7s3I1IaFHCignoM8yA3y0aNUj68zb+LYmB4cSpEhGAxGdQmO0oVjSCfmhKjXWkYlV3r5mB1JZc9hicZPU65/HeHEiOwlAatV26WG7eWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275607; c=relaxed/simple;
	bh=kLcUcA3Hbsgmy2ujvISNtpQrkBMNsVzJ9YF2k7DBPqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DMKkqwNRJZccMwJw7A9mCq0Cg47a3r5j0qkD5xzQLOV9GuFCie0to/qSqTvqE4padCRCn4Z1ZLHAZgn9+baRx5x9GmC2qsWLcvr+N4nTjG3m+bY9TKCZKESsnJ+IBeDQBl+ZCOCac3N2gA+/8p/0JB0VnaSOtTSFJZUJVzu33pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/gbQzXL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/gbQzXL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7DCC2BCB3;
	Mon, 23 Mar 2026 14:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275606;
	bh=kLcUcA3Hbsgmy2ujvISNtpQrkBMNsVzJ9YF2k7DBPqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/gbQzXLjuQT4T8mPpH9PuSkVfAwBDQMrn4zzQXWFzgqSI9A2Bvbs7DjfRtT1eo0k
	 4Idb65cUp1FkYpyi7LvyN/KJBDQtZrXS90Y1eqopYL7LOUk2xBnShvZ8F5nCijuirl
	 W3LFYxfPcR/FxRDUncRB6WgVmYLzYlAsttsM1by4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schmidbauer <github@grische.xyz>,
	Sven Eckelmann <sven@narfation.org>,
	=?UTF-8?q?S=C3=B6ren=20Skaarup?= <freifunk_nordm4nn@gmx.de>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6.12 159/460] batman-adv: Avoid double-rtnl_lock ELP metric worker
Date: Mon, 23 Mar 2026 14:42:35 +0100
Message-ID: <20260323134530.467076118@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit cfc83a3c71517b59c1047db57da31e26a9dc2f33 upstream.

batadv_v_elp_get_throughput() might be called when the RTNL lock is already
held. This could be problematic when the work queue item is cancelled via
cancel_delayed_work_sync() in batadv_v_elp_iface_disable(). In this case,
an rtnl_lock() would cause a deadlock.

To avoid this, rtnl_trylock() was used in this function to skip the
retrieval of the ethtool information in case the RTNL lock was already
held.

But for cfg80211 interfaces, batadv_get_real_netdev() was called - which
also uses rtnl_lock(). The approach for __ethtool_get_link_ksettings() must
also be used instead and the lockless version __batadv_get_real_netdev()
has to be called.

Cc: stable@vger.kernel.org
Fixes: 8c8ecc98f5c6 ("batman-adv: Drop unmanaged ELP metric worker")
Reported-by: Christian Schmidbauer <github@grische.xyz>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Tested-by: Sören Skaarup <freifunk_nordm4nn@gmx.de>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_v_elp.c      |   10 +++++++++-
 net/batman-adv/hard-interface.c |    8 ++++----
 net/batman-adv/hard-interface.h |    1 +
 3 files changed, 14 insertions(+), 5 deletions(-)

--- a/net/batman-adv/bat_v_elp.c
+++ b/net/batman-adv/bat_v_elp.c
@@ -112,7 +112,15 @@ static bool batadv_v_elp_get_throughput(
 			/* unsupported WiFi driver version */
 			goto default_throughput;
 
-		real_netdev = batadv_get_real_netdev(hard_iface->net_dev);
+		/* only use rtnl_trylock because the elp worker will be cancelled while
+		 * the rntl_lock is held. the cancel_delayed_work_sync() would otherwise
+		 * wait forever when the elp work_item was started and it is then also
+		 * trying to rtnl_lock
+		 */
+		if (!rtnl_trylock())
+			return false;
+		real_netdev = __batadv_get_real_netdev(hard_iface->net_dev);
+		rtnl_unlock();
 		if (!real_netdev)
 			goto default_throughput;
 
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -203,7 +203,7 @@ static bool batadv_is_valid_iface(const
 }
 
 /**
- * batadv_get_real_netdevice() - check if the given netdev struct is a virtual
+ * __batadv_get_real_netdev() - check if the given netdev struct is a virtual
  *  interface on top of another 'real' interface
  * @netdev: the device to check
  *
@@ -213,7 +213,7 @@ static bool batadv_is_valid_iface(const
  * Return: the 'real' net device or the original net device and NULL in case
  *  of an error.
  */
-static struct net_device *batadv_get_real_netdevice(struct net_device *netdev)
+struct net_device *__batadv_get_real_netdev(struct net_device *netdev)
 {
 	struct batadv_hard_iface *hard_iface = NULL;
 	struct net_device *real_netdev = NULL;
@@ -266,7 +266,7 @@ struct net_device *batadv_get_real_netde
 	struct net_device *real_netdev;
 
 	rtnl_lock();
-	real_netdev = batadv_get_real_netdevice(net_device);
+	real_netdev = __batadv_get_real_netdev(net_device);
 	rtnl_unlock();
 
 	return real_netdev;
@@ -335,7 +335,7 @@ static u32 batadv_wifi_flags_evaluate(st
 	if (batadv_is_cfg80211_netdev(net_device))
 		wifi_flags |= BATADV_HARDIF_WIFI_CFG80211_DIRECT;
 
-	real_netdev = batadv_get_real_netdevice(net_device);
+	real_netdev = __batadv_get_real_netdev(net_device);
 	if (!real_netdev)
 		return wifi_flags;
 
--- a/net/batman-adv/hard-interface.h
+++ b/net/batman-adv/hard-interface.h
@@ -68,6 +68,7 @@ enum batadv_hard_if_bcast {
 
 extern struct notifier_block batadv_hard_if_notifier;
 
+struct net_device *__batadv_get_real_netdev(struct net_device *net_device);
 struct net_device *batadv_get_real_netdev(struct net_device *net_device);
 bool batadv_is_cfg80211_hardif(struct batadv_hard_iface *hard_iface);
 bool batadv_is_wifi_hardif(struct batadv_hard_iface *hard_iface);


