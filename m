Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B72F2E1C74;
	Tue,  8 Jul 2025 16:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993835; cv=none; b=TpvZpt7EkNsOpQlQO6ilH9vv9GIwheS0Z8TOuLlexzOcjxcHGpO0KJLUuN0cKw4RKthNrMtk7OjVreN/ha/K+eFsKmQoOc16r4oDNlULLnQxBsK1roclX2XHcLTcJYwvc8FIDz867ktZYD6BTNVIORShvdzu2Axwx9FlYIPPwOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993835; c=relaxed/simple;
	bh=sUfnF5uYJsssE5VLXVDpRslmZbRpiNcX7hNNTTt3DmA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cw3b94Z6s4e4u3i5xriCKfrVdmhFBI7e0oM5g3ZfYkTu66MkS/lFbzz5xPoWVLnUaXAJzS8kLWEish1qNdmzGp+kThAUOFT8oNUCTnLRknds+V4vplzlllQL0OXKOHdD32BYlz47VRYcsIXYwa32VCT56iK/sThAevtrYyhAzsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kegdVkYV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kegdVkYV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D485BC4CEED;
	Tue,  8 Jul 2025 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993835;
	bh=sUfnF5uYJsssE5VLXVDpRslmZbRpiNcX7hNNTTt3DmA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kegdVkYVBtDPRLSl077B5V+ospUsqOQe9KO2ilhZD7pTz8YgORvRon4hHGySb4cKi
	 r7Id29qSv3+cloUBjaB1E9W5VI7A/PhHinkFp3pIv2mNZn7FF5foptY89viHW3MieK
	 Jr1D4j3DMHdOCXZ3hTWzlDUOBjYcIJWgUg1y2K9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 034/160] regulator: Add devm helpers for get and enable
Date: Tue,  8 Jul 2025 18:21:11 +0200
Message-ID: <20250708162232.471647521@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
References: <20250708162231.503362020@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit da279e6965b3838e99e5c0ab8f76b87bf86b31a5 ]

A few regulator consumer drivers seem to be just getting a regulator,
enabling it and registering a devm-action to disable the regulator at
the driver detach and then forget about it.

We can simplify this a bit by adding a devm-helper for this pattern.
Add devm_regulator_get_enable() and devm_regulator_get_enable_optional()

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://lore.kernel.org/r/ed7b8841193bb9749d426f3cb3b199c9460794cd.1660292316.git.mazziesaccount@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 9079db287fc3 ("ASoC: codecs: wcd9335: Fix missing free of regulator supplies")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/devres.c         | 164 +++++++++++++++++++++++++++++
 include/linux/regulator/consumer.h |  27 +++++
 2 files changed, 191 insertions(+)

diff --git a/drivers/regulator/devres.c b/drivers/regulator/devres.c
index 32823a87fd409..3265e75e97ab4 100644
--- a/drivers/regulator/devres.c
+++ b/drivers/regulator/devres.c
@@ -70,6 +70,65 @@ struct regulator *devm_regulator_get_exclusive(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(devm_regulator_get_exclusive);
 
+static void regulator_action_disable(void *d)
+{
+	struct regulator *r = (struct regulator *)d;
+
+	regulator_disable(r);
+}
+
+static int _devm_regulator_get_enable(struct device *dev, const char *id,
+				      int get_type)
+{
+	struct regulator *r;
+	int ret;
+
+	r = _devm_regulator_get(dev, id, get_type);
+	if (IS_ERR(r))
+		return PTR_ERR(r);
+
+	ret = regulator_enable(r);
+	if (!ret)
+		ret = devm_add_action_or_reset(dev, &regulator_action_disable, r);
+
+	if (ret)
+		devm_regulator_put(r);
+
+	return ret;
+}
+
+/**
+ * devm_regulator_get_enable_optional - Resource managed regulator get and enable
+ * @dev: device to supply
+ * @id:  supply name or regulator ID.
+ *
+ * Get and enable regulator for duration of the device life-time.
+ * regulator_disable() and regulator_put() are automatically called on driver
+ * detach. See regulator_get_optional() and regulator_enable() for more
+ * information.
+ */
+int devm_regulator_get_enable_optional(struct device *dev, const char *id)
+{
+	return _devm_regulator_get_enable(dev, id, OPTIONAL_GET);
+}
+EXPORT_SYMBOL_GPL(devm_regulator_get_enable_optional);
+
+/**
+ * devm_regulator_get_enable - Resource managed regulator get and enable
+ * @dev: device to supply
+ * @id:  supply name or regulator ID.
+ *
+ * Get and enable regulator for duration of the device life-time.
+ * regulator_disable() and regulator_put() are automatically called on driver
+ * detach. See regulator_get() and regulator_enable() for more
+ * information.
+ */
+int devm_regulator_get_enable(struct device *dev, const char *id)
+{
+	return _devm_regulator_get_enable(dev, id, NORMAL_GET);
+}
+EXPORT_SYMBOL_GPL(devm_regulator_get_enable);
+
 /**
  * devm_regulator_get_optional - Resource managed regulator_get_optional()
  * @dev: device to supply
@@ -194,6 +253,111 @@ int devm_regulator_bulk_get_const(struct device *dev, int num_consumers,
 }
 EXPORT_SYMBOL_GPL(devm_regulator_bulk_get_const);
 
+static int devm_regulator_bulk_match(struct device *dev, void *res,
+				     void *data)
+{
+	struct regulator_bulk_devres *match = res;
+	struct regulator_bulk_data *target = data;
+
+	/*
+	 * We check the put uses same consumer list as the get did.
+	 * We _could_ scan all entries in consumer array and check the
+	 * regulators match but ATM I don't see the need. We can change this
+	 * later if needed.
+	 */
+	return match->consumers == target;
+}
+
+/**
+ * devm_regulator_bulk_put - Resource managed regulator_bulk_put()
+ * @consumers: consumers to free
+ *
+ * Deallocate regulators allocated with devm_regulator_bulk_get(). Normally
+ * this function will not need to be called and the resource management
+ * code will ensure that the resource is freed.
+ */
+void devm_regulator_bulk_put(struct regulator_bulk_data *consumers)
+{
+	int rc;
+	struct regulator *regulator = consumers[0].consumer;
+
+	rc = devres_release(regulator->dev, devm_regulator_bulk_release,
+			    devm_regulator_bulk_match, consumers);
+	if (rc != 0)
+		WARN_ON(rc);
+}
+EXPORT_SYMBOL_GPL(devm_regulator_bulk_put);
+
+static void devm_regulator_bulk_disable(void *res)
+{
+	struct regulator_bulk_devres *devres = res;
+	int i;
+
+	for (i = 0; i < devres->num_consumers; i++)
+		regulator_disable(devres->consumers[i].consumer);
+}
+
+/**
+ * devm_regulator_bulk_get_enable - managed get'n enable multiple regulators
+ *
+ * @dev:           device to supply
+ * @num_consumers: number of consumers to register
+ * @id:            list of supply names or regulator IDs
+ *
+ * @return 0 on success, an errno on failure.
+ *
+ * This helper function allows drivers to get several regulator
+ * consumers in one operation with management, the regulators will
+ * automatically be freed when the device is unbound.  If any of the
+ * regulators cannot be acquired then any regulators that were
+ * allocated will be freed before returning to the caller.
+ */
+int devm_regulator_bulk_get_enable(struct device *dev, int num_consumers,
+				   const char * const *id)
+{
+	struct regulator_bulk_devres *devres;
+	struct regulator_bulk_data *consumers;
+	int i, ret;
+
+	devres = devm_kmalloc(dev, sizeof(*devres), GFP_KERNEL);
+	if (!devres)
+		return -ENOMEM;
+
+	devres->consumers = devm_kcalloc(dev, num_consumers, sizeof(*consumers),
+					 GFP_KERNEL);
+	consumers = devres->consumers;
+	if (!consumers)
+		return -ENOMEM;
+
+	devres->num_consumers = num_consumers;
+
+	for (i = 0; i < num_consumers; i++)
+		consumers[i].supply = id[i];
+
+	ret = devm_regulator_bulk_get(dev, num_consumers, consumers);
+	if (ret)
+		return ret;
+
+	for (i = 0; i < num_consumers; i++) {
+		ret = regulator_enable(consumers[i].consumer);
+		if (ret)
+			goto unwind;
+	}
+
+	ret = devm_add_action(dev, devm_regulator_bulk_disable, devres);
+	if (!ret)
+		return 0;
+
+unwind:
+	while (--i >= 0)
+		regulator_disable(consumers[i].consumer);
+
+	devm_regulator_bulk_put(consumers);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devm_regulator_bulk_get_enable);
+
 static void devm_rdev_release(struct device *dev, void *res)
 {
 	regulator_unregister(*(struct regulator_dev **)res);
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 61f922e6fe353..a1fce0f27ce16 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -203,6 +203,8 @@ struct regulator *__must_check regulator_get_optional(struct device *dev,
 						      const char *id);
 struct regulator *__must_check devm_regulator_get_optional(struct device *dev,
 							   const char *id);
+int devm_regulator_get_enable(struct device *dev, const char *id);
+int devm_regulator_get_enable_optional(struct device *dev, const char *id);
 void regulator_put(struct regulator *regulator);
 void devm_regulator_put(struct regulator *regulator);
 
@@ -240,12 +242,15 @@ int __must_check regulator_bulk_get(struct device *dev, int num_consumers,
 				    struct regulator_bulk_data *consumers);
 int __must_check devm_regulator_bulk_get(struct device *dev, int num_consumers,
 					 struct regulator_bulk_data *consumers);
+void devm_regulator_bulk_put(struct regulator_bulk_data *consumers);
 int __must_check devm_regulator_bulk_get_const(
 	struct device *dev, int num_consumers,
 	const struct regulator_bulk_data *in_consumers,
 	struct regulator_bulk_data **out_consumers);
 int __must_check regulator_bulk_enable(int num_consumers,
 				       struct regulator_bulk_data *consumers);
+int devm_regulator_bulk_get_enable(struct device *dev, int num_consumers,
+				   const char * const *id);
 int regulator_bulk_disable(int num_consumers,
 			   struct regulator_bulk_data *consumers);
 int regulator_bulk_force_disable(int num_consumers,
@@ -350,6 +355,17 @@ devm_regulator_get_exclusive(struct device *dev, const char *id)
 	return ERR_PTR(-ENODEV);
 }
 
+static inline int devm_regulator_get_enable(struct device *dev, const char *id)
+{
+	return -ENODEV;
+}
+
+static inline int devm_regulator_get_enable_optional(struct device *dev,
+						     const char *id)
+{
+	return -ENODEV;
+}
+
 static inline struct regulator *__must_check
 regulator_get_optional(struct device *dev, const char *id)
 {
@@ -371,6 +387,10 @@ static inline void devm_regulator_put(struct regulator *regulator)
 {
 }
 
+static inline void devm_regulator_bulk_put(struct regulator_bulk_data *consumers)
+{
+}
+
 static inline int regulator_register_supply_alias(struct device *dev,
 						  const char *id,
 						  struct device *alias_dev,
@@ -461,6 +481,13 @@ static inline int regulator_bulk_enable(int num_consumers,
 	return 0;
 }
 
+static inline int devm_regulator_bulk_get_enable(struct device *dev,
+						 int num_consumers,
+						 const char * const *id)
+{
+	return 0;
+}
+
 static inline int regulator_bulk_disable(int num_consumers,
 					 struct regulator_bulk_data *consumers)
 {
-- 
2.39.5



