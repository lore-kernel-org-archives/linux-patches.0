Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FAA8423A6B;
	Wed,  4 Feb 2026 15:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217553; cv=none; b=Uh5suzaM0z1Qb3UmyS6XKc6ILgnBj/eCFbzXKQI0aAIZDoDioxr6P3VJthBZ3+HzhfG50Lh6aNymOnhrnWXDaAfw5Yj/ijIS1zJh/fR/AoJjZKL78+eU7TO/Pp2LpgNg7RsycEhgLPJ6bUeBm1sgAU4tT4dqUpqD7IwFo/L385Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217553; c=relaxed/simple;
	bh=AwTaZxdNwG4AfAxE7lyau58URsgWlsUwl1pWYceA8WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IgcF0MwuH/htUBMCW+Tv/Kl2eD80SzdKNZ8Ai3HvNpYKiPBzyMMPV4G+BFcLtfSLGO13iI76dpIQ1SrSyM2VnGDtTeJ1ceuMHN5/MGGRTPTpgjcr370i7aXfzG7W1ix9CHYxSze8lPXuSaaIdABefk5jgQn3Wa80nuKd48H9Os8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IsNCMnoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IsNCMnoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3E1BC4CEF7;
	Wed,  4 Feb 2026 15:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217553;
	bh=AwTaZxdNwG4AfAxE7lyau58URsgWlsUwl1pWYceA8WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IsNCMnohH/kwjDUpIl8QPupfHrFwCsRO8PFjnDJRPEdq6CNZ3TM5aHbCV4aOYsJ45
	 ztD/kTVXt+rYKjhOMIrBft8cyVIRbeGiW7X6/79+RYcOx6JoYe9igbJiHiXmW6vCCA
	 exjVXky68UW/lxVvnH4gSCkZ1AYKgcDOCBWXvZz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?Johannes=20Br=C3=BCderl?= <johannes.bruederl@gmail.com>
Subject: [PATCH 6.1 048/280] usb: core: add USB_QUIRK_NO_BOS for devices that hang on BOS descriptor
Date: Wed,  4 Feb 2026 15:37:02 +0100
Message-ID: <20260204143911.365125524@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


