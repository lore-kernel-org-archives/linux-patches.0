Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2854973A6;
	Thu, 17 Sep 2026 16:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660925; cv=none; b=oPgXRfIw4eiO6tqEp5sOg7BsJjtw5+y8hUw3umZj0nRPAC0TLnA/j5bCOY1Y6LJirZmELBi5nwV8BIaRCxeiJifJ5pIHwOxO8Bl/lQdCzej7EE3J3CFAK6VPQ2D96QMJ0BRuKRVsrexuugF+KcEB4FIx/OeTT9nSEDO2R9Q1DlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660925; c=relaxed/simple;
	bh=wVrloVZVId3wV5zb181PAXRy6LSnIN2HZ5LJYXCXsIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRYS3fWdCORr1uKYSf3c8PtVOGJoTOZvLNmOJ2y5JScsH+r5QjDrsS02BAdOqOOwSPdOs4dYDWW9EW0ESvqDa66zdRHn6JOczwitgToJLZFxwRWPuu6UYiBvJQ2DLQ028bd3XvvuYjgpBExVEfh+ba6ub6xAwLMGRV+pRzk5ej4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VhP0CKq5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VhP0CKq5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797671F000FF;
	Thu, 17 Sep 2026 16:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660924;
	bh=1p1YW33catrJbRzUIw5Lmg9K8mTbiz9yhrophMistC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VhP0CKq5ugPhvidU6mCzCw9ciD1jK6ambbN1FZ3lMxDzMnLzGlDRKUiEzbqndbOIv
	 izFTBfsEkobrVdU5SRP9XCJLDbPxYiLQod44PZ+9Kx9hMl77EZvSgvsrJaYLCkZe60
	 u/dw09aH2yHk5UHqQ7QN0hftG71QdIg5drd1Lyi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0023/1250] usb: gadget: udc: skip pullup() if already connected
Date: Thu, 17 Sep 2026 15:56:58 +0100
Message-ID: <20260917151552.557132765@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index ab1bcc5512b2c..fa49746d54036 100644
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



