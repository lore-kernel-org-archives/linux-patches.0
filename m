Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1004C15E8B;
	Mon, 30 Dec 2024 15:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735574304; cv=none; b=JwqoZPt6uiy4LhMh87Jz1licvjUESn6b9TLK4dwiMRFgqOw8Qb33XV75GqTQH5jP3eww174O3m5k8x3htfOY/ShIxoyZXZ/CGCKRLoOwZkB3qnr9uAENCKUs2G9imtK8z4DRKNE7d8E7hiTfA/mY727moP9hpIVopSvoHDtRR8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735574304; c=relaxed/simple;
	bh=0SAASCfXmpEfBZUvTVwyBywBwpexCcFKVJakRCUN1bk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DKIWEV1bSQdKoZy8K23U0bYh1g+g9Y6NMqUNQ3eLz60adC1VK3W3BJPYJr6Adokm/+vPxnbLoRGRo/Qq9gz1lbImCcCJyO7Fdj9vg0w9WuSh/dfQmpJ35ShRVNiFXYokkv9BG9Gs/V+PYaVluMXr7/fsJKpVbpGNQhOUMQw/sns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+rv7kFC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+rv7kFC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 713C6C4CED0;
	Mon, 30 Dec 2024 15:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735574303;
	bh=0SAASCfXmpEfBZUvTVwyBywBwpexCcFKVJakRCUN1bk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+rv7kFCotUXxrLX0QuOnEoJWIMwaXF1JV9tzt8GDVGMgJUY6l++ykdQWz4NZ9Xlo
	 2hp6Kjvq2WHtqIRZ6yoK5kJP0LdFhcUDfSCfFRLcR0AOw2wp6rPeVoTlt4ni2WMeiw
	 sX/xGapaVyaa0mzLohGR5XxwVTRthAQcNgdkYdcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 097/114] power: supply: cros_charge-control: add mutex for driver data
Date: Mon, 30 Dec 2024 16:43:34 +0100
Message-ID: <20241230154221.849530702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
References: <20241230154218.044787220@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

commit e5f84d1cf562f7b45e28d6e5f6490626f870f81c upstream.

Concurrent accesses through sysfs may lead to inconsistent state in the
priv data. Introduce a mutex to avoid this.

Fixes: c6ed48ef5259 ("power: supply: add ChromeOS EC based charge control driver")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Link: https://lore.kernel.org/r/20241208-cros_charge-control-v2-v1-1-8d168d0f08a3@weissschuh.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/cros_charge-control.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/cros_charge-control.c b/drivers/power/supply/cros_charge-control.c
index 17c53591ce19..58ca6d9ed613 100644
--- a/drivers/power/supply/cros_charge-control.c
+++ b/drivers/power/supply/cros_charge-control.c
@@ -7,8 +7,10 @@
 #include <acpi/battery.h>
 #include <linux/container_of.h>
 #include <linux/dmi.h>
+#include <linux/lockdep.h>
 #include <linux/mod_devicetable.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/platform_data/cros_ec_commands.h>
 #include <linux/platform_data/cros_ec_proto.h>
 #include <linux/platform_device.h>
@@ -49,6 +51,7 @@ struct cros_chctl_priv {
 	struct attribute *attributes[_CROS_CHCTL_ATTR_COUNT];
 	struct attribute_group group;
 
+	struct mutex lock; /* protects fields below and cros_ec */
 	enum power_supply_charge_behaviour current_behaviour;
 	u8 current_start_threshold, current_end_threshold;
 };
@@ -85,6 +88,8 @@ static int cros_chctl_configure_ec(struct cros_chctl_priv *priv)
 {
 	struct ec_params_charge_control req = {};
 
+	lockdep_assert_held(&priv->lock);
+
 	req.cmd = EC_CHARGE_CONTROL_CMD_SET;
 
 	switch (priv->current_behaviour) {
@@ -159,6 +164,7 @@ static ssize_t charge_control_start_threshold_show(struct device *dev,
 	struct cros_chctl_priv *priv = cros_chctl_attr_to_priv(&attr->attr,
 							       CROS_CHCTL_ATTR_START_THRESHOLD);
 
+	guard(mutex)(&priv->lock);
 	return sysfs_emit(buf, "%u\n", (unsigned int)priv->current_start_threshold);
 }
 
@@ -169,6 +175,7 @@ static ssize_t charge_control_start_threshold_store(struct device *dev,
 	struct cros_chctl_priv *priv = cros_chctl_attr_to_priv(&attr->attr,
 							       CROS_CHCTL_ATTR_START_THRESHOLD);
 
+	guard(mutex)(&priv->lock);
 	return cros_chctl_store_threshold(dev, priv, 0, buf, count);
 }
 
@@ -178,6 +185,7 @@ static ssize_t charge_control_end_threshold_show(struct device *dev, struct devi
 	struct cros_chctl_priv *priv = cros_chctl_attr_to_priv(&attr->attr,
 							       CROS_CHCTL_ATTR_END_THRESHOLD);
 
+	guard(mutex)(&priv->lock);
 	return sysfs_emit(buf, "%u\n", (unsigned int)priv->current_end_threshold);
 }
 
@@ -187,6 +195,7 @@ static ssize_t charge_control_end_threshold_store(struct device *dev, struct dev
 	struct cros_chctl_priv *priv = cros_chctl_attr_to_priv(&attr->attr,
 							       CROS_CHCTL_ATTR_END_THRESHOLD);
 
+	guard(mutex)(&priv->lock);
 	return cros_chctl_store_threshold(dev, priv, 1, buf, count);
 }
 
@@ -195,6 +204,7 @@ static ssize_t charge_behaviour_show(struct device *dev, struct device_attribute
 	struct cros_chctl_priv *priv = cros_chctl_attr_to_priv(&attr->attr,
 							       CROS_CHCTL_ATTR_CHARGE_BEHAVIOUR);
 
+	guard(mutex)(&priv->lock);
 	return power_supply_charge_behaviour_show(dev, EC_CHARGE_CONTROL_BEHAVIOURS,
 						  priv->current_behaviour, buf);
 }
@@ -210,6 +220,7 @@ static ssize_t charge_behaviour_store(struct device *dev, struct device_attribut
 	if (ret < 0)
 		return ret;
 
+	guard(mutex)(&priv->lock);
 	priv->current_behaviour = ret;
 
 	ret = cros_chctl_configure_ec(priv);
@@ -290,6 +301,10 @@ static int cros_chctl_probe(struct platform_device *pdev)
 	if (!priv)
 		return -ENOMEM;
 
+	ret = devm_mutex_init(dev, &priv->lock);
+	if (ret)
+		return ret;
+
 	ret = cros_ec_get_cmd_versions(cros_ec, EC_CMD_CHARGE_CONTROL);
 	if (ret < 0)
 		return ret;
@@ -327,7 +342,8 @@ static int cros_chctl_probe(struct platform_device *pdev)
 	priv->current_end_threshold = 100;
 
 	/* Bring EC into well-known state */
-	ret = cros_chctl_configure_ec(priv);
+	scoped_guard(mutex, &priv->lock)
+		ret = cros_chctl_configure_ec(priv);
 	if (ret < 0)
 		return ret;
 
-- 
2.47.1



