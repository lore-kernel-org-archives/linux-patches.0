Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A368C1DDCE;
	Tue, 16 Jul 2024 16:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145734; cv=none; b=hugvf1hvnqcLVDyzoKU1685SQ+pUVxXuFSC5MZSPABlAGbluoZicvv7gutUuxXq4bZjAoBId5avEjzAmfZtOy92E61KYpKSTqqakSZdzKqWxhfqIX4q2dSheZjmfjTvW5HSQioXwwaXAwbKdFR4TrqNzXFOrwDYDoaaeRwBgzjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145734; c=relaxed/simple;
	bh=FWDVg8CzZb3w4araFBPA4H11hWCuklzWjWDDGjAZzvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YFVwHPVnShFU8sDDJytxD6eIuqONQv+al9WqG2JX1kyXWHE/lSLIRCtrHB/ObfPzFP8baGv/3lL32PAft8jg/Uy0M7RsW/rI+ZTf0twoMv9cInVFHDU+VeA90DBe8a8Um4zENwYnKhMGnoVC5vCKqfN4bT2/j1Eric9WG5xDY3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DHg2JxI+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DHg2JxI+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B4BEC116B1;
	Tue, 16 Jul 2024 16:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145734;
	bh=FWDVg8CzZb3w4araFBPA4H11hWCuklzWjWDDGjAZzvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DHg2JxI+vfqufbGU9IVg2ea6aNk8Xjw23wA5hWf+HTG4ygllXQ6w2S+f132VJJirh
	 aAAlHV2v/3HkcHY0v7n4nA3PGZG2fnNxSQPt/4TAMBt8S3BcZNyU5UgMpOWhtBChZq
	 3KzCg3pve8cyCm81tvdi+FMp2KqecgFcV5KLQrN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Oliver Neukum <oneukum@suse.com>,
	syzbot+8693a0bb9c10b554272a@syzkaller.appspotmail.com
Subject: [PATCH 6.6 067/121] USB: core: Fix duplicate endpoint bug by clearing reserved bits in the descriptor
Date: Tue, 16 Jul 2024 17:32:09 +0200
Message-ID: <20240716152753.905161346@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152751.312512071@linuxfoundation.org>
References: <20240716152751.312512071@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit a368ecde8a5055b627749b09c6218ef793043e47 upstream.

Syzbot has identified a bug in usbcore (see the Closes: tag below)
caused by our assumption that the reserved bits in an endpoint
descriptor's bEndpointAddress field will always be 0.  As a result of
the bug, the endpoint_is_duplicate() routine in config.c (and possibly
other routines as well) may believe that two descriptors are for
distinct endpoints, even though they have the same direction and
endpoint number.  This can lead to confusion, including the bug
identified by syzbot (two descriptors with matching endpoint numbers
and directions, where one was interrupt and the other was bulk).

To fix the bug, we will clear the reserved bits in bEndpointAddress
when we parse the descriptor.  (Note that both the USB-2.0 and USB-3.1
specs say these bits are "Reserved, reset to zero".)  This requires us
to make a copy of the descriptor earlier in usb_parse_endpoint() and
use the copy instead of the original when checking for duplicates.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: syzbot+8693a0bb9c10b554272a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-usb/0000000000003d868e061bc0f554@google.com/
Fixes: 0a8fd1346254 ("USB: fix problems with duplicate endpoint addresses")
CC: Oliver Neukum <oneukum@suse.com>
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/205a5edc-7fef-4159-b64a-80374b6b101a@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/config.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/usb/core/config.c
+++ b/drivers/usb/core/config.c
@@ -291,6 +291,20 @@ static int usb_parse_endpoint(struct dev
 	if (ifp->desc.bNumEndpoints >= num_ep)
 		goto skip_to_next_endpoint_or_interface_descriptor;
 
+	/* Save a copy of the descriptor and use it instead of the original */
+	endpoint = &ifp->endpoint[ifp->desc.bNumEndpoints];
+	memcpy(&endpoint->desc, d, n);
+	d = &endpoint->desc;
+
+	/* Clear the reserved bits in bEndpointAddress */
+	i = d->bEndpointAddress &
+			(USB_ENDPOINT_DIR_MASK | USB_ENDPOINT_NUMBER_MASK);
+	if (i != d->bEndpointAddress) {
+		dev_notice(ddev, "config %d interface %d altsetting %d has an endpoint descriptor with address 0x%X, changing to 0x%X\n",
+		    cfgno, inum, asnum, d->bEndpointAddress, i);
+		endpoint->desc.bEndpointAddress = i;
+	}
+
 	/* Check for duplicate endpoint addresses */
 	if (config_endpoint_is_duplicate(config, inum, asnum, d)) {
 		dev_notice(ddev, "config %d interface %d altsetting %d has a duplicate endpoint with address 0x%X, skipping\n",
@@ -308,10 +322,8 @@ static int usb_parse_endpoint(struct dev
 		}
 	}
 
-	endpoint = &ifp->endpoint[ifp->desc.bNumEndpoints];
+	/* Accept this endpoint */
 	++ifp->desc.bNumEndpoints;
-
-	memcpy(&endpoint->desc, d, n);
 	INIT_LIST_HEAD(&endpoint->urb_list);
 
 	/*


