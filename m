Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133AF3B2D1D;
	Tue, 21 Jul 2026 22:16:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672191; cv=none; b=kw26zvPCmzqIhaEjUenyRZipCwcaP+/r4R+JxLCBLEO22+ipyh8IhWjmkBtqg3tiiNw8Z3zsqii8tOgrlO6GNiMPVbZ3szX2lyH5LVsDIfw+1ZhNHwGUhBvtTb5/0xCBb4Fvs484vQ+Jz6cd4ETm0xzLkcnqhihph6U4wbI6YUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672191; c=relaxed/simple;
	bh=kVhFL/nG9Yo9qZEGckkRZDn1wGa3UyPW1l6jJsdDkwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ph/OjLVUtSQtR9xvX9UG9s4fspqMGkrgeWLTnzoqZdWCpImEK5ouxOetHo1QwPoL0NKMJXOSTK/+In0OtcfCxCMoVmTxBctWpcUsrtuR5j5k5H692YNeoV2s32qEX4qOIbDi9Qaj/XJ+HOf47KjnDHMW9Gc2eNxJ+c06g/i1rQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XKexZnIb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XKexZnIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C821F00A3A;
	Tue, 21 Jul 2026 22:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672189;
	bh=iUxfdvhPXCYu5aKiOvqQcthIpfzsZTrx6OoyGYbai70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XKexZnIba3pLjiOnvFfcXffHLZ2ReoEXKZe9pfiUE94gnetTD4L+c6mFyZ/JP4+ix
	 2d68zg85zcbxg3tV22KWY19T+WbPZcwFGoy75l+E2/Mfm4mzEz8YwxMD1PXyoJUGMy
	 pGys4eAQs9W8VI/7+yJn6/+1hLzfmng96K65d+T4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Enrico Pozzobon <enrico.pozzobon@dissecto.com>,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 530/843] net: usb: lan78xx: disable VLAN filter in promiscuous mode
Date: Tue, 21 Jul 2026 17:22:45 +0200
Message-ID: <20260721152417.952547834@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 524b95ac428588..511d7faa9e37b2 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1104,6 +1104,17 @@ static void lan78xx_deferred_multicast_write(struct work_struct *param)
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
@@ -1138,6 +1149,8 @@ static void lan78xx_set_multicast(struct net_device *netdev)
 		}
 	}
 
+	lan78xx_update_vlan_filter(pdata, dev->net, dev->net->features);
+
 	if (netdev_mc_count(dev->net)) {
 		struct netdev_hw_addr *ha;
 		int i;
@@ -2452,10 +2465,7 @@ static int lan78xx_set_features(struct net_device *netdev,
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



