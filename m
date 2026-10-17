Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B5E3AA9F3;
	Sat, 17 Oct 2026 17:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256543; cv=none; b=GSW7PZguAe53rIkTeYYzBpp307QFhfCwJyIQ2cgDyOGHSzHvRjPR1qNjCgwFtOII0pyOBrHNLrGbnFoJgPBM7O3akK/XubL8tpvKnqvgRc+ho39HGjReSiEYcFmxjAvZypL2nR3X8LOMJt8eJlbcpM6AiJajpf/uQAYbu+U0uVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256543; c=relaxed/simple;
	bh=n9jYP9EqtbJOPBUh4LGhg+sysExOPvQAc0pXYy7DKS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VLzkq1AfoGaRRD2Fe+dqenkxH5hGYwx3wLKVE2AzJxtgB4ZsCM8LuLeRQ7cw5KBfRUSomt5PF+X3M9OYg3PJkhbUxOzEJFa504B/nR0Gq3UNhCMlquBHrpsFfRIzvpTQBRXQHdXf0zsaRCMmcDr4aJH4Vq6p9iquuFwa9D1yGdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HQPLhIW2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HQPLhIW2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6392F1F000C4;
	Sat, 17 Oct 2026 17:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256541;
	bh=XW4Ns+AywyP1xJ4oW6fZ4qW3Hcdrjn5FdTTnSR7IHJM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HQPLhIW20ZxkNb3IOAVdNNwqvsrUG2IJ1rWNmSfr45HtAAo2mo18YAhRj31/oQI3X
	 1gV+jPxCMQJmTcEOeioOfcUKBGDg+Kd1gwDhbF+RANsM6T6MfgeKL4gvUdNoj/AOst
	 H3lgEC0wblEMwvSh7o1u+siwZqBmF94pz7uKNCK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuchao Zhang <ndaugoing@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Nazarewicz?= <mina86@mina86.com>
Subject: [PATCH 6.6 0270/1674] usb: gadget: f_fs: Fix NULL pointer dereference in FUNCTIONFS_ENDPOINT_DESC
Date: Sat, 17 Oct 2026 17:42:22 +0200
Message-ID: <20261017160438.049401018@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuchao Zhang <ndaugoing@gmail.com>

commit 9cd072788c76595529eb38f42bf94d23852f8534 upstream.

When user space sets up FunctionFS with only full-speed descriptors
(e.g., flags = FUNCTIONFS_HAS_FS_DESC) and the gadget operates at a
higher speed (such as USB_SPEED_HIGH or USB_SPEED_SUPER),
config_ep_by_speed() detects that the function lacks descriptors for
the current speed, logs a warning, and falls back to full-speed
descriptors. The endpoint is then successfully enabled via
usb_ep_enable(), and epfile->ep becomes valid.

However, when user space subsequently issues the FUNCTIONFS_ENDPOINT_DESC
ioctl to query the endpoint descriptor, ffs_epfile_ioctl() selects the
descriptor index solely based on gadget->speed:

	switch (epfile->ffs->gadget->speed) {
	case USB_SPEED_SUPER:
	case USB_SPEED_SUPER_PLUS:
		desc_idx = 2;
		break;
	case USB_SPEED_HIGH:
		desc_idx = 1;
		break;
	default:
		desc_idx = 0;
	}
	desc = epfile->ep->descs[desc_idx];
	memcpy(&desc1, desc, desc->bLength);

Because user space only supplied full-speed descriptors,
epfile->ep->descs[1] is NULL. Dereferencing desc->bLength triggers an
immediate kernel NULL pointer dereference panic.

Fix this by falling back through lower speed descriptors if the current
speed descriptor was not supplied, matching the fallback logic in
config_ep_by_speed() and historical f_fs behavior. If still missing,
fall back to epfile->ep->ep->desc (the active descriptor), and return
-EINVAL safely if no valid descriptor is found. In addition, mark desc
as const to match struct usb_ep::desc and avoid discarding qualifiers.

Fixes: c559a3534109 ("usb: gadget: f_fs: add ioctl returning ep descriptor")
Cc: stable@kernel.org
Signed-off-by: Yuchao Zhang <ndaugoing@gmail.com>
Acked-by: Michał Nazarewicz <mina86@mina86.com>
Link: https://patch.msgid.link/20260918005438.81263-2-ndaugoing@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -1326,8 +1326,9 @@ static long ffs_epfile_ioctl(struct file
 		break;
 	case FUNCTIONFS_ENDPOINT_DESC:
 	{
+		const struct usb_endpoint_descriptor *desc;
+		struct usb_endpoint_descriptor desc1;
 		int desc_idx;
-		struct usb_endpoint_descriptor desc1, *desc;
 
 		switch (epfile->ffs->gadget->speed) {
 		case USB_SPEED_SUPER:
@@ -1341,7 +1342,17 @@ static long ffs_epfile_ioctl(struct file
 			desc_idx = 0;
 		}
 
-		desc = epfile->ep->descs[desc_idx];
+		do {
+			desc = epfile->ep->descs[desc_idx];
+		} while (!desc && --desc_idx >= 0);
+
+		if (!desc)
+			desc = epfile->ep->ep->desc;
+		if (!desc) {
+			ret = -EINVAL;
+			break;
+		}
+
 		memcpy(&desc1, desc, desc->bLength);
 
 		spin_unlock_irq(&epfile->ffs->eps_lock);


