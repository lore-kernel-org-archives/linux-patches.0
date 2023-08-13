Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9866D9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F37CBC433C9;
	Sun, 13 Aug 2023 21:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962336;
	bh=sqTW8dK3H/9DaN2wTnRnd29na1gnUo6H+TTW5P1gbGQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kF4TwY5if33sK6X6OokdcWxkB+83IFzH6l9z4IeXYFK/pHNoKPe1B3tgkLif+sFUY
	 boNqCg7fZYei9tcYQ4YFaVQovtl075cLsxaBAzwcAlcmFeW6yze6tmGoRJOzQMmTLs
	 HmvM0NBa0eutwX8eGic7c3m0udavjXgen8O5/y3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Apitzsch?= <git@apitzsch.eu>,
	Andrew Kallmeyer <kallmeyeras@gmail.com>,
	=?UTF-8?q?Gerg=C5=91=20K=C3=B6teles?= <soyer@irl.hu>,
	Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 6.4 199/206] platform/x86: lenovo-ymc: Only bind on machines with a convertible DMI chassis-type
Date: Sun, 13 Aug 2023 23:19:29 +0200
Message-ID: <20230813211730.706570074@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit 2b6aa6610dc9690f79d305ca938abfb799a4f766 upstream.

The lenovo-ymc driver is causing the keyboard + touchpad to stop working
on some regular laptop models such as the Lenovo ThinkBook 13s G2 ITL 20V9.

The problem is that there are YMC WMI GUID methods in the ACPI tables
of these laptops, despite them not being Yogas and lenovo-ymc loading
causes libinput to see a SW_TABLET_MODE switch with state 1.

This in turn causes libinput to ignore events from the builtin keyboard
and touchpad, since it filters those out for a Yoga in tablet mode.

Similar issues with false-positive SW_TABLET_MODE=1 reporting have
been seen with the intel-hid driver.

Copy the intel-hid driver approach to fix this and only bind to the WMI
device on machines where the DMI chassis-type indicates the machine
is a convertible.

Add a 'force' module parameter to allow overriding the chassis-type check
so that users can easily test if the YMC interface works on models which
report an unexpected chassis-type.

Fixes: e82882cdd241 ("platform/x86: Add driver for Yoga Tablet Mode switch")
Link: https://bugzilla.redhat.com/show_bug.cgi?id=2229373
Cc: André Apitzsch <git@apitzsch.eu>
Cc: stable@vger.kernel.org
Tested-by: Andrew Kallmeyer <kallmeyeras@gmail.com>
Tested-by: Gergő Köteles <soyer@irl.hu>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20230812144818.383230-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/lenovo-ymc.c | 25 +++++++++++++++++++++++++
 1 file changed, 25 insertions(+)

diff --git a/drivers/platform/x86/lenovo-ymc.c b/drivers/platform/x86/lenovo-ymc.c
index 41676188b373..f360370d5002 100644
--- a/drivers/platform/x86/lenovo-ymc.c
+++ b/drivers/platform/x86/lenovo-ymc.c
@@ -24,6 +24,10 @@ static bool ec_trigger __read_mostly;
 module_param(ec_trigger, bool, 0444);
 MODULE_PARM_DESC(ec_trigger, "Enable EC triggering work-around to force emitting tablet mode events");
 
+static bool force;
+module_param(force, bool, 0444);
+MODULE_PARM_DESC(force, "Force loading on boards without a convertible DMI chassis-type");
+
 static const struct dmi_system_id ec_trigger_quirk_dmi_table[] = {
 	{
 		/* Lenovo Yoga 7 14ARB7 */
@@ -35,6 +39,20 @@ static const struct dmi_system_id ec_trigger_quirk_dmi_table[] = {
 	{ }
 };
 
+static const struct dmi_system_id allowed_chasis_types_dmi_table[] = {
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_CHASSIS_TYPE, "31" /* Convertible */),
+		},
+	},
+	{
+		.matches = {
+			DMI_EXACT_MATCH(DMI_CHASSIS_TYPE, "32" /* Detachable */),
+		},
+	},
+	{ }
+};
+
 struct lenovo_ymc_private {
 	struct input_dev *input_dev;
 	struct acpi_device *ec_acpi_dev;
@@ -111,6 +129,13 @@ static int lenovo_ymc_probe(struct wmi_device *wdev, const void *ctx)
 	struct input_dev *input_dev;
 	int err;
 
+	if (!dmi_check_system(allowed_chasis_types_dmi_table)) {
+		if (force)
+			dev_info(&wdev->dev, "Force loading Lenovo YMC support\n");
+		else
+			return -ENODEV;
+	}
+
 	ec_trigger |= dmi_check_system(ec_trigger_quirk_dmi_table);
 
 	priv = devm_kzalloc(&wdev->dev, sizeof(*priv), GFP_KERNEL);
-- 
2.41.0



