Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6291C168B0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5nIw8xs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3CD7C433C7;
	Mon, 23 Oct 2023 11:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061696;
	bh=v6WCvvd6ijV1BKKyHZhrpkhaY/35d/Opp6qCs33QXUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5nIw8xsbXziiwdosNocY6TWaVmCbg5Ksyo6K3tkSdLOQAmSLSX7KhqmCJDf6MxL5
	 fAYXAADuNzWV69ZRl4CU35qFV/5bZJLIFpMJldLRARJ+V/WmnAWDItl5ajkbUmtQMc
	 trOZ/tfm/qhPIu3//kDSQALQkV2Kr6H37bJDr3rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/202] usb: core: Track SuperSpeed Plus GenXxY
Date: Mon, 23 Oct 2023 12:57:21 +0200
Message-ID: <20231023104830.449104794@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

[ Upstream commit 0299809be415567366b66f248eed93848b8dc9f3 ]

Introduce ssp_rate field to usb_device structure to capture the
connected SuperSpeed Plus signaling rate generation and lane count with
the corresponding usb_ssp_rate enum.

Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/b7805d121e5ae4ad5ae144bd860b6ac04ee47436.1615432770.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: f74a7afc224a ("usb: hub: Guard against accesses to uninitialized BOS descriptors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/hcd.c |  6 +++-
 drivers/usb/core/hub.c | 78 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/usb.h    |  2 ++
 3 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 63bb04d262d84..0a77717d6af20 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -2745,6 +2745,7 @@ int usb_add_hcd(struct usb_hcd *hcd,
 
 	rhdev->rx_lanes = 1;
 	rhdev->tx_lanes = 1;
+	rhdev->ssp_rate = USB_SSP_GEN_UNKNOWN;
 
 	switch (hcd->speed) {
 	case HCD_USB11:
@@ -2762,8 +2763,11 @@ int usb_add_hcd(struct usb_hcd *hcd,
 	case HCD_USB32:
 		rhdev->rx_lanes = 2;
 		rhdev->tx_lanes = 2;
-		fallthrough;
+		rhdev->ssp_rate = USB_SSP_GEN_2x2;
+		rhdev->speed = USB_SPEED_SUPER_PLUS;
+		break;
 	case HCD_USB31:
+		rhdev->ssp_rate = USB_SSP_GEN_2x1;
 		rhdev->speed = USB_SPEED_SUPER_PLUS;
 		break;
 	default:
diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index b91b01c2c5dee..cfcd4f2ffffaa 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -31,6 +31,7 @@
 #include <linux/pm_qos.h>
 #include <linux/kobject.h>
 
+#include <linux/bitfield.h>
 #include <linux/uaccess.h>
 #include <asm/byteorder.h>
 
@@ -2691,6 +2692,81 @@ int usb_authorize_device(struct usb_device *usb_dev)
 	return result;
 }
 
+/**
+ * get_port_ssp_rate - Match the extended port status to SSP rate
+ * @hdev: The hub device
+ * @ext_portstatus: extended port status
+ *
+ * Match the extended port status speed id to the SuperSpeed Plus sublink speed
+ * capability attributes. Base on the number of connected lanes and speed,
+ * return the corresponding enum usb_ssp_rate.
+ */
+static enum usb_ssp_rate get_port_ssp_rate(struct usb_device *hdev,
+					   u32 ext_portstatus)
+{
+	struct usb_ssp_cap_descriptor *ssp_cap = hdev->bos->ssp_cap;
+	u32 attr;
+	u8 speed_id;
+	u8 ssac;
+	u8 lanes;
+	int i;
+
+	if (!ssp_cap)
+		goto out;
+
+	speed_id = ext_portstatus & USB_EXT_PORT_STAT_RX_SPEED_ID;
+	lanes = USB_EXT_PORT_RX_LANES(ext_portstatus) + 1;
+
+	ssac = le32_to_cpu(ssp_cap->bmAttributes) &
+		USB_SSP_SUBLINK_SPEED_ATTRIBS;
+
+	for (i = 0; i <= ssac; i++) {
+		u8 ssid;
+
+		attr = le32_to_cpu(ssp_cap->bmSublinkSpeedAttr[i]);
+		ssid = FIELD_GET(USB_SSP_SUBLINK_SPEED_SSID, attr);
+		if (speed_id == ssid) {
+			u16 mantissa;
+			u8 lse;
+			u8 type;
+
+			/*
+			 * Note: currently asymmetric lane types are only
+			 * applicable for SSIC operate in SuperSpeed protocol
+			 */
+			type = FIELD_GET(USB_SSP_SUBLINK_SPEED_ST, attr);
+			if (type == USB_SSP_SUBLINK_SPEED_ST_ASYM_RX ||
+			    type == USB_SSP_SUBLINK_SPEED_ST_ASYM_TX)
+				goto out;
+
+			if (FIELD_GET(USB_SSP_SUBLINK_SPEED_LP, attr) !=
+			    USB_SSP_SUBLINK_SPEED_LP_SSP)
+				goto out;
+
+			lse = FIELD_GET(USB_SSP_SUBLINK_SPEED_LSE, attr);
+			mantissa = FIELD_GET(USB_SSP_SUBLINK_SPEED_LSM, attr);
+
+			/* Convert to Gbps */
+			for (; lse < USB_SSP_SUBLINK_SPEED_LSE_GBPS; lse++)
+				mantissa /= 1000;
+
+			if (mantissa >= 10 && lanes == 1)
+				return USB_SSP_GEN_2x1;
+
+			if (mantissa >= 10 && lanes == 2)
+				return USB_SSP_GEN_2x2;
+
+			if (mantissa >= 5 && lanes == 2)
+				return USB_SSP_GEN_1x2;
+
+			goto out;
+		}
+	}
+
+out:
+	return USB_SSP_GEN_UNKNOWN;
+}
+
 /*
  * Return 1 if port speed is SuperSpeedPlus, 0 otherwise or if the
  * capability couldn't be checked.
@@ -2878,9 +2954,11 @@ static int hub_port_wait_reset(struct usb_hub *hub, int port1,
 		/* extended portstatus Rx and Tx lane count are zero based */
 		udev->rx_lanes = USB_EXT_PORT_RX_LANES(ext_portstatus) + 1;
 		udev->tx_lanes = USB_EXT_PORT_TX_LANES(ext_portstatus) + 1;
+		udev->ssp_rate = get_port_ssp_rate(hub->hdev, ext_portstatus);
 	} else {
 		udev->rx_lanes = 1;
 		udev->tx_lanes = 1;
+		udev->ssp_rate = USB_SSP_GEN_UNKNOWN;
 	}
 	if (hub_is_wusb(hub))
 		udev->speed = USB_SPEED_WIRELESS;
diff --git a/include/linux/usb.h b/include/linux/usb.h
index bc59237727033..8bc1119afc317 100644
--- a/include/linux/usb.h
+++ b/include/linux/usb.h
@@ -565,6 +565,7 @@ struct usb3_lpm_parameters {
  * @speed: device speed: high/full/low (or error)
  * @rx_lanes: number of rx lanes in use, USB 3.2 adds dual-lane support
  * @tx_lanes: number of tx lanes in use, USB 3.2 adds dual-lane support
+ * @ssp_rate: SuperSpeed Plus phy signaling rate and lane count
  * @tt: Transaction Translator info; used with low/full speed dev, highspeed hub
  * @ttport: device port on that tt hub
  * @toggle: one bit for each endpoint, with ([0] = IN, [1] = OUT) endpoints
@@ -642,6 +643,7 @@ struct usb_device {
 	enum usb_device_speed	speed;
 	unsigned int		rx_lanes;
 	unsigned int		tx_lanes;
+	enum usb_ssp_rate	ssp_rate;
 
 	struct usb_tt	*tt;
 	int		ttport;
-- 
2.40.1



