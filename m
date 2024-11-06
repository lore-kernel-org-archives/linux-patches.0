Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F5A1DF73C;
	Wed,  6 Nov 2024 12:22:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895721; cv=none; b=rgk0W4K5g34jkS/MqFmM1OJa0R44FIUqxxcNopu/LLr3zahchxl12lp9XSRGRhvoVovcVy1KPz3kJrnDAUE+VXs2DAwKYFCoOdD17ilLAlqe0fo328hTH6CEbZX5kVTigcrMW7/NXBzPaoiWGSRAj8gc7kfMp4GdSoedoDiyLrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895721; c=relaxed/simple;
	bh=1T+e97zD/mtrkC5E/tpzfuNn0NrjaIEEftGMxh8b8gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TpFnt5BJYnNSk3FrZx7NN20iVjlnTiFfm1bScNhi/gipI8CG/PB4UPbWjb6oPSA7VVam3IbaS8L5uAvwFNrmyiv0pvY6Ze4N8ZIzP4I/KIrZlvy3oGWaxeS/pOT6VgeGbX+76U0zz5ko1xbyaMWZc6BvW5Q2k73yM69B1t3vC3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPlp1vHb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPlp1vHb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D61CBC4CECD;
	Wed,  6 Nov 2024 12:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895721;
	bh=1T+e97zD/mtrkC5E/tpzfuNn0NrjaIEEftGMxh8b8gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPlp1vHb57h/yKiG8OgunzpvXqBdWP9l5hYbQ8tGo6vv09fuNH1H1Z6FXtjORjgMd
	 jfy8UfrxKOGUz6o0ZQI9i7q5MRWPZPIe2BFufQg3ZoXruG+gIxF4O46nw0yg3HO69o
	 vnNO1rfvFU0isOmxFfTL6QYFXyK/kHMIQVi0rFq0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Greg Thelen <gthelen@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	John Sperbeck <jsperbeck@google.com>
Subject: [PATCH 4.19 313/350] net: usb: usbnet: fix name regression
Date: Wed,  6 Nov 2024 13:04:01 +0100
Message-ID: <20241106120328.500586893@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 8a7d12d674ac6f2147c18f36d1e15f1a48060edf ]

The fix for MAC addresses broke detection of the naming convention
because it gave network devices no random MAC before bind()
was called. This means that the check for the local assignment bit
was always negative as the address was zeroed from allocation,
instead of from overwriting the MAC with a unique hardware address.

The correct check for whether bind() has altered the MAC is
done with is_zero_ether_addr

Signed-off-by: Oliver Neukum <oneukum@suse.com>
Reported-by: Greg Thelen <gthelen@google.com>
Diagnosed-by: John Sperbeck <jsperbeck@google.com>
Fixes: bab8eb0dd4cb9 ("usbnet: modern method to get random MAC")
Link: https://patch.msgid.link/20241017071849.389636-1-oneukum@suse.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/usbnet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
index 938335f4738df..ec3a7cea8c8a8 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1746,7 +1746,8 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
 		// can rename the link if it knows better.
 		if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
 		    ((dev->driver_info->flags & FLAG_POINTTOPOINT) == 0 ||
-		     (net->dev_addr [0] & 0x02) == 0))
+		     /* somebody touched it*/
+		     !is_zero_ether_addr(net->dev_addr)))
 			strscpy(net->name, "eth%d", sizeof(net->name));
 		/* WLAN devices should always be named "wlan%d" */
 		if ((dev->driver_info->flags & FLAG_WLAN) != 0)
-- 
2.43.0



