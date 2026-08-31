Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CE1441625;
	Mon, 31 Aug 2026 14:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185275; cv=none; b=AXL9YGtc85gA5XsmJLJ9sqrjHArhV7XxAvWIjdR3E9a7JE43fng0VIKTn6bgjLLdGmlU35lCzxFp4CSLMYqjLFV3/l1zACWbyME4XOPJWe56t7IyUQf5rsxO6J7byUvuXWsjadFqkc2oFgx0g1WmtfKFMtvM95Jo5ZiPHEYL+xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185275; c=relaxed/simple;
	bh=3P62eoKvIA090Zzz7X35e54cRZyrznU8sJu1cb68viI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p2U+LuPldZp0XMDrCsOMDUu7jlIryJdGG02Qs2jbg4CqaeZvFZI/Q7vYtncOQkbAQ3AUi+/UP/a155uw9VzJl9dRlrB1oz+nWHg/ffNG1EBOpsCMv00mSqr17ehzlOpYA3GNaEgkN3mEjfTxNt4fcprWKCLVRJDhrDkyLGjHuWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F3Oj+1oZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F3Oj+1oZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89651F00A3E;
	Mon, 31 Aug 2026 14:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788185274;
	bh=Mv8HyX2oumkDVG2CYdUQ3JSiXX6EzFz2p3yPa3vnVn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F3Oj+1oZDmWd3kUbJwMUr0fNPOoAePkhUNSatif/FHN82/7wzJyYKJZRbzWwP3nyO
	 GRt7g9H97u5RO6lK3J7HYYr7BGiGsqkvVhJCoCjJU6togIBQgk3oA0H3i3S5X2glm8
	 4FWAq3tYBPiZj7I9vZ1ENArMCdpysUMBfUQQAD9A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 5.10 37/43] usb: core: Add lock to usb_wakeup_notification()
Date: Mon, 31 Aug 2026 15:35:45 +0200
Message-ID: <20260831133400.413226431@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.571886287@linuxfoundation.org>
References: <20260831133358.571886287@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -714,10 +714,12 @@ void usb_wakeup_notification(struct usb_
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
@@ -727,6 +729,7 @@ void usb_wakeup_notification(struct usb_
 		set_bit(portnum, hub->wakeup_bits);
 		kick_hub_wq(hub);
 	}
+	spin_unlock_irqrestore(&device_state_lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_wakeup_notification);
 


