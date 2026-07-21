Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE953F825C;
	Tue, 21 Jul 2026 22:52:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674378; cv=none; b=NJdV3JQYoU9ARfgT1iMc2L9R7QpQFREkZk4X2QuC3Mrfyw6PBj7+XbAvvJpHUqJki+jqP/oMJ99AKeDd6vEaHHMQn7ECiZMxnq9i8J51QfEwkudPbrpGgyPjbge3GyVw6Dkx/M/IUdceiupZOCkYzJZdUkoIRcWCj/E36BNsV0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674378; c=relaxed/simple;
	bh=RoNSl+r88jvH2akV5389enBb8GBvUGohxEZP0Q/udtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2p9g48GX/iTOzPbnN+BWh/I6N1O5VGH8DgR9F4KUrXquhvnGk3MzI8XSyTXG9FAGZ8Tx/Mqy/W2IRG2Bc/TrIiZGy1zYQNu2dQGzqU4qQ24xVtJlK7uMp3FA97n4c/C83eA+VIWhIDz1T9nEnMoTSKDUUUtk1MKPtcpEJLjb9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FJZRwlgc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FJZRwlgc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15F3B1F000E9;
	Tue, 21 Jul 2026 22:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674376;
	bh=LS76WWuAqiCIaTCGFuiL+GjItztiZ5szoQxBI5LlL6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FJZRwlgc+5VwtrS+d4rxckGpOB5zEwgz0ZXRjXxDemMdoUxDPqxKPuvNiEJDLAU+l
	 +n7EnsrPCX/9cAv1pwgFIMLZC7juMIV6cVrhFxNimM48eWe+LoM4Rk8sWAid2eetXp
	 Iu7BGJB6+Tk+QdA5t3vGsTPcyvbVtDuaUN3MLQko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 518/699] Input: ims-pcu - fix use-after-free and double-free in disconnect
Date: Tue, 21 Jul 2026 17:24:37 +0200
Message-ID: <20260721152407.383823588@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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
@@ -2066,7 +2066,6 @@ err_free_mem:
 static void ims_pcu_disconnect(struct usb_interface *intf)
 {
 	struct ims_pcu *pcu = usb_get_intfdata(intf);
-	struct usb_host_interface *alt = intf->cur_altsetting;
 
 	usb_set_intfdata(intf, NULL);
 
@@ -2074,7 +2073,7 @@ static void ims_pcu_disconnect(struct us
 	 * See if we are dealing with control or data interface. The cleanup
 	 * happens when we unbind primary (control) interface.
 	 */
-	if (alt->desc.bInterfaceClass != USB_CLASS_COMM)
+	if (intf != pcu->ctrl_intf)
 		return;
 
 	sysfs_remove_group(&intf->dev.kobj, &ims_pcu_attr_group);


