Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5686B1ED4F
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6511C433C9;
	Tue, 25 Jul 2023 11:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690285565;
	bh=fsNdN4z3xFrXTYyZUHuByJMPmWw/2z75B/nXwkaUbLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=faHR4yB/O/N0/uy62TJIrvr1BtoPuk2gseX8l9D51NpFkbGtGvgSGn4+E6jKHCXqW
	 EFn7zWNyQQ7ZwsXIkJNYsHXthas7eymsUZCrQEIXcyq2JpvdI5MLKNwGwwJslZ69MC
	 /V1s2gYbtZrWPKPfZkl9/THYkB57FNjWGKEFFqGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 221/313] platform/x86: wmi: Break possible infinite loop when parsing GUID
Date: Tue, 25 Jul 2023 12:46:14 +0200
Message-ID: <20230725104530.611358074@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104521.167250627@linuxfoundation.org>
References: <20230725104521.167250627@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 028e6e204ace1f080cfeacd72c50397eb8ae8883 ]

The while-loop may break on one of the two conditions, either ID string
is empty or GUID matches. The second one, may never be reached if the
parsed string is not correct GUID. In such a case the loop will never
advance to check the next ID.

Break possible infinite loop by factoring out guid_parse_and_compare()
helper which may be moved to the generic header for everyone later on
and preventing from similar mistake in the future.

Interestingly that firstly it appeared when WMI was turned into a bus
driver, but later when duplicated GUIDs were checked, the while-loop
has been replaced by for-loop and hence no mistake made again.

Fixes: a48e23385fcf ("platform/x86: wmi: add context pointer field to struct wmi_device_id")
Fixes: 844af950da94 ("platform/x86: wmi: Turn WMI into a bus driver")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230621151155.78279-1-andriy.shevchenko@linux.intel.com
Tested-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 22 ++++++++++++----------
 1 file changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index 8d1a7923c03b6..67c4ec554ada8 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -129,6 +129,16 @@ static bool find_guid(const char *guid_string, struct wmi_block **out)
 	return false;
 }
 
+static bool guid_parse_and_compare(const char *string, const guid_t *guid)
+{
+	guid_t guid_input;
+
+	if (guid_parse(string, &guid_input))
+		return false;
+
+	return guid_equal(&guid_input, guid);
+}
+
 static const void *find_guid_context(struct wmi_block *wblock,
 				      struct wmi_driver *wdriver)
 {
@@ -141,11 +151,7 @@ static const void *find_guid_context(struct wmi_block *wblock,
 
 	id = wdriver->id_table;
 	while (*id->guid_string) {
-		guid_t guid_input;
-
-		if (guid_parse(id->guid_string, &guid_input))
-			continue;
-		if (guid_equal(&wblock->gblock.guid, &guid_input))
+		if (guid_parse_and_compare(id->guid_string, &wblock->gblock.guid))
 			return id->context;
 		id++;
 	}
@@ -801,11 +807,7 @@ static int wmi_dev_match(struct device *dev, struct device_driver *driver)
 		return 0;
 
 	while (*id->guid_string) {
-		guid_t driver_guid;
-
-		if (WARN_ON(guid_parse(id->guid_string, &driver_guid)))
-			continue;
-		if (guid_equal(&driver_guid, &wblock->gblock.guid))
+		if (guid_parse_and_compare(id->guid_string, &wblock->gblock.guid))
 			return 1;
 
 		id++;
-- 
2.39.2



