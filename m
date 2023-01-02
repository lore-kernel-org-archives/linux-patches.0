Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B682028EE
	for <patches@lists.linux.dev>; Mon,  2 Jan 2023 11:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A0E6C433EF;
	Mon,  2 Jan 2023 11:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672658831;
	bh=Wf5xNKqZ6Ql/BiGyE2MkFQiGMISDlUI5v4ls3UcP7nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BLL71hxwUgCaWXxAI2r24zmuqVwsVogh8JTdH7ku4n8bEbfjUnXRrLxMpdZNM/EfV
	 ufERx+kJnVk+lwW4+Uz95uBSG4hY1Df8Uy1/Y2uHN21m0jYTKhyjrxcgpcWhaw+VBf
	 ebyRFB72flsvqENcvyxfOIVhfbn1qKfURqJpCotU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 16/74] ACPI: resource: do IRQ override on LENOVO IdeaPad
Date: Mon,  2 Jan 2023 12:21:49 +0100
Message-Id: <20230102110552.734360713@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit bfcdf58380b1d9be564a78a9370da722ed1a9965 ]

LENOVO IdeaPad Flex 5 is ryzen-5 based and the commit below removed IRQ
overriding for those. This broke touchscreen and trackpad:
 i2c_designware AMDI0010:00: controller timed out
 i2c_designware AMDI0010:03: controller timed out
 i2c_hid_acpi i2c-MSFT0001:00: failed to reset device: -61
 i2c_designware AMDI0010:03: controller timed out
 ...
 i2c_hid_acpi i2c-MSFT0001:00: can't add hid device: -61
 i2c_hid_acpi: probe of i2c-MSFT0001:00 failed with error -61

White-list this specific model in the override_table.

For this to work, the ZEN test needs to be put below the table walk.

Fixes: 37c81d9f1d1b (ACPI: resource: skip IRQ override on AMD Zen platforms)
Link: https://bugzilla.suse.com/show_bug.cgi?id=1203794
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 42 +++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 2ebc85233bac..30811a9521d4 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -417,17 +417,31 @@ static const struct dmi_system_id asus_laptop[] = {
 	{ }
 };
 
+static const struct dmi_system_id lenovo_82ra[] = {
+	{
+		.ident = "LENOVO IdeaPad Flex 5 16ALC7",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "82RA"),
+		},
+	},
+	{ }
+};
+
 struct irq_override_cmp {
 	const struct dmi_system_id *system;
 	unsigned char irq;
 	unsigned char triggering;
 	unsigned char polarity;
 	unsigned char shareable;
+	bool override;
 };
 
-static const struct irq_override_cmp skip_override_table[] = {
-	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
-	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
+static const struct irq_override_cmp override_table[] = {
+	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
+	{ asus_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, false },
+	{ lenovo_82ra, 6, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
+	{ lenovo_82ra, 10, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0, true },
 };
 
 static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
@@ -435,6 +449,17 @@ static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
 {
 	int i;
 
+	for (i = 0; i < ARRAY_SIZE(override_table); i++) {
+		const struct irq_override_cmp *entry = &override_table[i];
+
+		if (dmi_check_system(entry->system) &&
+		    entry->irq == gsi &&
+		    entry->triggering == triggering &&
+		    entry->polarity == polarity &&
+		    entry->shareable == shareable)
+			return entry->override;
+	}
+
 #ifdef CONFIG_X86
 	/*
 	 * IRQ override isn't needed on modern AMD Zen systems and
@@ -445,17 +470,6 @@ static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
 		return false;
 #endif
 
-	for (i = 0; i < ARRAY_SIZE(skip_override_table); i++) {
-		const struct irq_override_cmp *entry = &skip_override_table[i];
-
-		if (dmi_check_system(entry->system) &&
-		    entry->irq == gsi &&
-		    entry->triggering == triggering &&
-		    entry->polarity == polarity &&
-		    entry->shareable == shareable)
-			return false;
-	}
-
 	return true;
 }
 
-- 
2.35.1



