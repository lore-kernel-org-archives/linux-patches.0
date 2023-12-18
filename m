Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 330F51D14D;
	Mon, 18 Dec 2023 13:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f6I1uvok"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB90FC433C7;
	Mon, 18 Dec 2023 13:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702907945;
	bh=u71E72QOnMHplzd+BmnNdmzhDTTsIHjHTISDXT8CfNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f6I1uvokVNuGmwOOyYfr/PQP6S/1+WEwenzODWtWJiX9992rcCKkoGfBjIQNCA2kx
	 geDusK9RxiuU6//aq9ifiJTxpbdC532StVB3oK4thgIHVV6a3rFjPJ5bQidLdO757z
	 hWJe6IwlRh992kL2lQ7KXxRsPbf3rp+owouEpa54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hayes Wang <hayeswang@realtek.com>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.1 104/106] r8152: avoid to change cfg for all devices
Date: Mon, 18 Dec 2023 14:51:58 +0100
Message-ID: <20231218135059.509970487@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135055.005497074@linuxfoundation.org>
References: <20231218135055.005497074@linuxfoundation.org>
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

From: Hayes Wang <hayeswang@realtek.com>

commit 0d4cda805a183bbe523f2407edb5c14ade50b841 upstream.

The rtl8152_cfgselector_probe() should set the USB configuration to the
vendor mode only for the devices which the driver (r8152) supports.
Otherwise, no driver would be used for such devices.

Fixes: ec51fbd1b8a2 ("r8152: add USB device driver for config selection")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/r8152.c |   20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -9556,9 +9556,8 @@ static int rtl_fw_init(struct r8152 *tp)
 	return 0;
 }
 
-u8 rtl8152_get_version(struct usb_interface *intf)
+static u8 __rtl_get_hw_ver(struct usb_device *udev)
 {
-	struct usb_device *udev = interface_to_usbdev(intf);
 	u32 ocp_data = 0;
 	__le32 *tmp;
 	u8 version;
@@ -9628,10 +9627,19 @@ u8 rtl8152_get_version(struct usb_interf
 		break;
 	default:
 		version = RTL_VER_UNKNOWN;
-		dev_info(&intf->dev, "Unknown version 0x%04x\n", ocp_data);
+		dev_info(&udev->dev, "Unknown version 0x%04x\n", ocp_data);
 		break;
 	}
 
+	return version;
+}
+
+u8 rtl8152_get_version(struct usb_interface *intf)
+{
+	u8 version;
+
+	version = __rtl_get_hw_ver(interface_to_usbdev(intf));
+
 	dev_dbg(&intf->dev, "Detected version 0x%04x\n", version);
 
 	return version;
@@ -9933,6 +9941,12 @@ static int rtl8152_cfgselector_probe(str
 	struct usb_host_config *c;
 	int i, num_configs;
 
+	/* Switch the device to vendor mode, if and only if the vendor mode
+	 * driver supports it.
+	 */
+	if (__rtl_get_hw_ver(udev) == RTL_VER_UNKNOWN)
+		return 0;
+
 	/* The vendor mode is not always config #1, so to find it out. */
 	c = udev->config;
 	num_configs = udev->descriptor.bNumConfigurations;


