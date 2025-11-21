Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0A1E34C98C;
	Fri, 21 Nov 2025 13:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732077; cv=none; b=RS8VGNwYR8Sk9HzBt6bFqr4Y5gPcYhVZtFQi8/+yT/SL31UBD2JZ/rd+dD1yPdUIjF3CaDgIWoCOQlWhc1YX5WBtj5B8yzT+fEhme8Mxr1+ROgLkMRxAsZWZsXvFbyJiGKSJKbg5jJn/g4/9xo97dOtM9vFQHfs93EeetJVvh1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732077; c=relaxed/simple;
	bh=h3vtcxWqc1O+u//cI/hlA24XyrvlYyWih3dW1vgNljg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jpEF5UUMAAX5a/tmLrQFNtNW9Iwsxr82lEFYSThfQBYiqg/XjsZY38zIUA5cMuWEFgQ8o5vrk8YtXsS86Cxs3gLA3K/j/ccsHQgng//axcG/Nf+H8z0ll3nLgIhqFvEBwwJqlTCntN5+AOcmlPgyxa+DI5xc3U4b/3OwOV+tIhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLye1wEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLye1wEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A16A7C4CEF1;
	Fri, 21 Nov 2025 13:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732077;
	bh=h3vtcxWqc1O+u//cI/hlA24XyrvlYyWih3dW1vgNljg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLye1wEl92lZv9yoT6XsnNY880RepVFz9eY/qdOLrsAS3ookrmyFPwIrTY8TovIP0
	 iLomNS/9oFIP+Um0adm26OqYD2TQPhbB/X+KHvu2B9RhULY7j3N1N/3X2ciPbPNak/
	 qEX9P1tndw0eAX9NRLVC9TFmUy3p/S5ZeME6B4kU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 181/185] isdn: mISDN: hfcsusb: fix memory leak in hfcsusb_probe()
Date: Fri, 21 Nov 2025 14:13:28 +0100
Message-ID: <20251121130150.424678590@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Abdun Nihaal <nihaal@cse.iitm.ac.in>

commit 3f978e3f1570155a1327ffa25f60968bc7b9398f upstream.

In hfcsusb_probe(), the memory allocated for ctrl_urb gets leaked when
setup_instance() fails with an error code. Fix that by freeing the urb
before freeing the hw structure. Also change the error paths to use the
goto ladder style.

Compile tested only. Issue found using a prototype static analysis tool.

Fixes: 69f52adb2d53 ("mISDN: Add HFC USB driver")
Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
Link: https://patch.msgid.link/20251030042524.194812-1-nihaal@cse.iitm.ac.in
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/isdn/hardware/mISDN/hfcsusb.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/isdn/hardware/mISDN/hfcsusb.c
+++ b/drivers/isdn/hardware/mISDN/hfcsusb.c
@@ -1904,13 +1904,13 @@ out:
 	mISDN_freebchannel(&hw->bch[1]);
 	mISDN_freebchannel(&hw->bch[0]);
 	mISDN_freedchannel(&hw->dch);
-	kfree(hw);
 	return err;
 }
 
 static int
 hfcsusb_probe(struct usb_interface *intf, const struct usb_device_id *id)
 {
+	int err;
 	struct hfcsusb			*hw;
 	struct usb_device		*dev = interface_to_usbdev(intf);
 	struct usb_host_interface	*iface = intf->cur_altsetting;
@@ -2101,20 +2101,28 @@ hfcsusb_probe(struct usb_interface *intf
 	if (!hw->ctrl_urb) {
 		pr_warn("%s: No memory for control urb\n",
 			driver_info->vend_name);
-		kfree(hw);
-		return -ENOMEM;
+		err = -ENOMEM;
+		goto err_free_hw;
 	}
 
 	pr_info("%s: %s: detected \"%s\" (%s, if=%d alt=%d)\n",
 		hw->name, __func__, driver_info->vend_name,
 		conf_str[small_match], ifnum, alt_used);
 
-	if (setup_instance(hw, dev->dev.parent))
-		return -EIO;
+	if (setup_instance(hw, dev->dev.parent)) {
+		err = -EIO;
+		goto err_free_urb;
+	}
 
 	hw->intf = intf;
 	usb_set_intfdata(hw->intf, hw);
 	return 0;
+
+err_free_urb:
+	usb_free_urb(hw->ctrl_urb);
+err_free_hw:
+	kfree(hw);
+	return err;
 }
 
 /* function called when an active device is removed */


