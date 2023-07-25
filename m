Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92EA182C8
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69AA9C433C8;
	Tue, 25 Jul 2023 11:27:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284447;
	bh=G8QdQxvwKIMQqQgvbOih9PD3LfvdNBm/xiC+5MynC6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X+PvSP+oRnz3D1jyjbSPdA9U17PJVcaqGoeUH73osoErenj6De/Q75Yacl8TEd8dV
	 h2WDViUtrmaG/4gM4Vdozxb0XX2Gexfjlesv+2cyNNVyrHaQ/MVE1oz3OwX3JvqYU1
	 cDNVkOeCKgZ9JGIlAfKza7FI/GVHOvUlP3jcYUs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 360/509] platform/x86: wmi: move variables
Date: Tue, 25 Jul 2023 12:44:59 +0200
Message-ID: <20230725104610.206533879@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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

[ Upstream commit f5431bf1e6781e876bdc8ae10fb1e7da6f1aa9b5 ]

Move some variables in order to keep them
in the narrowest possible scope.

Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>
Link: https://lore.kernel.org/r/20210904175450.156801-22-pobrn@protonmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 028e6e204ace ("platform/x86: wmi: Break possible infinite loop when parsing GUID")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 18c4080d4a71e..5e4c03f7db7c0 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -134,7 +134,6 @@ static const void *find_guid_context(struct wmi_block *wblock,
 				      struct wmi_driver *wdriver)
 {
 	const struct wmi_device_id *id;
-	guid_t guid_input;
 
 	if (wblock == NULL || wdriver == NULL)
 		return NULL;
@@ -143,6 +142,8 @@ static const void *find_guid_context(struct wmi_block *wblock,
 
 	id = wdriver->id_table;
 	while (*id->guid_string) {
+		guid_t guid_input;
+
 		if (guid_parse(id->guid_string, &guid_input))
 			continue;
 		if (guid_equal(&wblock->gblock.guid, &guid_input))
@@ -615,7 +616,6 @@ acpi_status wmi_get_event_data(u32 event, struct acpi_buffer *out)
 {
 	struct acpi_object_list input;
 	union acpi_object params[1];
-	struct guid_block *gblock;
 	struct wmi_block *wblock;
 
 	input.count = 1;
@@ -624,7 +624,7 @@ acpi_status wmi_get_event_data(u32 event, struct acpi_buffer *out)
 	params[0].integer.value = event;
 
 	list_for_each_entry(wblock, &wmi_block_list, list) {
-		gblock = &wblock->gblock;
+		struct guid_block *gblock = &wblock->gblock;
 
 		if ((gblock->flags & ACPI_WMI_EVENT) &&
 			(gblock->notify_id == event))
@@ -1281,12 +1281,11 @@ acpi_wmi_ec_space_handler(u32 function, acpi_physical_address address,
 static void acpi_wmi_notify_handler(acpi_handle handle, u32 event,
 				    void *context)
 {
-	struct guid_block *block;
 	struct wmi_block *wblock;
 	bool found_it = false;
 
 	list_for_each_entry(wblock, &wmi_block_list, list) {
-		block = &wblock->gblock;
+		struct guid_block *block = &wblock->gblock;
 
 		if (wblock->acpi_device->handle == handle &&
 		    (block->flags & ACPI_WMI_EVENT) &&
-- 
2.39.2



