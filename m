Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E161BD00C;
	Tue,  2 Jul 2024 17:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719941513; cv=none; b=D7UDc3gYukZKfUMMYNntTY+KRoTul9jhPy5UDAi4sHDviRvaedB1GlRk3VMoEOEYIHp+DstN4gEFJ5pSb1c0vvsDOBya56yqARETdYsQEYjQf9KgyeWzwpHCFVSVpv3iiMIQW4Eq3K6AzQLEz1uVPsBT3+7Kym9f1DNUH7zyKsY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719941513; c=relaxed/simple;
	bh=k7p5BimnB2SZOe9WL/+trYWIU+aCkGlCyRH4WhDaPtQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z/Gm6125YEarz8N+2TxFAqWtNZ5qwKz6IC3XPOAJpJGM5vQ+Gvu4v950lXbo38cvZ9wuZbX3g8r94Th1ZncjjQnFRJqvrtKiY6r1FNQSb1lipFELCdvmFZgMgXA1hK5jrQgxLEd/qNR2caypLVOCS71MH96VgnRrSb6Sv23Kvz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Eun5Tjfi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Eun5Tjfi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA244C116B1;
	Tue,  2 Jul 2024 17:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719941513;
	bh=k7p5BimnB2SZOe9WL/+trYWIU+aCkGlCyRH4WhDaPtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Eun5TjfiVw8one6IavgImmtVRVHgCwH0F4uMKkztlUPd6yZkZ3+/tcddnXiSxQ5Hr
	 NaPhYoqIM9vciAH0ZazEIPjUOcFlot1h55nJtosz68KuetM9mTfy2EJy30ffhS2Mb8
	 X9ZTyMRDXKYOAnBwydZT63F2osx68nJn+YmLUE5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	syzbot+00c18ee8497dd3be6ade@syzkaller.appspotmail.com
Subject: [PATCH 6.1 086/128] usb: atm: cxacru: fix endpoint checking in cxacru_bind()
Date: Tue,  2 Jul 2024 19:04:47 +0200
Message-ID: <20240702170229.474405924@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
References: <20240702170226.231899085@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit 2eabb655a968b862bc0c31629a09f0fbf3c80d51 upstream.

Syzbot is still reporting quite an old issue [1] that occurs due to
incomplete checking of present usb endpoints. As such, wrong
endpoints types may be used at urb sumbitting stage which in turn
triggers a warning in usb_submit_urb().

Fix the issue by verifying that required endpoint types are present
for both in and out endpoints, taking into account cmd endpoint type.

Unfortunately, this patch has not been tested on real hardware.

[1] Syzbot report:
usb 1-1: BOGUS urb xfer, pipe 1 != type 3
WARNING: CPU: 0 PID: 8667 at drivers/usb/core/urb.c:502 usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
Modules linked in:
CPU: 0 PID: 8667 Comm: kworker/0:4 Not tainted 5.14.0-rc4-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:usb_submit_urb+0xed2/0x18a0 drivers/usb/core/urb.c:502
...
Call Trace:
 cxacru_cm+0x3c0/0x8e0 drivers/usb/atm/cxacru.c:649
 cxacru_card_status+0x22/0xd0 drivers/usb/atm/cxacru.c:760
 cxacru_bind+0x7ac/0x11a0 drivers/usb/atm/cxacru.c:1209
 usbatm_usb_probe+0x321/0x1ae0 drivers/usb/atm/usbatm.c:1055
 cxacru_usb_probe+0xdf/0x1e0 drivers/usb/atm/cxacru.c:1363
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 call_driver_probe drivers/base/dd.c:517 [inline]
 really_probe+0x23c/0xcd0 drivers/base/dd.c:595
 __driver_probe_device+0x338/0x4d0 drivers/base/dd.c:747
 driver_probe_device+0x4c/0x1a0 drivers/base/dd.c:777
 __device_attach_driver+0x20b/0x2f0 drivers/base/dd.c:894
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:427
 __device_attach+0x228/0x4a0 drivers/base/dd.c:965
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:487
 device_add+0xc2f/0x2180 drivers/base/core.c:3354
 usb_set_configuration+0x113a/0x1910 drivers/usb/core/message.c:2170
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293

Reported-and-tested-by: syzbot+00c18ee8497dd3be6ade@syzkaller.appspotmail.com
Fixes: 902ffc3c707c ("USB: cxacru: Use a bulk/int URB to access the command endpoint")
Cc: stable <stable@kernel.org>
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20240609131546.3932-1-n.zhandarovich@fintech.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/atm/cxacru.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -1131,6 +1131,7 @@ static int cxacru_bind(struct usbatm_dat
 	struct cxacru_data *instance;
 	struct usb_device *usb_dev = interface_to_usbdev(intf);
 	struct usb_host_endpoint *cmd_ep = usb_dev->ep_in[CXACRU_EP_CMD];
+	struct usb_endpoint_descriptor *in, *out;
 	int ret;
 
 	/* instance init */
@@ -1176,6 +1177,19 @@ static int cxacru_bind(struct usbatm_dat
 		ret = -ENODEV;
 		goto fail;
 	}
+
+	if (usb_endpoint_xfer_int(&cmd_ep->desc))
+		ret = usb_find_common_endpoints(intf->cur_altsetting,
+						NULL, NULL, &in, &out);
+	else
+		ret = usb_find_common_endpoints(intf->cur_altsetting,
+						&in, &out, NULL, NULL);
+
+	if (ret) {
+		usb_err(usbatm_instance, "cxacru_bind: interface has incorrect endpoints\n");
+		ret = -ENODEV;
+		goto fail;
+	}
 
 	if ((cmd_ep->desc.bmAttributes & USB_ENDPOINT_XFERTYPE_MASK)
 			== USB_ENDPOINT_XFER_INT) {


