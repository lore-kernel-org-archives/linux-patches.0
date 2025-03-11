Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B32925EF99;
	Tue, 11 Mar 2025 15:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707558; cv=none; b=hwVNvCV9P12pQbhAlUSDtNCWO6oB1606Q6Mf73e57bXUcAMNLdDQN8p29+dZyuZCDbtXt5IXshDrpadUgZYX1i3PC3hFJDigQNkNJMVReEf894wxK6oiHcMyqIV2FOUSnF+QJ2gQyGqE9V+e9iG7WLopRVYdAyvzfNmbhNYVpbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707558; c=relaxed/simple;
	bh=oZgeyVZ9nWAD4owHEDYtv5fQktogh9bMIUBZxWhAEko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HM+cAfrFAFk6zAikJT+x8Rm+4nlWgIatDaKVXOnwtl5+oFR7U/gQaw6W/YHXc33Z1g+KZ0ZkgZq+XyY1NfZDq9QaJk27aqBXPR3uiUZQ1UpFt1AaPEmpdb/Mma+qOCb0oUNjJEeU62KzEI/LbVBICUWOJjnyRt+SmFTSnAwGyX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvk+OhWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvk+OhWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852B4C4CEE9;
	Tue, 11 Mar 2025 15:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707557;
	bh=oZgeyVZ9nWAD4owHEDYtv5fQktogh9bMIUBZxWhAEko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvk+OhWjA6QH1tXeR9Z40MpnPFESZKHpcqeQ0rDJr4C2u8zExEhoOImfdFG9AKaTI
	 XixB0SRYwtYz+nkoG5TpKszqkyDV8xBkpWp8jEl7GMcAen8BPLw6uQcpjhcwpJBoxJ
	 9MweCXEKwOXhjJX9oZ7hw3bc1XO07JDxb28tUicY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Nikita Zhandarovich <n.zhandarovich@fintech.ru>,
	syzbot+ccbbc229a024fa3e13b5@syzkaller.appspotmail.com
Subject: [PATCH 5.10 430/462] usb: atm: cxacru: fix a flaw in existing endpoint checks
Date: Tue, 11 Mar 2025 16:01:36 +0100
Message-ID: <20250311145815.322173614@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Nikita Zhandarovich <n.zhandarovich@fintech.ru>

commit c90aad369899a607cfbc002bebeafd51e31900cd upstream.

Syzbot once again identified a flaw in usb endpoint checking, see [1].
This time the issue stems from a commit authored by me (2eabb655a968
("usb: atm: cxacru: fix endpoint checking in cxacru_bind()")).

While using usb_find_common_endpoints() may usually be enough to
discard devices with wrong endpoints, in this case one needs more
than just finding and identifying the sufficient number of endpoints
of correct types - one needs to check the endpoint's address as well.

Since cxacru_bind() fills URBs with CXACRU_EP_CMD address in mind,
switch the endpoint verification approach to usb_check_XXX_endpoints()
instead to fix incomplete ep testing.

[1] Syzbot report:
usb 5-1: BOGUS urb xfer, pipe 3 != type 1
WARNING: CPU: 0 PID: 1378 at drivers/usb/core/urb.c:504 usb_submit_urb+0xc4e/0x18c0 drivers/usb/core/urb.c:503
...
RIP: 0010:usb_submit_urb+0xc4e/0x18c0 drivers/usb/core/urb.c:503
...
Call Trace:
 <TASK>
 cxacru_cm+0x3c8/0xe50 drivers/usb/atm/cxacru.c:649
 cxacru_card_status drivers/usb/atm/cxacru.c:760 [inline]
 cxacru_bind+0xcf9/0x1150 drivers/usb/atm/cxacru.c:1223
 usbatm_usb_probe+0x314/0x1d30 drivers/usb/atm/usbatm.c:1058
 cxacru_usb_probe+0x184/0x220 drivers/usb/atm/cxacru.c:1377
 usb_probe_interface+0x641/0xbb0 drivers/usb/core/driver.c:396
 really_probe+0x2b9/0xad0 drivers/base/dd.c:658
 __driver_probe_device+0x1a2/0x390 drivers/base/dd.c:800
 driver_probe_device+0x50/0x430 drivers/base/dd.c:830
...

Reported-and-tested-by: syzbot+ccbbc229a024fa3e13b5@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ccbbc229a024fa3e13b5
Fixes: 2eabb655a968 ("usb: atm: cxacru: fix endpoint checking in cxacru_bind()")
Cc: stable@kernel.org
Signed-off-by: Nikita Zhandarovich <n.zhandarovich@fintech.ru>
Link: https://lore.kernel.org/r/20250213122259.730772-1-n.zhandarovich@fintech.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/atm/cxacru.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -1134,7 +1134,10 @@ static int cxacru_bind(struct usbatm_dat
 	struct cxacru_data *instance;
 	struct usb_device *usb_dev = interface_to_usbdev(intf);
 	struct usb_host_endpoint *cmd_ep = usb_dev->ep_in[CXACRU_EP_CMD];
-	struct usb_endpoint_descriptor *in, *out;
+	static const u8 ep_addrs[] = {
+		CXACRU_EP_CMD + USB_DIR_IN,
+		CXACRU_EP_CMD + USB_DIR_OUT,
+		0};
 	int ret;
 
 	/* instance init */
@@ -1182,13 +1185,11 @@ static int cxacru_bind(struct usbatm_dat
 	}
 
 	if (usb_endpoint_xfer_int(&cmd_ep->desc))
-		ret = usb_find_common_endpoints(intf->cur_altsetting,
-						NULL, NULL, &in, &out);
+		ret = usb_check_int_endpoints(intf, ep_addrs);
 	else
-		ret = usb_find_common_endpoints(intf->cur_altsetting,
-						&in, &out, NULL, NULL);
+		ret = usb_check_bulk_endpoints(intf, ep_addrs);
 
-	if (ret) {
+	if (!ret) {
 		usb_err(usbatm_instance, "cxacru_bind: interface has incorrect endpoints\n");
 		ret = -ENODEV;
 		goto fail;


