Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E6E43806BD;
	Thu, 30 Jul 2026 15:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425707; cv=none; b=TB7jw03zEyAdIJpnRuKHu3QZI7sFEgSAOOGbvVr0LcFyB24uNN6XrnVJUkYvnR4l3fe9TbUr5GeTQRdRjR5Ufb00HGYlXrjW6ZgkWp64QDv9h9m3fiX9Ws0P8ynbU3V5bJ0CmGb+DnIHkM77ISnML6b5qd5vQYPyNtlEWV6JHDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425707; c=relaxed/simple;
	bh=FU7xEUGsPwZyHsytYp8XRk0dD1Bp2YL5dobEKvgGX2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Drfb+wXhcxCYEKR2+MKgE6BPzXnhusUtKITTgKMFqmIBrNnZMyFNSPN0FZ3ajocbziocZRjZvoJGO4+zEU8oiIZJBsei2knuCYH0Xn/Ubf4RD0T/5Irb4CF7eeOd6en82N6JBT/qLzcyUi3WTjz4PCVUeMJRTLzj1LHaZdPz+/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1+c16hWu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1+c16hWu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EABAB1F000E9;
	Thu, 30 Jul 2026 15:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425706;
	bh=l/ucv8tkmtIGZldJyHq3uXnN6b7jCp3ijxUq/K00IoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1+c16hWuaMUVtXy7My+kqMgy9ZL9IXyaR3QaCOYWUgVQ50hzCUPfd7+jzwUqbv4R4
	 KbwFUQur+z6XTFJlDam58sAsNe0Pv5laG5YUUJG6KpsAXZ4gmb4I3AXGfEOGyoQYAS
	 rp5E/TXl7kbR8Kdxl/kKBcwPD6pPMzgAUgyBk6CE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e62a973f8322b3bbe3ac@syzkaller.appspotmail.com,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 163/602] usb: atm: ueagle-atm: reject descriptors that confuse probe and disconnect
Date: Thu, 30 Jul 2026 16:09:15 +0200
Message-ID: <20260730141439.396948115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>

[ Upstream commit 71132cedd1ecbc4032d76e9928c18a10f7e39b80 ]

uea_probe() distinguishes a pre-firmware device from a post-firmware one
using the USB id (UEA_IS_PREFIRM()), and stores a different object as the
interface data in each case: a 'struct completion' for a pre-firmware
device (to be waited on in .disconnect()), or a 'struct usbatm_data' for a
post-firmware one.

uea_disconnect() instead tells the two apart by the number of interfaces
of the active configuration (a pre-firmware device exposes a single
interface, ADI930 has 2 and eagle has 3), and casts the interface data
accordingly.

Because the two handlers use different criteria, a crafted device that
advertises a pre-firmware id together with a multi-interface descriptor
(or a post-firmware id with a single interface) makes them disagree: the
small 'struct completion' stored by uea_probe() is then passed to
usbatm_usb_disconnect(), which casts it to 'struct usbatm_data' and takes
instance->serialize, reading past the end of the allocation:

  BUG: KASAN: slab-out-of-bounds in __mutex_lock+0x152a/0x1b80
  Read of size 8 at addr ffff8880470e2c60 by task kworker/1:2/982
  ...
   __mutex_lock+0x152a/0x1b80
   usbatm_usb_disconnect+0x70/0x820
   uea_disconnect+0x133/0x2c0
   usb_unbind_interface+0x1dd/0x9e0
  ...
  which belongs to the cache kmalloc-96 of size 96
  The buggy address is located 0 bytes to the right of
   allocated 96-byte region [ffff8880470e2c00, ffff8880470e2c60)

Reject such inconsistent descriptors in uea_probe() so that both handlers
always make the same pre/post-firmware decision.

Reported-by: syzbot+e62a973f8322b3bbe3ac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e62a973f8322b3bbe3ac
Fixes: e2674dfbed8a ("usb: atm: ueagle-atm: wait for pre-firmware load in .disconnect()")
Signed-off-by: Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
Link: https://patch.msgid.link/20260717080704.1264-1-diegomancera.dev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/atm/ueagle-atm.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index cd53d36aa30748..dad42820814022 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -2590,6 +2590,7 @@ static struct usbatm_driver uea_usbatm_driver = {
 static int uea_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct usb_device *usb = interface_to_usbdev(intf);
+	bool single_iface = usb->config->desc.bNumInterfaces == 1;
 	int ret;
 
 	uea_enters(usb);
@@ -2599,6 +2600,22 @@ static int uea_probe(struct usb_interface *intf, const struct usb_device_id *id)
 		le16_to_cpu(usb->descriptor.bcdDevice),
 		chip_name[UEA_CHIP_VERSION(id)]);
 
+	/*
+	 * uea_probe() decides between the pre-firmware and post-firmware case
+	 * from the USB id and stores a different object as interface data in
+	 * each case: a struct completion for a pre-firmware device, a struct
+	 * usbatm_data for a post-firmware one. uea_disconnect() instead tells
+	 * the two apart by the number of interfaces (a pre-firmware device
+	 * exposes a single interface, ADI930 has 2 and eagle has 3). A crafted
+	 * device advertising a pre-firmware id together with a multi-interface
+	 * descriptor (or the other way around) makes the two disagree, so that
+	 * usbatm_usb_disconnect() treats the small completion object as a
+	 * struct usbatm_data and reads out of bounds. Reject such inconsistent
+	 * descriptors so both paths make the same decision.
+	 */
+	if (UEA_IS_PREFIRM(id) != single_iface)
+		return -ENODEV;
+
 	usb_reset_device(usb);
 
 	if (UEA_IS_PREFIRM(id)) {
-- 
2.53.0



