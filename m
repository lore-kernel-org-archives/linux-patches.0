Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2D951C2D;
	Mon, 11 Dec 2023 18:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oiJDBw91"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F64C433C7;
	Mon, 11 Dec 2023 18:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320757;
	bh=tOBpnxqj9sdAwj9WSKBmHed7WrpBG/uN6RtRahJ5xKo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oiJDBw912YfEAN7NDd2cu0/oOA8OssxH1C6zYREVTMV72T3znC/keP/SuDnz39aKf
	 tAm9P+m6DTMFGkCK5638wKLSap2RjA1l2rmm92EClHUZHsJFvvrR24ulK3BPbynWUd
	 Cr7CqOy1vncNcW+h0IFCKQHiLReebXqWJuD+XcDk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roy Luo <royluo@google.com>
Subject: [PATCH 6.1 180/194] USB: gadget: core: adjust uevent timing on gadget unbind
Date: Mon, 11 Dec 2023 19:22:50 +0100
Message-ID: <20231211182044.692708493@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
---
 drivers/usb/gadget/udc/core.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -1608,8 +1608,6 @@ static void gadget_unbind_driver(struct
 
 	dev_dbg(&udc->dev, "unbinding gadget driver [%s]\n", driver->function);
 
-	kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);
-
 	udc->allow_connect = false;
 	cancel_work_sync(&udc->vbus_work);
 	mutex_lock(&udc->connect_lock);
@@ -1629,6 +1627,8 @@ static void gadget_unbind_driver(struct
 	driver->is_bound = false;
 	udc->driver = NULL;
 	mutex_unlock(&udc_lock);
+
+	kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);
 }
 
 /* ------------------------------------------------------------------------- */


