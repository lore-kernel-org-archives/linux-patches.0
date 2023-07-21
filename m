Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB55D20F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DB04C433C7;
	Fri, 21 Jul 2023 19:10:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966654;
	bh=72Q9KX0kyV2ob9d7OIho0L9yxkUaKL/L81pO/3QojcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vx2Y35VO36BHJKV692Crqz8IX/cQcgSszun7Hm7F5kgEobFVWy34v9DqcE5kEp1bX
	 C2lRg45gevb2D7Z7mD4LKdIiXlBpbhPOwZ2GsAkT1fItTQbjSvzY13l8n4V4CgrqVV
	 jOsa5Z2X4IjRKSl3b7a5d1ZbJBI8xezvmz1sImpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 421/532] platform/x86: wmi: use guid_t and guid_equal()
Date: Fri, 21 Jul 2023 18:05:25 +0200
Message-ID: <20230721160637.378882404@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Barnabás Pőcze <pobrn@protonmail.com>

[ Upstream commit 67f472fdacf4a691b1c3c20c27800b23ce31e2de ]

Instead of hard-coding a 16 long byte array,
use the available `guid_t` type and related methods.

Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>
Link: https://lore.kernel.org/r/20210904175450.156801-15-pobrn@protonmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 028e6e204ace ("platform/x86: wmi: Break possible infinite loop when parsing GUID")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 529f725271e99..d55770711a831 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -39,7 +39,7 @@ MODULE_LICENSE("GPL");
 static LIST_HEAD(wmi_block_list);
 
 struct guid_block {
-	char guid[16];
+	guid_t guid;
 	union {
 		char object_id[2];
 		struct {
@@ -124,7 +124,7 @@ static bool find_guid(const char *guid_string, struct wmi_block **out)
 	list_for_each_entry(wblock, &wmi_block_list, list) {
 		block = &wblock->gblock;
 
-		if (memcmp(block->guid, &guid_input, 16) == 0) {
+		if (guid_equal(&block->guid, &guid_input)) {
 			if (out)
 				*out = wblock;
 			return true;
@@ -148,7 +148,7 @@ static const void *find_guid_context(struct wmi_block *wblock,
 	while (*id->guid_string) {
 		if (guid_parse(id->guid_string, &guid_input))
 			continue;
-		if (!memcmp(wblock->gblock.guid, &guid_input, 16))
+		if (guid_equal(&wblock->gblock.guid, &guid_input))
 			return id->context;
 		id++;
 	}
@@ -460,7 +460,7 @@ EXPORT_SYMBOL_GPL(wmi_set_block);
 
 static void wmi_dump_wdg(const struct guid_block *g)
 {
-	pr_info("%pUL:\n", g->guid);
+	pr_info("%pUL:\n", &g->guid);
 	if (g->flags & ACPI_WMI_EVENT)
 		pr_info("\tnotify_id: 0x%02X\n", g->notify_id);
 	else
@@ -542,7 +542,7 @@ wmi_notify_handler handler, void *data)
 	list_for_each_entry(block, &wmi_block_list, list) {
 		acpi_status wmi_status;
 
-		if (memcmp(block->gblock.guid, &guid_input, 16) == 0) {
+		if (guid_equal(&block->gblock.guid, &guid_input)) {
 			if (block->handler &&
 			    block->handler != wmi_notify_debug)
 				return AE_ALREADY_ACQUIRED;
@@ -582,7 +582,7 @@ acpi_status wmi_remove_notify_handler(const char *guid)
 	list_for_each_entry(block, &wmi_block_list, list) {
 		acpi_status wmi_status;
 
-		if (memcmp(block->gblock.guid, &guid_input, 16) == 0) {
+		if (guid_equal(&block->gblock.guid, &guid_input)) {
 			if (!block->handler ||
 			    block->handler == wmi_notify_debug)
 				return AE_NULL_ENTRY;
@@ -693,7 +693,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 {
 	struct wmi_block *wblock = dev_to_wblock(dev);
 
-	return sprintf(buf, "wmi:%pUL\n", wblock->gblock.guid);
+	return sprintf(buf, "wmi:%pUL\n", &wblock->gblock.guid);
 }
 static DEVICE_ATTR_RO(modalias);
 
@@ -702,7 +702,7 @@ static ssize_t guid_show(struct device *dev, struct device_attribute *attr,
 {
 	struct wmi_block *wblock = dev_to_wblock(dev);
 
-	return sprintf(buf, "%pUL\n", wblock->gblock.guid);
+	return sprintf(buf, "%pUL\n", &wblock->gblock.guid);
 }
 static DEVICE_ATTR_RO(guid);
 
@@ -785,10 +785,10 @@ static int wmi_dev_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
 	struct wmi_block *wblock = dev_to_wblock(dev);
 
-	if (add_uevent_var(env, "MODALIAS=wmi:%pUL", wblock->gblock.guid))
+	if (add_uevent_var(env, "MODALIAS=wmi:%pUL", &wblock->gblock.guid))
 		return -ENOMEM;
 
-	if (add_uevent_var(env, "WMI_GUID=%pUL", wblock->gblock.guid))
+	if (add_uevent_var(env, "WMI_GUID=%pUL", &wblock->gblock.guid))
 		return -ENOMEM;
 
 	return 0;
@@ -815,7 +815,7 @@ static int wmi_dev_match(struct device *dev, struct device_driver *driver)
 
 		if (WARN_ON(guid_parse(id->guid_string, &driver_guid)))
 			continue;
-		if (!memcmp(&driver_guid, wblock->gblock.guid, 16))
+		if (guid_equal(&driver_guid, &wblock->gblock.guid))
 			return 1;
 
 		id++;
@@ -1108,7 +1108,7 @@ static int wmi_create_device(struct device *wmi_bus_dev,
 	wblock->dev.dev.bus = &wmi_bus_type;
 	wblock->dev.dev.parent = wmi_bus_dev;
 
-	dev_set_name(&wblock->dev.dev, "%pUL", wblock->gblock.guid);
+	dev_set_name(&wblock->dev.dev, "%pUL", &wblock->gblock.guid);
 
 	device_initialize(&wblock->dev.dev);
 
@@ -1128,12 +1128,12 @@ static void wmi_free_devices(struct acpi_device *device)
 	}
 }
 
-static bool guid_already_parsed(struct acpi_device *device, const u8 *guid)
+static bool guid_already_parsed(struct acpi_device *device, const guid_t *guid)
 {
 	struct wmi_block *wblock;
 
 	list_for_each_entry(wblock, &wmi_block_list, list) {
-		if (memcmp(wblock->gblock.guid, guid, 16) == 0) {
+		if (guid_equal(&wblock->gblock.guid, guid)) {
 			/*
 			 * Because we historically didn't track the relationship
 			 * between GUIDs and ACPI nodes, we don't know whether
@@ -1188,7 +1188,7 @@ static int parse_wdg(struct device *wmi_bus_dev, struct acpi_device *device)
 		 * case yet, so for now, we'll just ignore the duplicate
 		 * for device creation.
 		 */
-		if (guid_already_parsed(device, gblock[i].guid))
+		if (guid_already_parsed(device, &gblock[i].guid))
 			continue;
 
 		wblock = kzalloc(sizeof(struct wmi_block), GFP_KERNEL);
@@ -1225,7 +1225,7 @@ static int parse_wdg(struct device *wmi_bus_dev, struct acpi_device *device)
 		retval = device_add(&wblock->dev.dev);
 		if (retval) {
 			dev_err(wmi_bus_dev, "failed to register %pUL\n",
-				wblock->gblock.guid);
+				&wblock->gblock.guid);
 			if (debug_event)
 				wmi_method_enable(wblock, 0);
 			list_del(&wblock->list);
@@ -1333,7 +1333,7 @@ static void acpi_wmi_notify_handler(acpi_handle handle, u32 event,
 	}
 
 	if (debug_event)
-		pr_info("DEBUG Event GUID: %pUL\n", wblock->gblock.guid);
+		pr_info("DEBUG Event GUID: %pUL\n", &wblock->gblock.guid);
 
 	acpi_bus_generate_netlink_event(
 		wblock->acpi_device->pnp.device_class,
-- 
2.39.2



