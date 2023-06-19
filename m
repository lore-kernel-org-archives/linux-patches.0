Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAE98C06
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4653C433CA;
	Mon, 19 Jun 2023 10:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171663;
	bh=PMEAXbvyLcJiV4pi5D8rwNVt4Be/Zf0x+WB38b8ei+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g6YnAQ6TuPiGFCcZCCJ/m5HpMUPQklwGNOwXPyAOxKaZJVb4z5+bzgg3Fs7H/vFPL
	 kn79IemIPhoej0BCtuXHa2XWceOnsQhkmcEPY3Bo8aVx85IwpSiL8v8eA4Ol7iYEbe
	 DeVoxCl4tEUrm1qlXeD8mRF8Srpc5y8FoAip5BAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Badhri Jagan Sridharan <badhri@google.com>,
	Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 6.1 085/166] usb: gadget: udc: core: Offload usb_udc_vbus_handler processing
Date: Mon, 19 Jun 2023 12:29:22 +0200
Message-ID: <20230619102158.921563472@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Badhri Jagan Sridharan <badhri@google.com>

commit 50966da807c81c5eb3bdfd392990fe0bba94d1ee upstream.

usb_udc_vbus_handler() can be invoked from interrupt context by irq
handlers of the gadget drivers, however, usb_udc_connect_control() has
to run in non-atomic context due to the following:
a. Some of the gadget driver implementations expect the ->pullup
   callback to be invoked in non-atomic context.
b. usb_gadget_disconnect() acquires udc_lock which is a mutex.

Hence offload invocation of usb_udc_connect_control()
to workqueue.

UDC should not be pulled up unless gadget driver is bound. The new flag
"allow_connect" is now set by gadget_bind_driver() and cleared by
gadget_unbind_driver(). This prevents work item to pull up the gadget
even if queued when the gadget driver is already unbound.

Cc: stable@vger.kernel.org
Fixes: 1016fc0c096c ("USB: gadget: Fix obscure lockdep violation for udc_mutex")
Signed-off-by: Badhri Jagan Sridharan <badhri@google.com>
Reviewed-by: Alan Stern <stern@rowland.harvard.edu>
Message-ID: <20230609010227.978661-1-badhri@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/udc/core.c |   29 +++++++++++++++++++++++++++--
 1 file changed, 27 insertions(+), 2 deletions(-)

--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -37,6 +37,9 @@ static struct bus_type gadget_bus_type;
  * @vbus: for udcs who care about vbus status, this value is real vbus status;
  * for udcs who do not care about vbus status, this value is always true
  * @started: the UDC's started state. True if the UDC had started.
+ * @allow_connect: Indicates whether UDC is allowed to be pulled up.
+ * Set/cleared by gadget_(un)bind_driver() after gadget driver is bound or
+ * unbound.
  *
  * This represents the internal data structure which is used by the UDC-class
  * to hold information about udc driver and gadget together.
@@ -48,6 +51,8 @@ struct usb_udc {
 	struct list_head		list;
 	bool				vbus;
 	bool				started;
+	bool				allow_connect;
+	struct work_struct		vbus_work;
 };
 
 static struct class *udc_class;
@@ -679,7 +684,7 @@ int usb_gadget_connect(struct usb_gadget
 		goto out;
 	}
 
-	if (gadget->deactivated) {
+	if (gadget->deactivated || !gadget->udc->allow_connect) {
 		/*
 		 * If gadget is deactivated we only save new state.
 		 * Gadget will be connected automatically after activation.
@@ -1059,6 +1064,13 @@ static void usb_udc_connect_control(stru
 		usb_gadget_disconnect(udc->gadget);
 }
 
+static void vbus_event_work(struct work_struct *work)
+{
+	struct usb_udc *udc = container_of(work, struct usb_udc, vbus_work);
+
+	usb_udc_connect_control(udc);
+}
+
 /**
  * usb_udc_vbus_handler - updates the udc core vbus status, and try to
  * connect or disconnect gadget
@@ -1067,6 +1079,14 @@ static void usb_udc_connect_control(stru
  *
  * The udc driver calls it when it wants to connect or disconnect gadget
  * according to vbus status.
+ *
+ * This function can be invoked from interrupt context by irq handlers of
+ * the gadget drivers, however, usb_udc_connect_control() has to run in
+ * non-atomic context due to the following:
+ * a. Some of the gadget driver implementations expect the ->pullup
+ * callback to be invoked in non-atomic context.
+ * b. usb_gadget_disconnect() acquires udc_lock which is a mutex.
+ * Hence offload invocation of usb_udc_connect_control() to workqueue.
  */
 void usb_udc_vbus_handler(struct usb_gadget *gadget, bool status)
 {
@@ -1074,7 +1094,7 @@ void usb_udc_vbus_handler(struct usb_gad
 
 	if (udc) {
 		udc->vbus = status;
-		usb_udc_connect_control(udc);
+		schedule_work(&udc->vbus_work);
 	}
 }
 EXPORT_SYMBOL_GPL(usb_udc_vbus_handler);
@@ -1301,6 +1321,7 @@ int usb_add_gadget(struct usb_gadget *ga
 	mutex_lock(&udc_lock);
 	list_add_tail(&udc->list, &udc_list);
 	mutex_unlock(&udc_lock);
+	INIT_WORK(&udc->vbus_work, vbus_event_work);
 
 	ret = device_add(&udc->dev);
 	if (ret)
@@ -1432,6 +1453,7 @@ void usb_del_gadget(struct usb_gadget *g
 	flush_work(&gadget->work);
 	device_del(&gadget->dev);
 	ida_free(&gadget_id_numbers, gadget->id_number);
+	cancel_work_sync(&udc->vbus_work);
 	device_unregister(&udc->dev);
 }
 EXPORT_SYMBOL_GPL(usb_del_gadget);
@@ -1500,6 +1522,7 @@ static int gadget_bind_driver(struct dev
 	if (ret)
 		goto err_start;
 	usb_gadget_enable_async_callbacks(udc);
+	udc->allow_connect = true;
 	usb_udc_connect_control(udc);
 
 	kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);
@@ -1531,6 +1554,8 @@ static void gadget_unbind_driver(struct
 
 	kobject_uevent(&udc->dev.kobj, KOBJ_CHANGE);
 
+	udc->allow_connect = false;
+	cancel_work_sync(&udc->vbus_work);
 	usb_gadget_disconnect(gadget);
 	usb_gadget_disable_async_callbacks(udc);
 	if (gadget->irq)


