Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764F7376BDD;
	Wed, 21 Jan 2026 18:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019690; cv=none; b=u1YigVB1HN1fh+SuczYin/NT6BDbgMklWN/E1yfmGa9TYgCglVVdBy7/r8K9MzW7sBEaX0thklx9j639kER6zZCons038oE8CN1C/MZIVThOVaU7XCzIdmhZCxwXAl84+QwmkuW+94v1WCNAKPoZbGhKtGlK2msTpaheQj4KAfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019690; c=relaxed/simple;
	bh=1QfUGiX28PEQonO2s4dUKnc1knPpv+lFkLqTB2FznXI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VUAeiQ8q+aNPWQ5ASc2YnUnQAe2QqVTIDBQPtOM95ZB6QTLOz94X9kK53SaFptbtEeoqXcLC2IG3kojlcNBXfaOWJkVHBmGuxrHIWCMi+2KHSkEMeiXXtGutdhaB8zV7d5fmzcSc4v9zMwMa5E1IOua/l5dSJkfBs5is89FgbeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pBLQKTco; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pBLQKTco"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EFBEC4CEF1;
	Wed, 21 Jan 2026 18:21:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019690;
	bh=1QfUGiX28PEQonO2s4dUKnc1knPpv+lFkLqTB2FznXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pBLQKTcoCSDoOe20TArXq9iXTREKLKfTzXA+DQfz7H6/XjBnnV7sck92I7OoOVgdo
	 yjRslfO6lNOfcHBwNtNqVUP3V1EHZg6Yg3698uBcuof5l6LD3aDVG1qZbfj9y/n7gx
	 It0nSNoUkvbdOykmgkX8lhjYTVZBUwkbJC1p66VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?Johannes=20Br=C3=BCderl?= <johannes.bruederl@gmail.com>
Subject: [PATCH 6.12 079/139] usb: core: add USB_QUIRK_NO_BOS for devices that hang on BOS descriptor
Date: Wed, 21 Jan 2026 19:15:27 +0100
Message-ID: <20260121181414.295020273@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Brüderl <johannes.bruederl@gmail.com>

commit 2740ac33c87b3d0dfa022efd6ba04c6261b1abbd upstream.

Add USB_QUIRK_NO_BOS quirk flag to skip requesting the BOS descriptor
for devices that cannot handle it.

Add Elgato 4K X (0fd9:009b) to the quirk table. This device hangs when
the BOS descriptor is requested at SuperSpeed Plus (10Gbps).

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220027
Cc: stable <stable@kernel.org>
Signed-off-by: Johannes Brüderl <johannes.bruederl@gmail.com>
Link: https://patch.msgid.link/20251207090220.14807-1-johannes.bruederl@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/config.c  |    5 +++++
 drivers/usb/core/quirks.c  |    3 +++
 include/linux/usb/quirks.h |    3 +++
 3 files changed, 11 insertions(+)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -1004,6 +1004,11 @@ int usb_get_bos_descriptor(struct usb_de
 	__u8 cap_type;
 	int ret;
 
+	if (dev->quirks & USB_QUIRK_NO_BOS) {
+		dev_dbg(ddev, "skipping BOS descriptor\n");
+		return -ENOMSG;
+	}
+
 	bos = kzalloc(sizeof(*bos), GFP_KERNEL);
 	if (!bos)
 		return -ENOMEM;
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -447,6 +447,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x0c45, 0x7056), .driver_info =
 			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
 
+	/* Elgato 4K X - BOS descriptor fetch hangs at SuperSpeed Plus */
+	{ USB_DEVICE(0x0fd9, 0x009b), .driver_info = USB_QUIRK_NO_BOS },
+
 	/* Sony Xperia XZ1 Compact (lilac) smartphone in fastboot mode */
 	{ USB_DEVICE(0x0fce, 0x0dde), .driver_info = USB_QUIRK_NO_LPM },
 
--- a/include/linux/usb/quirks.h
+++ b/include/linux/usb/quirks.h
@@ -75,4 +75,7 @@
 /* short SET_ADDRESS request timeout */
 #define USB_QUIRK_SHORT_SET_ADDRESS_REQ_TIMEOUT	BIT(16)
 
+/* skip BOS descriptor request */
+#define USB_QUIRK_NO_BOS			BIT(17)
+
 #endif /* __LINUX_USB_QUIRKS_H */


