Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87D0044AB91;
	Tue, 21 Jul 2026 21:44:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670249; cv=none; b=ui4kEkj9QYEoMat4necqRX+/OCbW1AppTCrjpe2zOf69RDLNhVcam/WKRvqSkeukS5msjQDvV09vdhsZvfdjAWRl0APOVxz4Zm93NIdpi+Ily/QNaknxqnv8klvTTU0knHp8RxLVfeuS5nKQ7eACxSEVvjax3pgQRO4qFtyQtbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670249; c=relaxed/simple;
	bh=p3l7FJA7raJkfNgmfJ2wNYOgZaisoksBAO10ViZm1iE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HZ5pz9sBE/610It+MfirtfWDdAhHYylwEwyi3KuQMNvWc8CtafhDxpw0xutqRI1y4r89LTz00oF2u0Bb2xmewNaiPnfeo4B8ASIFqSBur93cJOE5TbiB5BSHNWW8O+giNHNjqA09Q2ZoKf7YeCuHMFJ/E6cBSBMk3pAlEq3PE5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AhGc601X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AhGc601X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED2451F00A3A;
	Tue, 21 Jul 2026 21:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670248;
	bh=5DC/NQ3jJHJjuBa444REY8SpDhmjkgpoFKiOWd8gCJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AhGc601XpaOAngdSQdRxqVTS5pYc5opF4OwZ9lCweolhG1ggIjji/M3nWpv4gifSh
	 C7RJ66iwFULZyZLV3v/JKFvq3CLa/l4UqqaOO7Od6JG29aetsj6HX+Szxp5sIsdev9
	 egvLcUFSXsL8NoXtkdBORgob5CPmjJ2Kq/b0iFKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 0861/1067] Input: ims-pcu - fix use-after-free and double-free in disconnect
Date: Tue, 21 Jul 2026 17:24:22 +0200
Message-ID: <20260721152443.803124440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 462a999917755a3bf77448dfd64307963cf0a9f0 upstream.

ims_pcu_disconnect() only intended to perform cleanup when the primary
(control) interface is unbound. However, it currently relies on the
interface class to distinguish between control and data interfaces.
A malicious device could present a data interface with the same class
as the control interface, leading to premature cleanup and potential
use-after-free or double-free.

Switch to verifying that the interface being disconnected is indeed
the control interface.

Fixes: 628329d52474 ("Input: add IMS Passenger Control Unit driver")
Cc: stable@vger.kernel.org
Reported-by: Sashiko bot <sashiko-bot@kernel.org>
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/misc/ims-pcu.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/input/misc/ims-pcu.c
+++ b/drivers/input/misc/ims-pcu.c
@@ -2065,7 +2065,6 @@ err_free_mem:
 static void ims_pcu_disconnect(struct usb_interface *intf)
 {
 	struct ims_pcu *pcu = usb_get_intfdata(intf);
-	struct usb_host_interface *alt = intf->cur_altsetting;
 
 	usb_set_intfdata(intf, NULL);
 
@@ -2073,7 +2072,7 @@ static void ims_pcu_disconnect(struct us
 	 * See if we are dealing with control or data interface. The cleanup
 	 * happens when we unbind primary (control) interface.
 	 */
-	if (alt->desc.bInterfaceClass != USB_CLASS_COMM)
+	if (intf != pcu->ctrl_intf)
 		return;
 
 	sysfs_remove_group(&intf->dev.kobj, &ims_pcu_attr_group);


