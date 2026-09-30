Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7D94F796E;
	Wed, 30 Sep 2026 16:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784223; cv=none; b=q5l7YGXoc8Z5whSq+YZhbBFYbqBpN4IzGtCtvx+/RRiIw2c8Nt9Foc4NwdaUwwVfuUpnmL3TMYDi7Ls4Quyz6nNkYrjNhj9W9L80OxmBGBxVEgC/s8owPz73Uz8UYRsYt51L8bJ++uZTcjcbeXxTGdViSCppa6wmaBYniMezFfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784223; c=relaxed/simple;
	bh=xmur5MSj3jjTId8NTu8vgJzubyYkpXDGdHC9ufYORTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EJnJbheWgaio2Pw9zTwz3+JwLG5b8xCQHay4lTav0T7vIInk/XJZ8+uz+L5XuVQvIJX8n1rpXpI7JmMMpsyfICa4fqVD4RlCrQrUbdIBvPDI/4pqa3CdOHjIa8AMRkH9ePwUOQgezJ6+BXX4+6JaMfhOC1VFJg7NDCwtBVIAcHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RE/dzkua; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RE/dzkua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DDF1F00898;
	Wed, 30 Sep 2026 16:03:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784218;
	bh=V0H94WaiDU58kRqrjjFb15HCR5gS4vQmxe3Vcc54tpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RE/dzkuaIdZEuGNQlPN7yHUCHzY60acvd6sXGK1o068QXexKJw/0I3/16JSoXpkGz
	 xlmCpmoaPjsJ7KKRfh6RSLBQniL9hcmdB+roRjZubba0oT0rg56OJsdREgW8YmGmpt
	 QDkzBv1VlOXRQigGXGh3mTI+NhdeW2b7GshXSD/8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Carey <carvsdriver@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/982] USB: cdc-acm: start bulk-IN polling when ALWAYS_POLL_CTRL is set
Date: Wed, 30 Sep 2026 17:13:35 +0200
Message-ID: <20260930152418.505519023@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d1c8f620596d8..9ff5feceadad4 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -786,6 +786,9 @@ static void acm_port_shutdown(struct tty_port *port)
 				"ctrl polling restart failed after port close\n");
 		/* port_shutdown() cleared DTR/RTS; restore them */
 		acm_set_control(acm, USB_CDC_CTRL_DTR | USB_CDC_CTRL_RTS);
+		if (acm_submit_read_urbs(acm, GFP_KERNEL))
+			dev_dbg(&acm->control->dev,
+				"read urb restart failed after port close\n");
 	}
 }
 
@@ -1539,6 +1542,9 @@ static int acm_probe(struct usb_interface *intf,
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



