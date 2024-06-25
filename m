Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2583913D62A;
	Tue, 25 Jun 2024 09:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308377; cv=none; b=Now8SLCQmc/bv0QpKeUxXMaduOHbxfXbvwfr45TQbbIHmHyyecaiFd3XW6VFPuB+IX4JsJgFh9/Rsgzq5k8pzLjHJKtfl/lklR01c1LatiL4FGis0p+tfBVyzscwhUi1ehfXzWr2qui2eDEUFM7G3jlFq+Rl4X51rqQusZZrdZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308377; c=relaxed/simple;
	bh=nb692jtPkD2cDLBlh1eCUeu8bM0Esd1WO/tmEHl1Ncc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ih0uVq65b01QwILSTCNP/u3DEcc0SAy+xt7A23ypNP2XZgTdo6ess+ahzBphkv/a3/n+lTgO+Sd1VmQnZ5k/JapuZzHBdFLIu/gs95fpXXVz9p/sVpAWQUl9PQTkOjCBo/c7vs4kvkpMWZHv6mmW8V+Duj1mac3u5RSFe7vZb1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LBeZeZzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LBeZeZzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4EFC32781;
	Tue, 25 Jun 2024 09:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308377;
	bh=nb692jtPkD2cDLBlh1eCUeu8bM0Esd1WO/tmEHl1Ncc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LBeZeZzAhu0CUHbQD34xxOwjcocQ7tZ5TL/9IfGrCB4VORflZr/qTA7f3dv/2KwZs
	 5iATbR3F0kCWaWRrEHr/9+4ZMDCwNdlf1i2ZQ2AOPHmHQD0lZDluOb4fQfbktWPaeb
	 YvNBOBXsmzu0QZsLdul8HIcYBxWnVlDnDIOF1AlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Grzeschik <m.grzeschik@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 070/250] usb: gadget: uvc: configfs: ensure guid to be valid before set
Date: Tue, 25 Jun 2024 11:30:28 +0200
Message-ID: <20240625085550.752660335@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
index a4377df612f51..6fac696ea8463 100644
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



