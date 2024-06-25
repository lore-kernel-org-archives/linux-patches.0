Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6501465A8;
	Tue, 25 Jun 2024 09:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308956; cv=none; b=rLHkGTEgZBJ0WnV7bppJCoU9x/UhQIWuAxOi7lbye1u8R1lEglE5vI4fmpTG0OtndCYMRqMjdPkSeD0kPUtj6T3dPMn06z5YgwfNDJjrEYQvVbkHqlR2PlxMV3ZDnkb7nTwFhlGnEJ4oSeXd136QwwIxtHEzlsFaWWDRDGhITU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308956; c=relaxed/simple;
	bh=7P/OO/Bk/HYIlIQG7dHVP3jHvzeAfevMlvIgFg70uMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXmaRvIpKF0TPYP2l/jhDJl0e2CYxYEYKmgXptlVhlBKk9QjiGDcTVfP/VsGZ7dJEJABw3PrMAijyrHKwNwZTAaJb5FNwR8DMyQo2joDeFmRomGujN0/seDdUgn97gmwyog1+o0QmnfQklMaCKd3d96miOfFVpnf9jGc/Ev6jVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZU1asyw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZU1asyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4556DC32781;
	Tue, 25 Jun 2024 09:49:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308956;
	bh=7P/OO/Bk/HYIlIQG7dHVP3jHvzeAfevMlvIgFg70uMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZU1asywCZWZwGZiUfDuiCiYVfMlnbWWj6IzCFvQt+iY5qzPdtAZX1CNTl5WS34eP
	 VS0Y8sMSfAYL0PYdmXk4WiM9FJcuQwy7u6rboOo3w/VBOZnpVetWKcFRZTYiSGYkx6
	 9Uui8LisBtY9aTkH7MXq/pzpXXb4+c3Im59z5Ayc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/192] usb: gadget: uvc: configfs: ensure guid to be valid before set
Date: Tue, 25 Jun 2024 11:31:57 +0200
Message-ID: <20240625085538.898779846@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085537.150087723@linuxfoundation.org>
References: <20240625085537.150087723@linuxfoundation.org>
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

From: Michael Grzeschik <m.grzeschik@pengutronix.de>

[ Upstream commit f7a7f80ccc8df017507e2b1e1dd652361374d25b ]

When setting the guid via configfs it is possible to test if
its value is one of the kernel supported ones by calling
uvc_format_by_guid on it. If the result is NULL, we know the
guid is unsupported and can be ignored.

Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>
Link: https://lore.kernel.org/r/20240221-uvc-gadget-configfs-guid-v1-1-f0678ca62ebb@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/uvc_configfs.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
index d16c04d2961b6..4acf336e946d6 100644
--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -13,6 +13,7 @@
 #include "uvc_configfs.h"
 
 #include <linux/sort.h>
+#include <linux/usb/uvc.h>
 #include <linux/usb/video.h>
 
 /* -----------------------------------------------------------------------------
@@ -2260,6 +2261,8 @@ static ssize_t uvcg_uncompressed_guid_format_store(struct config_item *item,
 	struct f_uvc_opts *opts;
 	struct config_item *opts_item;
 	struct mutex *su_mutex = &ch->fmt.group.cg_subsys->su_mutex;
+	const struct uvc_format_desc *format;
+	u8 tmpguidFormat[sizeof(ch->desc.guidFormat)];
 	int ret;
 
 	mutex_lock(su_mutex); /* for navigating configfs hierarchy */
@@ -2273,7 +2276,16 @@ static ssize_t uvcg_uncompressed_guid_format_store(struct config_item *item,
 		goto end;
 	}
 
-	memcpy(ch->desc.guidFormat, page,
+	memcpy(tmpguidFormat, page,
+	       min(sizeof(tmpguidFormat), len));
+
+	format = uvc_format_by_guid(tmpguidFormat);
+	if (!format) {
+		ret = -EINVAL;
+		goto end;
+	}
+
+	memcpy(ch->desc.guidFormat, tmpguidFormat,
 	       min(sizeof(ch->desc.guidFormat), len));
 	ret = sizeof(ch->desc.guidFormat);
 
-- 
2.43.0



