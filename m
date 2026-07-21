Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86E643C063;
	Tue, 21 Jul 2026 20:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667560; cv=none; b=eAQeS8i28AJvptB44itVpDSQv1+tt4eyf0va34Cqh91OGjwBKGpi1qYwnygPavljPkd9D8gMrLAeu8mhsNkaww7A2jREu0LWnY14qE9FuwDH2cAmDgENBuujCSxkIp3Vt+bzXSbLYwkZu/LLq5mdcasbltU3+oon/11ot9QtKjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667560; c=relaxed/simple;
	bh=Nr8rTgkT3G8qxZrlIFCtjgLwR8V9XPmkousDA+b9tv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DWn1FIbMa+1UKGgJ2UHMoe7VFtdl6W+AVLkI8KeOHizD4b7h57cKSMcc44qsu9MzZD8yjYh/5WNivbcJ623ueewO92wbGc4EjxkpjBR/o2KUZixBc/opunO//9XWO4yp32kzJC6a+WvlnnMAq0EpGkbOCIr/JRk6lEwrDmi71H4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GHWYTfRz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GHWYTfRz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7C5C1F00A3A;
	Tue, 21 Jul 2026 20:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667559;
	bh=TqK7BGYyMEGHvzhRkV8vO4j/ey3rP3oyQN+oX9q1H1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GHWYTfRzs5O55QeNVSqs4/HZe4p3tuW45eam+q3Ay5/wTIRcM7G7I4Mhv95cJWUgI
	 hI58oBMHQsu+cu/V5UbQk9FTjwGd+Xa7kT0VmoyzBxImo2Nnoa6C7wiyLYainzoxA2
	 KGHqOu2h0MdPMurDGdwwht4JeJfe/6v3DW/cuGAY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko bot <sashiko-bot@kernel.org>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 1065/1266] Input: ims-pcu - fix use-after-free and double-free in disconnect
Date: Tue, 21 Jul 2026 17:25:02 +0200
Message-ID: <20260721152505.653716861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


