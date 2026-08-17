Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01A59442391;
	Mon, 17 Aug 2026 15:27:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980440; cv=none; b=igK+1E4KOSPNm+Q+XvY3YLVtxpzKcQdBWRKZaSDnXLB3gikUAo8E01/j0aLLxkROjVApdTaelXZ+q7KEo0LAm1bplkhn6tOpWhJT0BNh7Su6o6HpmHoBv8VdyZO4ScYmcYJZvUB7XmzAwLUeUuQzqi52dR+jgV/3oNJjQmhhKUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980440; c=relaxed/simple;
	bh=Sxqn+QFX2U74bzp74ypaJEjz2O/GAYRGR9Lyrtt7Hvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EZoJavilJj/cy7L4lcGsVJng7MBuCbFKezfjokBZTeDL1iiYcQ1xmeRvUCbYniBAbM/cvhWo8uDdxIDkCpU+DnxVQcSRG0oUU1FlyBwuA7uNMGXm78uzHaNiZT1LURHaTAhfWdJWNQvb/kYslL1siiIhW2NWTo7CzmBMLnlIIh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOxVn281; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOxVn281"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5437C1F00A3A;
	Mon, 17 Aug 2026 15:27:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980438;
	bh=FKuCMCWwcodPcdWx4NtGJrRHTSFbu0ILryWGt2RTh6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOxVn281hjbZlxhS6EDldti8rZJtcdLGI79Qu2IT3kjIPOFnlyJuImfTvz3DDl5N4
	 23bErf7Xlg6dQDYX3BvpBkYjZnrUGNbzHGwAM/Enpl+tFBK9x1sGKb2tGvI6+ktcyq
	 hZXKgJpg5eeapcjFITPDPSVYyB0UzJMzAXoz4+fY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 533/609] regulator: devres: add API for reference voltage supplies
Date: Mon, 17 Aug 2026 15:33:49 +0200
Message-ID: <20260817132601.623163030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit b250c20b64290808aa4b5cc6d68819a7ee28237f ]

A common use case for regulators is to supply a reference voltage to an
analog input or output device. This adds a new devres API to get,
enable, and get the voltage in a single call. This allows eliminating
boilerplate code in drivers that use reference supplies in this way.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240429-regulator-get-enable-get-votlage-v2-1-b1f11ab766c1@baylibre.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: fddb5ceaf901 ("hwmon: (ads7828) Fix external VREF regulator handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../driver-api/driver-model/devres.rst        |  1 +
 drivers/regulator/devres.c                    | 59 +++++++++++++++++++
 include/linux/regulator/consumer.h            |  7 +++
 3 files changed, 67 insertions(+)

diff --git a/Documentation/driver-api/driver-model/devres.rst b/Documentation/driver-api/driver-model/devres.rst
index 56082265e8e50..11234c12718d1 100644
--- a/Documentation/driver-api/driver-model/devres.rst
+++ b/Documentation/driver-api/driver-model/devres.rst
@@ -413,6 +413,7 @@ REGULATOR
   devm_regulator_bulk_put()
   devm_regulator_get()
   devm_regulator_get_enable()
+  devm_regulator_get_enable_read_voltage()
   devm_regulator_get_enable_optional()
   devm_regulator_get_exclusive()
   devm_regulator_get_optional()
diff --git a/drivers/regulator/devres.c b/drivers/regulator/devres.c
index 5c7ff9b3e8a79..6e8d6dc729cef 100644
--- a/drivers/regulator/devres.c
+++ b/drivers/regulator/devres.c
@@ -145,6 +145,65 @@ struct regulator *devm_regulator_get_optional(struct device *dev,
 }
 EXPORT_SYMBOL_GPL(devm_regulator_get_optional);
 
+/**
+ * devm_regulator_get_enable_read_voltage - Resource managed regulator get and
+ *                                          enable that returns the voltage
+ * @dev: device to supply
+ * @id:  supply name or regulator ID.
+ *
+ * Get and enable regulator for duration of the device life-time.
+ * regulator_disable() and regulator_put() are automatically called on driver
+ * detach. See regulator_get_optional(), regulator_enable(), and
+ * regulator_get_voltage() for more information.
+ *
+ * This is a convenience function for supplies that provide a reference voltage
+ * where the consumer driver just needs to know the voltage and keep the
+ * regulator enabled.
+ *
+ * In cases where the supply is not strictly required, callers can check for
+ * -ENODEV error and handle it accordingly.
+ *
+ * Returns: voltage in microvolts on success, or an error code on failure.
+ */
+int devm_regulator_get_enable_read_voltage(struct device *dev, const char *id)
+{
+	struct regulator *r;
+	int ret;
+
+	/*
+	 * Since we need a real voltage, we use devm_regulator_get_optional()
+	 * rather than getting a dummy regulator with devm_regulator_get() and
+	 * then letting regulator_get_voltage() fail with -EINVAL. This way, the
+	 * caller can handle the -ENODEV error code if needed instead of the
+	 * ambiguous -EINVAL.
+	 */
+	r = devm_regulator_get_optional(dev, id);
+	if (IS_ERR(r))
+		return PTR_ERR(r);
+
+	ret = regulator_enable(r);
+	if (ret)
+		goto err_regulator_put;
+
+	ret = devm_add_action_or_reset(dev, regulator_action_disable, r);
+	if (ret)
+		goto err_regulator_put;
+
+	ret = regulator_get_voltage(r);
+	if (ret < 0)
+		goto err_release_action;
+
+	return 0;
+
+err_release_action:
+	devm_release_action(dev, regulator_action_disable, r);
+err_regulator_put:
+	devm_regulator_put(r);
+
+	return ret;
+}
+EXPORT_SYMBOL_GPL(devm_regulator_get_enable_read_voltage);
+
 static int devm_regulator_match(struct device *dev, void *res, void *data)
 {
 	struct regulator **r = res;
diff --git a/include/linux/regulator/consumer.h b/include/linux/regulator/consumer.h
index 60bc7e143869b..8d3afff87b6e3 100644
--- a/include/linux/regulator/consumer.h
+++ b/include/linux/regulator/consumer.h
@@ -209,6 +209,7 @@ struct regulator *__must_check devm_regulator_get_optional(struct device *dev,
 							   const char *id);
 int devm_regulator_get_enable(struct device *dev, const char *id);
 int devm_regulator_get_enable_optional(struct device *dev, const char *id);
+int devm_regulator_get_enable_read_voltage(struct device *dev, const char *id);
 void regulator_put(struct regulator *regulator);
 void devm_regulator_put(struct regulator *regulator);
 
@@ -372,6 +373,12 @@ static inline int devm_regulator_get_enable_optional(struct device *dev,
 	return 0;
 }
 
+static inline int devm_regulator_get_enable_read_voltage(struct device *dev,
+							 const char *id)
+{
+	return -ENODEV;
+}
+
 static inline struct regulator *__must_check
 regulator_get_optional(struct device *dev, const char *id)
 {
-- 
2.53.0



