Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F16838910F;
	Tue, 21 Jul 2026 18:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659055; cv=none; b=LKPQfG0K/AMy7vCPLkOuMUHaiOx2pSaisx7QYnhe0yjJUHWaHbwhhWrrl32+Kz3VfHjD1o8Xt4/X7auckF+ODiejcRMqG8zL0vs/kmn+/lMwUSIb75WdM90ZOcLRLqIIsNVvkDaN8KHZhKzTA0qZ+FjRdkBnEV/YNwPJ+IPFw8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659055; c=relaxed/simple;
	bh=8n4rRWSImA1UZ4Hym4FFIX9uA7EiUoyWhxk/8GYehTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWfGaPHkMPsruC1C0ZOMa6QDHxoF7VrMR+kCtSP8oA7pA1bUjQYlqaRWFIqAcSt9I5rfyg6b/Xbptt3hgza7eqrActyZw8MumcxbE+TaymYG7NbabQdO6rGpcqIuKTOaRu1S2y5oFjO0zNjOFMA8K9qbITZQ5zQVjh4ze+K/QVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0k2lMuEf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0k2lMuEf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFEF31F000E9;
	Tue, 21 Jul 2026 18:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659054;
	bh=RisLRdeGC157hTx1YYCiaVQoXo6ucKP3VUklpSqqr3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0k2lMuEfEgbsww7WokBBMcbl17FWGEelHKmsPnRXjCBZ2BPSjstgoZgXQ0gaqg9rv
	 bGY+H8L6/8orX5F8RIqcsSvpR/ojMlov8YsB/RAQey9RjVOK5VaUAsEG0HNsJsPrhV
	 HoYE5pxq8WKT2ZnN4MFuz5d2x3hYskH1TM3tg8+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.18 1375/1611] Input: ims-pcu - only expose sysfs attributes on control interface
Date: Tue, 21 Jul 2026 17:24:51 +0200
Message-ID: <20260721152546.373960427@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


