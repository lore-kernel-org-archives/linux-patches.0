Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3B558F087;
	Mon, 31 Aug 2026 13:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184248; cv=none; b=aOo4ngjlTMaXpd1Qy8C6RyVr1ZeR0yasWYq0CnHkASGonySjt7kGB2eWFpCeXr50urUHgAS7WJoyLx5PA7GG5q0Q4qJBOnWY6/Udu3YLllCG2yXwyUjldc4QHBdZAmp48ZWQOfIQilhADEcPsXGqzk0nLwDVLsohQDWrZ9xI37E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184248; c=relaxed/simple;
	bh=J7WNZSZ/JcOLFM3IsJcnvhPDsNGMyl67oiCG50aRsr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cZ1YMGMGZZRdW4ns3ezgOFvZP7ofUuzta6li39sGkFhFMc4NprFmbjXz9fUqlvyIUYWvfiW0Z+iR1ILXK0Z9FVwbWdGKy0Ogxy8q4oB8Z7BZj3SmaOMdpbdN7UBTh9EY72n/isqIF9nbT3R5vxWM7J5UwukfD1XvpbUeUaFxkBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IOdNlE+i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IOdNlE+i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 922A31F00ACA;
	Mon, 31 Aug 2026 13:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788184246;
	bh=IFyAEP2QOMrRqV1RcnVwKCuSaMrGV7VT33VILFQm7GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IOdNlE+iCnDwB9mB7SEf1Au/OtKBckXaFZKf/zb2wjZulNjwVh+Jgp9Fv4XPFX8Qo
	 jHwEYFpMsGWfsTErA/hiH0rcstnKKtcGP/MPOlCEqR4ruyFykxaZuxdLHMiMMWTwwX
	 lvm9vAcYLZadyFSk3A/EzGP4AiSV6QA3pNjLDHHTidFkwGmc+hPkRqdplR5jNWrmVE
	 ygii9eNAs4XcRyZy+fJ5gSeYvQQHk7MvcRGgXkJEeU+RR1qbH8gQMAetb5/zODqx7v
	 WIER8IzWxICcRPQgwOooqyZBZzjNei08IiwRbd6bIWFsRw1vx2qdRTUyXQ7HDXaqiw
	 E/DTBdy0doiZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Dave Carey <carvsdriver@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	oneukum@suse.com,
	linux-usb@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] USB: cdc-acm: start bulk-IN polling when ALWAYS_POLL_CTRL is set
Date: Mon, 31 Aug 2026 09:30:07 -0400
Message-ID: <20260831133314.4125787-579-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background searches finished and match the earlier analysis:

- **`git log --grep="start bulk-IN polling"` /
  `--grep="ALWAYS_POLL_CTRL"`** only turned up the prerequisite Yoga
  Book quirk commits (`5d29d7ff8679e`, `625153b917bc4`), not the bulk-IN
  polling fix.
- **`git log --grep="bulk-IN polling"` / `--grep="start bulk"`** found
  no matching fix commit in this tree.

So the patch under review is **not present in 6.18.44**; the incomplete
`ALWAYS_POLL_CTRL` behavior is still there. The backport recommendation
remains **YES** — it completes the quirk already in this tree.

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

