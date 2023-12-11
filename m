Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDEB51C38;
	Mon, 11 Dec 2023 18:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdPrupWo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC42C433C8;
	Mon, 11 Dec 2023 18:53:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320838;
	bh=Hr2+GCVSWXjh2Cxox/uJGCRMdXbdXcsUdSENJfk20Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdPrupWoz+376pE8QLVT/Ectp9CInCdfn3TS6koDkcxfQIFAveqAOHQwV+uQNMxwn
	 mj4xrQCYysCwTWMlh97Ggfb7V/VIXSxxscEXA3slQ0RV9iZe03RCV5wjz9Lsgq+Nxm
	 sd+a4aPIp0wx7d+70QcFMsokNzNDF7TLKs5eKdt8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/141] platform/x86: wmi: Allow duplicate GUIDs for drivers that use struct wmi_driver
Date: Mon, 11 Dec 2023 19:21:14 +0100
Message-ID: <20231211182027.164457644@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182026.503492284@linuxfoundation.org>
References: <20231211182026.503492284@linuxfoundation.org>
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

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 134038b075cb1dae21623499d765973d286ac94a ]

The WMI subsystem in the kernel currently tracks WMI devices by
a GUID string not by ACPI device.  The GUID used by the `wmi-bmof`
module however is available from many devices on nearly every machine.

This originally was thought to be a bug, but as it happens on most
machines it is a design mistake.  It has been fixed by tying an ACPI
device to the driver with struct wmi_driver. So drivers that have
moved over to struct wmi_driver can actually support multiple
instantiations of a GUID without any problem.

Add an allow list into wmi.c for GUIDs that the drivers that are known
to use struct wmi_driver.  The list is populated with `wmi-bmof` right
now. The additional instances of that in sysfs with be suffixed with -%d

Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20220829201500.6341-1-mario.limonciello@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: cbf54f37600e ("platform/x86: wmi: Skip blocks with zero instances")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 49 +++++++++++++++++++++++++++++++-------
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 63265ab964245..ce3380f09a472 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -99,6 +99,12 @@ static const struct acpi_device_id wmi_device_ids[] = {
 };
 MODULE_DEVICE_TABLE(acpi, wmi_device_ids);
 
+/* allow duplicate GUIDs as these device drivers use struct wmi_driver */
+static const char * const allow_duplicates[] = {
+	"05901221-D566-11D1-B2F0-00A0C9062910",	/* wmi-bmof */
+	NULL
+};
+
 static struct platform_driver acpi_wmi_driver = {
 	.driver = {
 		.name = "acpi-wmi",
@@ -1039,6 +1045,23 @@ static const struct device_type wmi_type_data = {
 	.release = wmi_dev_release,
 };
 
+/*
+ * _WDG is a static list that is only parsed at startup,
+ * so it's safe to count entries without extra protection.
+ */
+static int guid_count(const guid_t *guid)
+{
+	struct wmi_block *wblock;
+	int count = 0;
+
+	list_for_each_entry(wblock, &wmi_block_list, list) {
+		if (guid_equal(&wblock->gblock.guid, guid))
+			count++;
+	}
+
+	return count;
+}
+
 static int wmi_create_device(struct device *wmi_bus_dev,
 			     struct wmi_block *wblock,
 			     struct acpi_device *device)
@@ -1046,6 +1069,7 @@ static int wmi_create_device(struct device *wmi_bus_dev,
 	struct acpi_device_info *info;
 	char method[5];
 	int result;
+	uint count;
 
 	if (wblock->gblock.flags & ACPI_WMI_EVENT) {
 		wblock->dev.dev.type = &wmi_type_event;
@@ -1102,7 +1126,11 @@ static int wmi_create_device(struct device *wmi_bus_dev,
 	wblock->dev.dev.bus = &wmi_bus_type;
 	wblock->dev.dev.parent = wmi_bus_dev;
 
-	dev_set_name(&wblock->dev.dev, "%pUL", &wblock->gblock.guid);
+	count = guid_count(&wblock->gblock.guid);
+	if (count)
+		dev_set_name(&wblock->dev.dev, "%pUL-%d", &wblock->gblock.guid, count);
+	else
+		dev_set_name(&wblock->dev.dev, "%pUL", &wblock->gblock.guid);
 
 	device_initialize(&wblock->dev.dev);
 
@@ -1122,11 +1150,20 @@ static void wmi_free_devices(struct acpi_device *device)
 	}
 }
 
-static bool guid_already_parsed(struct acpi_device *device, const guid_t *guid)
+static bool guid_already_parsed_for_legacy(struct acpi_device *device, const guid_t *guid)
 {
 	struct wmi_block *wblock;
 
 	list_for_each_entry(wblock, &wmi_block_list, list) {
+		/* skip warning and register if we know the driver will use struct wmi_driver */
+		for (int i = 0; allow_duplicates[i] != NULL; i++) {
+			guid_t tmp;
+
+			if (guid_parse(allow_duplicates[i], &tmp))
+				continue;
+			if (guid_equal(&tmp, guid))
+				return false;
+		}
 		if (guid_equal(&wblock->gblock.guid, guid)) {
 			/*
 			 * Because we historically didn't track the relationship
@@ -1176,13 +1213,7 @@ static int parse_wdg(struct device *wmi_bus_dev, struct acpi_device *device)
 		if (debug_dump_wdg)
 			wmi_dump_wdg(&gblock[i]);
 
-		/*
-		 * Some WMI devices, like those for nVidia hooks, have a
-		 * duplicate GUID. It's not clear what we should do in this
-		 * case yet, so for now, we'll just ignore the duplicate
-		 * for device creation.
-		 */
-		if (guid_already_parsed(device, &gblock[i].guid))
+		if (guid_already_parsed_for_legacy(device, &gblock[i].guid))
 			continue;
 
 		wblock = kzalloc(sizeof(struct wmi_block), GFP_KERNEL);
-- 
2.42.0



