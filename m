Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30242BCF4C;
	Sat, 12 Sep 2026 16:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229062; cv=none; b=No8xeyR8wsaAW1OLOzbeeaMNSjIz1tE6jetJGj4g1NnMtYhVSzgyjDqLtrOdOg+WmBoE+3qN0C9bDn4JewCZlb6g5nrDEzwKvannzqvYtwqMGVYjoyhlDjhL4b+9pC+IshrrJYm6OlmdUxT9n+TTQSRXBekKaT2ELec3I2HpcIY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229062; c=relaxed/simple;
	bh=5QJYcCWqdCx+aOFa0ltDPDawRRRlu9pp6lIRKvztPOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cOko9mCJQNcqIZaQ2tQxGXbXDbmw95zQCio4RT1H93kwjpomQb4OVIyXq5ckMvDtyLPKXqaUCs0v0U48Wvsbhab7trKmeYD9ZiyqotlwP0yUOdkyreduAAGI2AzZtHm/ci+vrzDxzGIuP3Gq/zICf7oRiB5+7UtLUrCQbKsWwEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L6+kawBL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L6+kawBL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6CF31F000FF;
	Sat, 12 Sep 2026 16:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229060;
	bh=fHL5pmYRa57zAPxFkp0aDPQ6pIq/cJsFxm46kf6EeeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L6+kawBL/Ni9wAevV/ygvGm6yKRZevpYlBVtx4925jW0lx2HxaT39G8oyZmTZTnDd
	 rXh5TzRY5Ax9Q3N1x9hl51CWL+d/I+ZtYOjBDEur7ecKaJ0GnwbB1u10CedUwnmAxv
	 3VLdoAYb8CsIOONXRFkHgobZaNcVpV+DEzhbuA4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Prashant Malani <pmalani@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0471/1191] usb: typec: Add partner PD object wrapper
Date: Sat, 12 Sep 2026 08:53:19 +0200
Message-ID: <20260912065558.812944808@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Prashant Malani <pmalani@chromium.org>

[ Upstream commit 032399819dd5f135e6ffe446c8e97ab54eec3464 ]

Some port drivers may want to set a Type-C partner as a parent for a
USB Power Delivery object, but the Type-C partner struct isn't exposed
outside of the Type-C class driver. Add a wrapper to
usb_power_delivery_register() which sets the provided Type-C partner
as a parent to the USB PD object. This helps to avoid exposing the
Type-C partner's device struct unnecessarily.

Cc: Benson Leung <bleung@chromium.org>
Suggested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Prashant Malani <pmalani@chromium.org>
Link: https://lore.kernel.org/r/20221122220538.2991775-2-pmalani@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a0a8cd9fc9c4 ("platform/chrome: cros_ec_typec: Reject out-of-bounds PD cap count")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/class.c | 19 +++++++++++++++++++
 include/linux/usb/typec.h |  4 ++++
 2 files changed, 23 insertions(+)

diff --git a/drivers/usb/typec/class.c b/drivers/usb/typec/class.c
index a8e04beb3bc07..95a026d3a0664 100644
--- a/drivers/usb/typec/class.c
+++ b/drivers/usb/typec/class.c
@@ -827,6 +827,25 @@ void typec_partner_set_svdm_version(struct typec_partner *partner,
 }
 EXPORT_SYMBOL_GPL(typec_partner_set_svdm_version);
 
+/**
+ * typec_partner_usb_power_delivery_register - Register Type-C partner USB Power Delivery Support
+ * @partner: Type-C partner device.
+ * @desc: Description of the USB PD contract.
+ *
+ * This routine is a wrapper around usb_power_delivery_register(). It registers
+ * USB Power Delivery Capabilities for a Type-C partner device. Specifically,
+ * it sets the Type-C partner device as a parent for the resulting USB Power Delivery object.
+ *
+ * Returns handle to struct usb_power_delivery or ERR_PTR.
+ */
+struct usb_power_delivery *
+typec_partner_usb_power_delivery_register(struct typec_partner *partner,
+					  struct usb_power_delivery_desc *desc)
+{
+	return usb_power_delivery_register(&partner->dev, desc);
+}
+EXPORT_SYMBOL_GPL(typec_partner_usb_power_delivery_register);
+
 /**
  * typec_register_partner - Register a USB Type-C Partner
  * @port: The USB Type-C Port the partner is connected to
diff --git a/include/linux/usb/typec.h b/include/linux/usb/typec.h
index 7751bedcae5dd..8fa781207970a 100644
--- a/include/linux/usb/typec.h
+++ b/include/linux/usb/typec.h
@@ -23,6 +23,7 @@ struct fwnode_handle;
 struct device;
 
 struct usb_power_delivery;
+struct usb_power_delivery_desc;
 
 enum typec_port_type {
 	TYPEC_PORT_SRC,
@@ -327,6 +328,9 @@ void typec_partner_set_svdm_version(struct typec_partner *partner,
 				    enum usb_pd_svdm_ver svdm_version);
 int typec_get_negotiated_svdm_version(struct typec_port *port);
 
+struct usb_power_delivery *typec_partner_usb_power_delivery_register(struct typec_partner *partner,
+							struct usb_power_delivery_desc *desc);
+
 int typec_port_set_usb_power_delivery(struct typec_port *port, struct usb_power_delivery *pd);
 int typec_partner_set_usb_power_delivery(struct typec_partner *partner,
 					 struct usb_power_delivery *pd);
-- 
2.53.0



