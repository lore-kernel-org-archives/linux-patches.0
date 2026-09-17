Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019D24D4876;
	Thu, 17 Sep 2026 17:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667677; cv=none; b=jq6Z7QFmYGk8jPjclthrrbU2D5Fyf8YVITBOQF6RN6BD3lzYtfHDKC4g+CHczzHG09yz1L8orEYUgLqMF4syc2jjWPNDXYOdCQr3bcM6Hity17sZJc4RU+VoJHqdnCabBz+p2DOmC11ByO1niBoqJ1I1eYx/dKyV9dgGxzWYLS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667677; c=relaxed/simple;
	bh=/8c6SQg4i6ZNE+gDnSttZjY/MEt+l2IM6MMg2Q/wjTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9/U5QzZwueddXRt7P0cRRFFjXcCqy5G39e+Bqg5hDJ9U68TZZ9iZfLRb21lX1UnN477F1FnrWzn0+7CNphhZwI4iK0zXXvBZwM+OQRVzV/hHbrB9KDehZHHqMCl5N0xJHhxx5JB3pNrdOPoH9uItjwHgNyHN3ex71R0Cu3DJrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpCq2YmF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpCq2YmF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529E91F000FF;
	Thu, 17 Sep 2026 17:54:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667675;
	bh=LebeLhcLKDU2U0NWWKsBQeHnYbvFa1/+69TmeCV/Q30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fpCq2YmFkuEN7Da7kJvFq/W6iVkZVFWg/tPaJgW+ZGhlSq/pOmJfaPzcvedEoXXI7
	 gs8sZgWgFHQ4oK53dPykCEuraUkqd75zH//btZ7M7WmiH/wp4Hhdd24jzciabVwJTc
	 I84VdE+W7bii9CbmivUUliW1IkN6kyp/he7A3/C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Carey <carvsdriver@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0134/1102] USB: cdc-acm: start bulk-IN polling when ALWAYS_POLL_CTRL is set
Date: Thu, 17 Sep 2026 16:01:17 +0100
Message-ID: <20260917151542.885307727@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Dave Carey <carvsdriver@gmail.com>

[ Upstream commit e5ab27ddd74e2d67a94c51c6f2ad87b1ff13912b ]

The INGENIC 17EF:6161 touchscreen composite device has a ~55-second
watchdog that resets the USB device if the bulk-IN endpoint on the CDC
data interface goes unread.  The existing ALWAYS_POLL_CTRL quirk keeps
the notification endpoint (ctrlurb / EP 0x82) polling continuously, but
that alone is insufficient: the firmware monitors bulk-IN activity, not
just notification-endpoint activity.

Add acm_submit_read_urbs() calls to the two ALWAYS_POLL_CTRL paths that
already restart the ctrlurb:

  1. acm_probe(): start bulk reads at probe time alongside the ctrlurb,
     so the watchdog is satisfied from first bind without requiring a
     userspace process to open /dev/ttyACMn.

  2. acm_port_shutdown(): restart bulk reads after port close alongside
     the ctrlurb restart, so the watchdog keeps running when the last
     TTY user closes the port.

acm_read_bulk_callback() already resubmits each URB unconditionally on
normal completion, so once submitted the reads remain active until an
explicit kill (disconnect, suspend).  acm_submit_read_urb() is a no-op
for URBs that are already in flight (read_urbs_free bit clear), so the
existing acm_port_activate() call remains correct and races are avoided.

Tested on Lenovo Yoga Book 9 14IAH10 (83KJ): without this patch the
device resets every ~55 s when no TTY is open; with it the device
remains stable indefinitely.

Signed-off-by: Dave Carey <carvsdriver@gmail.com>
Link: https://patch.msgid.link/20260515141940.751397-1-carvsdriver@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 12f9fe62199ba..d6a2f1591460a 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -797,6 +797,9 @@ static void acm_port_shutdown(struct tty_port *port)
 				"ctrl polling restart failed after port close\n");
 		/* port_shutdown() cleared DTR/RTS; restore them */
 		acm_set_control(acm, USB_CDC_CTRL_DTR | USB_CDC_CTRL_RTS);
+		if (acm_submit_read_urbs(acm, GFP_KERNEL))
+			dev_dbg(&acm->control->dev,
+				"read urb restart failed after port close\n");
 	}
 }
 
@@ -1564,6 +1567,9 @@ static int acm_probe(struct usb_interface *intf,
 		if (usb_submit_urb(acm->ctrlurb, GFP_KERNEL))
 			dev_warn(&intf->dev,
 				 "failed to start persistent ctrl polling\n");
+		if (acm_submit_read_urbs(acm, GFP_KERNEL))
+			dev_warn(&intf->dev,
+				 "failed to start persistent bulk read polling\n");
 	}
 
 	return 0;
-- 
2.53.0



