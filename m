Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64992F9D4;
	Tue, 14 May 2024 11:58:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687919; cv=none; b=ovPXE11Q/o7Vv0RDdPekDxIOVf+svIAh3SwafG+/D7Am+2Y8/DkUJrsHPZ4IZt4XWstxQGt9624S10PHsOilbKfxymKvlPJx+WZM03R2Mw4O0wWzcPRlpDKxCSyHGCKybhWRZZJ43kgkzf6n3AvTwyoI1rZGTDgNm7CHyeq0eeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687919; c=relaxed/simple;
	bh=tyAegohV0m6CrK9zSUrDlTz6fPzWqRK5VAoA8yPN+0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jd7rzgFNx5BKmNb2kkkZ+TNqVb2YtfuUXH8DfLhrbkp99FIUV2kM0feQ1u4pP80ODKAGIGcy4aPiyp7ZtUwRYEnhaYTSL+bHdWdCpSaoUO846Ovt/9OuirHtawcSTcvuFel6tWh44CVORfaMiBV10y9Olo7ZznaB0sRCaN4MffI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=haDuDqSJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="haDuDqSJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F73C2BD10;
	Tue, 14 May 2024 11:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687919;
	bh=tyAegohV0m6CrK9zSUrDlTz6fPzWqRK5VAoA8yPN+0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=haDuDqSJfslg0HhwtIQB7mcEFDh9DfAXOy0mdJnr1/iQ1MgHb2XcV2rdPU3Rw3+Q2
	 MZDNESHfxchifu/8qTpLYrM1Q5MKtD89vzuEC8axhZXRGUgSjxae9U9MIMUg2b5Sfz
	 M8u71WtTx13/kTtMZCOAIpilKbULvEBGZNh4bAFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Roger Whittaker <roger.whittaker@suse.com>
Subject: [PATCH 5.15 143/168] usb: Fix regression caused by invalid ep0 maxpacket in virtual SuperSpeed device
Date: Tue, 14 May 2024 12:20:41 +0200
Message-ID: <20240514101012.086266357@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit c78c3644b772e356ca452ae733a3c4de0fb11dc8 upstream.

A virtual SuperSpeed device in the FreeBSD BVCP package
(https://bhyve.npulse.net/) presents an invalid ep0 maxpacket size of 256.
It stopped working with Linux following a recent commit because now we
check these sizes more carefully than before.

Fix this regression by using the bMaxpacketSize0 value in the device
descriptor for SuperSpeed or faster devices, even if it is invalid.  This
is a very simple-minded change; we might want to check more carefully for
values that actually make some sense (for instance, no smaller than 64).

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Roger Whittaker <roger.whittaker@suse.com>
Closes: https://bugzilla.suse.com/show_bug.cgi?id=1220569
Link: https://lore.kernel.org/linux-usb/9efbd569-7059-4575-983f-0ea30df41871@suse.com/
Fixes: 59cf44575456 ("USB: core: Fix oversight in SuperSpeed initialization")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/4058ac05-237c-4db4-9ecc-5af42bdb4501@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/hub.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5049,9 +5049,10 @@ hub_port_init(struct usb_hub *hub, struc
 	}
 	if (usb_endpoint_maxp(&udev->ep0.desc) == i) {
 		;	/* Initial ep0 maxpacket guess is right */
-	} else if ((udev->speed == USB_SPEED_FULL ||
+	} else if (((udev->speed == USB_SPEED_FULL ||
 				udev->speed == USB_SPEED_HIGH) &&
-			(i == 8 || i == 16 || i == 32 || i == 64)) {
+			(i == 8 || i == 16 || i == 32 || i == 64)) ||
+			(udev->speed >= USB_SPEED_SUPER && i > 0)) {
 		/* Initial guess is wrong; use the descriptor's value */
 		if (udev->speed == USB_SPEED_FULL)
 			dev_dbg(&udev->dev, "ep0 maxpacket = %d\n", i);


