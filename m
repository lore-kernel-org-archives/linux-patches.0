Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B8097E
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 15:07:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6295C433EF;
	Sun, 22 Jan 2023 15:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674400074;
	bh=8/pCthJrNJrVyJX/tgThM8NDME8TgLNris9k8uM+b/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ffnfsm0M1uUw2tc6LY8gv8Zh5bfsCN8Os7NESivvI3YWryENNGDHtJsGHkgOK+lX3
	 oKbRtdjGEy4FOdboXp9wKCfrGIH6Jj3bEJgBvwYHhqOjs++Q+dkVEhV8AriQRtt/Ff
	 /Z3dRe7lXtmUCABQUjp2/Tkfm3gsczkN+Pk8/mHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Hongling Zeng <zenghongling@kylinos.cn>,
	Juhyung Park <qkrwngud825@gmail.com>,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 4.19 29/37] usb-storage: apply IGNORE_UAS only for HIKSEMI MD202 on RTL9210
Date: Sun, 22 Jan 2023 16:04:26 +0100
Message-Id: <20230122150220.760612334@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150219.557984692@linuxfoundation.org>
References: <20230122150219.557984692@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Juhyung Park <qkrwngud825@gmail.com>

commit dbd24ec17b85b45f4e823d1aa5607721920f2b05 upstream.

The commit e00b488e813f ("usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS")
blacklists UAS for all of RTL9210 enclosures.

The RTL9210 controller was advertised with UAS since its release back in
2019 and was shipped with a lot of enclosure products with different
firmware combinations.

Blacklist UAS only for HIKSEMI MD202.

This should hopefully be replaced with more robust method than just
comparing strings.  But with limited information [1] provided thus far
(dmesg when the device is plugged in, which includes manufacturer and
product, but no lsusb -v to compare against), this is the best we can do
for now.

[1] https://lore.kernel.org/all/20230109115550.71688-1-qkrwngud825@gmail.com

Fixes: e00b488e813f ("usb-storage: Add Hiksemi USB3-FW to IGNORE_UAS")
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Hongling Zeng <zenghongling@kylinos.cn>
Cc: stable@vger.kernel.org
Signed-off-by: Juhyung Park <qkrwngud825@gmail.com>
Acked-by: Oliver Neukum <oneukum@suse.com>
Link: https://lore.kernel.org/r/20230117085154.123301-1-qkrwngud825@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/uas-detect.h  |   13 +++++++++++++
 drivers/usb/storage/unusual_uas.h |    7 -------
 2 files changed, 13 insertions(+), 7 deletions(-)

--- a/drivers/usb/storage/uas-detect.h
+++ b/drivers/usb/storage/uas-detect.h
@@ -116,6 +116,19 @@ static int uas_use_uas_driver(struct usb
 	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bc2)
 		flags |= US_FL_NO_ATA_1X;
 
+	/*
+	 * RTL9210-based enclosure from HIKSEMI, MD202 reportedly have issues
+	 * with UAS.  This isn't distinguishable with just idVendor and
+	 * idProduct, use manufacturer and product too.
+	 *
+	 * Reported-by: Hongling Zeng <zenghongling@kylinos.cn>
+	 */
+	if (le16_to_cpu(udev->descriptor.idVendor) == 0x0bda &&
+			le16_to_cpu(udev->descriptor.idProduct) == 0x9210 &&
+			(udev->manufacturer && !strcmp(udev->manufacturer, "HIKSEMI")) &&
+			(udev->product && !strcmp(udev->product, "MD202")))
+		flags |= US_FL_IGNORE_UAS;
+
 	usb_stor_adjust_quirks(udev, &flags);
 
 	if (flags & US_FL_IGNORE_UAS) {
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -83,13 +83,6 @@ UNUSUAL_DEV(0x0bc2, 0x331a, 0x0000, 0x99
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_LUNS),
 
-/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
-UNUSUAL_DEV(0x0bda, 0x9210, 0x0000, 0x9999,
-		"Hiksemi",
-		"External HDD",
-		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_IGNORE_UAS),
-
 /* Reported-by: Benjamin Tissoires <benjamin.tissoires@redhat.com> */
 UNUSUAL_DEV(0x13fd, 0x3940, 0x0000, 0x9999,
 		"Initio Corporation",


