Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF0C46F49C;
	Tue, 21 Jul 2026 19:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663971; cv=none; b=CdUOLsCvpOjYC8L5sNy5640f99h+XLZgYvYrgqVzuUnc4okLenz/7gQ3aB9iedr3cS7LHWqLEq33rB/q5mWMtl7jG4szzj0aVhn87e624KsCfRbk+WjQHixgMqPg/5sqtNBq/cwzGKSreargWgGJ0xq9fDVOD8QuvxgprRW3/k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663971; c=relaxed/simple;
	bh=KFSTOnqcUfaq557xEPbEv87bkwby+2v6YuTvFSNQ3Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hoHspCuhlN6yszobbSCl6IvmOkzUVHAIoaLoxFBYnT0ZLu3VMHI8+qs4rjkdvQ64RPdYZc9Rqc4PkqgNafS650tLaFN7eTvGKYigRhKJfpIDl/dOheVNdUZCivqcIFmAlyur4qo+PyXJOzAdcQLXTmmP0EQsH4QSmpjApSoerSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggBatWUw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggBatWUw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76CE51F000E9;
	Tue, 21 Jul 2026 19:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663970;
	bh=WnyWOSZxQ37VViwCcvV3TNRwc9YmmhTy+qU2nHv7+Hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ggBatWUwbTAkdHE/VIHyxmQeh6fUtRSKlgwR3G84Y77LVdIgsIMmnTqHQWUCOMKin
	 NYiPfqLB9OnHZtikwgZxBawbF8b8VaMBBLZA7aUlkwxnBUwm8i4/LuZsKOkA2Mk+UI
	 3y/BFHZn57rhWGDVsb06jzdfw3LK9CLqz9blgQdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 1025/1276] Input: ims-pcu - fix use-after-free and double-free in disconnect
Date: Tue, 21 Jul 2026 17:24:28 +0200
Message-ID: <20260721152508.934349596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2051,7 +2051,6 @@ err_free_mem:
 static void ims_pcu_disconnect(struct usb_interface *intf)
 {
 	struct ims_pcu *pcu = usb_get_intfdata(intf);
-	struct usb_host_interface *alt = intf->cur_altsetting;
 
 	usb_set_intfdata(intf, NULL);
 
@@ -2059,7 +2058,7 @@ static void ims_pcu_disconnect(struct us
 	 * See if we are dealing with control or data interface. The cleanup
 	 * happens when we unbind primary (control) interface.
 	 */
-	if (alt->desc.bInterfaceClass != USB_CLASS_COMM)
+	if (intf != pcu->ctrl_intf)
 		return;
 
 	ims_pcu_stop_io(pcu);


