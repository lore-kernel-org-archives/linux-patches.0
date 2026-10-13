Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24E2345039;
	Tue, 13 Oct 2026 12:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895059; cv=none; b=DK/46mb/vOMRekVOWzcSVJ4spaKqdxYt1Gti/aNcqOMjo/iWhWGzNu0o8PlYIVW+M/qu4191E5CfWtHmZVnmU547TYzn5eDFro90jJ/sUZ49EelJDHpe6RaRY6MciUQqrk777ljD/MEMG4LD88ulGLGTaNsXmSL/5i0730/S6NY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895059; c=relaxed/simple;
	bh=h9IokOw03mXC6Kl8E4xDTdqopoZYPp27+2VyUYNGjHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DYbQgU5ECLdVe0M3GjsgwVYTRA3ULSkSGT1S/SfEqNs86suf4uizi3lqhuXwr79J1YlSia1++OX0f6qmCaUVFkOyhNueUTUeAlBL5vr4amf0naDIuLceJDPzbtZ3EzOxtmIQtOrEraSZkkNZxo+G/vnMgXQPn1EeMg6TO48FXB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wtSnbLGL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wtSnbLGL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189AA1F000FF;
	Tue, 13 Oct 2026 12:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895057;
	bh=WybnrBabbmICpqqkv/CUUiQJt9cI6cdrTK/mTmCYf4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wtSnbLGLhz7F7fF9K51DbVH2nJyMSLw9/qQAVPjQnHWY2nxVa4p7FynZM0Os9Vaid
	 3c1UsHolobZmFoPYD0I9HlnJqBg/gkdokcjUMuxcqwi2IBov7HauuxDj0k0GlbhtZm
	 BTNfSynqPBUpB9NLEJUftAiMGEPDwn70Uy2UXttA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuchao Zhang <ndaugoing@gmail.com>,
	=?UTF-8?q?Micha=C5=82=20Nazarewicz?= <mina86@mina86.com>
Subject: [PATCH 6.12 148/497] usb: gadget: f_fs: Fix NULL pointer dereference in FUNCTIONFS_ENDPOINT_DESC
Date: Tue, 13 Oct 2026 13:35:15 +0200
Message-ID: <20261013112911.400422987@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1834,8 +1834,9 @@ static long ffs_epfile_ioctl(struct file
 		break;
 	case FUNCTIONFS_ENDPOINT_DESC:
 	{
+		const struct usb_endpoint_descriptor *desc;
+		struct usb_endpoint_descriptor desc1;
 		int desc_idx;
-		struct usb_endpoint_descriptor desc1, *desc;
 
 		switch (epfile->ffs->gadget->speed) {
 		case USB_SPEED_SUPER:
@@ -1849,7 +1850,17 @@ static long ffs_epfile_ioctl(struct file
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


