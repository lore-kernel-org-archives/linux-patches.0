Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1CCA22E00A;
	Mon, 10 Mar 2025 17:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627798; cv=none; b=bkrCNQz7rSLPGRLAYLr+1ZDvA9XhHmmjk3ayJIs4aX5GPZoJN12dSAvn7Y/aRySVmfXpzjGi5In/lsZrQGUx8tyAKixXYc8f+0QVEQJQ4GiiXRHUpGdinn/CAywuamX0v0nLRD1U2Y1laHntPfbksNdXRKF3bOIWnehrVzTSmXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627798; c=relaxed/simple;
	bh=5K6cb7gVRzdm/9oLDgrVxZDcaZTB09FgmHaiOjDI4Zo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhSMtW9zgcUhcQQ70fNpDQkLi4dL1FFwKRMluwmPRBhoQ1tcxWrpf7RYREDNInCKXNTQfViq50WcAkYYlXHzYKl+hRb5F3bMkhnVxqSPKXS5cXxZfItpkIEkBGhHZ7mcVF6+9IJFezq19yr2etq4zgxy06wVqxGMkx0vmx56QLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htQze18d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htQze18d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39D6C4CEE5;
	Mon, 10 Mar 2025 17:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627798;
	bh=5K6cb7gVRzdm/9oLDgrVxZDcaZTB09FgmHaiOjDI4Zo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htQze18dTsEDEQXAUL6TL4IE7zQPlcos+YIeMhcTIGDBY3cUxZGn37x1N1BgBZnkj
	 WJVTzMoNKMCRoUGb7aXpqxSWguEUq1YBCNFCwR7gdXt9QLDisxlvBRr847qaA93ace
	 KGo43kiR0zIYV6UKDV/lbV6SAvnvrHHWHiP9VWSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.12 221/269] usb: gadget: Fix setting self-powered state on suspend
Date: Mon, 10 Mar 2025 18:06:14 +0100
Message-ID: <20250310170506.491210814@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit c783e1258f29c5caac9eea0aea6b172870f1baf8 upstream.

cdev->config might be NULL, so check it before dereferencing.

CC: stable <stable@kernel.org>
Fixes: 40e89ff5750f ("usb: gadget: Set self-powered based on MaxPower and bmAttributes")
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250220120314.3614330-1-m.szyprowski@samsung.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -2616,7 +2616,8 @@ void composite_suspend(struct usb_gadget
 
 	cdev->suspended = 1;
 
-	if (cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER)
+	if (cdev->config &&
+	    cdev->config->bmAttributes & USB_CONFIG_ATT_SELFPOWER)
 		usb_gadget_set_selfpowered(gadget);
 
 	usb_gadget_vbus_draw(gadget, 2);


