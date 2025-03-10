Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF73D1A315A;
	Mon, 10 Mar 2025 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626954; cv=none; b=MI0GcI/BQKPpAnURYOG2TYbMC4CNaanULLBFDjKs2PpOAdY+Z8WkBQVBPMr0qLmQHNgEGtFwEOZtHKEK4xgeOiBEiYGuQljPADsChDz7jTkckzd1pHCSSErdz2c9G5v2GpUSSAKnbfBZaW1wuR9Y/fDsI6gfcOaiAnTs4YhAcBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626954; c=relaxed/simple;
	bh=LaD7bg2VwSGTYa+Xf7/7LomptH3TYrx8RyW0y0fMXFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1mpoZpA4a7MEcChpwg6toE5Fv45rIxM+c4p1btT6YYy+tL4ZO5nyXoS7cwoDq6V1OgZ7GtumDpqxWk1tKjXvLxYSl1S+GlObuY/EeJVT7OO+x/o2xGtmlDD+iVyM3Hp9ZboX9VbM/B6Vo3Lk0xcweZiBhP2IHwUYXiF73JdrCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uLCx5TSr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uLCx5TSr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB9BC4CEE5;
	Mon, 10 Mar 2025 17:15:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626954;
	bh=LaD7bg2VwSGTYa+Xf7/7LomptH3TYrx8RyW0y0fMXFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uLCx5TSrsspO1u/zev7IHUDMl9EingfBmIuLqMkhtb43vptg0VzHm8m4iCzCK4Rt8
	 ulNSvNvUnehPvoFZZJ6JGyRYf97KZaRHAjaQaW1anUQGfP9UPsOtx5A4qY/vQbyWFg
	 7T4hgxICCcV+o2GLiHJqyD5Oq1Xd5+9P3Hsy94wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 6.13 169/207] usb: gadget: Check bmAttributes only if configuration is valid
Date: Mon, 10 Mar 2025 18:06:02 +0100
Message-ID: <20250310170454.504999828@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashanth K <prashanth.k@oss.qualcomm.com>

commit 8e812e9355a6f14dffd54a33d951ca403b9732f5 upstream.

If the USB configuration is not valid, then avoid checking for
bmAttributes to prevent null pointer deference.

Cc: stable <stable@kernel.org>
Fixes: 40e89ff5750f ("usb: gadget: Set self-powered based on MaxPower and bmAttributes")
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250224085604.417327-1-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/composite.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1051,7 +1051,7 @@ static int set_config(struct usb_composi
 		usb_gadget_set_remote_wakeup(gadget, 0);
 done:
 	if (power > USB_SELF_POWER_VBUS_MAX_DRAW ||
-	    !(c->bmAttributes & USB_CONFIG_ATT_SELFPOWER))
+	    (c && !(c->bmAttributes & USB_CONFIG_ATT_SELFPOWER)))
 		usb_gadget_clear_selfpowered(gadget);
 	else
 		usb_gadget_set_selfpowered(gadget);


