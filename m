Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C7D8AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:13:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AA12C433EF;
	Wed,  4 Jan 2023 16:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848793;
	bh=MLqWsvv4z/vdalGPAKjnUi15MeM7CF0nPaJgEgCIVr0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KuE2f/FedCIG3KIGEWn9KmCgecJBE4sbxkuj7HuztvMyJAtbA8LR2063JATSlDora
	 gqXS1N4CbiT90zYXzTWTl0ZeLCPD5NrkVx8fns1mvZ/Yl2X9sC6/tkJC6vbXK2tn2M
	 78/zsc8NXVXljbLxdV5WTra45dGmX6pHzM5tCSrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 057/207] platform/x86: x86-android-tablets: Add Advantech MICA-071 extra button
Date: Wed,  4 Jan 2023 17:05:15 +0100
Message-Id: <20230104160513.720464353@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

[ Upstream commit b03ae77e7e057f4b3b858f10c840557e71448a91 ]

The Advantech MICA-071 is a standard Windows tablet, but it has an extra
"quick launch" button which is not described in the ACPI tables in anyway.

Use the x86-android-tablets infra to create a gpio-button device for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20221127221928.123660-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/x86-android-tablets.c | 58 ++++++++++++++++++++++
 1 file changed, 58 insertions(+)

diff --git a/drivers/platform/x86/x86-android-tablets.c b/drivers/platform/x86/x86-android-tablets.c
index bbfae1395e18..123a4618db55 100644
--- a/drivers/platform/x86/x86-android-tablets.c
+++ b/drivers/platform/x86/x86-android-tablets.c
@@ -265,6 +265,56 @@ static struct gpiod_lookup_table int3496_gpo2_pin22_gpios = {
 	},
 };
 
+/*
+ * Advantech MICA-071
+ * This is a standard Windows tablet, but it has an extra "quick launch" button
+ * which is not described in the ACPI tables in anyway.
+ * Use the x86-android-tablets infra to create a gpio-button device for this.
+ */
+static struct gpio_keys_button advantech_mica_071_button = {
+	.code = KEY_PROG1,
+	/* .gpio gets filled in by advantech_mica_071_init() */
+	.active_low = true,
+	.desc = "prog1_key",
+	.type = EV_KEY,
+	.wakeup = false,
+	.debounce_interval = 50,
+};
+
+static const struct gpio_keys_platform_data advantech_mica_071_button_pdata __initconst = {
+	.buttons = &advantech_mica_071_button,
+	.nbuttons = 1,
+	.name = "prog1_key",
+};
+
+static const struct platform_device_info advantech_mica_071_pdevs[] __initconst = {
+	{
+		.name = "gpio-keys",
+		.id = PLATFORM_DEVID_AUTO,
+		.data = &advantech_mica_071_button_pdata,
+		.size_data = sizeof(advantech_mica_071_button_pdata),
+	},
+};
+
+static int __init advantech_mica_071_init(void)
+{
+	struct gpio_desc *gpiod;
+	int ret;
+
+	ret = x86_android_tablet_get_gpiod("INT33FC:00", 2, &gpiod);
+	if (ret < 0)
+		return ret;
+	advantech_mica_071_button.gpio = desc_to_gpio(gpiod);
+
+	return 0;
+}
+
+static const struct x86_dev_info advantech_mica_071_info __initconst = {
+	.pdev_info = advantech_mica_071_pdevs,
+	.pdev_count = ARRAY_SIZE(advantech_mica_071_pdevs),
+	.init = advantech_mica_071_init,
+};
+
 /* Asus ME176C and TF103C tablets shared data */
 static struct gpio_keys_button asus_me176c_tf103c_lid = {
 	.code = SW_LID,
@@ -1385,6 +1435,14 @@ static const struct x86_dev_info xiaomi_mipad2_info __initconst = {
 };
 
 static const struct dmi_system_id x86_android_tablet_ids[] __initconst = {
+	{
+		/* Advantech MICA-071 */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Advantech"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "MICA-071"),
+		},
+		.driver_data = (void *)&advantech_mica_071_info,
+	},
 	{
 		/* Asus MeMO Pad 7 ME176C */
 		.matches = {
-- 
2.35.1



