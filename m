Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90371A7056;
	Thu, 15 Aug 2024 14:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731010; cv=none; b=P9p1micishlfmgrEfKFD6MwxI9zlbbJY/QA+qffVbQtnH9LlaII+3gnYD7YYbmmjhdoAo3x37ZHyJOdDAqIyI5ezFtRBGF9NUODm5SuEB/+2DMV1s+viQlZKKP878OnkdrnQ6hakOqr+yc/aDQ1XN9vrLIXlEiPIB5jFSqc/uBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731010; c=relaxed/simple;
	bh=QGDEwYSXEJfdjZ5I8Mda29Agntp3MXRW0vsRHuFm4/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/XdlrAX9z8UspS+VoEiAE8rg8RJ86MAGgEnqEkzHNnvQRDdUpgaBLEhoQ0pRxCbtLwq1vlfrWmCEXxe74EA/JaszKoG0RSgOe8XG/RvU+UIbir4NBca6D235dUMZ596AQqQZbp18iUiWkEYLIqnsPxXVZhCD25cR0buYlCFi4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QnMsgxaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QnMsgxaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33356C32786;
	Thu, 15 Aug 2024 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731010;
	bh=QGDEwYSXEJfdjZ5I8Mda29Agntp3MXRW0vsRHuFm4/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QnMsgxaCNngnR2RyqwS3fncem9QFYUAMIyyzavNtLNZ0nmV/Sssz96bdFVhS1jJP6
	 CxgkoQLEtvKQ5dvkZm9H2GoYurXl4sk2zPXCzu3gyd7gJ+a/CPHx3GWgqxFSMDmmHa
	 81Tq/ODzdJl8Z+KIelW1Rtmp8BFk6Xl2/wq6uilY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacopo Radice <jacopo.radice@outlook.com>,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 63/67] Revert "Input: bcm5974 - check endpoint type before starting traffic"
Date: Thu, 15 Aug 2024 15:26:17 +0200
Message-ID: <20240815131840.718224334@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131838.311442229@linuxfoundation.org>
References: <20240815131838.311442229@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 7105e92c60c9cc4112c782d69c172e96b69a43dc upstream.

This patch intended to fix an well-knonw issue in old drivers where the
endpoint type is taken for granted, which is often triggered by fuzzers.

That was the case for this driver [1], and although the fix seems to be
correct, it uncovered another issue that leads to a regression [2], if
the endpoints of the current interface are checked.

The driver makes use of endpoints that belong to a different interface
rather than the one it binds (it binds to the third interface, but also
accesses an endpoint from a different one). The driver should claim the
interfaces it requires, but that is still not the case.

Given that the regression is more severe than the issue found by
syzkaller, the best approach is reverting the patch that causes the
regression, and trying to fix the underlying problem before checking
the endpoint types again.

Note that reverting this patch will probably trigger the syzkaller bug
at some point.

This reverts commit 2b9c3eb32a699acdd4784d6b93743271b4970899.

Link: https://syzkaller.appspot.com/bug?extid=348331f63b034f89b622 [1]
Link: https://lore.kernel.org/linux-input/87sf161jjc.wl-tiwai@suse.de/ [2]

Fixes: 2b9c3eb32a69 ("Input: bcm5974 - check endpoint type before starting traffic")
Reported-by: Jacopo Radice <jacopo.radice@outlook.com>
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1220030
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20240305-revert_bcm5974_ep_check-v3-1-527198cf6499@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/mouse/bcm5974.c |   20 --------------------
 1 file changed, 20 deletions(-)

--- a/drivers/input/mouse/bcm5974.c
+++ b/drivers/input/mouse/bcm5974.c
@@ -19,7 +19,6 @@
  * Copyright (C) 2006	   Nicolas Boichat (nicolas@boichat.ch)
  */
 
-#include "linux/usb.h"
 #include <linux/kernel.h>
 #include <linux/errno.h>
 #include <linux/slab.h>
@@ -194,8 +193,6 @@ enum tp_type {
 
 /* list of device capability bits */
 #define HAS_INTEGRATED_BUTTON	1
-/* maximum number of supported endpoints (currently trackpad and button) */
-#define MAX_ENDPOINTS	2
 
 /* trackpad finger data block size */
 #define FSIZE_TYPE1		(14 * sizeof(__le16))
@@ -894,18 +891,6 @@ static int bcm5974_resume(struct usb_int
 	return error;
 }
 
-static bool bcm5974_check_endpoints(struct usb_interface *iface,
-				    const struct bcm5974_config *cfg)
-{
-	u8 ep_addr[MAX_ENDPOINTS + 1] = {0};
-
-	ep_addr[0] = cfg->tp_ep;
-	if (cfg->tp_type == TYPE1)
-		ep_addr[1] = cfg->bt_ep;
-
-	return usb_check_int_endpoints(iface, ep_addr);
-}
-
 static int bcm5974_probe(struct usb_interface *iface,
 			 const struct usb_device_id *id)
 {
@@ -918,11 +903,6 @@ static int bcm5974_probe(struct usb_inte
 	/* find the product index */
 	cfg = bcm5974_get_config(udev);
 
-	if (!bcm5974_check_endpoints(iface, cfg)) {
-		dev_err(&iface->dev, "Unexpected non-int endpoint\n");
-		return -ENODEV;
-	}
-
 	/* allocate memory for our device state and initialize it */
 	dev = kzalloc(sizeof(struct bcm5974), GFP_KERNEL);
 	input_dev = input_allocate_device();


