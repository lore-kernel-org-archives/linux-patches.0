Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9A3A3C3F56;
	Wed, 30 Sep 2026 19:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795811; cv=none; b=dVZZ2iUEvmgV6Zifuzdao5Oer6x0hstrxZ0958gnvh1n2YvgOzQrAOBJfnFyJAWTsNM9AuzgZSN/+4Qa8gm6OCoJdgiv8wGEZuu/2eH+rPWol4L4qEL5kKMyQnNkHzdFAk8OovTjrZoEIa6uslDnXb/axKBpAyhY+zpE7b4HqPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795811; c=relaxed/simple;
	bh=EAFARA/t8lL1+udRBb/8POraUcfXbU0ICC65+Z6XEF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJgu1z1oi7IDOENf83D1kkcKICco4UVzA6BEe3zYO5uaC7j2IUHrJsTR2somUpa1WE33YQt/11fGtR4Rm6VUOpoOMHlycVw8oIaqUpFkVv0OlcdT1VQJCVkprLdOzEljVbXdKrzoIFR+Yk1Wkh6JRfhIbjnFXAwKyeopB5/xJfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OuPGzbk2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OuPGzbk2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0074D1F000FF;
	Wed, 30 Sep 2026 19:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795810;
	bh=PPaZCAA5/CZ76m+CNqMagQPlEQcuG/5EyXjVXH+09mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OuPGzbk29LSeejQ2QJx9ct6NsqU55T8cuCbaiAnVfRO6xbT7H16DnHFlOcENKO5kt
	 g2WDc4MHum7kQszbpoIdia0qKhgwksd4XdSqBbM5OHoGF5pkMIO8WaU0fbGikk5DPR
	 i0VQ/D4IAHxiFYxBQ+U8lGqeOoVkC/IpBFdrxb2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gary Guo <gary@garyguo.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0691/1193] usb: xusbatm: dont rely on id table pointer arithmetic
Date: Wed, 30 Sep 2026 17:22:55 +0200
Message-ID: <20260930152449.599571908@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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



