Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BD247A6C;
	Tue, 14 May 2024 11:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715686599; cv=none; b=IgwSkuRc57dDaXN1Ak2Hg8Tgwi4yGnsXqjwO20NNFNbGBVLJvpq8vv+s76vLJie2T6DgnBxBSH0q9mZ7Ilx30jen7StaUlEYfplgC5fyCA3R4CE6qeji6lGe/ScaR0QlB7A5rS5RSBjG7JM1/14O52pBvrXleQ2RtYEjvS/JKFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715686599; c=relaxed/simple;
	bh=e+Y/iM6oonc56a/5Gm9Z41OMc3n7C56MXyibVvctmfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qeTYZV2dHAS8/gQFBz24CezNMNecrQxzC2iYNLRw8l5Myo7E4mDwpmlLxLxob+hv+owCJio5JCRG3fFd2uksOaPQdObPqRlfIx78NNE71fO0kpYp9L4qAOhdNOaRQJq5HN8RavGJPyLpInThgLK1pQ8oipEr9cqmVdJl42QvH4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wxefd45h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wxefd45h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92D5EC2BD10;
	Tue, 14 May 2024 11:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715686599;
	bh=e+Y/iM6oonc56a/5Gm9Z41OMc3n7C56MXyibVvctmfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wxefd45hMEcwh7sEOscCJXJP27b1Z6fscxMDUqz2VzbmhnjRLwqUI2cGTDzYsIZWh
	 a50FLLPFAW93M4b7sWHJvPNoM7FPF7JV5QsJreFNqJ/pdNRKkjmMlhmDYZOw7u7/sY
	 srckeeNvfakb9Y28yjCp3YUjn9dNOgOqB9q8p+cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alan Stern <stern@rowland.harvard.edu>,
	Roger Whittaker <roger.whittaker@suse.com>
Subject: [PATCH 6.1 194/236] usb: Fix regression caused by invalid ep0 maxpacket in virtual SuperSpeed device
Date: Tue, 14 May 2024 12:19:16 +0200
Message-ID: <20240514101027.733006795@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101020.320785513@linuxfoundation.org>
References: <20240514101020.320785513@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5069,9 +5069,10 @@ hub_port_init(struct usb_hub *hub, struc
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


