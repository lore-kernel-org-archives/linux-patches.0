Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3FA442586B;
	Mon, 31 Aug 2026 13:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184658; cv=none; b=PYhYG+1yLfUN8saoWD6kXfHQDFd5xQH0Rx2PIggHTn9sWiYcaos2B3HKHWG87M+zNzus2p5OAnrIoJpI15Osfo8ACOF2SFo52GNJm3Iv82rLxB0GjG9Yc8qNVnZnqrU0WO8RFVjzBg+nCb3Mm4UmoXmAHFJYX8ZtFnSKxTebNjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184658; c=relaxed/simple;
	bh=FOb5EZu5HrY8bQoLuBonk5GM5W0gyXRnXDESLQ4iITk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SNxAc6J302tDL07l8ex82FYo9il/7SEcGIulk94aYTe3i7u8Lg4y2S/+hbnNgSy2xSOEdBFxGQRX83OLk5xJjT+BAmLIRXFNX3Mdt2U+M72HQTcxX7PUZeZ/XRteinatzPkha2EzOUCN5USz3xUy0LAiKb1slgLlNIwAlqvF2Pk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uu2Yum6I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uu2Yum6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08D401F000E9;
	Mon, 31 Aug 2026 13:57:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184657;
	bh=TXUeJe3axn8SfYNniFH4equXfE0Zt4Xci1URwni33BA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uu2Yum6Iyyxi+V+uOyPcr3eXEsvRih5yymjJOt6w9f3d9rgWUMpUcGLaURAB30FWV
	 6wVO7e2PZv7MxtppPk8EGziWqeGBhQRRUvjlFT2iqnqGDyPmvqhWFbnwFOls2PRe/W
	 N+zRtIH6cEgac885GY0Ct7d5JVTiWx41UokJ1uhc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.6 84/91] usb: core: Add lock to usb_wakeup_notification()
Date: Mon, 31 Aug 2026 15:35:12 +0200
Message-ID: <20260831133403.885927638@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.468089036@linuxfoundation.org>
References: <20260831133359.468089036@linuxfoundation.org>
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
@@ -727,10 +727,12 @@ void usb_wakeup_notification(struct usb_
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
@@ -740,6 +742,7 @@ void usb_wakeup_notification(struct usb_
 		set_bit(portnum, hub->wakeup_bits);
 		kick_hub_wq(hub);
 	}
+	spin_unlock_irqrestore(&device_state_lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_wakeup_notification);
 


