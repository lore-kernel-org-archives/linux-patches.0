Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DD03B52FF;
	Tue, 21 Jul 2026 22:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672556; cv=none; b=aqqE+9x50EEAMgqc3CUfYm/rb5AaaPptdVsM3HNL0Iqa9JV47Uqn7jFNQQtp4Jjk21PaiSBkHFzUvuE+CUljRNZfh4Tk5YwicwsnXFGV2Y6B1u9tO3MC1t7AJmsp4uTjbK11PPtSszqGl/udUX0GpDfvwHpnON7putA2d7cvQUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672556; c=relaxed/simple;
	bh=h2pPxdf9BmwX8+28aNN1IKJJ1wA/dBOYa5FQsy9Mt5Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GP35HuRdAhIiNj1QCAwlFdRk7O4z61hyQCkb4/xITojo1Qxm8J9j1L2ShIah3Xe0l+5n9ys51Vs/W6oaXWIdAI7f5vZCLJ15yWv3eNAqT9jrp917jK+uBCRXD5z/moWPD0LxEAyuqpnyChnrxyyUV4emLI0qn6/llQbU0HHZcJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycJnlu88; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycJnlu88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0E371F000E9;
	Tue, 21 Jul 2026 22:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672555;
	bh=gBO5foak/uSNal7S+e3XNcwF01s8J5VYL0BSw2ok5Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ycJnlu88k0atbbSdOIAUFoFcLdLNQumXUu7FX0SA1S/HUWsui0KE9F0X9c7h3vBJt
	 u4KTFaza9NwkTuZkUMolmMLyQ4taUUgSZ4SIMrCZ9tT3jUKdYh4BB+jz52ROBcm3IR
	 oqEUeUTQ18sU3wBFDwkljAAsSRGXG/23jLg0JD8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.15 668/843] Input: ims-pcu - fix use-after-free and double-free in disconnect
Date: Tue, 21 Jul 2026 17:25:03 +0200
Message-ID: <20260721152421.089651289@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


