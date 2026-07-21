Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED323415F0C;
	Tue, 21 Jul 2026 22:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784674765; cv=none; b=uxqdqNcm5DlL7xC/8OC1fiy4ywmbDCDQfA6e3xWY2yZmR2V+xB6luFGEyVIoJsL4cP6rlJrLKeKqnnuIL3d/GZKQxQ+Lp2Kec7QRcRZysDkpwmlRQ2uHnt/xAdzfT3bG5KnIJl8XVd64UE+cn9uSTGl6BIO4yJVO48mUXWZ0iAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784674765; c=relaxed/simple;
	bh=6scZNRqzUtyR7bimD/5brwwGhNjos/Meg/NMJ3PBp6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FyZ0xsh0oj9yWIS14KdaXSb5xe5kBpk55jqQUZM9flwAaWFd5/rTLaZgBAFd046caDvEOgpx8rrUuadZAM+JHteyWqMsbNDCmAPytRPa4UN3T4/1solkLsWIeNCg8nUWiFbTQcMQF+wuObJOMXRefbq15hTnUFVBUmFGxchMol8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1dKydEoE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1dKydEoE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4F81F00A3A;
	Tue, 21 Jul 2026 22:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784674763;
	bh=eKdjfTQ83m3vpQLAJk6KCpFn4whgdvYE0INxXajUI18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1dKydEoELkmRzO9B47xcgVMxdwVz2bfN+o0TSVKXTvr6FyGjJ/CP7Z7YnFeSpi/AA
	 KgdxDKshXjkER8GeEgNnQHhfsGLO2eVORqs3mPxEjfD69+/KulQ/MVuI7pPmr1RGda
	 2f/tJOMdX9wwUd4X0XabKydMdjaVGuX3wzgfHPY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Pietrasiewicz <andrzej.p@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 663/699] usb: gadget: function: Simplify diagnostic messaging in printer
Date: Tue, 21 Jul 2026 17:27:02 +0200
Message-ID: <20260721152410.722844814@linuxfoundation.org>
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

From: Andrzej Pietrasiewicz <andrzej.p@collabora.com>

[ Upstream commit 57b7b733b1a7aeab25bc2670afff608214284863 ]

Don't issue messages which can be easily achieved with ftrace.
In case of printer_open() the return code is propagated to other layers
so the user will know about -EBUSY anyway.

Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@collabora.com>
Link: https://lore.kernel.org/r/20221123110746.59611-1-andrzej.p@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 30adce93d5c4 ("usb: gadget: f_printer: take kref only for successful open")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_printer.c |    9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

--- a/drivers/usb/gadget/function/f_printer.c
+++ b/drivers/usb/gadget/function/f_printer.c
@@ -363,7 +363,7 @@ printer_open(struct inode *inode, struct
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	kref_get(&dev->kref);
-	DBG(dev, "printer_open returned %x\n", ret);
+
 	return ret;
 }
 
@@ -381,7 +381,6 @@ printer_close(struct inode *inode, struc
 	spin_unlock_irqrestore(&dev->lock, flags);
 
 	kref_put(&dev->kref, printer_dev_free);
-	DBG(dev, "printer_close\n");
 
 	return 0;
 }
@@ -867,8 +866,6 @@ static void printer_reset_interface(stru
 	if (dev->interface < 0)
 		return;
 
-	DBG(dev, "%s\n", __func__);
-
 	if (dev->in_ep->desc)
 		usb_ep_disable(dev->in_ep);
 
@@ -906,8 +903,6 @@ static void printer_soft_reset(struct pr
 {
 	struct usb_request	*req;
 
-	INFO(dev, "Received Printer Reset Request\n");
-
 	if (usb_ep_disable(dev->in_ep))
 		DBG(dev, "Failed to disable USB in_ep\n");
 	if (usb_ep_disable(dev->out_ep))
@@ -1204,8 +1199,6 @@ static void printer_func_disable(struct
 {
 	struct printer_dev *dev = func_to_printer(f);
 
-	DBG(dev, "%s\n", __func__);
-
 	printer_reset_interface(dev);
 }
 


