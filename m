Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEFB413EFF4;
	Tue, 27 Feb 2024 14:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042735; cv=none; b=hEEXFYLfCZVdYgnb3FU5W3xViG9G/Eyz4Mh3jcubPm8vHrg6dzzr8+kqR8GGiih156cC38NwAGfjeVRwcC70fSVKKD3035W+N08XF5PRZYzbDAC0SDxGd9hEEYH5QpfOT1pUMxXJATLVieRUdntx814wjzi4hFLUMOZUVEtBd4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042735; c=relaxed/simple;
	bh=Qp36fLL6cD0uPjQATxA20II6tHrWI4S21U9d/j81oOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXKGWYIu9s5nlk38dEmZVxkyYv4zOq1sttjTTuzKQkWvWuUcEqgu5AlV1pJM1XB/HsS67TdK7lBgouZ+O2Ws3JQ93GAtS8X2ZGwqL4e/xNnPv9tJxpe2C/tkfUwg5pTSUofeb9DRH+kSS9dxpUNWPH41O4fj6AFw/yTgS2Ls9sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cs0dGn6w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cs0dGn6w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABFEC433C7;
	Tue, 27 Feb 2024 14:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042734;
	bh=Qp36fLL6cD0uPjQATxA20II6tHrWI4S21U9d/j81oOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cs0dGn6wQKzmTDBEWtVKOLrG5++iv7cQMUoTQkJmaTtAf5A5/P56j9WW0GGoA+G60
	 INI9TfIay/4Xjqic8NhjKkC47E6NZcXbv+oflP+AUvxHw9zzXixWtFEnJAzfyoFwYR
	 gBZCIiT/mZgzs1uby93PpT6TSgHN7fDnIbnghOOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 5.15 102/245] usb: roles: fix NULL pointer issue when put modules reference
Date: Tue, 27 Feb 2024 14:24:50 +0100
Message-ID: <20240227131618.529249007@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131615.098467438@linuxfoundation.org>
References: <20240227131615.098467438@linuxfoundation.org>
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

From: Xu Yang <xu.yang_2@nxp.com>

commit 1c9be13846c0b2abc2480602f8ef421360e1ad9e upstream.

In current design, usb role class driver will get usb_role_switch parent's
module reference after the user get usb_role_switch device and put the
reference after the user put the usb_role_switch device. However, the
parent device of usb_role_switch may be removed before the user put the
usb_role_switch. If so, then, NULL pointer issue will be met when the user
put the parent module's reference.

This will save the module pointer in structure of usb_role_switch. Then,
we don't need to find module by iterating long relations.

Fixes: 5c54fcac9a9d ("usb: roles: Take care of driver module reference counting")
cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://lore.kernel.org/r/20240129093739.2371530-1-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/roles/class.c |   17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

--- a/drivers/usb/roles/class.c
+++ b/drivers/usb/roles/class.c
@@ -19,6 +19,7 @@ static struct class *role_class;
 struct usb_role_switch {
 	struct device dev;
 	struct mutex lock; /* device lock*/
+	struct module *module; /* the module this device depends on */
 	enum usb_role role;
 
 	/* From descriptor */
@@ -133,7 +134,7 @@ struct usb_role_switch *usb_role_switch_
 						  usb_role_switch_match);
 
 	if (!IS_ERR_OR_NULL(sw))
-		WARN_ON(!try_module_get(sw->dev.parent->driver->owner));
+		WARN_ON(!try_module_get(sw->module));
 
 	return sw;
 }
@@ -155,7 +156,7 @@ struct usb_role_switch *fwnode_usb_role_
 		sw = fwnode_connection_find_match(fwnode, "usb-role-switch",
 						  NULL, usb_role_switch_match);
 	if (!IS_ERR_OR_NULL(sw))
-		WARN_ON(!try_module_get(sw->dev.parent->driver->owner));
+		WARN_ON(!try_module_get(sw->module));
 
 	return sw;
 }
@@ -170,7 +171,7 @@ EXPORT_SYMBOL_GPL(fwnode_usb_role_switch
 void usb_role_switch_put(struct usb_role_switch *sw)
 {
 	if (!IS_ERR_OR_NULL(sw)) {
-		module_put(sw->dev.parent->driver->owner);
+		module_put(sw->module);
 		put_device(&sw->dev);
 	}
 }
@@ -187,15 +188,18 @@ struct usb_role_switch *
 usb_role_switch_find_by_fwnode(const struct fwnode_handle *fwnode)
 {
 	struct device *dev;
+	struct usb_role_switch *sw = NULL;
 
 	if (!fwnode)
 		return NULL;
 
 	dev = class_find_device_by_fwnode(role_class, fwnode);
-	if (dev)
-		WARN_ON(!try_module_get(dev->parent->driver->owner));
+	if (dev) {
+		sw = to_role_switch(dev);
+		WARN_ON(!try_module_get(sw->module));
+	}
 
-	return dev ? to_role_switch(dev) : NULL;
+	return sw;
 }
 EXPORT_SYMBOL_GPL(usb_role_switch_find_by_fwnode);
 
@@ -337,6 +341,7 @@ usb_role_switch_register(struct device *
 	sw->set = desc->set;
 	sw->get = desc->get;
 
+	sw->module = parent->driver->owner;
 	sw->dev.parent = parent;
 	sw->dev.fwnode = desc->fwnode;
 	sw->dev.class = role_class;


