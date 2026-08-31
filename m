Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D5A4B66D0;
	Mon, 31 Aug 2026 13:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184395; cv=none; b=h4fW35iPrxGDt19+ZzKz1e8l50un7f/J9BdjQ/BCkrjUNK33+/6EElV0DQ084QA8JES44+vQh2tDifIofIugzQtF0G7dJE7CkWG1wo2nTi4X/Rpf9gocB1iBXpNvH2sc9/Kb+XW+3eSZCLcnS77nBQhOXj9hdFpyCxmC6HZWTms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184395; c=relaxed/simple;
	bh=QIxLzACIhRWP7TK4g7qqK/k88tSiD3OPOjfg2RPFDRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iIbkBso76HuLc86R1g54V0FZZau0BAz0+L8JrJMU6Y/hQDTPJwhS5SeKZaueveRo9TxXZZWGDy8mxqLx0epRFI5/uPePFWahll8YGgdp0uOgcIQQVr0BDZx6Dueh6w1TKcmru2fLiy0QKik25bhammh0Yt/wceyO9pOGLIaVcVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bu9gjt2q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bu9gjt2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6A91F000E9;
	Mon, 31 Aug 2026 13:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184394;
	bh=hhKO7zlJEqK/v2ScgwMAgP+hA4WytJ297GrQsVwpAQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bu9gjt2qunY9uguXZKHSoEkOlYLJ0NpG0lESRCEQul6pqFV+0HUP15KKBw3GOAter
	 RKYehftkpd7/fqezwQ1gBcqpMSsA1R046/tivLbsvrvnUKxceq4kJYSskJCevB3Je7
	 GYmXEhUSPIqsodL4UiRvojmWdfkIOMsnINqHu5ac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Griffin Kroah-Hartman <griffin@kroah.com>
Subject: [PATCH 6.12 91/99] usb: core: Add lock to usb_wakeup_notification()
Date: Mon, 31 Aug 2026 15:35:00 +0200
Message-ID: <20260831133404.304516844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -756,10 +756,12 @@ void usb_wakeup_notification(struct usb_
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
@@ -769,6 +771,7 @@ void usb_wakeup_notification(struct usb_
 		set_bit(portnum, hub->wakeup_bits);
 		kick_hub_wq(hub);
 	}
+	spin_unlock_irqrestore(&device_state_lock, flags);
 }
 EXPORT_SYMBOL_GPL(usb_wakeup_notification);
 


