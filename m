Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216621BDDE;
	Wed,  3 Jan 2024 17:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iutbcGCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252C6C433C8;
	Wed,  3 Jan 2024 17:06:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301620;
	bh=3CjQ9/RaMrUTAUtOr0v6B08nkphJYaNxsMCNAPVhK2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iutbcGCHAvT3cO+91J7pvs/UwOaGGA8c8NsJJOKI/aznNQ2ab6g7UU3tv4lGA3Cyh
	 bAmSWZVq0ebJtpnZz9yC3964XpgOish6Lcke6r8hjThUAaigNX0EXYpBQ7EVjXIo/0
	 JQ0VffX55/n23A4aoJcDCanB8g6JEOdZr9TPOVdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Justin Chen <justinpopo6@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 77/95] net: usb: ax88179_178a: clean up pm calls
Date: Wed,  3 Jan 2024 17:55:25 +0100
Message-ID: <20240103164905.570490180@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
References: <20240103164853.921194838@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Justin Chen <justinpopo6@gmail.com>

[ Upstream commit 843f92052da7694e846e8e12bbe2342845d2033e ]

Instead of passing in_pm flags all over the place, use the private
struct to handle in_pm mode.

Signed-off-by: Justin Chen <justinpopo6@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: aef05e349bfd ("net: usb: ax88179_178a: avoid failed operations when device is disconnected")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/ax88179_178a.c | 147 +++++++++++++--------------------
 1 file changed, 59 insertions(+), 88 deletions(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 7f5680c0b230c..bd258c4e13948 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -169,6 +169,7 @@ struct ax88179_data {
 	u8  eee_active;
 	u16 rxctl;
 	u16 reserved;
+	u8 in_pm;
 };
 
 struct ax88179_int_data {
@@ -185,15 +186,29 @@ static const struct {
 	{7, 0xcc, 0x4c, 0x18, 8},
 };
 
+static void ax88179_set_pm_mode(struct usbnet *dev, bool pm_mode)
+{
+	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
+
+	ax179_data->in_pm = pm_mode;
+}
+
+static int ax88179_in_pm(struct usbnet *dev)
+{
+	struct ax88179_data *ax179_data = (struct ax88179_data *)dev->data;
+
+	return ax179_data->in_pm;
+}
+
 static int __ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-			      u16 size, void *data, int in_pm)
+			      u16 size, void *data)
 {
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, void *, u16);
 
 	BUG_ON(!dev);
 
-	if (!in_pm)
+	if (!ax88179_in_pm(dev))
 		fn = usbnet_read_cmd;
 	else
 		fn = usbnet_read_cmd_nopm;
@@ -209,14 +224,14 @@ static int __ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 }
 
 static int __ax88179_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
-			       u16 size, const void *data, int in_pm)
+			       u16 size, const void *data)
 {
 	int ret;
 	int (*fn)(struct usbnet *, u8, u8, u16, u16, const void *, u16);
 
 	BUG_ON(!dev);
 
-	if (!in_pm)
+	if (!ax88179_in_pm(dev))
 		fn = usbnet_write_cmd;
 	else
 		fn = usbnet_write_cmd_nopm;
@@ -249,47 +264,6 @@ static void ax88179_write_cmd_async(struct usbnet *dev, u8 cmd, u16 value,
 	}
 }
 
-static int ax88179_read_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
-				 u16 index, u16 size, void *data)
-{
-	int ret;
-
-	if (2 == size) {
-		u16 buf;
-		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 1);
-		le16_to_cpus(&buf);
-		*((u16 *)data) = buf;
-	} else if (4 == size) {
-		u32 buf;
-		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 1);
-		le32_to_cpus(&buf);
-		*((u32 *)data) = buf;
-	} else {
-		ret = __ax88179_read_cmd(dev, cmd, value, index, size, data, 1);
-	}
-
-	return ret;
-}
-
-static int ax88179_write_cmd_nopm(struct usbnet *dev, u8 cmd, u16 value,
-				  u16 index, u16 size, const void *data)
-{
-	int ret;
-
-	if (2 == size) {
-		u16 buf;
-		buf = *((u16 *)data);
-		cpu_to_le16s(&buf);
-		ret = __ax88179_write_cmd(dev, cmd, value, index,
-					  size, &buf, 1);
-	} else {
-		ret = __ax88179_write_cmd(dev, cmd, value, index,
-					  size, data, 1);
-	}
-
-	return ret;
-}
-
 static int ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 			    u16 size, void *data)
 {
@@ -297,16 +271,16 @@ static int ax88179_read_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 
 	if (2 == size) {
 		u16 buf = 0;
-		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
+		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf);
 		le16_to_cpus(&buf);
 		*((u16 *)data) = buf;
 	} else if (4 == size) {
 		u32 buf = 0;
-		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf, 0);
+		ret = __ax88179_read_cmd(dev, cmd, value, index, size, &buf);
 		le32_to_cpus(&buf);
 		*((u32 *)data) = buf;
 	} else {
-		ret = __ax88179_read_cmd(dev, cmd, value, index, size, data, 0);
+		ret = __ax88179_read_cmd(dev, cmd, value, index, size, data);
 	}
 
 	return ret;
@@ -322,10 +296,10 @@ static int ax88179_write_cmd(struct usbnet *dev, u8 cmd, u16 value, u16 index,
 		buf = *((u16 *)data);
 		cpu_to_le16s(&buf);
 		ret = __ax88179_write_cmd(dev, cmd, value, index,
-					  size, &buf, 0);
+					  size, &buf);
 	} else {
 		ret = __ax88179_write_cmd(dev, cmd, value, index,
-					  size, data, 0);
+					  size, data);
 	}
 
 	return ret;
@@ -428,52 +402,46 @@ static int ax88179_suspend(struct usb_interface *intf, pm_message_t message)
 	u16 tmp16;
 	u8 tmp8;
 
+	ax88179_set_pm_mode(dev, true);
+
 	usbnet_suspend(intf, message);
 
 	/* Disable RX path */
-	ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
-			      2, 2, &tmp16);
+	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
+			 2, 2, &tmp16);
 	tmp16 &= ~AX_MEDIUM_RECEIVE_EN;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
-			       2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_MEDIUM_STATUS_MODE,
+			  2, 2, &tmp16);
 
 	/* Force bulk-in zero length */
-	ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
-			      2, 2, &tmp16);
+	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
+			 2, 2, &tmp16);
 
 	tmp16 |= AX_PHYPWR_RSTCTL_BZ | AX_PHYPWR_RSTCTL_IPRL;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
-			       2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
+			  2, 2, &tmp16);
 
 	/* change clock */
 	tmp8 = 0;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
 
 	/* Configure RX control register => stop operation */
 	tmp16 = AX_RX_CTL_STOP;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_RX_CTL, 2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RX_CTL, 2, 2, &tmp16);
+
+	ax88179_set_pm_mode(dev, false);
 
 	return 0;
 }
 
 /* This function is used to enable the autodetach function. */
 /* This function is determined by offset 0x43 of EEPROM */
-static int ax88179_auto_detach(struct usbnet *dev, int in_pm)
+static int ax88179_auto_detach(struct usbnet *dev)
 {
 	u16 tmp16;
 	u8 tmp8;
-	int (*fnr)(struct usbnet *, u8, u16, u16, u16, void *);
-	int (*fnw)(struct usbnet *, u8, u16, u16, u16, const void *);
-
-	if (!in_pm) {
-		fnr = ax88179_read_cmd;
-		fnw = ax88179_write_cmd;
-	} else {
-		fnr = ax88179_read_cmd_nopm;
-		fnw = ax88179_write_cmd_nopm;
-	}
 
-	if (fnr(dev, AX_ACCESS_EEPROM, 0x43, 1, 2, &tmp16) < 0)
+	if (ax88179_read_cmd(dev, AX_ACCESS_EEPROM, 0x43, 1, 2, &tmp16) < 0)
 		return 0;
 
 	if ((tmp16 == 0xFFFF) || (!(tmp16 & 0x0100)))
@@ -481,13 +449,13 @@ static int ax88179_auto_detach(struct usbnet *dev, int in_pm)
 
 	/* Enable Auto Detach bit */
 	tmp8 = 0;
-	fnr(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
+	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
 	tmp8 |= AX_CLK_SELECT_ULR;
-	fnw(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
 
-	fnr(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
+	ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
 	tmp16 |= AX_PHYPWR_RSTCTL_AT;
-	fnw(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL, 2, 2, &tmp16);
 
 	return 0;
 }
@@ -498,32 +466,36 @@ static int ax88179_resume(struct usb_interface *intf)
 	u16 tmp16;
 	u8 tmp8;
 
+	ax88179_set_pm_mode(dev, true);
+
 	usbnet_link_change(dev, 0, 0);
 
 	/* Power up ethernet PHY */
 	tmp16 = 0;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
-			       2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
+			  2, 2, &tmp16);
 	udelay(1000);
 
 	tmp16 = AX_PHYPWR_RSTCTL_IPRL;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
-			       2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_PHYPWR_RSTCTL,
+			  2, 2, &tmp16);
 	msleep(200);
 
 	/* Ethernet PHY Auto Detach*/
-	ax88179_auto_detach(dev, 1);
+	ax88179_auto_detach(dev);
 
 	/* Enable clock */
-	ax88179_read_cmd_nopm(dev, AX_ACCESS_MAC,  AX_CLK_SELECT, 1, 1, &tmp8);
+	ax88179_read_cmd(dev, AX_ACCESS_MAC,  AX_CLK_SELECT, 1, 1, &tmp8);
 	tmp8 |= AX_CLK_SELECT_ACS | AX_CLK_SELECT_BCS;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_CLK_SELECT, 1, 1, &tmp8);
 	msleep(100);
 
 	/* Configure RX control register => start operation */
 	tmp16 = AX_RX_CTL_DROPCRCERR | AX_RX_CTL_IPE | AX_RX_CTL_START |
 		AX_RX_CTL_AP | AX_RX_CTL_AMALL | AX_RX_CTL_AB;
-	ax88179_write_cmd_nopm(dev, AX_ACCESS_MAC, AX_RX_CTL, 2, 2, &tmp16);
+	ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_RX_CTL, 2, 2, &tmp16);
+
+	ax88179_set_pm_mode(dev, false);
 
 	return usbnet_resume(intf);
 }
@@ -599,8 +571,7 @@ ax88179_get_eeprom(struct net_device *net, struct ethtool_eeprom *eeprom,
 	/* ax88179/178A returns 2 bytes from eeprom on read */
 	for (i = first_word; i <= last_word; i++) {
 		ret = __ax88179_read_cmd(dev, AX_ACCESS_EEPROM, i, 1, 2,
-					 &eeprom_buff[i - first_word],
-					 0);
+					 &eeprom_buff[i - first_word]);
 		if (ret < 0) {
 			kfree(eeprom_buff);
 			return -EIO;
@@ -1069,7 +1040,7 @@ static int ax88179_check_eeprom(struct usbnet *dev)
 		} while (buf & EEP_BUSY);
 
 		__ax88179_read_cmd(dev, AX_ACCESS_MAC, AX_SROM_DATA_LOW,
-				   2, 2, &eeprom[i * 2], 0);
+				   2, 2, &eeprom[i * 2]);
 
 		if ((i == 0) && (eeprom[0] == 0xFF))
 			return -EINVAL;
@@ -1707,7 +1678,7 @@ static int ax88179_reset(struct usbnet *dev)
 	msleep(200);
 
 	/* Ethernet PHY Auto Detach*/
-	ax88179_auto_detach(dev, 0);
+	ax88179_auto_detach(dev);
 
 	/* Read MAC address from DTB or asix chip */
 	ax88179_get_mac_addr(dev);
-- 
2.43.0



