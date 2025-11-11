Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88E32EA481;
	Tue, 11 Nov 2025 01:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824729; cv=none; b=nJLdXUsr0RKLTxl+rXcWErc8Hs4zmPQj91pxnnD2olag3DtmneBOCOjELQa2fHNOILXUupxTkywnyp0HPp/O12sIuOPNYxv94yvojR8qHqhbALreg6gNNIMrenxoNePFiep+R8v/pyETmD1t5sjX/tSufPnK5c+f4bpz3yV2SSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824729; c=relaxed/simple;
	bh=LGPuBDvaU1NAJn5OfswNUZPPFax+A67jnVKWruyY6A0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlwLyQxAO3GYbt0y28Vyurlf+kS0KD2AMf0XsyJtgaRVzfteHhZ0b6enaWvnOHdvQDNLmMq2FfbxFAx7N6b6fr7zwVOixuJ2YDnFxTcirr1bN0aTKCnN/Hc0QS+psvxWSHXdpFwCM6IQ52nJtLoRORNQAyltLZuZw8AMXE0AJLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xp1r26ZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xp1r26ZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A650C4CEFB;
	Tue, 11 Nov 2025 01:32:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824728;
	bh=LGPuBDvaU1NAJn5OfswNUZPPFax+A67jnVKWruyY6A0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xp1r26ZWVI0yOqHKNhq/GseJPFiUrc+MqnBFK+WkYvwglFwRYsVbrdsCkm8qd0k12
	 pXCcgJq/ekpnMsMEjxhd4fmzTatGSgALkHFbNGoPN3rKS2EwgR7xSb1zXbHxM7FOU4
	 +GUABVjeBsmj0KVsnsP+IFbype9P+hn9NXUAHEkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 506/565] net: libwx: fix device bus LAN ID
Date: Tue, 11 Nov 2025 09:46:02 +0900
Message-ID: <20251111004538.329774564@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1943,7 +1943,8 @@ int wx_sw_init(struct wx *wx)
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
@@ -85,6 +85,8 @@
 #define WX_CFG_PORT_CTL_DRV_LOAD     BIT(3)
 #define WX_CFG_PORT_CTL_QINQ         BIT(2)
 #define WX_CFG_PORT_CTL_D_VLAN       BIT(0) /* double vlan*/
+#define WX_CFG_PORT_ST               0x14404
+#define WX_CFG_PORT_ST_LANID         GENMASK(9, 8)
 #define WX_CFG_TAG_TPID(_i)          (0x14430 + ((_i) * 4))
 #define WX_CFG_PORT_CTL_NUM_VT_MASK  GENMASK(13, 12) /* number of TVs */
 
@@ -451,8 +453,6 @@ enum WX_MSCA_CMD_value {
 #define TXD_USE_COUNT(S)     DIV_ROUND_UP((S), WX_MAX_DATA_PER_TXD)
 #define DESC_NEEDED          (MAX_SKB_FRAGS + 4)
 
-#define WX_CFG_PORT_ST               0x14404
-
 /******************* Receive Descriptor bit definitions **********************/
 #define WX_RXD_STAT_DD               BIT(0) /* Done */
 #define WX_RXD_STAT_EOP              BIT(1) /* End of Packet */


