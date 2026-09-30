Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76C334BD786;
	Wed, 30 Sep 2026 15:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783442; cv=none; b=GAGguawtshDu+PQlsCos4bH0eoWfMJf2Ksp9n6rAPSNAMM3MZjJmtJB6uSAwjfDo3NuxCewaapg39ei6IlM8RAn2A0mcrnI2o/r6eUeqhU/RFCzxys01CRwSaH56Br2lj0m/EunZtOLRYGstlOT40A1WbTieR9ADAc3aF3p8jtY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783442; c=relaxed/simple;
	bh=vUBO9IihuPIMDU+eQ6PlN+f72B76wdC0g61egcB8A8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oi3SvcVQXW3NQwD6vgMhcYoXx59o9q8LdZ2GWZG44olAnZvIQFmxIDQYc9d8rbn7t4TTSDWOMsZxXzAW8a3Skhw1v6EW883NLCLux2IRk8qRFrEUYa2i4BiKbobTb+aYOxoPGx7AoCNWjecgzY0Wpz/zPHLA3SAAc0eJOYtC2TA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipbV3nPu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipbV3nPu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 304F01F00893;
	Wed, 30 Sep 2026 15:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783435;
	bh=LlgCHA9ssYaRfg/NJmvrSc+GSy3Ss7J8eBU558Rdp84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ipbV3nPup01RDlD6fR44ea/uIClPyHurvlC1KmZ66c32eP7qoGxPh/FmvqtuUVpbN
	 EpHGqaHQ+W6zXLR+Ntey6QQ4xaDFZmuuH8FY2B+LvqeMtDwKqjXSFCyOqqKZL8/beX
	 7NLsYn2EF/BRLm8LRQle24B2X3/nlsghlBMwQhJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 396/595] wifi: virt_wifi: dont transfer operstate before register
Date: Wed, 30 Sep 2026 17:24:49 +0200
Message-ID: <20260930152356.191829439@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zihan Xi <zihanx@nebusec.ai>

[ Upstream commit e5c8d7acd31b27057ea42cd405d0b3ece097bc89 ]

virt_wifi_newlink() calls netif_stacked_transfer_operstate() before
register_netdevice(). If the lower device is dormant, that queues the
new netdev on lweventlist while it is still uninitialized. If
registration fails after that, for example because of an invalid name
such as "bad/name", free_netdev() immediately frees the object. A
later linkwatch_fire_event() then use-after-frees the list entry.

Move the transfer to after netdev_upper_dev_link(), as macvlan and
ipvlan already do.

Fixes: c7cdba31ed8b ("mac80211-next: rtnetlink wifi simulation device")
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Link: https://patch.msgid.link/f5a832fb0ab228ce6e2b5a91fba4ca8b79198a2f.1788948455.git.zihanx@nebusec.ai
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/virt_wifi.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/virt_wifi.c b/drivers/net/wireless/virt_wifi.c
index e6dfb1180b19a..a2bb8542c6f92 100644
--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -552,7 +552,6 @@ static int virt_wifi_newlink(struct net *src_net, struct net_device *dev,
 	}
 
 	eth_hw_addr_inherit(dev, priv->lowerdev);
-	netif_stacked_transfer_operstate(priv->lowerdev, dev);
 
 	SET_NETDEV_DEV(dev, &priv->lowerdev->dev);
 	dev->ieee80211_ptr = kzalloc(sizeof(*dev->ieee80211_ptr), GFP_KERNEL);
@@ -579,6 +578,8 @@ static int virt_wifi_newlink(struct net *src_net, struct net_device *dev,
 		goto unregister_netdev;
 	}
 
+	netif_stacked_transfer_operstate(priv->lowerdev, dev);
+
 	dev->priv_destructor = virt_wifi_net_device_destructor;
 	priv->being_deleted = false;
 	priv->is_connected = false;
-- 
2.53.0



