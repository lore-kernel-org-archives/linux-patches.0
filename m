Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852F83D8100;
	Tue, 16 Jun 2026 18:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635846; cv=none; b=OQkR/6i2JIGh1zDuQeCzkmx3EPVlrOK8i0XLAmJBCsV3V5wOU1AGlr5nRa4gVU1K7vZXXbHoh499i68Nja4Bo0vkQpUc0fnuxEcBS9WSvnuyYtwcI3CVtt6B6YaqlbiGpnbGoGDbZVoLHOVO8WoAmkgYkDRQqtlePGyziL6gyQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635846; c=relaxed/simple;
	bh=FXI0/cdClf08XUQvDFx1pyzLgaE7EJBlw0EG8ZbLqyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p0LP7p/IRyc7n/0VeiImPFffVCjfOCZ91b6Duq3PY3alzHOZd+j/iOFrctYKCZKcPQ21C9a/xYsoiZAUcboNPkvCldfyAin+f1zynKrMxllSJUEeAiPVzIrr0MPLM6azs+n/CgZeF5qhM+1c8680F6R05ia0wv0ghjIrX+i0Weo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PetlyBR7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PetlyBR7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713AB1F000E9;
	Tue, 16 Jun 2026 18:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635845;
	bh=SaRC1ogAo6M2ZVlNhVYdSnOKS/i6rR0EVT9jUSioVhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PetlyBR7wXDnWCyUwnWl8szBCTHBQyPr0FxWcG2xMLyxigs30lT+I1+/g4qUiQa2Q
	 /Mc6dS/AwixjBXDTBZBNYO4sWM0cpAptY607g446e0hNRDnNuDHLl86zAe07PtngO8
	 80QPgqtdQA5/QCFruxcY6uoL7ZjBQ+VacdX2eyqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stephen J. Fuhry" <fuhrysteve@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 5.10 092/342] USB: quirks: add NO_LPM for Lenovo ThinkPad USB-C Dock Gen2 hub controllers
Date: Tue, 16 Jun 2026 20:26:28 +0530
Message-ID: <20260616145052.522325242@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephen J. Fuhry <fuhrysteve@gmail.com>

commit 9ddb9c0deca48d2c2a22ebf4d2f35c925a520328 upstream.

The Lenovo ThinkPad USB-C Dock Gen2 (17ef:a391, 17ef:a392) hub
controllers exhibit link instability when USB Link Power Management
is enabled, similar to the dock's Ethernet adapter (17ef:a387) which
already carries USB_QUIRK_NO_LPM.

When the dock reconnects after a transient disconnect, the hub
controllers enter LPM states between re-enumeration retries, causing
repeated disconnect/reconnect cycles lasting up to two minutes.
Disabling LPM for these devices restores stable enumeration.

Signed-off-by: Stephen J. Fuhry <fuhrysteve@gmail.com>
Cc: stable <stable@kernel.org>
Link: https://patch.msgid.link/20260513171419.44849-1-fuhrysteve@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -498,6 +498,10 @@ static const struct usb_device_id usb_qu
 	/* Lenovo ThinkPad USB-C Dock Gen2 Ethernet (RTL8153 GigE) */
 	{ USB_DEVICE(0x17ef, 0xa387), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Lenovo ThinkPad USB-C Dock Gen2 USB 3.1 and USB 2.0 hub controllers */
+	{ USB_DEVICE(0x17ef, 0xa391), .driver_info = USB_QUIRK_NO_LPM },
+	{ USB_DEVICE(0x17ef, 0xa392), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* BUILDWIN Photo Frame */
 	{ USB_DEVICE(0x1908, 0x1315), .driver_info =
 			USB_QUIRK_HONOR_BNUMINTERFACES },


