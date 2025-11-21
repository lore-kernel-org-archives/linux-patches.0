Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE65A26CE33;
	Fri, 21 Nov 2025 13:59:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763733598; cv=none; b=fPrHjpYDe/syV/WRduKr6UuN+y+hs5DoLGosHJgDO+ZySkvE20FQz+xK4W4L1wzMwk0bzojtLkVR7kC0O29XZCeLiX9WXtQ1eN3H0JSIwxJW1jNVx6xJpsxwJw8/V3cDWb8CdmPr4s25p/oJRwu1foew+TckSxUd3xVQI0+lNAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763733598; c=relaxed/simple;
	bh=Avo/IiH+xzlO7mY0ztYF0kilDlxH1bTpkuBvpGjI3mw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+woDf2FfV8dYbfTaSg3lzToNi9Zt5Q2IinlNBWLnAqCLBRCdLccDy0jZXnCYi3hXRMe3SFA8SAwuJHuI6m9S2c3O+7sZQ93Zc6wNx9R+IO1X8SL/BZm3pZmYbELe4fgaDwEgR7M+i6mnETBHS9W5IAN48UIltBxwEwrEPLk268=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYK7mJ+b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYK7mJ+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 782C6C4CEF1;
	Fri, 21 Nov 2025 13:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763733597;
	bh=Avo/IiH+xzlO7mY0ztYF0kilDlxH1bTpkuBvpGjI3mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYK7mJ+budB+xCmagvByqIxA16znjXm/xEXwYkXsKnDIKtmxurptDvZP030uA+CAc
	 /+osRv0a68FvQDwRSPhuXJhlyxf0I2Hnv5vPWxTMtzFlTH2F8dj0oIgZCaDFBL1z99
	 dIZXSCs2a8gghUFqbtUPvrdZf9jXGN3EQIKVpSvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 522/529] isdn: mISDN: hfcsusb: fix memory leak in hfcsusb_probe()
Date: Fri, 21 Nov 2025 14:13:41 +0100
Message-ID: <20251121130249.619343348@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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
@@ -1903,13 +1903,13 @@ out:
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
@@ -2100,20 +2100,28 @@ hfcsusb_probe(struct usb_interface *intf
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


