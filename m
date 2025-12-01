Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A15DA263C9F;
	Mon,  1 Dec 2025 11:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588842; cv=none; b=eW3sH5scWpWRGT1PUUjQsoWl2izspyUIbIfu7Czwte/25PSuqryEHvs2l9yxP+zJiuPWGFGigPvhc0Z8Ieb+oim+3lz8QKqVVwAkgRKO2CuHoExCxP4WRCnWMP4lH6UY5wJvNpB3yoeS1I5eaIF7hGsX7P7GzRpkVryrvmPo0E4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588842; c=relaxed/simple;
	bh=v0S5Qns7k4zyMc8OKckQj0TB9Lso+i1C9P1mUKJN9gg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=STzHT3dA3sUYBNorrZdR60GoorGtPNBHsmBsZghROQD2yMpzIj0PC/fghvxxoDRQu3FfAoyiqujtHyfdl99pMmKrpTA6o1vEx9HZaQtMDO2jSzolj9b5e44NmPP3eYpdIWXtC5DofWWZ7LMpihMRzotHYl7BjRUZ+HtuF1Z20Ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S/E2tGi6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S/E2tGi6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D97C116D0;
	Mon,  1 Dec 2025 11:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588842;
	bh=v0S5Qns7k4zyMc8OKckQj0TB9Lso+i1C9P1mUKJN9gg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S/E2tGi6L3LqQKBSA6S2fVcpuMGdq5euUX5sk5+hFTk4hEgEPu3K+q736FcusYQIP
	 VFzzoYTZkGTs9+r/gy7XyPBbB1yjA+4e/gFOjZdsuuwd58NOQmgP8RK+Bn3LEyiJjM
	 7EsFXPNdQHWJ/4CQpWY2x5BQZSyNK289IYpavfIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdun Nihaal <nihaal@cse.iitm.ac.in>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.4 158/187] isdn: mISDN: hfcsusb: fix memory leak in hfcsusb_probe()
Date: Mon,  1 Dec 2025 12:24:26 +0100
Message-ID: <20251201112246.923669389@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


