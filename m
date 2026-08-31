Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC33556E060;
	Mon, 31 Aug 2026 13:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184112; cv=none; b=TG0R7cjOHqtldwdltCWPkn/CEgmdJEa1vO/HfBTdtONYbDyCatbJ+H6G3C9mI67K8/JxGg0WHbt9iHavZCIc+TKXfu5vo/Iknx37vRMVHk4Yc6fTkdO0aJXb75BiVbfkCeJwEkrT2cyNIavX7Uvw9yb/7RE8Ac77YNpdFQfP88k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184112; c=relaxed/simple;
	bh=COpMlfRJh2ovbJt3GjC2h2PNj6AdC/HPAAzpxbVN7fw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KCkdgvMDV6Ell+temCPQ9qJuaguqi1z8KhoCqLg21mjhMqxUFAONoWm8/okDrUYHqdAIpMHdobj9j8vpzn9APyNg/R0GZAAcE1SB+7G1lK2unZQEWGLdjsPMIM3dDRqQL6Un8X0R/8gWVO1+RCqNG3FqKXtvg5BxQrcsjap9aW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTjp89FR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTjp89FR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 116F31F00A3E;
	Mon, 31 Aug 2026 13:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184110;
	bh=0OR8fxu0XD3qgfKgRomKSggOsQEImH5IiARNSy5EXW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTjp89FRd4IBmU5ZLefFzHMk5cNQlOT6UWbN0r20j0lQh2HUAVy+k1ptAWktyxuEW
	 aGVu/SZcEoGkqIjPcYGVax37lM/wr8iY8yNwi1vVlo0Lh3eliMjpLBcpi5Bt2PNSKb
	 iz6bmKOO8BLDW6v0R9na6MJ/lInJrM8GO1Q9jVvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.18 75/83] usb: core: Add lock to usb_wakeup_notification()
Date: Mon, 31 Aug 2026 15:34:51 +0200
Message-ID: <20260831133403.256454626@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

From: Griffin Kroah-Hartman <griffin@kroah.com>

commit e263e18a9e7b1ff3e7301f0801c6ff87c31adfb6 upstream.

Add a spin lock to usb_wakeup notification to prevent a race condition
with dereferencing freed memory. This could be hit by the xHCI driver as
it calls this function from an IRQ and could race with the
hub_disconnect() function, which properly grabs this lock to protect the
state of the device.

Assisted-by: gkh_clanker_t1000
Signed-off-by: Griffin Kroah-Hartman <griffin@kroah.com>
Link: https://patch.msgid.link/20260713-usb_core_patches_1-v1-3-7721c2b33f53@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -757,10 +757,12 @@ void usb_wakeup_notification(struct usb_
 {
 	struct usb_hub *hub;
 	struct usb_port *port_dev;
+	unsigned long flags;
 
 	if (!hdev)
 		return;
 
+	spin_lock_irqsave(&device_state_lock, flags);
 	hub = usb_hub_to_struct_hub(hdev);
 	if (hub) {
 		port_dev = hub->ports[portnum - 1];
@@ -770,6 +772,7 @@ void usb_wakeup_notification(struct usb_
 		set_bit(portnum, hub->wakeup_bits);
 		kick_hub_wq(hub);
 	}
+	spin_unlock_irqrestore(&device_state_lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_wakeup_notification);
 


