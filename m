Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2661B4F0F;
	Mon, 10 Mar 2025 17:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627801; cv=none; b=NB5mJAbgqkpX3IfCRcTmymcbzipbQxacTiQGKZkX0ls0E6kIns/8+F760zVi4v15i7ecjFMZzJYm6kYcEbJNGCvUJhNUTy1oRz45k1vmR+woRkoXO5IaaifiChm66/9riHrBmb97CSCeW3Yi1nKEksISA6q7AKL3PLCUrV2EvAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627801; c=relaxed/simple;
	bh=zFMrExRejzXGyk1XqnqF27OkPwHzNQmQZSABf/HNbVw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPNieGyVqAPLzmMpJdF8k+UDtyEGwptvi8qKdc5YPc44HNeV1pQJzd9Se5ffzLELmwMdpk0CuOs/dY2ibEUrAChhP0ZvW6fwzfKh11z7PzdDVSygBiX4J9Xoqv+j4As2RpHPFjrV59VAp/W9TEkOLrOlWAegZXFmYvu7y7OYDHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XCXGMOke; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XCXGMOke"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45C0C4CEE5;
	Mon, 10 Mar 2025 17:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627801;
	bh=zFMrExRejzXGyk1XqnqF27OkPwHzNQmQZSABf/HNbVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XCXGMOkeKQ4W4hHnRbo5LJ2Z8V8bUWrN4pFF8nUGNivjim5OZMR7vOkADRcQgkoav
	 z05/IBJyqLCEw160KakMH/5V5ipYfCOi6z0SI5795itcFL0PIe0NZJhru2Bc+TF21r
	 IqHKB+5GxTpmzbeUYGqgY6j83/HtaqEivh4oXTp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>
Subject: [PATCH 6.12 222/269] usb: gadget: Check bmAttributes only if configuration is valid
Date: Mon, 10 Mar 2025 18:06:15 +0100
Message-ID: <20250310170506.530344997@linuxfoundation.org>
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


