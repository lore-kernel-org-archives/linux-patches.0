Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A29F6280CE5;
	Mon, 17 Aug 2026 14:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976757; cv=none; b=fTfMpUDC4oisUg6e7Eyiti6g5V2wiSXhnsg8NXPpPJNy/6mdtb8/oWHfzsK+DWLZoIL9I1r0tedjsB9XTCnGkajpqs9+2hR+7wXNYutHl0B0na9wiY7JiUuO8WRRJt0/0dtlM2jVM92d2qvAa2R1bBI5lMD0bMENvJfdjwL4FKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976757; c=relaxed/simple;
	bh=zRyYyaXXzVoBzh5xjw4iTJ5sjLeN6KAECr9kCX+obIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXnJ8JRB+a1XROUT0v5BP7AdC/o3H6NDE7WDd+SCifKpxZwKZoWASyM3hoocc72JjvoWnNWszdDHUXUIhN0Dy7vHSwMcbNqhNvZMjmNBxLuW8XZl4fKy1QkXpKrdSSvLA/mpsBc1JRnldGfuGx1xpydeZwTKoqEzSch21mI415M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hPF/fpKE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hPF/fpKE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073781F000E9;
	Mon, 17 Aug 2026 14:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976756;
	bh=4TF5iHWVoYisMFYj6hx1Ydw/HG1z4uULsMFebqR+q5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hPF/fpKEfmSdn0UWIQQevNwktdncm79VIfoSeQmptQQ2jomafQN1HfotGYAAMyim/
	 whWGwS2lu6YzOD+C8IZjIIkgloqMaOcz/JeqeQgG/zDLChQ31L16dkCixXA+dnAEL+
	 RwuyFy6+HfqlLGexhIUj1JmNsI6zWfGGGLqrFct0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e62a973f8322b3bbe3ac@syzkaller.appspotmail.com,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 092/456] usb: atm: ueagle-atm: reject descriptors that confuse probe and disconnect
Date: Mon, 17 Aug 2026 15:28:02 +0200
Message-ID: <20260817132543.709860107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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
index 661820041ca70d..6a282400027d68 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -2591,6 +2591,7 @@ static struct usbatm_driver uea_usbatm_driver = {
 static int uea_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
 	struct usb_device *usb = interface_to_usbdev(intf);
+	bool single_iface = usb->config->desc.bNumInterfaces == 1;
 	int ret;
 
 	uea_enters(usb);
@@ -2600,6 +2601,22 @@ static int uea_probe(struct usb_interface *intf, const struct usb_device_id *id)
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



