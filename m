Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039571A315A;
	Mon, 10 Mar 2025 17:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626952; cv=none; b=q9PXebUxTgVV8rWQ5ShGwc/BsbDQOKezet73ttBt+AN26nRmlwoyJ219ZVzNi0E3yyNPhAKdEUBsVKBnHMJ1bRN1NaWLDjgfWdL0HzITcWwR79aBqh6UwfjIXRveeejRQbaoxUOQaWVSOS5NOGdWpSP7KJB+eSKdPjFHur7as7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626952; c=relaxed/simple;
	bh=RsP8HV1YBAVrURIS3ywfPtaULdL+xFUkQy7Kpdm+LQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GqjegRFMBAqx4GksGLl6DaBXJZcphvjzLBtjCKxDSB9RFy6c6OzKunE10T8/xC0Qsr2coytM50cyns1zbK8oilbSMgdrmN/12HLSMIC3T/r9yu3VejTSEDmHNSX9T8bRMo7h/vRNtQg9BiNN9eF+CF4KQKdAMiO60cHks6eDhjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NBkiRohi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NBkiRohi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FDDBC4CEE5;
	Mon, 10 Mar 2025 17:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626951;
	bh=RsP8HV1YBAVrURIS3ywfPtaULdL+xFUkQy7Kpdm+LQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NBkiRohitOmITKXEjfllr+hIkR9SKOG4ZnoSQ4zVheIHv72JjqJmtd9HlmGC1CuU7
	 rIEs7hmY8xPANZh+U30PkCcsawMpnvYcooyyEjHHiX9Rwd6BkzrkDtcIET/cVkmcWs
	 NpMBRMNCPJQz8/x8VObaiMvmh9YhoFBBJ5xsaRZ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.13 168/207] usb: gadget: Fix setting self-powered state on suspend
Date: Mon, 10 Mar 2025 18:06:01 +0100
Message-ID: <20250310170454.465086039@linuxfoundation.org>
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


