Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E745547010A;
	Tue, 21 Jul 2026 19:30:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662253; cv=none; b=l+pEvzHIDFcA8cw+oXdR7KNAO2Mz2leMuRd0j/iDEV1iPLmfMTlwy30AczF4KjeWvovt3Fd1oROUFI97eJqPwVOcLPHFbcBb1+UNAOWCu8YVJeMw7y+wAW7WGjm4bwferFVhJF+PBjPIA603IElJ8C1YLO3Xq2TYvlmFBheX7Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662253; c=relaxed/simple;
	bh=ZSNtTeDSwlS1YkwZIlcx/SJqygcTOqaXRBUXgwvWoE4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n52J/uD36wcm+S5EWfx+kBwoKm3YSlB+20GfUg70RsYlXevCgwllALn4norGOUEt/L7w7JGncqEFW3JKdTvgEf6fWMFrOx9H+IO1IKaYQ8ghOHkVZ69N2+eVzamEVRKiQ/jbtHhpIF1qPpiIPT4wFL9Q0721O2t6J7hzoqp0aOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1knd9iF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1knd9iF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC5541F00A3A;
	Tue, 21 Jul 2026 19:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662251;
	bh=cSvU2ReL+Gtsnh1KoaGNtOgcwzNeJpom4IwtRlUdx14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k1knd9iFX1wvr/4eqRoMnqPcSBHyvWBlTqUqHDaqPJpsaHPrkkfQ73pbq3580gAdv
	 GSlr6kfN5EDZz1X0s237y+3s6dgXPE2NNzsv0nag30t1BHZ5IK+RuDmQSHgMRvYGaO
	 qaoU46+o5gw6jAnv8aiamHtuqa++ewil7bRvhCsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0367/1276] dpll: Enhance and consolidate reference counting logic
Date: Tue, 21 Jul 2026 17:13:30 +0200
Message-ID: <20260721152454.319752303@linuxfoundation.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 729f5e0153bda8c0423fb7c5795865b6b77ca050 ]

Refactor the reference counting mechanism for DPLL devices and pins to
improve consistency and prevent potential lifetime issues.

Introduce internal helpers __dpll_{device,pin}_{hold,put}() to
centralize reference management.

Update the internal XArray reference helpers (dpll_xa_ref_*) to
automatically grab a reference to the target object when it is added to
a list, and release it when removed. This ensures that objects linked
internally (e.g., pins referenced by parent pins) are properly kept
alive without relying on the caller to manually manage the count.

Consequently, remove the now redundant manual `refcount_inc/dec` calls
in dpll_pin_on_pin_{,un}register()`, as ownership is now correctly handled
by the dpll_xa_ref_* functions.

Additionally, ensure that dpll_device_{,un}register()` takes/releases
a reference to the device, ensuring the device object remains valid for
the duration of its registration.

Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Link: https://patch.msgid.link/20260203174002.705176-7-ivecera@redhat.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 32239d600236 ("dpll: fix stale iteration in dpll_pin_on_pin_unregister()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 74 +++++++++++++++++++++++++++-------------
 1 file changed, 50 insertions(+), 24 deletions(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 59081cf2c73ae0..f6ab4f0cad84d2 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -83,6 +83,45 @@ void dpll_pin_notify(struct dpll_pin *pin, unsigned long action)
 	call_dpll_notifiers(action, &info);
 }
 
+static void __dpll_device_hold(struct dpll_device *dpll)
+{
+	refcount_inc(&dpll->refcount);
+}
+
+static void __dpll_device_put(struct dpll_device *dpll)
+{
+	if (refcount_dec_and_test(&dpll->refcount)) {
+		ASSERT_DPLL_NOT_REGISTERED(dpll);
+		WARN_ON_ONCE(!xa_empty(&dpll->pin_refs));
+		xa_destroy(&dpll->pin_refs);
+		xa_erase(&dpll_device_xa, dpll->id);
+		WARN_ON(!list_empty(&dpll->registration_list));
+		kfree(dpll);
+	}
+}
+
+static void __dpll_pin_hold(struct dpll_pin *pin)
+{
+	refcount_inc(&pin->refcount);
+}
+
+static void dpll_pin_idx_free(u32 pin_idx);
+static void dpll_pin_prop_free(struct dpll_pin_properties *prop);
+
+static void __dpll_pin_put(struct dpll_pin *pin)
+{
+	if (refcount_dec_and_test(&pin->refcount)) {
+		xa_erase(&dpll_pin_xa, pin->id);
+		xa_destroy(&pin->dpll_refs);
+		xa_destroy(&pin->parent_refs);
+		xa_destroy(&pin->ref_sync_pins);
+		dpll_pin_prop_free(&pin->prop);
+		fwnode_handle_put(pin->fwnode);
+		dpll_pin_idx_free(pin->pin_idx);
+		kfree_rcu(pin, rcu);
+	}
+}
+
 struct dpll_device *dpll_device_get_by_id(int id)
 {
 	if (xa_get_mark(&dpll_device_xa, id, DPLL_REGISTERED))
@@ -152,6 +191,7 @@ dpll_xa_ref_pin_add(struct xarray *xa_pins, struct dpll_pin *pin,
 	reg->ops = ops;
 	reg->priv = priv;
 	reg->cookie = cookie;
+	__dpll_pin_hold(pin);
 	if (ref_exists)
 		refcount_inc(&ref->refcount);
 	list_add_tail(&reg->list, &ref->registration_list);
@@ -174,6 +214,7 @@ static int dpll_xa_ref_pin_del(struct xarray *xa_pins, struct dpll_pin *pin,
 		if (WARN_ON(!reg))
 			return -EINVAL;
 		list_del(&reg->list);
+		__dpll_pin_put(pin);
 		kfree(reg);
 		if (refcount_dec_and_test(&ref->refcount)) {
 			xa_erase(xa_pins, i);
@@ -231,6 +272,7 @@ dpll_xa_ref_dpll_add(struct xarray *xa_dplls, struct dpll_device *dpll,
 	reg->ops = ops;
 	reg->priv = priv;
 	reg->cookie = cookie;
+	__dpll_device_hold(dpll);
 	if (ref_exists)
 		refcount_inc(&ref->refcount);
 	list_add_tail(&reg->list, &ref->registration_list);
@@ -253,6 +295,7 @@ dpll_xa_ref_dpll_del(struct xarray *xa_dplls, struct dpll_device *dpll,
 		if (WARN_ON(!reg))
 			return;
 		list_del(&reg->list);
+		__dpll_device_put(dpll);
 		kfree(reg);
 		if (refcount_dec_and_test(&ref->refcount)) {
 			xa_erase(xa_dplls, i);
@@ -323,8 +366,8 @@ dpll_device_get(u64 clock_id, u32 device_idx, struct module *module)
 		if (dpll->clock_id == clock_id &&
 		    dpll->device_idx == device_idx &&
 		    dpll->module == module) {
+			__dpll_device_hold(dpll);
 			ret = dpll;
-			refcount_inc(&ret->refcount);
 			break;
 		}
 	}
@@ -347,14 +390,7 @@ EXPORT_SYMBOL_GPL(dpll_device_get);
 void dpll_device_put(struct dpll_device *dpll)
 {
 	mutex_lock(&dpll_lock);
-	if (refcount_dec_and_test(&dpll->refcount)) {
-		ASSERT_DPLL_NOT_REGISTERED(dpll);
-		WARN_ON_ONCE(!xa_empty(&dpll->pin_refs));
-		xa_destroy(&dpll->pin_refs);
-		xa_erase(&dpll_device_xa, dpll->id);
-		WARN_ON(!list_empty(&dpll->registration_list));
-		kfree(dpll);
-	}
+	__dpll_device_put(dpll);
 	mutex_unlock(&dpll_lock);
 }
 EXPORT_SYMBOL_GPL(dpll_device_put);
@@ -416,6 +452,7 @@ int dpll_device_register(struct dpll_device *dpll, enum dpll_type type,
 	reg->ops = ops;
 	reg->priv = priv;
 	dpll->type = type;
+	__dpll_device_hold(dpll);
 	first_registration = list_empty(&dpll->registration_list);
 	list_add_tail(&reg->list, &dpll->registration_list);
 	if (!first_registration) {
@@ -455,6 +492,7 @@ void dpll_device_unregister(struct dpll_device *dpll,
 		return;
 	}
 	list_del(&reg->list);
+	__dpll_device_put(dpll);
 	kfree(reg);
 
 	if (!list_empty(&dpll->registration_list)) {
@@ -666,8 +704,8 @@ dpll_pin_get(u64 clock_id, u32 pin_idx, struct module *module,
 		if (pos->clock_id == clock_id &&
 		    pos->pin_idx == pin_idx &&
 		    pos->module == module) {
+			__dpll_pin_hold(pos);
 			ret = pos;
-			refcount_inc(&ret->refcount);
 			break;
 		}
 	}
@@ -690,16 +728,7 @@ EXPORT_SYMBOL_GPL(dpll_pin_get);
 void dpll_pin_put(struct dpll_pin *pin)
 {
 	mutex_lock(&dpll_lock);
-	if (refcount_dec_and_test(&pin->refcount)) {
-		xa_erase(&dpll_pin_xa, pin->id);
-		xa_destroy(&pin->dpll_refs);
-		xa_destroy(&pin->parent_refs);
-		xa_destroy(&pin->ref_sync_pins);
-		dpll_pin_prop_free(&pin->prop);
-		fwnode_handle_put(pin->fwnode);
-		dpll_pin_idx_free(pin->pin_idx);
-		kfree_rcu(pin, rcu);
-	}
+	__dpll_pin_put(pin);
 	mutex_unlock(&dpll_lock);
 }
 EXPORT_SYMBOL_GPL(dpll_pin_put);
@@ -740,8 +769,8 @@ struct dpll_pin *fwnode_dpll_pin_find(struct fwnode_handle *fwnode)
 	mutex_lock(&dpll_lock);
 	xa_for_each(&dpll_pin_xa, index, pin) {
 		if (pin->fwnode == fwnode) {
+			__dpll_pin_hold(pin);
 			ret = pin;
-			refcount_inc(&ret->refcount);
 			break;
 		}
 	}
@@ -893,7 +922,6 @@ int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
 	ret = dpll_xa_ref_pin_add(&pin->parent_refs, parent, ops, priv, pin);
 	if (ret)
 		goto unlock;
-	refcount_inc(&pin->refcount);
 	xa_for_each(&parent->dpll_refs, i, ref) {
 		ret = __dpll_pin_register(ref->dpll, pin, ops, priv, parent);
 		if (ret) {
@@ -913,7 +941,6 @@ int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
 					      parent);
 			dpll_pin_delete_ntf(pin);
 		}
-	refcount_dec(&pin->refcount);
 	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv, pin);
 unlock:
 	mutex_unlock(&dpll_lock);
@@ -940,7 +967,6 @@ void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin,
 	mutex_lock(&dpll_lock);
 	dpll_pin_delete_ntf(pin);
 	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv, pin);
-	refcount_dec(&pin->refcount);
 	xa_for_each(&pin->dpll_refs, i, ref)
 		__dpll_pin_unregister(ref->dpll, pin, ops, priv, parent);
 	mutex_unlock(&dpll_lock);
-- 
2.53.0



