Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A97CC168B0
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:48:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GLhvGYW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24594C433C8;
	Mon, 23 Oct 2023 11:48:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061734;
	bh=yssk2AKsu2ELNdjaLnUoiIxrQke8YN5NBZXkfB4LzQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLhvGYW8R4gFqOeBa5w/DQygtw+xkc3FHS3RGHKN6K9gYcAkq4Dah5XsqFQ9JE4JR
	 AIgNAT83tZ/apIDYrupjOmjEKxtx5iTq/YZY94csuexZ3WtA0lC8w03djGVfojLCpI
	 WTjGdLyt/8cvyZmkSxjnEHQJ2jqjfdc/qcVgdNKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Lyude Paul <lyude@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 146/202] drm/connector: Add a fwnode pointer to drm_connector and register with ACPI (v2)
Date: Mon, 23 Oct 2023 12:57:33 +0200
Message-ID: <20231023104830.803647220@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104826.569169691@linuxfoundation.org>
References: <20231023104826.569169691@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 48c429c6d18db115c277b75000152d8fa4cd35d0 ]

Add a fwnode pointer to struct drm_connector and register an acpi_bus_type
for the connectors with the ACPI subsystem (when CONFIG_ACPI is enabled).

The adding of the fwnode pointer allows drivers to associate a fwnode
that represents a connector with that connector.

When the new fwnode pointer points to an ACPI-companion, then the new
acpi_bus_type will cause the ACPI subsys to bind the device instantiated
for the connector with the fwnode by calling acpi_bind_one(). This will
result in a firmware_node symlink under /sys/class/card#-<connecter-name>/
which helps to verify that the fwnode-s and connectors are properly
matched.

Changes in v2:
- Make drm_connector_cleanup() call fwnode_handle_put() on
  connector->fwnode and document this

Co-developed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Tested-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://lore.kernel.org/r/20210817215201.795062-3-hdegoede@redhat.com
Stable-dep-of: 89434b069e46 ("usb: typec: altmodes/displayport: Signal hpd low when exiting mode")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_connector.c |  2 ++
 drivers/gpu/drm/drm_sysfs.c     | 37 +++++++++++++++++++++++++++++++++
 include/drm/drm_connector.h     |  8 +++++++
 3 files changed, 47 insertions(+)

diff --git a/drivers/gpu/drm/drm_connector.c b/drivers/gpu/drm/drm_connector.c
index 9c3bbe2c3e6f9..c08501a5620d5 100644
--- a/drivers/gpu/drm/drm_connector.c
+++ b/drivers/gpu/drm/drm_connector.c
@@ -471,6 +471,8 @@ void drm_connector_cleanup(struct drm_connector *connector)
 	drm_mode_object_unregister(dev, &connector->base);
 	kfree(connector->name);
 	connector->name = NULL;
+	fwnode_handle_put(connector->fwnode);
+	connector->fwnode = NULL;
 	spin_lock_irq(&dev->mode_config.connector_list_lock);
 	list_del(&connector->head);
 	dev->mode_config.num_connector--;
diff --git a/drivers/gpu/drm/drm_sysfs.c b/drivers/gpu/drm/drm_sysfs.c
index a3b71478c5904..71a0d9596efee 100644
--- a/drivers/gpu/drm/drm_sysfs.c
+++ b/drivers/gpu/drm/drm_sysfs.c
@@ -10,6 +10,7 @@
  * Copyright (c) 2003-2004 IBM Corp.
  */
 
+#include <linux/acpi.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/export.h>
@@ -56,6 +57,39 @@ static struct device_type drm_sysfs_device_connector = {
 
 struct class *drm_class;
 
+#ifdef CONFIG_ACPI
+static bool drm_connector_acpi_bus_match(struct device *dev)
+{
+	return dev->type == &drm_sysfs_device_connector;
+}
+
+static struct acpi_device *drm_connector_acpi_find_companion(struct device *dev)
+{
+	struct drm_connector *connector = to_drm_connector(dev);
+
+	return to_acpi_device_node(connector->fwnode);
+}
+
+static struct acpi_bus_type drm_connector_acpi_bus = {
+	.name = "drm_connector",
+	.match = drm_connector_acpi_bus_match,
+	.find_companion = drm_connector_acpi_find_companion,
+};
+
+static void drm_sysfs_acpi_register(void)
+{
+	register_acpi_bus_type(&drm_connector_acpi_bus);
+}
+
+static void drm_sysfs_acpi_unregister(void)
+{
+	unregister_acpi_bus_type(&drm_connector_acpi_bus);
+}
+#else
+static void drm_sysfs_acpi_register(void) { }
+static void drm_sysfs_acpi_unregister(void) { }
+#endif
+
 static char *drm_devnode(struct device *dev, umode_t *mode)
 {
 	return kasprintf(GFP_KERNEL, "dri/%s", dev_name(dev));
@@ -89,6 +123,8 @@ int drm_sysfs_init(void)
 	}
 
 	drm_class->devnode = drm_devnode;
+
+	drm_sysfs_acpi_register();
 	return 0;
 }
 
@@ -101,6 +137,7 @@ void drm_sysfs_destroy(void)
 {
 	if (IS_ERR_OR_NULL(drm_class))
 		return;
+	drm_sysfs_acpi_unregister();
 	class_remove_file(drm_class, &class_attr_version.attr);
 	class_destroy(drm_class);
 	drm_class = NULL;
diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index 928136556174c..ffad68f775cc6 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -1174,6 +1174,14 @@ struct drm_connector {
 	struct device *kdev;
 	/** @attr: sysfs attributes */
 	struct device_attribute *attr;
+	/**
+	 * @fwnode: associated fwnode supplied by platform firmware
+	 *
+	 * Drivers can set this to associate a fwnode with a connector, drivers
+	 * are expected to get a reference on the fwnode when setting this.
+	 * drm_connector_cleanup() will call fwnode_handle_put() on this.
+	 */
+	struct fwnode_handle *fwnode;
 
 	/**
 	 * @head:
-- 
2.40.1



