Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D431B2309B0;
	Mon, 10 Mar 2025 17:37:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628247; cv=none; b=CGRAtwv2vgtTX0nQpYKIGnOtTbimWf3ItLmGwNBp1PKZDU4nC8tjuI1l3sQKk0rU66fVSFeK8sjwAUUrqG/XX8IQcmnPQJnncPy3NpWqTieD+sDtjeDcKpZEqeTuihqKsCiJ/tLwLu0rk/TJpS7+u25dR/w7fX9LFUzxLeIqaEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628247; c=relaxed/simple;
	bh=h8QpQHbZnpZlvKI7zyoHW8PecK/vw5fT8kbfRTYcRFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rB/3N4XNs4EPD5ZsugIH6K9btHZps3DKQmS88j0INnahIj1U0GTTWbvEag6jWIGZSxpCA0i2jq8AFRsJdPAz9WgW5IpPLpN6G3xTIXByvEG4i1I5PU5W2dn0F86ayYVeSksLEXFoq3qkiAOExR/U2Xq6L9Odam7Ruz2mcYFiuNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CUuU45UB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CUuU45UB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BD19C4CEEC;
	Mon, 10 Mar 2025 17:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628247;
	bh=h8QpQHbZnpZlvKI7zyoHW8PecK/vw5fT8kbfRTYcRFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CUuU45UBw9OqU8XUhVL5Z0uE2xZAtuoaD4I7lbJSJmf3OdF2G4SsK7zqIfdf6WXXR
	 TLNxrl7kaKrq3vkC2Ruo40rsNkxcf76P72bZIJm22pIh2eECeQ8x79+bkp+CAkzYwE
	 Q5xKle52svyjVKI6/cK1MRZWC4D+qS9mMe+gkdMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 6.6 107/145] usb: gadget: Check bmAttributes only if configuration is valid
Date: Mon, 10 Mar 2025 18:06:41 +0100
Message-ID: <20250310170439.078250870@linuxfoundation.org>
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


