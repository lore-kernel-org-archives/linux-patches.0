Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5654611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:47:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32618C433EF;
	Sun, 28 May 2023 19:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303263;
	bh=BhDNn27Yu9vs0xcrGEcdpul8nBZT7A3wklMAHCkaJi4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0poaAmF3QVpHuGrbIGh/i5awPdDcV3CFXP5WTiookLWNRHXbsOc5+irpdTO6QtBS
	 5Cz7v7XZBzR9dxJ1rDnCNGCFTOKtGpWCBQbzuH75NZ37pq+8tGdGnD8kW7wtf1SgZg
	 bMY4dShDO/zw86ITrc4Yos0NXVV9F+On0+q/3PbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Elson Roy Serrao <quic_eserrao@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 01/69] usb: gadget: Properly configure the device for remote wakeup
Date: Sun, 28 May 2023 20:11:21 +0100
Message-Id: <20230528190828.408769873@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Elson Roy Serrao <quic_eserrao@quicinc.com>

[ Upstream commit b93c2a68f3d9dc98ec30dcb342ae47c1c8d09d18 ]

The wakeup bit in the bmAttributes field indicates whether the device
is configured for remote wakeup. But this field should be allowed to
set only if the UDC supports such wakeup mechanism. So configure this
field based on UDC capability. Also inform the UDC whether the device
is configured for remote wakeup by implementing a gadget op.

Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Elson Roy Serrao <quic_eserrao@quicinc.com>
Link: https://lore.kernel.org/r/1679694482-16430-2-git-send-email-quic_eserrao@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 4e8ef34e36f2 ("usb: dwc3: fix gadget mode suspend interrupt handler issue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/composite.c | 18 ++++++++++++++++++
 drivers/usb/gadget/configfs.c  |  3 +++
 drivers/usb/gadget/udc/core.c  | 27 +++++++++++++++++++++++++++
 drivers/usb/gadget/udc/trace.h |  5 +++++
 include/linux/usb/composite.h  |  2 ++
 include/linux/usb/gadget.h     |  8 ++++++++
 6 files changed, 63 insertions(+)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 553382ce38378..0886cff9aa1c0 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -498,6 +498,19 @@ static u8 encode_bMaxPower(enum usb_device_speed speed,
 		return min(val, 900U) / 8;
 }
 
+void check_remote_wakeup_config(struct usb_gadget *g,
+				struct usb_configuration *c)
+{
+	if (USB_CONFIG_ATT_WAKEUP & c->bmAttributes) {
+		/* Reset the rw bit if gadget is not capable of it */
+		if (!g->wakeup_capable && g->ops->set_remote_wakeup) {
+			WARN(c->cdev, "Clearing wakeup bit for config c.%d\n",
+			     c->bConfigurationValue);
+			c->bmAttributes &= ~USB_CONFIG_ATT_WAKEUP;
+		}
+	}
+}
+
 static int config_buf(struct usb_configuration *config,
 		enum usb_device_speed speed, void *buf, u8 type)
 {
@@ -945,6 +958,11 @@ static int set_config(struct usb_composite_dev *cdev,
 		power = min(power, 500U);
 	else
 		power = min(power, 900U);
+
+	if (USB_CONFIG_ATT_WAKEUP & c->bmAttributes)
+		usb_gadget_set_remote_wakeup(gadget, 1);
+	else
+		usb_gadget_set_remote_wakeup(gadget, 0);
 done:
 	if (power <= USB_SELF_POWER_VBUS_MAX_DRAW)
 		usb_gadget_set_selfpowered(gadget);
diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 5cbf4084daedc..528b9ec1d9e85 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1384,6 +1384,9 @@ static int configfs_composite_bind(struct usb_gadget *gadget,
 		if (gadget_is_otg(gadget))
 			c->descriptors = otg_desc;
 
+		/* Properly configure the bmAttributes wakeup bit */
+		check_remote_wakeup_config(gadget, c);
+
 		cfg = container_of(c, struct config_usb_cfg, c);
 		if (!list_empty(&cfg->string_list)) {
 			i = 0;
diff --git a/drivers/usb/gadget/udc/core.c b/drivers/usb/gadget/udc/core.c
index 61099f2d057dc..6c05a3a9b542f 100644
--- a/drivers/usb/gadget/udc/core.c
+++ b/drivers/usb/gadget/udc/core.c
@@ -508,6 +508,33 @@ int usb_gadget_wakeup(struct usb_gadget *gadget)
 }
 EXPORT_SYMBOL_GPL(usb_gadget_wakeup);
 
+/**
+ * usb_gadget_set_remote_wakeup - configures the device remote wakeup feature.
+ * @gadget:the device being configured for remote wakeup
+ * @set:value to be configured.
+ *
+ * set to one to enable remote wakeup feature and zero to disable it.
+ *
+ * returns zero on success, else negative errno.
+ */
+int usb_gadget_set_remote_wakeup(struct usb_gadget *gadget, int set)
+{
+	int ret = 0;
+
+	if (!gadget->ops->set_remote_wakeup) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
+
+	ret = gadget->ops->set_remote_wakeup(gadget, set);
+
+out:
+	trace_usb_gadget_set_remote_wakeup(gadget, ret);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(usb_gadget_set_remote_wakeup);
+
 /**
  * usb_gadget_set_selfpowered - sets the device selfpowered feature.
  * @gadget:the device being declared as self-powered
diff --git a/drivers/usb/gadget/udc/trace.h b/drivers/usb/gadget/udc/trace.h
index 98584f6b6c662..428819311afbf 100644
--- a/drivers/usb/gadget/udc/trace.h
+++ b/drivers/usb/gadget/udc/trace.h
@@ -91,6 +91,11 @@ DEFINE_EVENT(udc_log_gadget, usb_gadget_wakeup,
 	TP_ARGS(g, ret)
 );
 
+DEFINE_EVENT(udc_log_gadget, usb_gadget_set_remote_wakeup,
+	TP_PROTO(struct usb_gadget *g, int ret),
+	TP_ARGS(g, ret)
+);
+
 DEFINE_EVENT(udc_log_gadget, usb_gadget_set_selfpowered,
 	TP_PROTO(struct usb_gadget *g, int ret),
 	TP_ARGS(g, ret)
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 9d27622792867..0399d1226323b 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -426,6 +426,8 @@ extern int composite_dev_prepare(struct usb_composite_driver *composite,
 extern int composite_os_desc_req_prepare(struct usb_composite_dev *cdev,
 					 struct usb_ep *ep0);
 void composite_dev_cleanup(struct usb_composite_dev *cdev);
+void check_remote_wakeup_config(struct usb_gadget *g,
+				struct usb_configuration *c);
 
 static inline struct usb_composite_driver *to_cdriver(
 		struct usb_gadget_driver *gdrv)
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index 10fe57cf40bec..c5bc739266ed6 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -311,6 +311,7 @@ struct usb_udc;
 struct usb_gadget_ops {
 	int	(*get_frame)(struct usb_gadget *);
 	int	(*wakeup)(struct usb_gadget *);
+	int	(*set_remote_wakeup)(struct usb_gadget *, int set);
 	int	(*set_selfpowered) (struct usb_gadget *, int is_selfpowered);
 	int	(*vbus_session) (struct usb_gadget *, int is_active);
 	int	(*vbus_draw) (struct usb_gadget *, unsigned mA);
@@ -385,6 +386,8 @@ struct usb_gadget_ops {
  * @connected: True if gadget is connected.
  * @lpm_capable: If the gadget max_speed is FULL or HIGH, this flag
  *	indicates that it supports LPM as per the LPM ECN & errata.
+ * @wakeup_capable: True if gadget is capable of sending remote wakeup.
+ * @wakeup_armed: True if gadget is armed by the host for remote wakeup.
  * @irq: the interrupt number for device controller.
  *
  * Gadgets have a mostly-portable "gadget driver" implementing device
@@ -445,6 +448,8 @@ struct usb_gadget {
 	unsigned			deactivated:1;
 	unsigned			connected:1;
 	unsigned			lpm_capable:1;
+	unsigned			wakeup_capable:1;
+	unsigned			wakeup_armed:1;
 	int				irq;
 };
 #define work_to_gadget(w)	(container_of((w), struct usb_gadget, work))
@@ -600,6 +605,7 @@ static inline int gadget_is_otg(struct usb_gadget *g)
 #if IS_ENABLED(CONFIG_USB_GADGET)
 int usb_gadget_frame_number(struct usb_gadget *gadget);
 int usb_gadget_wakeup(struct usb_gadget *gadget);
+int usb_gadget_set_remote_wakeup(struct usb_gadget *gadget, int set);
 int usb_gadget_set_selfpowered(struct usb_gadget *gadget);
 int usb_gadget_clear_selfpowered(struct usb_gadget *gadget);
 int usb_gadget_vbus_connect(struct usb_gadget *gadget);
@@ -615,6 +621,8 @@ static inline int usb_gadget_frame_number(struct usb_gadget *gadget)
 { return 0; }
 static inline int usb_gadget_wakeup(struct usb_gadget *gadget)
 { return 0; }
+static inline int usb_gadget_set_remote_wakeup(struct usb_gadget *gadget, int set)
+{ return 0; }
 static inline int usb_gadget_set_selfpowered(struct usb_gadget *gadget)
 { return 0; }
 static inline int usb_gadget_clear_selfpowered(struct usb_gadget *gadget)
-- 
2.39.2



