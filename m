Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A889F257824;
	Mon, 23 Mar 2026 16:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282660; cv=none; b=eJYzsG07useEQjlupGB9UBjl2HOwza8oWCEQno3vDd0cmBno0k/7ubiuTrbJmcso92Uv4tB1R4i2er+Ce4DqLRjebXRC5MSRC+1veMBrQZDA58AAf6jdqylak039xzZeLdXd5h/MoIXESZCnUzxNOH3j5XWn/sAYqHk+sRv3GbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282660; c=relaxed/simple;
	bh=lFsErzL9RajnaFWZaJNWbKAlU+Q66uq9nCz714XKykE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XYS7Ta8Daagjl8DrlE2Pv8vwGnNeXUtE2JGXwFpY0TYuHDJCOk8SVTzU4kWrorNp47CvyjKJgPGxsjjPnexi2L81KO3HGzmyl8IaNg6xj5qQ2E6PnVFEFXCQWpufPWKYxDV3ZjlbNg6qRe3KXxKrrkUkh7WwoDvS2rsd7YKDekk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tgE0uxKe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tgE0uxKe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0590C4CEF7;
	Mon, 23 Mar 2026 16:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282660;
	bh=lFsErzL9RajnaFWZaJNWbKAlU+Q66uq9nCz714XKykE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tgE0uxKehJeBvZ7yVk0nAbMDZdmYN8X5pYoAs8ydF5koEZCF2f9c5yhU1i6XvqzMN
	 Fs3nhmtYFY6NkxOqcLcn6MlfxIJ39ZHfHKlfJAPWZumhgi5Vahbs3hA4+KpOzObZTM
	 6PD1fcFGZNi9/k2TUPf1Z47QGyhIRDZJrRWx3+U0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Schmidbauer <github@grische.xyz>,
	Sven Eckelmann <sven@narfation.org>,
	=?UTF-8?q?S=C3=B6ren=20Skaarup?= <freifunk_nordm4nn@gmx.de>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 6.1 240/481] batman-adv: Avoid double-rtnl_lock ELP metric worker
Date: Mon, 23 Mar 2026 14:43:42 +0100
Message-ID: <20260323134530.989334586@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -113,7 +113,15 @@ static bool batadv_v_elp_get_throughput(
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
@@ -202,7 +202,7 @@ static bool batadv_is_valid_iface(const
 }
 
 /**
- * batadv_get_real_netdevice() - check if the given netdev struct is a virtual
+ * __batadv_get_real_netdev() - check if the given netdev struct is a virtual
  *  interface on top of another 'real' interface
  * @netdev: the device to check
  *
@@ -212,7 +212,7 @@ static bool batadv_is_valid_iface(const
  * Return: the 'real' net device or the original net device and NULL in case
  *  of an error.
  */
-static struct net_device *batadv_get_real_netdevice(struct net_device *netdev)
+struct net_device *__batadv_get_real_netdev(struct net_device *netdev)
 {
 	struct batadv_hard_iface *hard_iface = NULL;
 	struct net_device *real_netdev = NULL;
@@ -265,7 +265,7 @@ struct net_device *batadv_get_real_netde
 	struct net_device *real_netdev;
 
 	rtnl_lock();
-	real_netdev = batadv_get_real_netdevice(net_device);
+	real_netdev = __batadv_get_real_netdev(net_device);
 	rtnl_unlock();
 
 	return real_netdev;
@@ -334,7 +334,7 @@ static u32 batadv_wifi_flags_evaluate(st
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


