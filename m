Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DCA20F88
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:10:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80892C433C8;
	Fri, 21 Jul 2023 19:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689966651;
	bh=TwIdimlUYYyx1sR21VeQvqWmA+H0+AqEXcQuVxZIcwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D1AzicfUfRMr0nYs70GCAawojpRiUS130mp31twCAbj//853A8g8TuU1BfQHhpsOh
	 jTm7jKG+jNf2xuCf00uuj6lhkLg5XVlA0tEWNXqyvftCkEE9ot4qMApV7IKBRKbHUn
	 nSKkeEUm4sIbAOuPwZvCDRzzohyIxrJqbyuo2jcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 420/532] platform/x86: wmi: remove unnecessary argument
Date: Fri, 21 Jul 2023 18:05:24 +0200
Message-ID: <20230721160637.308021984@linuxfoundation.org>
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

[ Upstream commit 84eacf7e6413d5e2d2f4f9dddf9216c18a3631cf ]

The GUID block is available for `wmi_create_device()`
through `wblock->gblock`. Use that consistently in
the function instead of using a mix of `gblock` and
`wblock->gblock`.

Signed-off-by: Barnabás Pőcze <pobrn@protonmail.com>
Link: https://lore.kernel.org/r/20210904175450.156801-8-pobrn@protonmail.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 028e6e204ace ("platform/x86: wmi: Break possible infinite loop when parsing GUID")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index c4f917d45b51d..529f725271e99 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -1046,7 +1046,6 @@ static const struct device_type wmi_type_data = {
 };
 
 static int wmi_create_device(struct device *wmi_bus_dev,
-			     const struct guid_block *gblock,
 			     struct wmi_block *wblock,
 			     struct acpi_device *device)
 {
@@ -1054,12 +1053,12 @@ static int wmi_create_device(struct device *wmi_bus_dev,
 	char method[5];
 	int result;
 
-	if (gblock->flags & ACPI_WMI_EVENT) {
+	if (wblock->gblock.flags & ACPI_WMI_EVENT) {
 		wblock->dev.dev.type = &wmi_type_event;
 		goto out_init;
 	}
 
-	if (gblock->flags & ACPI_WMI_METHOD) {
+	if (wblock->gblock.flags & ACPI_WMI_METHOD) {
 		wblock->dev.dev.type = &wmi_type_method;
 		mutex_init(&wblock->char_mutex);
 		goto out_init;
@@ -1109,7 +1108,7 @@ static int wmi_create_device(struct device *wmi_bus_dev,
 	wblock->dev.dev.bus = &wmi_bus_type;
 	wblock->dev.dev.parent = wmi_bus_dev;
 
-	dev_set_name(&wblock->dev.dev, "%pUL", gblock->guid);
+	dev_set_name(&wblock->dev.dev, "%pUL", wblock->gblock.guid);
 
 	device_initialize(&wblock->dev.dev);
 
@@ -1201,7 +1200,7 @@ static int parse_wdg(struct device *wmi_bus_dev, struct acpi_device *device)
 		wblock->acpi_device = device;
 		wblock->gblock = gblock[i];
 
-		retval = wmi_create_device(wmi_bus_dev, &gblock[i], wblock, device);
+		retval = wmi_create_device(wmi_bus_dev, wblock, device);
 		if (retval) {
 			kfree(wblock);
 			continue;
-- 
2.39.2



