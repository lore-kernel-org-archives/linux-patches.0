Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED3E523D7FF;
	Wed, 30 Sep 2026 18:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793971; cv=none; b=VTEkcD7pRu5Z7GulykE9ATTOkRadHxsO8jTMX2v+K1no4Wh2V13qE20BoOtDMm207FyEtlc1dhsbWcWeFTxK8yN9x/NjgyTenueKxQD/Quj96CZVo+L8gibbM/HhO0vn2RlNTDMjXni/6N/DqGmbNi2+PXHV+/PaWAXrS+6JZr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793971; c=relaxed/simple;
	bh=/uU/zNXZLP9VvJwujSyluWlyiFGgCWp4ya7C+fr3/pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rgyEr5n07Y3gaPR1Na8++thK8f0pmczhhW7WMT9ZEkIs3/a+Y3ZEpXmG7r5hF0XbRXK7nuef+9KHfddLK3uYH9bMiTnkKjydfXeEYYlBO1XRMScXdeTK6QPcMX5XplG/XAGlFBCzm6+E3QhQfFpO5do9bFKjSW5Gybs7tTODMKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7kZlRRE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7kZlRRE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2551F000FF;
	Wed, 30 Sep 2026 18:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793969;
	bh=oZJJOqRRmRNJkHRNb0wwlNBnvrxKSH6PYqxSpMqiWL0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j7kZlRREe07OwqtT245ptm31aHpuQKULMGFXDsHwsYdh5gfp1PSTRGSmpOqfvtSD8
	 Gq/m7+wMuL5bMFRnl9tmVVeQf+KLy5mng1fGCODS7H8iXLpaGW+9lJd8JygMelSQWg
	 MHRd1oFI95j2hP6cTlpB+vU/xX7ADkiO917GNILk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0009/1193] usb: gadget: udc: skip pullup() if already connected
Date: Wed, 30 Sep 2026 17:11:33 +0200
Message-ID: <20260930152434.514989253@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit 62911bc82b0332aee7546156800d3516500fa1e1 ]

The device controller may update vbus status via usb_udc_vbus_handler(),
which tries to connect the gadget even though gadget_bind_driver() has
already called usb_udc_connect_control_locked(). This causes pullup() to
be called twice. Avoid this by checking if gadget->connected is true.

This also set gadget->connected as false in usb_gadget_activate() if it
became connected while it was being deactivated. Otherwise,
usb_gadget_connect_locked will return early and pullup() won't be called.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://patch.msgid.link/20260423095355.2673035-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/core.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index a13fbef19c0ad..2ef28760e9ad9 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -714,6 +714,9 @@ static int usb_gadget_connect_locked(struct usb_gadget *gadget)
 		goto out;
 	}
 
+	if (gadget->connected)
+		goto out;
+
 	if (gadget->deactivated || !gadget->udc->allow_connect || !gadget->udc->started) {
 		/*
 		 * If the gadget isn't usable (because it is deactivated,
@@ -887,8 +890,10 @@ int usb_gadget_activate(struct usb_gadget *gadget)
 	 * If gadget has been connected before deactivation, or became connected
 	 * while it was being deactivated, we call usb_gadget_connect().
 	 */
-	if (gadget->connected)
+	if (gadget->connected) {
+		gadget->connected = false;
 		ret = usb_gadget_connect_locked(gadget);
+	}
 
 unlock:
 	mutex_unlock(&gadget->udc->connect_lock);
-- 
2.53.0



