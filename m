Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653CB43B6E0;
	Tue, 21 Jul 2026 21:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669961; cv=none; b=gx940OS78slh/iDs1G7zBo9t5503h9Cj8CqgIgy4Ejd3IOf3O5wH5cTfYnDCGni31XB+laKJJziZcoFrK51MhFxxYognrMTdFervFmKfY/HmpURzBKnOGDyKfULNx1JrTAQT9j3ofj7Z8KRaI53Ccke2rnRsEPSl8cBpTxNilRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669961; c=relaxed/simple;
	bh=ygH2gHJWSXIxt/g2506CrjY2+LcyRTP969dxV4E2X8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h5E7nymCwUXItycvxGCiwtPg77kM/0SrJeMsdg5LZDQOIre5EMfq3oBk3j2CBXRypf2YLXB7iLAId3/cLFMksqLdAjawn+Liz38glgw5UW/W5IO5I2WgqQesgbT9mvkrscRrgtalWHSzxkiqM24QRaKUam98Q+yhzaxsMnxsfzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rtc5wuGM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rtc5wuGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7991F000E9;
	Tue, 21 Jul 2026 21:39:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669960;
	bh=hzaJ1GnKhqLznSQ8ld9ebAnl9gQ02ZOUbt9aR/AH+QE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rtc5wuGMZ0bWMtrNXPkZW5i4hwUCD2Hn9r5A6AcUMcvX/jR0Ejnh8zQu6nLFNPz5E
	 0nmREByxmX3rbUhraPBBxegvxr97eejQY2DHnmH6WKzc/bm+qHkyFWU3fvOLE8920U
	 EYc3lzfY40CX7YbuWKMImSQWzO/Ubz9cB/IzZbZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrico Pozzobon <enrico.pozzobon@dissecto.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0699/1067] net: usb: lan78xx: disable VLAN filter in promiscuous mode
Date: Tue, 21 Jul 2026 17:21:40 +0200
Message-ID: <20260721152440.230499263@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enrico Pozzobon <enrico.pozzobon@dissecto.com>

[ Upstream commit 60444706aa17616efc03190d099ac347e28b3d0a ]

The hardware VLAN filter (RFE_CTL_VLAN_FILTER_) drops VLAN-tagged frames
whose VID has not been registered via lan78xx_vlan_rx_add_vid(). It is
left enabled in promiscuous mode, so packet capture (e.g. tcpdump or
Wireshark) does not see tagged frames for unregistered VIDs.

Clear the filter while the interface is promiscuous and restore it from
NETIF_F_HW_VLAN_CTAG_FILTER otherwise. Enforce the same condition in
lan78xx_set_features() so netdev_update_features() cannot re-enable the
filter while promiscuous.

Fixes: 55d7de9de6c3 ("Microchip's LAN7800 family USB 2/3 to 10/100/1000 Ethernet device driver")
Signed-off-by: Enrico Pozzobon <enrico.pozzobon@dissecto.com>
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Link: https://patch.msgid.link/20260701-lan78xx-vlan-promisc-v3-1-232266d32743@dissecto.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 9d4f807ba47b8f..a8a34f44c269c4 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1418,6 +1418,17 @@ static void lan78xx_deferred_multicast_write(struct work_struct *param)
 	lan78xx_write_reg(dev, RFE_CTL, pdata->rfe_ctl);
 }
 
+static void lan78xx_update_vlan_filter(struct lan78xx_priv *pdata,
+				       struct net_device *netdev,
+				       netdev_features_t features)
+{
+	if ((features & NETIF_F_HW_VLAN_CTAG_FILTER) &&
+	    !(netdev->flags & IFF_PROMISC))
+		pdata->rfe_ctl |= RFE_CTL_VLAN_FILTER_;
+	else
+		pdata->rfe_ctl &= ~RFE_CTL_VLAN_FILTER_;
+}
+
 static void lan78xx_set_multicast(struct net_device *netdev)
 {
 	struct lan78xx_net *dev = netdev_priv(netdev);
@@ -1452,6 +1463,8 @@ static void lan78xx_set_multicast(struct net_device *netdev)
 		}
 	}
 
+	lan78xx_update_vlan_filter(pdata, dev->net, dev->net->features);
+
 	if (netdev_mc_count(dev->net)) {
 		struct netdev_hw_addr *ha;
 		int i;
@@ -2756,10 +2769,7 @@ static int lan78xx_set_features(struct net_device *netdev,
 	else
 		pdata->rfe_ctl &= ~RFE_CTL_VLAN_STRIP_;
 
-	if (features & NETIF_F_HW_VLAN_CTAG_FILTER)
-		pdata->rfe_ctl |= RFE_CTL_VLAN_FILTER_;
-	else
-		pdata->rfe_ctl &= ~RFE_CTL_VLAN_FILTER_;
+	lan78xx_update_vlan_filter(pdata, netdev, features);
 
 	spin_unlock_irqrestore(&pdata->rfe_ctl_lock, flags);
 
-- 
2.53.0



