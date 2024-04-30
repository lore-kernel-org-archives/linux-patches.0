Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F2312C462;
	Tue, 30 Apr 2024 10:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474296; cv=none; b=RJwpUyaU7e11qPULw6sCOjbHAxUgHSVQPbie6LJst//wwFqRKcL++JlZlG2y4+NVp6ViUfF59Ea43tw+iXIBBItJJixMo/+Ys0YXf9K/Jl527sSKySml9oM2JPsDoL6aikOUlv6DR6bk+e2ABsH6wYVdlp6OB1TkzJdiDwOynwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474296; c=relaxed/simple;
	bh=U6In7X5I/0LWFvrGvK6hhNzccMMgXRjV5EVvY0c66X4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZLQw16MN9BBjzbNdhBqWlilJS2jlnaoK4Nusb3jHCsGjbYkkHJw6Z3D81Kk/lZDrE442dJVf5cpQGnap02xc+WIwmRqKLpqMF1OeR+WzfFtwIWQjbV5ZBKW1PVkaKWp1PCU9OMaak5KlX2WbzjlnIhnKRBTBnnBcSIDCjlvYI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Ommt3Ls; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Ommt3Ls"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFFEC2BBFC;
	Tue, 30 Apr 2024 10:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474296;
	bh=U6In7X5I/0LWFvrGvK6hhNzccMMgXRjV5EVvY0c66X4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Ommt3LsiYIs52abGaQcGi9w8KSqTM3KUAdt8IV/zfBl/Tj+Gzvz4t1qP1TPNIfdR
	 1Sc6BdfQKO5+3to8rMniWSAHqSfBMjjSo/68wyMUY3nXHttCjmVXIvNkm7kDIdf6Zc
	 4GA0kyaNo6nfHapy6dDV6F4vj9TK8+i/OzI//Xt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 116/228] dpll: fix dpll_pin_on_pin_register() for multiple parent pins
Date: Tue, 30 Apr 2024 12:38:14 +0200
Message-ID: <20240430103107.156937733@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>

[ Upstream commit 38d7b94e81d068b8d8c8392f421cfd2c3bbfd1a6 ]

In scenario where pin is registered with multiple parent pins via
dpll_pin_on_pin_register(..), all belonging to the same dpll device.
A second call to dpll_pin_on_pin_unregister(..) would cause a call trace,
as it tries to use already released registration resources (due to fix
introduced in b446631f355e). In this scenario pin was registered twice,
so resources are not yet expected to be release until each registered
pin/pin pair is unregistered.

Currently, the following crash/call trace is produced when ice driver is
removed on the system with installed E810T NIC which includes dpll device:

WARNING: CPU: 51 PID: 9155 at drivers/dpll/dpll_core.c:809 dpll_pin_ops+0x20/0x30
RIP: 0010:dpll_pin_ops+0x20/0x30
Call Trace:
 ? __warn+0x7f/0x130
 ? dpll_pin_ops+0x20/0x30
 dpll_msg_add_pin_freq+0x37/0x1d0
 dpll_cmd_pin_get_one+0x1c0/0x400
 ? __nlmsg_put+0x63/0x80
 dpll_pin_event_send+0x93/0x140
 dpll_pin_on_pin_unregister+0x3f/0x100
 ice_dpll_deinit_pins+0xa1/0x230 [ice]
 ice_remove+0xf1/0x210 [ice]

Fix by adding a parent pointer as a cookie when creating a registration,
also when searching for it. For the regular pins pass NULL, this allows to
create separated registration for each parent the pin is registered with.

Fixes: b446631f355e ("dpll: fix dpll_xa_ref_*_del() for multiple registrations")
Signed-off-by: Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20240424101636.1491424-1-arkadiusz.kubalewski@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 58 +++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 3e6282937e35c..a6856730ca90f 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -42,6 +42,7 @@ struct dpll_pin_registration {
 	struct list_head list;
 	const struct dpll_pin_ops *ops;
 	void *priv;
+	void *cookie;
 };
 
 struct dpll_device *dpll_device_get_by_id(int id)
@@ -54,12 +55,14 @@ struct dpll_device *dpll_device_get_by_id(int id)
 
 static struct dpll_pin_registration *
 dpll_pin_registration_find(struct dpll_pin_ref *ref,
-			   const struct dpll_pin_ops *ops, void *priv)
+			   const struct dpll_pin_ops *ops, void *priv,
+			   void *cookie)
 {
 	struct dpll_pin_registration *reg;
 
 	list_for_each_entry(reg, &ref->registration_list, list) {
-		if (reg->ops == ops && reg->priv == priv)
+		if (reg->ops == ops && reg->priv == priv &&
+		    reg->cookie == cookie)
 			return reg;
 	}
 	return NULL;
@@ -67,7 +70,8 @@ dpll_pin_registration_find(struct dpll_pin_ref *ref,
 
 static int
 dpll_xa_ref_pin_add(struct xarray *xa_pins, struct dpll_pin *pin,
-		    const struct dpll_pin_ops *ops, void *priv)
+		    const struct dpll_pin_ops *ops, void *priv,
+		    void *cookie)
 {
 	struct dpll_pin_registration *reg;
 	struct dpll_pin_ref *ref;
@@ -78,7 +82,7 @@ dpll_xa_ref_pin_add(struct xarray *xa_pins, struct dpll_pin *pin,
 	xa_for_each(xa_pins, i, ref) {
 		if (ref->pin != pin)
 			continue;
-		reg = dpll_pin_registration_find(ref, ops, priv);
+		reg = dpll_pin_registration_find(ref, ops, priv, cookie);
 		if (reg) {
 			refcount_inc(&ref->refcount);
 			return 0;
@@ -111,6 +115,7 @@ dpll_xa_ref_pin_add(struct xarray *xa_pins, struct dpll_pin *pin,
 	}
 	reg->ops = ops;
 	reg->priv = priv;
+	reg->cookie = cookie;
 	if (ref_exists)
 		refcount_inc(&ref->refcount);
 	list_add_tail(&reg->list, &ref->registration_list);
@@ -119,7 +124,8 @@ dpll_xa_ref_pin_add(struct xarray *xa_pins, struct dpll_pin *pin,
 }
 
 static int dpll_xa_ref_pin_del(struct xarray *xa_pins, struct dpll_pin *pin,
-			       const struct dpll_pin_ops *ops, void *priv)
+			       const struct dpll_pin_ops *ops, void *priv,
+			       void *cookie)
 {
 	struct dpll_pin_registration *reg;
 	struct dpll_pin_ref *ref;
@@ -128,7 +134,7 @@ static int dpll_xa_ref_pin_del(struct xarray *xa_pins, struct dpll_pin *pin,
 	xa_for_each(xa_pins, i, ref) {
 		if (ref->pin != pin)
 			continue;
-		reg = dpll_pin_registration_find(ref, ops, priv);
+		reg = dpll_pin_registration_find(ref, ops, priv, cookie);
 		if (WARN_ON(!reg))
 			return -EINVAL;
 		list_del(&reg->list);
@@ -146,7 +152,7 @@ static int dpll_xa_ref_pin_del(struct xarray *xa_pins, struct dpll_pin *pin,
 
 static int
 dpll_xa_ref_dpll_add(struct xarray *xa_dplls, struct dpll_device *dpll,
-		     const struct dpll_pin_ops *ops, void *priv)
+		     const struct dpll_pin_ops *ops, void *priv, void *cookie)
 {
 	struct dpll_pin_registration *reg;
 	struct dpll_pin_ref *ref;
@@ -157,7 +163,7 @@ dpll_xa_ref_dpll_add(struct xarray *xa_dplls, struct dpll_device *dpll,
 	xa_for_each(xa_dplls, i, ref) {
 		if (ref->dpll != dpll)
 			continue;
-		reg = dpll_pin_registration_find(ref, ops, priv);
+		reg = dpll_pin_registration_find(ref, ops, priv, cookie);
 		if (reg) {
 			refcount_inc(&ref->refcount);
 			return 0;
@@ -190,6 +196,7 @@ dpll_xa_ref_dpll_add(struct xarray *xa_dplls, struct dpll_device *dpll,
 	}
 	reg->ops = ops;
 	reg->priv = priv;
+	reg->cookie = cookie;
 	if (ref_exists)
 		refcount_inc(&ref->refcount);
 	list_add_tail(&reg->list, &ref->registration_list);
@@ -199,7 +206,7 @@ dpll_xa_ref_dpll_add(struct xarray *xa_dplls, struct dpll_device *dpll,
 
 static void
 dpll_xa_ref_dpll_del(struct xarray *xa_dplls, struct dpll_device *dpll,
-		     const struct dpll_pin_ops *ops, void *priv)
+		     const struct dpll_pin_ops *ops, void *priv, void *cookie)
 {
 	struct dpll_pin_registration *reg;
 	struct dpll_pin_ref *ref;
@@ -208,7 +215,7 @@ dpll_xa_ref_dpll_del(struct xarray *xa_dplls, struct dpll_device *dpll,
 	xa_for_each(xa_dplls, i, ref) {
 		if (ref->dpll != dpll)
 			continue;
-		reg = dpll_pin_registration_find(ref, ops, priv);
+		reg = dpll_pin_registration_find(ref, ops, priv, cookie);
 		if (WARN_ON(!reg))
 			return;
 		list_del(&reg->list);
@@ -594,14 +601,14 @@ EXPORT_SYMBOL_GPL(dpll_pin_put);
 
 static int
 __dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
-		    const struct dpll_pin_ops *ops, void *priv)
+		    const struct dpll_pin_ops *ops, void *priv, void *cookie)
 {
 	int ret;
 
-	ret = dpll_xa_ref_pin_add(&dpll->pin_refs, pin, ops, priv);
+	ret = dpll_xa_ref_pin_add(&dpll->pin_refs, pin, ops, priv, cookie);
 	if (ret)
 		return ret;
-	ret = dpll_xa_ref_dpll_add(&pin->dpll_refs, dpll, ops, priv);
+	ret = dpll_xa_ref_dpll_add(&pin->dpll_refs, dpll, ops, priv, cookie);
 	if (ret)
 		goto ref_pin_del;
 	xa_set_mark(&dpll_pin_xa, pin->id, DPLL_REGISTERED);
@@ -610,7 +617,7 @@ __dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
 	return ret;
 
 ref_pin_del:
-	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv);
+	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv, cookie);
 	return ret;
 }
 
@@ -642,7 +649,7 @@ dpll_pin_register(struct dpll_device *dpll, struct dpll_pin *pin,
 		      dpll->clock_id == pin->clock_id)))
 		ret = -EINVAL;
 	else
-		ret = __dpll_pin_register(dpll, pin, ops, priv);
+		ret = __dpll_pin_register(dpll, pin, ops, priv, NULL);
 	mutex_unlock(&dpll_lock);
 
 	return ret;
@@ -651,11 +658,11 @@ EXPORT_SYMBOL_GPL(dpll_pin_register);
 
 static void
 __dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
-		      const struct dpll_pin_ops *ops, void *priv)
+		      const struct dpll_pin_ops *ops, void *priv, void *cookie)
 {
 	ASSERT_DPLL_PIN_REGISTERED(pin);
-	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv);
-	dpll_xa_ref_dpll_del(&pin->dpll_refs, dpll, ops, priv);
+	dpll_xa_ref_pin_del(&dpll->pin_refs, pin, ops, priv, cookie);
+	dpll_xa_ref_dpll_del(&pin->dpll_refs, dpll, ops, priv, cookie);
 	if (xa_empty(&pin->dpll_refs))
 		xa_clear_mark(&dpll_pin_xa, pin->id, DPLL_REGISTERED);
 }
@@ -680,7 +687,7 @@ void dpll_pin_unregister(struct dpll_device *dpll, struct dpll_pin *pin,
 
 	mutex_lock(&dpll_lock);
 	dpll_pin_delete_ntf(pin);
-	__dpll_pin_unregister(dpll, pin, ops, priv);
+	__dpll_pin_unregister(dpll, pin, ops, priv, NULL);
 	mutex_unlock(&dpll_lock);
 }
 EXPORT_SYMBOL_GPL(dpll_pin_unregister);
@@ -716,12 +723,12 @@ int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
 		return -EINVAL;
 
 	mutex_lock(&dpll_lock);
-	ret = dpll_xa_ref_pin_add(&pin->parent_refs, parent, ops, priv);
+	ret = dpll_xa_ref_pin_add(&pin->parent_refs, parent, ops, priv, pin);
 	if (ret)
 		goto unlock;
 	refcount_inc(&pin->refcount);
 	xa_for_each(&parent->dpll_refs, i, ref) {
-		ret = __dpll_pin_register(ref->dpll, pin, ops, priv);
+		ret = __dpll_pin_register(ref->dpll, pin, ops, priv, parent);
 		if (ret) {
 			stop = i;
 			goto dpll_unregister;
@@ -735,11 +742,12 @@ int dpll_pin_on_pin_register(struct dpll_pin *parent, struct dpll_pin *pin,
 dpll_unregister:
 	xa_for_each(&parent->dpll_refs, i, ref)
 		if (i < stop) {
-			__dpll_pin_unregister(ref->dpll, pin, ops, priv);
+			__dpll_pin_unregister(ref->dpll, pin, ops, priv,
+					      parent);
 			dpll_pin_delete_ntf(pin);
 		}
 	refcount_dec(&pin->refcount);
-	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv);
+	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv, pin);
 unlock:
 	mutex_unlock(&dpll_lock);
 	return ret;
@@ -764,10 +772,10 @@ void dpll_pin_on_pin_unregister(struct dpll_pin *parent, struct dpll_pin *pin,
 
 	mutex_lock(&dpll_lock);
 	dpll_pin_delete_ntf(pin);
-	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv);
+	dpll_xa_ref_pin_del(&pin->parent_refs, parent, ops, priv, pin);
 	refcount_dec(&pin->refcount);
 	xa_for_each(&pin->dpll_refs, i, ref)
-		__dpll_pin_unregister(ref->dpll, pin, ops, priv);
+		__dpll_pin_unregister(ref->dpll, pin, ops, priv, parent);
 	mutex_unlock(&dpll_lock);
 }
 EXPORT_SYMBOL_GPL(dpll_pin_on_pin_unregister);
-- 
2.43.0



