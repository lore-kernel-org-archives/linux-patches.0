Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 020B08837;
	Mon, 28 Oct 2024 06:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098290; cv=none; b=UGBGo3z8IhWNxPUJe06ced2hTbpRTd4V7VMuK4wcp5vJitXZqyAbCFy/P/R8cN3QTMqDbN3NRhypSghHHA6GQl2GcRnVcFpY/tkq8hNikuB79HA8talmoWpYwrUCrUsCs6V6lYNhtpb7Pz2YM4cCRhdt2AY7/ov0JkRfKB+d10k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098290; c=relaxed/simple;
	bh=25xlZlWWnyoq4vWPVhzwjx0UGkGsdLW8dtrafMcoyms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cGo6z2FKm+gWP4XJWq5dunTWOGvAqBu/yxhaMpgrjKeQk677Pngxq2GunpU4nReE1uvEpbaMTTOIpUEDGjmeOYz4s8Lbehwq92Iu6wO930chKzd8AI961/lynNLKPVEbEMALibw00knHsHLHw7PjTPuNb4t0sUAENVrjsO23zyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FBtY205h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FBtY205h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E39C4CEC3;
	Mon, 28 Oct 2024 06:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098289;
	bh=25xlZlWWnyoq4vWPVhzwjx0UGkGsdLW8dtrafMcoyms=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FBtY205hcEZQfzShZkM0NQfNIIGhnVuR80YSVvGHpQWvkpPv4USSKVvZxzzOXZUnQ
	 uCIWT4pqrXOueJ9yPHzKW9DYWiQvtZ1g48HV/bv2KjvV6+tsypbKbaXl5zChTFO227
	 0geTvghPyb/yZsJ14clkr0mjv3Fcf1P4mE40dFjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Greg Thelen <gthelen@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	John Sperbeck <jsperbeck@google.com>
Subject: [PATCH 6.11 161/261] net: usb: usbnet: fix name regression
Date: Mon, 28 Oct 2024 07:25:03 +0100
Message-ID: <20241028062316.041730542@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index ee1b5fd7b4919..44179f4e807fc 100644
--- a/drivers/net/usb/usbnet.c
+++ b/drivers/net/usb/usbnet.c
@@ -1767,7 +1767,8 @@ usbnet_probe (struct usb_interface *udev, const struct usb_device_id *prod)
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



