Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6490C477995;
	Tue, 16 Jun 2026 16:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628919; cv=none; b=rd8FXuCqi3UevFNE+lrJCxklPc2wxYreJpEYjNNpvqEh/Kq+LvGisfjY5qOeZKtwtpLuwwPyYeNeGwljXYIEAfulYneIRWY+WmBglVFaxE6DId8voPIRMu75daWWQu8sOfCrxJGrwg54hQu12uQyMdY3cJOuDQKDHfSoPXEB1B0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628919; c=relaxed/simple;
	bh=mwX7/RN26CQ/XqT914i1abrpTYpv1rI446np1K7wNHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9uJ6ZHH5Inmqtv3xhZGgY3ocTAw9l/Wh7CK0DHbtXl+LHBKSj3i3F8RehmYb7PYEh3gZE3EjtEb8sF93NdNex1tCxgaRLRKGKYikrxfCan9rWMyyxmf1kEJH/hsqPA6d1mqN0Lil5Wv8cXeLBtLW6PA9j7P2f8MPWVwBeAUqY4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0sj9lR3m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0sj9lR3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33BAC1F000E9;
	Tue, 16 Jun 2026 16:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628918;
	bh=kf5BQEVNk/PWAXBbTXEQ7Od+aCNce0R/ZIzg7QlJ63M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0sj9lR3m0i4Q8Wz9lb9ROJ6wzNDHlMG8uLlN8PWWAnCm1LnKFz2X0o3KXY05V8iiT
	 fpfnuCwkPK+MH/F1UT7RgJ99eV/SPh6pprdXdgGtjQ1OjuAs/itGXP/9Zx7Wlu4B4W
	 ttlovg+NnOfGoJpZuVREh0514UrLDU/yd9t+DL+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Stephen J. Fuhry" <fuhrysteve@gmail.com>,
	stable <stable@kernel.org>
Subject: [PATCH 6.6 153/452] USB: quirks: add NO_LPM for Lenovo ThinkPad USB-C Dock Gen2 hub controllers
Date: Tue, 16 Jun 2026 20:26:20 +0530
Message-ID: <20260616145125.738207424@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -511,6 +511,10 @@ static const struct usb_device_id usb_qu
 	/* Lenovo ThinkPad USB-C Dock Gen2 Ethernet (RTL8153 GigE) */
 	{ USB_DEVICE(0x17ef, 0xa387), .driver_info = USB_QUIRK_NO_LPM },
 
+	/* Lenovo ThinkPad USB-C Dock Gen2 USB 3.1 and USB 2.0 hub controllers */
+	{ USB_DEVICE(0x17ef, 0xa391), .driver_info = USB_QUIRK_NO_LPM },
+	{ USB_DEVICE(0x17ef, 0xa392), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* BUILDWIN Photo Frame */
 	{ USB_DEVICE(0x1908, 0x1315), .driver_info =
 			USB_QUIRK_HONOR_BNUMINTERFACES },


