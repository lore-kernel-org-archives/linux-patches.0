Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72FA311C83
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:28:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA78CC433C8;
	Mon, 28 Aug 2023 10:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218510;
	bh=EU+gLHhihpJpMo/F4Nlnc0Bez/wSyhJa8vsg+1+Rs3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l16vqEUx7Gw9nTfZ15/I4JJPu4/ZQreR0fXm7Q6FIIiGWwXqsfZLqsQjv0IkzYE4S
	 8CnDBGwGDaZ9Dc9Jhcs7rBEPfD4MPlZymnSEUWPmCkyph+KSZX3K0xxgdZDEdXYWg7
	 R0TPzHwhbln5RsfHHo9MWym9q0m83ACKiJOBm940=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sven Eckelmann <sven@narfation.org>,
	Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.19 113/129] batman-adv: Dont increase MTU when set by user
Date: Mon, 28 Aug 2023 12:13:27 +0200
Message-ID: <20230828101157.371486988@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101153.030066927@linuxfoundation.org>
References: <20230828101153.030066927@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

commit d8e42a2b0addf238be8b3b37dcd9795a5c1be459 upstream.

If the user set an MTU value, it usually means that there are special
requirements for the MTU. But if an interface gots activated, the MTU was
always recalculated and then the user set value was overwritten.

The only reason why this user set value has to be overwritten, is when the
MTU has to be decreased because batman-adv is not able to transfer packets
with the user specified size.

Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Cc: stable@vger.kernel.org
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/hard-interface.c |   14 +++++++++++++-
 net/batman-adv/soft-interface.c |    3 +++
 net/batman-adv/types.h          |    6 ++++++
 3 files changed, 22 insertions(+), 1 deletion(-)

--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -643,7 +643,19 @@ out:
  */
 void batadv_update_min_mtu(struct net_device *soft_iface)
 {
-	dev_set_mtu(soft_iface, batadv_hardif_min_mtu(soft_iface));
+	struct batadv_priv *bat_priv = netdev_priv(soft_iface);
+	int limit_mtu;
+	int mtu;
+
+	mtu = batadv_hardif_min_mtu(soft_iface);
+
+	if (bat_priv->mtu_set_by_user)
+		limit_mtu = bat_priv->mtu_set_by_user;
+	else
+		limit_mtu = ETH_DATA_LEN;
+
+	mtu = min(mtu, limit_mtu);
+	dev_set_mtu(soft_iface, mtu);
 
 	/* Check if the local translate table should be cleaned up to match a
 	 * new (and smaller) MTU.
--- a/net/batman-adv/soft-interface.c
+++ b/net/batman-adv/soft-interface.c
@@ -167,11 +167,14 @@ static int batadv_interface_set_mac_addr
 
 static int batadv_interface_change_mtu(struct net_device *dev, int new_mtu)
 {
+	struct batadv_priv *bat_priv = netdev_priv(dev);
+
 	/* check ranges */
 	if (new_mtu < 68 || new_mtu > batadv_hardif_min_mtu(dev))
 		return -EINVAL;
 
 	dev->mtu = new_mtu;
+	bat_priv->mtu_set_by_user = new_mtu;
 
 	return 0;
 }
--- a/net/batman-adv/types.h
+++ b/net/batman-adv/types.h
@@ -1515,6 +1515,12 @@ struct batadv_priv {
 	struct net_device *soft_iface;
 
 	/**
+	 * @mtu_set_by_user: MTU was set once by user
+	 * protected by rtnl_lock
+	 */
+	int mtu_set_by_user;
+
+	/**
 	 * @bat_counters: mesh internal traffic statistic counters (see
 	 *  batadv_counters)
 	 */


