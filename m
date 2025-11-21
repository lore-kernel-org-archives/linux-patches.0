Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2201125B69F;
	Fri, 21 Nov 2025 13:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733047; cv=none; b=gskp9iWoCiTEWMWV5YEKw4FurLxzo8JJkg0PMb/ZTKGERTOYuovAvpnrFKrGuxRUumOZh0erj/nivvm+ZvJZe3VTmbaV58KjZ4UT2F8FTjwFaD42M5cJqFiDhfBisDKsSIcpa+YjBFmrzmHCQ5D/BbAvNBLOtNF+zJlNSu7yf5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733047; c=relaxed/simple;
	bh=cSYOYADxWDGXAEz1QGZB8hpUJhzpnYOVjk2HVQbhx6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e4NKj63/ST2i2UhpvGfKEDHUWb7hk+i/S7EuO4wJt+ljsp40dpopcl91+irPiSVQeivKsdU2JjGMe3/Akd5sDk4ZLKWAhYlgxVgn/wFtH+7nNphdNhu6a2AERjubFhKvZDIpUcdMoAqRe4cz0QLu4iujbMHbOAvNCJdgd+dypu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=POwuYYWO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="POwuYYWO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F1CCC4CEF1;
	Fri, 21 Nov 2025 13:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733047;
	bh=cSYOYADxWDGXAEz1QGZB8hpUJhzpnYOVjk2HVQbhx6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POwuYYWO1vxX7EygteKcXbRfqj+eBxtsyLOLm7dWagx2UMe1LFNLXYFwIOvCq3/sj
	 /HColUe19ZJJiII/pAcSYxVmxBPAgfQQWxdcc5gn6y9+Q8dfWNbfsRzJMNuxC5xKl9
	 6bjlkbx+IZF9wTkikd5eQzqIPku8k5khPyKRsFyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 332/529] net: libwx: fix device bus LAN ID
Date: Fri, 21 Nov 2025 14:10:31 +0100
Message-ID: <20251121130242.839665476@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Jiawen Wu <jiawenwu@trustnetic.com>

commit a04ea57aae375bdda1cb57034d8bcbb351e1f973 upstream.

The device bus LAN ID was obtained from PCI_FUNC(), but when a PF
port is passthrough to a virtual machine, the function number may not
match the actual port index on the device. This could cause the driver
to perform operations such as LAN reset on the wrong port.

Fix this by reading the LAN ID from port status register.

Fixes: a34b3e6ed8fb ("net: txgbe: Store PCI info")
Cc: stable@vger.kernel.org
Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/B60A670C1F52CB8E+20251104062321.40059-1-jiawenwu@trustnetic.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/wangxun/libwx/wx_hw.c   |    3 ++-
 drivers/net/ethernet/wangxun/libwx/wx_type.h |    4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/wangxun/libwx/wx_hw.c
+++ b/drivers/net/ethernet/wangxun/libwx/wx_hw.c
@@ -1667,7 +1667,8 @@ int wx_sw_init(struct wx *wx)
 	wx->oem_svid = pdev->subsystem_vendor;
 	wx->oem_ssid = pdev->subsystem_device;
 	wx->bus.device = PCI_SLOT(pdev->devfn);
-	wx->bus.func = PCI_FUNC(pdev->devfn);
+	wx->bus.func = FIELD_GET(WX_CFG_PORT_ST_LANID,
+				 rd32(wx, WX_CFG_PORT_ST));
 
 	if (wx->oem_svid == PCI_VENDOR_ID_WANGXUN) {
 		wx->subsystem_vendor_id = pdev->subsystem_vendor;
--- a/drivers/net/ethernet/wangxun/libwx/wx_type.h
+++ b/drivers/net/ethernet/wangxun/libwx/wx_type.h
@@ -65,6 +65,8 @@
 #define WX_CFG_PORT_CTL_DRV_LOAD     BIT(3)
 #define WX_CFG_PORT_CTL_QINQ         BIT(2)
 #define WX_CFG_PORT_CTL_D_VLAN       BIT(0) /* double vlan*/
+#define WX_CFG_PORT_ST               0x14404
+#define WX_CFG_PORT_ST_LANID         GENMASK(9, 8)
 #define WX_CFG_TAG_TPID(_i)          (0x14430 + ((_i) * 4))
 #define WX_CFG_PORT_CTL_NUM_VT_MASK  GENMASK(13, 12) /* number of TVs */
 
@@ -363,8 +365,6 @@ enum WX_MSCA_CMD_value {
 #define TXD_USE_COUNT(S)     DIV_ROUND_UP((S), WX_MAX_DATA_PER_TXD)
 #define DESC_NEEDED          (MAX_SKB_FRAGS + 4)
 
-#define WX_CFG_PORT_ST               0x14404
-
 /******************* Receive Descriptor bit definitions **********************/
 #define WX_RXD_STAT_DD               BIT(0) /* Done */
 #define WX_RXD_STAT_EOP              BIT(1) /* End of Packet */


