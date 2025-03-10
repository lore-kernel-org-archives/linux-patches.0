Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF5A21B3927;
	Mon, 10 Mar 2025 17:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628245; cv=none; b=Sdst7061eVFSSZ9IytFb4VEvGokPxD0Fv1dVi3TwNvXQTLPuk8LpyU5MflRbxClj1qOGvQLHXRzE6qsgAx875wxdlyViMI7Mm2QgPLBPT8YLHEpAuu2TSeXAjCDvqjnKFjSnWgl5grG2MBuPE0iJ9jsEHImbnVhJ2uc1AKIQ91U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628245; c=relaxed/simple;
	bh=/XA6DY7HdSz2KfG509VuOh+oW6LcOEOU0Ozb0bpr34I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PFZPQjoFgl91gX93pM7oVJ1G4pXb8dQzLzmFwdVkZnWfQK3sCuo9VHtrm5++5C2MMiRXLcnEdChrns2j6BYpQFqSqp489+bqes314eH6Wlq+CDJMpnractgaVzmk7z8S9+vrgWwiAfG2Gt9AaTJU679TeOEqEprPA0vH5tSIPIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VIbPFA72; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VIbPFA72"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74A90C4CEE5;
	Mon, 10 Mar 2025 17:37:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628244;
	bh=/XA6DY7HdSz2KfG509VuOh+oW6LcOEOU0Ozb0bpr34I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VIbPFA72/EeAWlHjgt5zkCV1s/Uc/Cvfz8ZSZrusfKYL8lYyoK1/GoKrVE3rjYpvg
	 Zh7PvJ9vBTq6ZjuYlCS1i/Ghm2Bf1UVNUGLt8Dll5a3scWJn4HoD2mArBItktJtD/W
	 PJH/8hJuoiCiCg/Tq2pqKvZv5sgFKzY56KS5BuI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.6 106/145] usb: gadget: Fix setting self-powered state on suspend
Date: Mon, 10 Mar 2025 18:06:40 +0100
Message-ID: <20250310170439.041196173@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


