Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775702D9780;
	Wed, 28 Jan 2026 15:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614174; cv=none; b=p1PvQI4Upgbg+yER+4tMz9euqDy+2BcmzGtBmwOrkc68HzKcI65vbvGApdCmgAYESysPQ5r9Sr+fuU8GUkpZ/WarmKSrkt1TwlVsWBZJpLvxwTKUjydlead4IGYADBQpJor478nUkUkOJgkm14tEGfPtMaG3t5+0JPVOxZeRS9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614174; c=relaxed/simple;
	bh=j/jQdbemDabydDopaczq1GO5VYNdEx4MB8mvUjBxAhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eSM2voNJ8xAr3PkoJDNlq+4tjLMiBQCQvgt8bLLCbRqczXKOp731uap1YmhL/vwa7xon0lpebkw4jbOdCE/0KDZSuHjkzpXO+X3Uwc6fwi399nvxtoI6ilTFd/3bdJZrOpRbFXTucYyKwr8/fS7xROH+bvNRSu78mT03lPS2EQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AEJB2OPy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AEJB2OPy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 908D6C4CEF1;
	Wed, 28 Jan 2026 15:29:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614174;
	bh=j/jQdbemDabydDopaczq1GO5VYNdEx4MB8mvUjBxAhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AEJB2OPymw+CpxMtuHlSpFFij4ZyvRrdJnBM9fhC/9z7FaSkx09QydXPftS4QpLWz
	 liKWdpJl3SvjBSxy8Fs1HYg63qBb2NR3LTHqD49MhW7QMFDYVF8BdsTn539wg856V9
	 Pj7/keeJQNDabs4eJuGxe5VXno3z5rj/ii1AAlwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?Johannes=20Br=C3=BCderl?= <johannes.bruederl@gmail.com>
Subject: [PATCH 6.6 057/254] usb: core: add USB_QUIRK_NO_BOS for devices that hang on BOS descriptor
Date: Wed, 28 Jan 2026 16:20:33 +0100
Message-ID: <20260128145346.751639088@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


