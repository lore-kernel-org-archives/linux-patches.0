Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930B91D122;
	Mon, 18 Dec 2023 14:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cE/Bc9sG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A724C433C7;
	Mon, 18 Dec 2023 14:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702908566;
	bh=usnmf4l9PMLFLwaXl+K8R7On1t/Sh/79Wx9dgu6RQrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cE/Bc9sGh2Scdhft0p9Oi+S2zIjpagCxtw6+4KpF23Lw8i9Wyct+gg4FdhDDgDllv
	 8dCfoXMWGPHip6VhfGAw/A8SjpRTyFRXdK6tVZqx/XONPa+aN5AetmFR+Sk1rtHliY
	 Q/ejKpGArgK5nUjKYiiqK4V6YElgBw0ZRDgUk4gw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Luo <royluo@google.com>
Subject: [PATCH 5.10 57/62] USB: gadget: core: adjust uevent timing on gadget unbind
Date: Mon, 18 Dec 2023 14:52:21 +0100
Message-ID: <20231218135048.734995339@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231218135046.178317233@linuxfoundation.org>
References: <20231218135046.178317233@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Roy Luo <royluo@google.com>

commit 73ea73affe8622bdf292de898da869d441da6a9d upstream.

The KOBJ_CHANGE uevent is sent before gadget unbind is actually
executed, resulting in inaccurate uevent emitted at incorrect timing
(the uevent would have USB_UDC_DRIVER variable set while it would
soon be removed).
Move the KOBJ_CHANGE uevent to the end of the unbind function so that
uevent is sent only after the change has been made.

Fixes: 2ccea03a8f7e ("usb: gadget: introduce UDC Class")
Cc: stable@vger.kernel.org
Signed-off-by: Roy Luo <royluo@google.com>
Link: https://lore.kernel.org/r/20231128221756.2591158-1-royluo@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1353,8 +1353,6 @@ static void usb_gadget_remove_driver(str
 	dev_dbg(&udc->dev, "unregistering UDC driver [%s]\n",
 			udc->driver->function);
 
-	kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);
-
 	usb_gadget_disconnect(udc->gadget);
 	if (udc->gadget->irq)
 		synchronize_irq(udc->gadget->irq);
@@ -1363,6 +1361,8 @@ static void usb_gadget_remove_driver(str
 
 	udc->driver = NULL;
 	udc->gadget->dev.driver = NULL;
+
+	kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);
 }
 
 /**


