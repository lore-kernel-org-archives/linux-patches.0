Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCED738F658;
	Thu, 17 Sep 2026 18:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789671339; cv=none; b=TolwqPxpzZxaN+GLIOrh/iG22zKeB36EfmKjxdooarnCU9FdC67pIK3+p1O/tONQqdswlK0DfZ0zucW4njZhPUAgBwMk+JaJhlrrO62QKsfxfMJqNC9xh3z6ECZhgFY4b62xXcZjdbJZVNZwkSa4k9EK50YF3nUOM7uuvlhkoxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789671339; c=relaxed/simple;
	bh=+QgtDu4GrtwI4daqFsLHQh2es2P4yntAtTKErNzr4NM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ueMcDjYuw7TqXhYfwX6ni5hKE2Mdr9TIh0jo6veIwBDxXcG+tdZ7vTcvKMQ2qJTVlfhmPr7R9E/b+3G8b+c4zziqZQfUKvdjp1uN/3l6ZlPn3CLcBkhLuqgYDdtQuwB1a50Ugydn8H0Db+sL4d7VIhn/vcVNxQjMI3xF/eO6fz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6psuW5f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6psuW5f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A5871F000FF;
	Thu, 17 Sep 2026 18:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789671337;
	bh=6f0/5WmjlMkffI7hIvhcaJDF3wF9EB8U4Ui/j98iMRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6psuW5fcf+7lKg9PYDwPLvKj+/r253oM8SE0F0PQAu7OHSiaFXBLKjtgmoGiesO0
	 y9asPlTXG4GWkAQho4kUidOMxvs+6kAJzQq+zj+MELdrGogSyr/XsLDEV3e8W82UgX
	 8gCbC3wbukOd7iHml0Uc1X/xWN0A2ExXd9u1BIhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0943/1102] usb: xusbatm: dont rely on id table pointer arithmetic
Date: Thu, 17 Sep 2026 16:14:46 +0100
Message-ID: <20260917151604.320265358@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Gary Guo <gary@garyguo.net>

[ Upstream commit eb6cd6d3d8abeac5d7e8251b898067184afdad8a ]

The current code is broken when dynamic ID is involved; in such cases
usb_device_id parameter of probe lives on the heap and the pointer
arithmetic will get an index that is wildly out of bound. xusbatm
initialize the USB device IDs dynamically so it can just use driver_info
too.

Even with conversion, xusbatm still cannot support dynamic IDs, so also set
no_dynamic_id.

Signed-off-by: Gary Guo <gary@garyguo.net>
Link: https://patch.msgid.link/20260707-usb_dyn_id_uaf-v2-6-632dcf3adfba@garyguo.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/atm/xusbatm.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/atm/xusbatm.c b/drivers/usb/atm/xusbatm.c
index 0befbf63d1cc8..5c1e1f5215555 100644
--- a/drivers/usb/atm/xusbatm.c
+++ b/drivers/usb/atm/xusbatm.c
@@ -79,7 +79,7 @@ static int xusbatm_bind(struct usbatm_data *usbatm,
 			struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct usb_device *usb_dev = interface_to_usbdev(intf);
-	int drv_ix = id - xusbatm_usb_ids;
+	int drv_ix = id->driver_info;
 	int rx_alt = rx_altsetting[drv_ix];
 	int tx_alt = tx_altsetting[drv_ix];
 	struct usb_interface *rx_intf = xusbatm_find_intf(usb_dev, rx_alt, rx_endpoint[drv_ix]);
@@ -168,7 +168,8 @@ static struct usb_driver xusbatm_usb_driver = {
 	.name		= xusbatm_driver_name,
 	.probe		= xusbatm_usb_probe,
 	.disconnect	= usbatm_usb_disconnect,
-	.id_table	= xusbatm_usb_ids
+	.id_table	= xusbatm_usb_ids,
+	.no_dynamic_id	= 1,
 };
 
 static int __init xusbatm_init(void)
@@ -190,6 +191,7 @@ static int __init xusbatm_init(void)
 		xusbatm_usb_ids[i].match_flags	= USB_DEVICE_ID_MATCH_DEVICE;
 		xusbatm_usb_ids[i].idVendor	= vendor[i];
 		xusbatm_usb_ids[i].idProduct	= product[i];
+		xusbatm_usb_ids[i].driver_info	= i;
 
 		xusbatm_drivers[i].driver_name	= xusbatm_driver_name;
 		xusbatm_drivers[i].bind		= xusbatm_bind;
-- 
2.53.0



