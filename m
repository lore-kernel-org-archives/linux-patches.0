Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B0337B40C;
	Tue, 21 Jul 2026 17:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654906; cv=none; b=knR6c8iUX8SMDd+mPXjbJfGXyNB6b95kqtUNZQnNCCds44e840lJyc6vQPKwideuaqXn9/mFEl6eyDktflMpNEypi5T7XPyh/WVQ6tox86mLLwcordQiD8oipQBYJPprUp4dAq+2Bgu0DwMnY9FCxXjpMR5NgHEY27wU2nQqOWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654906; c=relaxed/simple;
	bh=BPwevMceqHgUzyd5oiGvTYzR9/J1x1Mivd1UpoqRGP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENlKFapS2HeI2ZenRLaPxSekhtDCtZBNESm/0juIEHFh0L744/umTJSrOiOb92YPtNjdhWfEph5cvIMbVeW2bFgzy2MY43oYG1w4qKrN4G0GC+fvSMnqWRTDwmLChe31nYkmd+XuuHDgEb69l4MUkCrBqAZX24/e0rWCWKC5J4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kgRJEJ5/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kgRJEJ5/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D431F000E9;
	Tue, 21 Jul 2026 17:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654904;
	bh=c6oFCSlXmU/YdlQzuCLOfzdGpvjBJ/nMclGS9ToF8KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kgRJEJ5/KHRjvztRSlnk2NPUuD+wyRaadnwRszwfB7SwaT/N1oAR8+TdZGzCTkmq4
	 GxexQJer4iynbDRfp2ApTtQHvyJT7iV3P+3MWFfRQpjIgHF0Hy2kuU9fZuKY2icjUm
	 00tZlM/kqqPcdF8Y7Bh9fr8AHzhwQ20R6gceF6TA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 1881/2077] Input: ims-pcu - only expose sysfs attributes on control interface
Date: Tue, 21 Jul 2026 17:25:54 +0200
Message-ID: <20260721152637.091205410@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1249,6 +1250,9 @@ static umode_t ims_pcu_is_attr_visible(s
 	struct ims_pcu *pcu = usb_get_intfdata(intf);
 	umode_t mode = attr->mode;
 
+	if (intf != pcu->ctrl_intf)
+		return 0;
+
 	if (pcu->bootloader_mode) {
 		if (attr != &dev_attr_update_firmware_status.attr &&
 		    attr != &dev_attr_update_firmware.attr &&
@@ -1488,6 +1492,9 @@ static umode_t ims_pcu_ofn_is_attr_visib
 	struct ims_pcu *pcu = usb_get_intfdata(intf);
 	umode_t mode = attr->mode;
 
+	if (intf != pcu->ctrl_intf)
+		return SYSFS_GROUP_INVISIBLE;
+
 	/*
 	 * PCU-B devices, both GEN_1 and GEN_2 do not have OFN sensor.
 	 */


