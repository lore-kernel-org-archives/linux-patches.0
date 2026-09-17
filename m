Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17961515979;
	Thu, 17 Sep 2026 17:42:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666938; cv=none; b=V9PBjrGH/fD/OBwqUPQ/xjzNUUcdSaHLnTMNpqV0D4DpvSRMxtrztr4j7bJEFYYtDCpOdZQuqLBE8N19VHDVye+ZGG7FzR711lWWZ8YE9trfzHrQkIKUFgNpMDNw6KOJ+OH7cc9NgvRsxQOFilyQAjpazKZLRah6HFlUdKHvNRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666938; c=relaxed/simple;
	bh=eiY9LD2wxO6w7ur7ebCVgIdVu7Lp7lcQDBgWTgE/8kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjhTgWjyj1KQ6Xzhd4r5AiopG0KhCM3Y5Xxhy6wvPIeNIvbbRQ8UB8KFUaPEJh6LLEs7HDZrdkzTsNrWSASbSrjlSiKyMSheTHOT/WI2aHPDIUxeyW2sTlLyzzFP6HACuWfYVUA1Z5flRapuI/9WOfpgbMEPo8pb7v/IzuWoj6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kAwZXlvO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kAwZXlvO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 699D41F000FF;
	Thu, 17 Sep 2026 17:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666937;
	bh=La4fVvOB4ivDsBNuENW6vPCF6NtxvAVG7Bu3HS30FD0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kAwZXlvOkIDnakId5hYwS8plLuWQ9YD3+Z8wmWq6t6ew1065xTIOMC8dGjz2CSNPO
	 mO/Kxui+JBpa7xy5298QGISVoeJ9GuGSE/gEAyyAxPk53M8+m4gIpqLDNRVMA8DIzI
	 RILrlcIBxcgoTuR0axWFeUNTBXV1+dghiLs5eIfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1147/1250] usb: xusbatm: dont rely on id table pointer arithmetic
Date: Thu, 17 Sep 2026 16:15:42 +0100
Message-ID: <20260917151623.355347556@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



