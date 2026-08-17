Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B352EEE85;
	Mon, 17 Aug 2026 15:07:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979236; cv=none; b=SgSsPkO0GG7pP32+sm+A/FsxQQiD05cFqtWpYldq/CcRyu+KHBQhORInYRq00xu7/+XCgdKdpRdqm7phvFxUB1YwauqlydbyqYw+kU/mjNpa3q8rfEQuR40O0Hn7W4mazF5oDmubtMMkhYAGaIfgt3l2QbnJxRZhoilec4DQ+pE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979236; c=relaxed/simple;
	bh=by/kQs+6icgc419obYn5GrhUJrNH8QJ7zj/uJaGWlDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rFf+kl8+NCiqHTDDqrA8Qcf+XWx5kmztfS0M4JnQxqPw+QD3HgEgVzL1Dt67DvxXeQMsfkA+rD6i2kiE3+xkQi62GeEYYWHnSacsEY7f9C4Kr5TFfYqVAYCInsti1ROvcR/lFoASk3bODN0ZL9m6cPflp6gWrlWpWvNC5JOa9q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1h0UHjCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1h0UHjCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4501F000E9;
	Mon, 17 Aug 2026 15:07:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979235;
	bh=Yyae1q84DztNcjiJau7tI0wzIZ6nnQa0hOZr6nUWlQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1h0UHjCbVIWnIAW1Lqmxh6vnsbUz/q30HdONWrvhPrBDW8mdMEzoPgTvL74M6vcja
	 ZCTt5yEVt+/iVBX0fDqVhj7OrwkzN3dEoUtRipLLMJFRpmuZ2iOckChoE4B6ztZq5C
	 rAcEM4qUsxZVVu3f4fJpGjFnuq+SBiTYb6eVI8zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e62a973f8322b3bbe3ac@syzkaller.appspotmail.com,
	Diego Fernando Mancera Gomez <diegomancera.dev@gmail.com>,
	Stanislaw Gruszka <stf_xl@wp.pl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 116/609] usb: atm: ueagle-atm: reject descriptors that confuse probe and disconnect
Date: Mon, 17 Aug 2026 15:26:52 +0200
Message-ID: <20260817132547.651498417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b41f352769f072..5dfe82a4c130da 100644
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



