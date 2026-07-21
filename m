Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67BC63B2FE4;
	Tue, 21 Jul 2026 20:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666936; cv=none; b=Y2TbuGi4m7aXHjebMPQmdozjFSTfPL4z36iyn3CVQIEgTWZyfeYrzl2gGm/fheZesy71+dfWdBTp+dZEviCBEtUqOli44eycyt2+5018F44d3A4AveEqUYZmJPYJGQfN5pKTCWtnjhlgLXKgFstWgzDCKZVJK8jlUt1x1y1bAQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666936; c=relaxed/simple;
	bh=gp9LezZy/is5na8lpry85WqmMkIJCUqQB+Kx62vvAj4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoHgV7DhygW43ASgWzXlCNEOGL270LC9tnMOjI2DBhhIwE491NK+iRBqhrREG6DY44Ag66YDIQiJn3W4oS4GbW9XcyDhUM7VhlEh09mlUj3x99QewdmkOCrLeOiZjmJMRA1PUiDGOclDumUMFF85Et9HWRaszPthhXuzXwNHESI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGHEI7rb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGHEI7rb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCDC71F00A3A;
	Tue, 21 Jul 2026 20:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666935;
	bh=Mi7w7SkiXIapJzLr2fX/ZvohxgTRfG2a4CVYQLutmUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGHEI7rb1iGlHEYqfOq2DxFev98qlDumRbEItOSvJ2tpvT868N9Lwc7s1ba9Vu+Rf
	 CPjqumdbKrnpCQewUCE3yoY9kTGQSmepzDRX/f++2MZppvflSsDzs2XG9QuK2X/4TZ
	 FqWe92GX5aR2+2KwE1aDMi+Fcy/vlidr0V5ShMhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrico Pozzobon <enrico.pozzobon@dissecto.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0869/1266] net: usb: lan78xx: disable VLAN filter in promiscuous mode
Date: Tue, 21 Jul 2026 17:21:46 +0200
Message-ID: <20260721152501.292768619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 36a7ece093ae23..cc9fa1ae7c1c19 100644
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



