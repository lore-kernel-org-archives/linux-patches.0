Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB2141735B;
	Tue, 21 Jul 2026 19:59:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663973; cv=none; b=kdrt30KwfgZkTVkstBzhBq52VS7xF7vqGODp5mA/9kZUgkhWm5jCnsvcrzxONZxkWgdOQICQAZ2jxh4337jRQ98C93qnA/1dUa9cy4dDRFYizW45M4JNSFBlKHbqYTDBoYeJ6mQV0uNvKXt6Iuyf99EnumqrphP5RpCinFxMwps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663973; c=relaxed/simple;
	bh=N9rXPN0ETWhRIrBTBr8mX+F5nQPKazbfmSB6yOlNs1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uH4Pm3tTOAefX+DN53+20etYhV7ufpxrFDgrqmJC7Qf7Jnygtphqf/fJXj3zbuVZEFHavWj6oMli7TsFUU2tbGWDyKjuEz2R1oOfsj5yh5Pq5NT/Oa3eGbWeMwLXeEylH96nhzd/C5Q+heXn3yG3H8thesep3PCP6CnK5bx2BgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tRWMPJTV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tRWMPJTV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C1011F000E9;
	Tue, 21 Jul 2026 19:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663972;
	bh=rFVWAnIT6vVLcKprBqeClEv6AQE8fbtsKjUU0m4QJ3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tRWMPJTV+vGkr1rrdN64L/VssVJ5twoumF8MS4Hoiqw+tfYwoEWU1LQpB2+8zBfrx
	 GWi5q3GqVzMo/bM8bsY8d68T69ImLT8iL753vQxYJlN1SZLDY+lqvk76u5fy26Ia3k
	 HU2wLP6x38hNFM6L+t//+vKLBQmfRGHzxPbJc6Mo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 1026/1276] Input: ims-pcu - only expose sysfs attributes on control interface
Date: Tue, 21 Jul 2026 17:24:29 +0200
Message-ID: <20260721152508.955894072@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 001428ea4d2c371107cb984108e266adf99f1f1e upstream.

When the driver was converted to use the driver core to instantiate device
attributes (via .dev_groups in the usb_driver structure), the attributes
started appearing on all interfaces bound to the driver. Since the ims-pcu
driver manually claims the secondary data interface during probe, the
driver core automatically creates the sysfs attributes for that interface
as well.

However, the driver only supports these attributes on the primary control
interface. Data interfaces lack the necessary descriptors and internal
state to handle these requests, and accessing them can lead to unexpected
behavior or crashes.

Fix this by updating the is_visible() callbacks for both the main and OFN
attribute groups to verify that the interface being accessed is indeed the
control interface.

Fixes: 204d18a7a0c6 ("Input: ims-pcu - use driver core to instantiate device attributes")
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/ahp23lj4_vXIeUBl@google.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -14,6 +14,7 @@
 #include <linux/leds.h>
 #include <linux/module.h>
 #include <linux/slab.h>
+#include <linux/sysfs.h>
 #include <linux/types.h>
 #include <linux/usb/input.h>
 #include <linux/usb/cdc.h>
@@ -1229,6 +1230,9 @@ static umode_t ims_pcu_is_attr_visible(s
 	struct ims_pcu *pcu = usb_get_intfdata(intf);
 	umode_t mode = attr->mode;
 
+	if (intf != pcu->ctrl_intf)
+		return 0;
+
 	if (pcu->bootloader_mode) {
 		if (attr != &dev_attr_update_firmware_status.attr &&
 		    attr != &dev_attr_update_firmware.attr &&
@@ -1468,6 +1472,9 @@ static umode_t ims_pcu_ofn_is_attr_visib
 	struct ims_pcu *pcu = usb_get_intfdata(intf);
 	umode_t mode = attr->mode;
 
+	if (intf != pcu->ctrl_intf)
+		return SYSFS_GROUP_INVISIBLE;
+
 	/*
 	 * PCU-B devices, both GEN_1 and GEN_2 do not have OFN sensor.
 	 */


