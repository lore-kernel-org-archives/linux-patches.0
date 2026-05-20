Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E703F1AD9;
	Wed, 20 May 2026 17:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299644; cv=none; b=ozSFYNpVLvKX0VLjtmd4S6UdGZKztC/OKmuc5g9sHdkkbdRGyBVKLzqYPuozBmfG0FK3xQF4TZO5x3+04mDLyvuKUiBaeEMITK3XFo/YcAAE+hr4wU2jLkCFq0WFGUI8srZMopuGd3gdyBHsYxKOiil6zz1wNmLeTBB1bZSbuY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299644; c=relaxed/simple;
	bh=qLGdWKz3Sh2u2lVBuffJUOFF5yZXXVXIsMDtkR+EGus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlBEIKtzIX3giEpJ6P5eC+my7552huQVt/O8jcvgvCdudM6ou8AKFg4jZXV1VYHKUgLT5nSrRRGs1tYZxW9VMq3itBk8MbrtVCUHXtZRmdc8knVmvxhPt7wKV5oj3DOpmrh07CVMVYbbNHyY2r19M/GYfnt+jGkR02IUT9R4Uhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=os2zPlP3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="os2zPlP3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE951F000E9;
	Wed, 20 May 2026 17:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299642;
	bh=8DntM4s7/rVXPbeXj1Vh6fASVK3Wm/2Ajzt4EB0d1AA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=os2zPlP3F799JXso1kIbiKjsKOmP3jj0F1s6mcWc1kP5jqOtXbzEOg6HMk/8RVGqj
	 GGFlElOLSLHziJqqeCjZZQ0DEIMh28bgeSnsVh8MGkghEPGYTzldNJr5xINzCMVJJv
	 KwWkadGZn2YO54kWdQ860dTmFIKg5uR/RkDC2eQo=
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
Subject: [PATCH 6.18 851/957] dpll: Add notifier chain for dpll events
Date: Wed, 20 May 2026 18:22:14 +0200
Message-ID: <20260520162153.022109370@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Stable-dep-of: 9e5dead140af ("ice: add dpll peer notification for paired SMA and U.FL pins")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c    | 57 +++++++++++++++++++++++++++++++++++++
 drivers/dpll/dpll_core.h    |  4 +++
 drivers/dpll/dpll_netlink.c |  6 ++++
 include/linux/dpll.h        | 29 +++++++++++++++++++
 4 files changed, 96 insertions(+)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index f04ed7195cadd..b05fe2ba46d91 100644
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
index d3e17ff0ecef0..b7b4bb251f739 100644
--- a/drivers/dpll/dpll_core.h
+++ b/drivers/dpll/dpll_core.h
@@ -91,4 +91,8 @@ struct dpll_pin_ref *dpll_xa_ref_dpll_first(struct xarray *xa_refs);
 extern struct xarray dpll_device_xa;
 extern struct xarray dpll_pin_xa;
 extern struct mutex dpll_lock;
+
+void dpll_device_notify(struct dpll_device *dpll, unsigned long action);
+void dpll_pin_notify(struct dpll_pin *pin, unsigned long action);
+
 #endif
diff --git a/drivers/dpll/dpll_netlink.c b/drivers/dpll/dpll_netlink.c
index 64944f601ee5a..fe9c3d9073f0f 100644
--- a/drivers/dpll/dpll_netlink.c
+++ b/drivers/dpll/dpll_netlink.c
@@ -742,17 +742,20 @@ dpll_device_event_send(enum dpll_cmd event, struct dpll_device *dpll)
 
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
 
@@ -810,16 +813,19 @@ dpll_pin_event_send(enum dpll_cmd event, struct dpll_pin *pin)
 
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
index f0c31a111c304..34b005bb4df6f 100644
--- a/include/linux/dpll.h
+++ b/include/linux/dpll.h
@@ -11,6 +11,7 @@
 #include <linux/device.h>
 #include <linux/netlink.h>
 #include <linux/netdevice.h>
+#include <linux/notifier.h>
 #include <linux/rtnetlink.h>
 
 struct dpll_device;
@@ -167,6 +168,30 @@ struct dpll_pin_properties {
 	u32 phase_gran;
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
@@ -237,4 +262,8 @@ int dpll_device_change_ntf(struct dpll_device *dpll);
 
 int dpll_pin_change_ntf(struct dpll_pin *pin);
 
+int register_dpll_notifier(struct notifier_block *nb);
+
+int unregister_dpll_notifier(struct notifier_block *nb);
+
 #endif
-- 
2.53.0



