Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666123644B3;
	Tue, 21 Jul 2026 19:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662234; cv=none; b=L5fAwNlJ/MWiq5jw7RVXzaD7jW6lmovvBexZYr1MzXYVHFI1Ehn1HVA2mu9BTPkAM6JEtEwTWgQfvpoi/mWbbM5Hl45Jcksn+EHT3LsISN4ITu137kveyFP35CH/CgInHGjMqt32CoVN+4EHtFz2UxgbVC5br7zdmFQyA6PHw7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662234; c=relaxed/simple;
	bh=V63VLw4C5HrauePypF3amb0HaVVmjmcwfVq8N0SlRQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XAcWV8RbQXcsFqJBK0g9c1I48WoP36+aRFIfaB4HvJb5jG4RXAwiuFjrTuNVYrSOwP3WpHcgP+44RQHCkp68Sds4yzl+2fIkyd/2QIlWjdHbPDDOH1v7oxGgQgJwSeL1z7xFq5gSdWE66eE9KVlSfNGhds0MtHfbandB0GCMcRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1bErg1p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1bErg1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C431F00A3A;
	Tue, 21 Jul 2026 19:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662233;
	bh=eS8CSIMC2wQio00yBmJQFG1IEraqWDyq3WzRtvQsoRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c1bErg1p1XTmk+lSdG+o5MyEsrhKgt6L27VURoDaCGFHvIEix9odPteNkMuUkNsXI
	 Xd+EN4Z0ZTOx7C5NFUtwuueRRcXi528imz/ZYy5kdr/IvnuyiLa/8hxwMvZmNegFf7
	 yDXI0XS4zjkbDsfCA3goTxnvXjlRSdWG69lHb9NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Ivan Vecera <ivecera@redhat.com>,
	Petr Oros <poros@redhat.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0365/1276] dpll: Add notifier chain for dpll events
Date: Tue, 21 Jul 2026 17:13:28 +0200
Message-ID: <20260721152454.275343511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Oros <poros@redhat.com>

[ Upstream commit 2be467588d6bc6ec5988fc254e62a44b865912a0 ]

Currently, the DPLL subsystem reports events (creation, deletion, changes)
to userspace via Netlink. However, there is no mechanism for other kernel
components to be notified of these events directly.

Add a raw notifier chain to the DPLL core protected by dpll_lock. This
allows other kernel subsystems or drivers to register callbacks and
receive notifications when DPLL devices or pins are created, deleted,
or modified.

Define the following:
- Registration helpers: {,un}register_dpll_notifier()
- Event types: DPLL_DEVICE_CREATED, DPLL_PIN_CREATED, etc.
- Context structures: dpll_{device,pin}_notifier_info  to pass relevant
  data to the listeners.

The notification chain is invoked alongside the existing Netlink event
generation to ensure in-kernel listeners are kept in sync with the
subsystem state.

Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Co-developed-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Signed-off-by: Petr Oros <poros@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Link: https://patch.msgid.link/20260203174002.705176-4-ivecera@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 32239d600236 ("dpll: fix stale iteration in dpll_pin_on_pin_unregister()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c    | 57 +++++++++++++++++++++++++++++++++++++
 drivers/dpll/dpll_core.h    |  4 +++
 drivers/dpll/dpll_netlink.c |  6 ++++
 include/linux/dpll.h        | 29 +++++++++++++++++++
 4 files changed, 96 insertions(+)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index f04ed7195cadd6..b05fe2ba46d910 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -23,6 +23,8 @@ DEFINE_MUTEX(dpll_lock);
 DEFINE_XARRAY_FLAGS(dpll_device_xa, XA_FLAGS_ALLOC);
 DEFINE_XARRAY_FLAGS(dpll_pin_xa, XA_FLAGS_ALLOC);
 
+static RAW_NOTIFIER_HEAD(dpll_notifier_chain);
+
 static u32 dpll_device_xa_id;
 static u32 dpll_pin_xa_id;
 
@@ -46,6 +48,39 @@ struct dpll_pin_registration {
 	void *cookie;
 };
 
+static int call_dpll_notifiers(unsigned long action, void *info)
+{
+	lockdep_assert_held(&dpll_lock);
+	return raw_notifier_call_chain(&dpll_notifier_chain, action, info);
+}
+
+void dpll_device_notify(struct dpll_device *dpll, unsigned long action)
+{
+	struct dpll_device_notifier_info info = {
+		.dpll = dpll,
+		.id = dpll->id,
+		.idx = dpll->device_idx,
+		.clock_id = dpll->clock_id,
+		.type = dpll->type,
+	};
+
+	call_dpll_notifiers(action, &info);
+}
+
+void dpll_pin_notify(struct dpll_pin *pin, unsigned long action)
+{
+	struct dpll_pin_notifier_info info = {
+		.pin = pin,
+		.id = pin->id,
+		.idx = pin->pin_idx,
+		.clock_id = pin->clock_id,
+		.fwnode = pin->fwnode,
+		.prop = &pin->prop,
+	};
+
+	call_dpll_notifiers(action, &info);
+}
+
 struct dpll_device *dpll_device_get_by_id(int id)
 {
 	if (xa_get_mark(&dpll_device_xa, id, DPLL_REGISTERED))
@@ -539,6 +574,28 @@ void dpll_netdev_pin_clear(struct net_device *dev)
 }
 EXPORT_SYMBOL(dpll_netdev_pin_clear);
 
+int register_dpll_notifier(struct notifier_block *nb)
+{
+	int ret;
+
+	mutex_lock(&dpll_lock);
+	ret = raw_notifier_chain_register(&dpll_notifier_chain, nb);
+	mutex_unlock(&dpll_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(register_dpll_notifier);
+
+int unregister_dpll_notifier(struct notifier_block *nb)
+{
+	int ret;
+
+	mutex_lock(&dpll_lock);
+	ret = raw_notifier_chain_unregister(&dpll_notifier_chain, nb);
+	mutex_unlock(&dpll_lock);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(unregister_dpll_notifier);
+
 /**
  * dpll_pin_get - find existing or create new dpll pin
  * @clock_id: clock_id of creator
diff --git a/drivers/dpll/dpll_core.h b/drivers/dpll/dpll_core.h
index 2b71824f10adbc..c75a3ba837312e 100644
--- a/drivers/dpll/dpll_core.h
+++ b/drivers/dpll/dpll_core.h
@@ -92,4 +92,8 @@ struct dpll_pin_ref *dpll_xa_ref_dpll_first(struct xarray *xa_refs);
 extern struct xarray dpll_device_xa;
 extern struct xarray dpll_pin_xa;
 extern struct mutex dpll_lock;
+
+void dpll_device_notify(struct dpll_device *dpll, unsigned long action);
+void dpll_pin_notify(struct dpll_pin *pin, unsigned long action);
+
 #endif
diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index d81ac5d8a0fa5c..45969cc342d846 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -667,17 +667,20 @@ dpll_device_event_send(enum dpll_cmd event, struct dpll_device *dpll)
 
 int dpll_device_create_ntf(struct dpll_device *dpll)
 {
+	dpll_device_notify(dpll, DPLL_DEVICE_CREATED);
 	return dpll_device_event_send(DPLL_CMD_DEVICE_CREATE_NTF, dpll);
 }
 
 int dpll_device_delete_ntf(struct dpll_device *dpll)
 {
+	dpll_device_notify(dpll, DPLL_DEVICE_DELETED);
 	return dpll_device_event_send(DPLL_CMD_DEVICE_DELETE_NTF, dpll);
 }
 
 static int
 __dpll_device_change_ntf(struct dpll_device *dpll)
 {
+	dpll_device_notify(dpll, DPLL_DEVICE_CHANGED);
 	return dpll_device_event_send(DPLL_CMD_DEVICE_CHANGE_NTF, dpll);
 }
 
@@ -735,16 +738,19 @@ dpll_pin_event_send(enum dpll_cmd event, struct dpll_pin *pin)
 
 int dpll_pin_create_ntf(struct dpll_pin *pin)
 {
+	dpll_pin_notify(pin, DPLL_PIN_CREATED);
 	return dpll_pin_event_send(DPLL_CMD_PIN_CREATE_NTF, pin);
 }
 
 int dpll_pin_delete_ntf(struct dpll_pin *pin)
 {
+	dpll_pin_notify(pin, DPLL_PIN_DELETED);
 	return dpll_pin_event_send(DPLL_CMD_PIN_DELETE_NTF, pin);
 }
 
 int __dpll_pin_change_ntf(struct dpll_pin *pin)
 {
+	dpll_pin_notify(pin, DPLL_PIN_CHANGED);
 	return dpll_pin_event_send(DPLL_CMD_PIN_CHANGE_NTF, pin);
 }
 
diff --git a/include/linux/dpll.h b/include/linux/dpll.h
index 003c003a1b4c5c..627c8524c58830 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -11,6 +11,7 @@
 #include <linux/device.h>
 #include <linux/netlink.h>
 #include <linux/netdevice.h>
+#include <linux/notifier.h>
 #include <linux/rtnetlink.h>
 
 struct dpll_device;
@@ -148,6 +149,30 @@ struct dpll_pin_properties {
 	struct dpll_pin_phase_adjust_range phase_range;
 };
 
+#define DPLL_DEVICE_CREATED	1
+#define DPLL_DEVICE_DELETED	2
+#define DPLL_DEVICE_CHANGED	3
+#define DPLL_PIN_CREATED	4
+#define DPLL_PIN_DELETED	5
+#define DPLL_PIN_CHANGED	6
+
+struct dpll_device_notifier_info {
+	struct dpll_device *dpll;
+	u32 id;
+	u32 idx;
+	u64 clock_id;
+	enum dpll_type type;
+};
+
+struct dpll_pin_notifier_info {
+	struct dpll_pin *pin;
+	u32 id;
+	u32 idx;
+	u64 clock_id;
+	const struct fwnode_handle *fwnode;
+	const struct dpll_pin_properties *prop;
+};
+
 #if IS_ENABLED(CONFIG_DPLL)
 void dpll_netdev_pin_set(struct net_device *dev, struct dpll_pin *dpll_pin);
 void dpll_netdev_pin_clear(struct net_device *dev);
@@ -218,4 +243,8 @@ int dpll_device_change_ntf(struct dpll_device *dpll);
 
 int dpll_pin_change_ntf(struct dpll_pin *pin);
 
+int register_dpll_notifier(struct notifier_block *nb);
+
+int unregister_dpll_notifier(struct notifier_block *nb);
+
 #endif
-- 
2.53.0



