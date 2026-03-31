Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 823573E316C;
	Tue, 31 Mar 2026 16:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974299; cv=none; b=qQtwUdUTp1Y05wewRNacVub/L2oiaAjCvO/Zw1KFxnaBhi16u7RQgcrfqgR31lKjM/lO/ByjI8hKroVEv9XOyspoXdBUVN3OTvtHuXD/4hwXtfg7bZFIgubeti3WcD/fwxQ+G++iDkEDv+9omY8Dlc8SQ8ipVs/+ecuQE4De89k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974299; c=relaxed/simple;
	bh=wW746/M8dzojgF04kuor+2Hr80sBEfslfAFTEDvicVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6kQ1W5N9llJC22dj+PQ0laY6yGMBWwwOmZhrfjj51Ht+IWS6NgTRoCncshLWmWtcjWjjRHaiR+PHogLmXqmLJdeqfX+Gaw9vbH/sdfeiQt4OWS6XLknMWKUw6DnkaNDaf5IByjEMO+H4qDMlbeb/DgoF5noWtPdzWlx4HyFSVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u67MncYn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u67MncYn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199C5C19423;
	Tue, 31 Mar 2026 16:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974299;
	bh=wW746/M8dzojgF04kuor+2Hr80sBEfslfAFTEDvicVQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u67MncYnTjq4zBizvKoewkiTHdLC33fJMmOMx/cjf8/T234juHpE4RceJshcNAfDX
	 KZ8UwPx26Q7riikLAwA6kDPGABDnO6yMEXh/w96XPQ/eNCfYkcdFrSgaTyYHQdyRM2
	 I7MwhBpOK1fcBXiDp8puAzbl3umafxZKuvbS9lTk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jie Deng <dengjie03@kylinos.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 031/175] usb: core: new quirk to handle devices with zero configurations
Date: Tue, 31 Mar 2026 18:20:15 +0200
Message-ID: <20260331161730.930494804@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Jie Deng <dengjie03@kylinos.cn>

[ Upstream commit 9f6a983cfa22ac662c86e60816d3a357d4b551e9 ]

Some USB devices incorrectly report bNumConfigurations as 0 in their
device descriptor, which causes the USB core to reject them during
enumeration.
logs:
usb 1-2: device descriptor read/64, error -71
usb 1-2: no configurations
usb 1-2: can't read configurations, error -22

However, these devices actually work correctly when
treated as having a single configuration.

Add a new quirk USB_QUIRK_FORCE_ONE_CONFIG to handle such devices.
When this quirk is set, assume the device has 1 configuration instead
of failing with -EINVAL.

This quirk is applied to the device with VID:PID 5131:2007 which
exhibits this behavior.

Signed-off-by: Jie Deng <dengjie03@kylinos.cn>
Link: https://patch.msgid.link/20260227084931.1527461-1-dengjie03@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt | 3 +++
 drivers/usb/core/config.c                       | 6 +++++-
 drivers/usb/core/quirks.c                       | 5 +++++
 include/linux/usb/quirks.h                      | 3 +++
 4 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index fff3ca50c6c26..fdbc2749fbb37 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -6901,6 +6901,9 @@
 				p = USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT
 					(Reduce timeout of the SET_ADDRESS
 					request from 5000 ms to 500 ms);
+				q = USB_QUIRK_FORCE_ONE_CONFIG (Device
+					claims zero configurations,
+					forcing to 1);
 			Example: quirks=0781:5580:bk,0a5c:5834:gij
 
 	usbhid.mousepoll=
diff --git a/drivers/usb/core/config.c b/drivers/usb/core/config.c
index 10a1bc059ea1f..9cd263b6cdee8 100644
--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -891,7 +891,11 @@ int usb_get_configuration(struct usb_device *dev)
 		dev->descriptor.bNumConfigurations = ncfg = USB_MAXCONFIG;
 	}
 
-	if (ncfg < 1) {
+	if (ncfg < 1 && dev->quirks & USB_QUIRK_FORCE_ONE_CONFIG) {
+		dev_info(ddev, "Device claims zero configurations, forcing to 1\n");
+		dev->descriptor.bNumConfigurations = 1;
+		ncfg = 1;
+	} else if (ncfg < 1) {
 		dev_err(ddev, "no configurations\n");
 		return -EINVAL;
 	}
diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index c12942a533ce2..53b08d6cf7824 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -141,6 +141,8 @@ static int quirks_param_set(const char *value, const struct kernel_param *kp)
 			case 'p':
 				flags |= USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT;
 				break;
+			case 'q':
+				flags |= USB_QUIRK_FORCE_ONE_CONFIG;
 			/* Ignore unrecognized flag characters */
 			}
 		}
@@ -594,6 +596,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	/* VCOM device */
 	{ USB_DEVICE(0x4296, 0x7570), .driver_info = USB_QUIRK_CONFIG_INTF_STRINGS },
 
+	/* Noji-MCS SmartCard Reader */
+	{ USB_DEVICE(0x5131, 0x2007), .driver_info = USB_QUIRK_FORCE_ONE_CONFIG },
+
 	/* INTEL VALUE SSD */
 	{ USB_DEVICE(0x8086, 0xf1a5), .driver_info = USB_QUIRK_RESET_RESUME },
 
diff --git a/include/linux/usb/quirks.h b/include/linux/usb/quirks.h
index 2f7bd2fdc6164..b3cc7beab4a3c 100644
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -78,4 +78,7 @@
 /* skip BOS descriptor request */
 #define USB_QUIRK_NO_BOS			BIT(17)
 
+/* Device claims zero configurations, forcing to 1 */
+#define USB_QUIRK_FORCE_ONE_CONFIG		BIT(18)
+
 #endif /* __LINUX_USB_QUIRKS_H */
-- 
2.51.0



