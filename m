Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F46296BCC;
	Sun,  7 Jun 2026 10:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829222; cv=none; b=cEDq+y7Su5iqO2DmLdv6eca2/sTSGLgbYfQ3/5sNB5w62Bf6DgB/ttI393LQQAPbJ+cumDKgvHqydEeY07gPhd+BqnLTFpRu+DAMG+chr8CP8/+/Fe+i8S5XUzaNcU5QbuM7NfjIWDzo15QNd1OJHbqPmoV7qP07wOleDAtiWBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829222; c=relaxed/simple;
	bh=wigbhd06SQ5mzgYTZhzBvR0IRxlkE9YrjBfzoeHyCkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P3O06U66LcoD/tSSlSGAsWaPjCafHcBhfbM5OXzEfXexbE+9/n3ktqu3t+9Szx1faUfoSk6jcGDCPd5V0Xwg98jyi1iTrmMwgRC2XsrGF0OlI62cHMUQFK0mTKe9xRTZpiCRa/rDNMmqHbzlUuuT2g6tEMdEkm1aEWw8iX0PHeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CrK4gTTu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CrK4gTTu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DECE31F00893;
	Sun,  7 Jun 2026 10:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829221;
	bh=nOI9ebQu30qecAVKMwwdpVksF38n2bHLvSsUe28eW1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CrK4gTTuV2rUXe77h60ZM6aYnGZbH9VpJpwA6ESGIzkbdpDIdIOqIXJv5SFOSwYob
	 hqqXEImG67dhJwJ6pnChCZK6xGI/SwT3R1djn39Uvzz7wB3Fd/Nfdz6pGmJ9r0eFTs
	 1Ag3EW7tuT3XDAXOd0nWix8tQTPlAIyrDjVJaBp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stephen J. Fuhry" <fuhrysteve@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 7.0 255/332] USB: quirks: add NO_LPM for Lenovo ThinkPad USB-C Dock Gen2 hub controllers
Date: Sun,  7 Jun 2026 12:00:24 +0200
Message-ID: <20260607095737.411505900@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -513,6 +513,10 @@ static const struct usb_device_id usb_qu
 	/* Lenovo ThinkPad USB-C Dock Gen2 Ethernet (RTL8153 GigE) */
 	{ USB_DEVICE(0x17ef, 0xa387), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Lenovo ThinkPad USB-C Dock Gen2 USB 3.1 and USB 2.0 hub controllers */
+	{ USB_DEVICE(0x17ef, 0xa391), .driver_info = USB_QUIRK_NO_LPM },
+	{ USB_DEVICE(0x17ef, 0xa392), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* BUILDWIN Photo Frame */
 	{ USB_DEVICE(0x1908, 0x1315), .driver_info =
 			USB_QUIRK_HONOR_BNUMINTERFACES },


