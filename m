Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5657115B10D;
	Mon, 28 Oct 2024 06:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097117; cv=none; b=opmqdjl5+yJuHAh/ro7+LFtQb2mq0ixJRrNK5qB1F+XwD4RrECgoBxP143npqIFR2Vx8zUFk6P6a5T8Ilfnw8op1CByyMBY4W45E+A26BhlL7xdZDCF7aFuwk4tVnQlUjCS+4CgkvkTbfVuLi7EreADtVkVASi69WHqdr7MFD2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097117; c=relaxed/simple;
	bh=ZCUsB4ur38sytrwyAG2BghZ/1xKLJ0M4pz6vpla9O5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCL/N1uLKYoQtfuLVIP4JUgqBZIAl/rQ1LeVPcUCE7osE6DKfYeG8QeQcUKiv7i1l1XYUzj8uiIcF7pBVsqdbE7mcuuQBTqnsq1OslznN5jB4LUus0QyZrgkDU8HJ0K6WKVWc/juhvooOiresrngE7hyIB1GbN/KYAEV+EZ2TdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f0QYcAij; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f0QYcAij"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA078C4CEC7;
	Mon, 28 Oct 2024 06:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097117;
	bh=ZCUsB4ur38sytrwyAG2BghZ/1xKLJ0M4pz6vpla9O5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f0QYcAijb+Ze7PAdE5B//7uzg57HhV8Skt22gsRqoRSBej0xHeN1VzPKvoOoetSIh
	 65BBHaKWLR9aR/Q5eybjcmX7l/4pjODuSputiq7sfORMpoDeOEo8W0D+eXMu3WZZc6
	 ePhCiLbWXpT4lmWckv4Z8x1HF17NJUiVKp1dh4aA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
	Elson Roy Serrao <quic_eserrao@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 36/80] usb: gadget: Add function wakeup support
Date: Mon, 28 Oct 2024 07:25:16 +0100
Message-ID: <20241028062253.627919704@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062252.611837461@linuxfoundation.org>
References: <20241028062252.611837461@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elson Roy Serrao <quic_eserrao@quicinc.com>

[ Upstream commit f0db885fb05d35befa81896db6b19eb3ee9ccdfe ]

USB3.2 spec section 9.2.5.4 quotes that a function may signal that
it wants to exit from Function Suspend by sending a Function
Wake Notification to the host if it is enabled for function
remote wakeup. Add an api in composite layer that can be used
by the function drivers to support this feature. Also expose
a gadget op so that composite layer can trigger a wakeup request
to the UDC driver.

Reviewed-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Signed-off-by: Elson Roy Serrao <quic_eserrao@quicinc.com>
Link: https://lore.kernel.org/r/1679694482-16430-4-git-send-email-quic_eserrao@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 705e3ce37bcc ("usb: dwc3: core: Fix system suspend on TI AM62 platforms")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/composite.c | 40 ++++++++++++++++++++++++++++++++++
 include/linux/usb/composite.h  |  6 +++++
 include/linux/usb/gadget.h     |  1 +
 3 files changed, 47 insertions(+)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 3f035e905b242..1052ca4e29bc1 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -477,6 +477,46 @@ int usb_interface_id(struct usb_configuration *config,
 }
 EXPORT_SYMBOL_GPL(usb_interface_id);
 
+/**
+ * usb_func_wakeup - sends function wake notification to the host.
+ * @func: function that sends the remote wakeup notification.
+ *
+ * Applicable to devices operating at enhanced superspeed when usb
+ * functions are put in function suspend state and armed for function
+ * remote wakeup. On completion, function wake notification is sent. If
+ * the device is in low power state it tries to bring the device to active
+ * state before sending the wake notification. Since it is a synchronous
+ * call, caller must take care of not calling it in interrupt context.
+ * For devices operating at lower speeds  returns negative errno.
+ *
+ * Returns zero on success, else negative errno.
+ */
+int usb_func_wakeup(struct usb_function *func)
+{
+	struct usb_gadget	*gadget = func->config->cdev->gadget;
+	int			id;
+
+	if (!gadget->ops->func_wakeup)
+		return -EOPNOTSUPP;
+
+	if (!func->func_wakeup_armed) {
+		ERROR(func->config->cdev, "not armed for func remote wakeup\n");
+		return -EINVAL;
+	}
+
+	for (id = 0; id < MAX_CONFIG_INTERFACES; id++)
+		if (func->config->interface[id] == func)
+			break;
+
+	if (id == MAX_CONFIG_INTERFACES) {
+		ERROR(func->config->cdev, "Invalid function\n");
+		return -EINVAL;
+	}
+
+	return gadget->ops->func_wakeup(gadget, id);
+}
+EXPORT_SYMBOL_GPL(usb_func_wakeup);
+
 static u8 encode_bMaxPower(enum usb_device_speed speed,
 		struct usb_configuration *c)
 {
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 0399d1226323b..456fca4d6a253 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -163,6 +163,9 @@ struct usb_os_desc_table {
  *	GetStatus() request when the recipient is Interface.
  * @func_suspend: callback to be called when
  *	SetFeature(FUNCTION_SUSPEND) is reseived
+ * @func_suspended: Indicates whether the function is in function suspend state.
+ * @func_wakeup_armed: Indicates whether the function is armed by the host for
+ *	wakeup signaling.
  *
  * A single USB function uses one or more interfaces, and should in most
  * cases support operation at both full and high speeds.  Each function is
@@ -233,6 +236,8 @@ struct usb_function {
 	int			(*get_status)(struct usb_function *);
 	int			(*func_suspend)(struct usb_function *,
 						u8 suspend_opt);
+	bool			func_suspended;
+	bool			func_wakeup_armed;
 	/* private: */
 	/* internals */
 	struct list_head		list;
@@ -254,6 +259,7 @@ int config_ep_by_speed_and_alt(struct usb_gadget *g, struct usb_function *f,
 
 int config_ep_by_speed(struct usb_gadget *g, struct usb_function *f,
 			struct usb_ep *_ep);
+int usb_func_wakeup(struct usb_function *func);
 
 #define	MAX_CONFIG_INTERFACES		16	/* arbitrary; max 255 */
 
diff --git a/include/linux/usb/gadget.h b/include/linux/usb/gadget.h
index c5bc739266ed6..e4feeaa8bab30 100644
--- a/include/linux/usb/gadget.h
+++ b/include/linux/usb/gadget.h
@@ -311,6 +311,7 @@ struct usb_udc;
 struct usb_gadget_ops {
 	int	(*get_frame)(struct usb_gadget *);
 	int	(*wakeup)(struct usb_gadget *);
+	int	(*func_wakeup)(struct usb_gadget *gadget, int intf_id);
 	int	(*set_remote_wakeup)(struct usb_gadget *, int set);
 	int	(*set_selfpowered) (struct usb_gadget *, int is_selfpowered);
 	int	(*vbus_session) (struct usb_gadget *, int is_active);
-- 
2.43.0



