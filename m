Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5F69134AC;
	Mon, 12 Aug 2024 16:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480068; cv=none; b=RmpGiMkhvrlcfcnzmuKYHJAwkvXRF26bEq6CFbbBhf4pzc2TopH1dICAG2NLSYOVpj10HF8PPqfHPaplmCLUIrNkEA3U5s8BoJA8TOryAjhPGRb7pCuRBclfEfC19OMY1OtMqc4n7GzigENhZ3rLdtuVvGW86P+itkY5TxfHqXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480068; c=relaxed/simple;
	bh=0YBqT2J9PbuRwepN7t4mXUdogFs8zpMt969yaA9sces=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=S/2/ivmX8+3LPUTGSF193sp2kP5t9Kpa8C8bSN0Cxplp+58pMSMsf7+49V4upvU4sfPAV2uDLzlRC+ZpBjSiwW8fS+uBeXa2sCD/5/rfckY6aTpCO+UapV2o0v004CQGnes6exZWjz3oWcpgaZulHwvvm8jOCc09VuhUwvkyA28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WHQ3gsf+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WHQ3gsf+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4B0C32782;
	Mon, 12 Aug 2024 16:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480067;
	bh=0YBqT2J9PbuRwepN7t4mXUdogFs8zpMt969yaA9sces=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WHQ3gsf+n695AWZrxwn5FDWOJ/HxkEqPMz+W+3GPnmpol61UQtr7cqlFUvEjei3Bi
	 JsNl8nXmKbzorDYNrbwxNE4HOogfrt2Azj6Br9meYDWi33D2sEvc9tgDgOAe2a7Gqx
	 qCsdQYtbD7Rj4mNNC75KOBUygM/ZA1fj7BjNQcKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 055/263] ACPI: SBS: manage alarm sysfs attribute through psy core
Date: Mon, 12 Aug 2024 18:00:56 +0200
Message-ID: <20240812160148.650698268@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <linux@weissschuh.net>

[ Upstream commit 6bad28cfc30988a845fb3f59a99f4b8a4ce8fe95 ]

Let the power supply core register the attribute.

This ensures that the attribute is created before the device is
announced to userspace, avoiding a race condition.

Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/sbs.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index dc8164b182dcc..442c5905d43be 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -77,7 +77,6 @@ struct acpi_battery {
 	u16 spec;
 	u8 id;
 	u8 present:1;
-	u8 have_sysfs_alarm:1;
 };
 
 #define to_acpi_battery(x) power_supply_get_drvdata(x)
@@ -462,12 +461,18 @@ static ssize_t acpi_battery_alarm_store(struct device *dev,
 	return count;
 }
 
-static const struct device_attribute alarm_attr = {
+static struct device_attribute alarm_attr = {
 	.attr = {.name = "alarm", .mode = 0644},
 	.show = acpi_battery_alarm_show,
 	.store = acpi_battery_alarm_store,
 };
 
+static struct attribute *acpi_battery_attrs[] = {
+	&alarm_attr.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(acpi_battery);
+
 /* --------------------------------------------------------------------------
                                  Driver Interface
    -------------------------------------------------------------------------- */
@@ -518,7 +523,10 @@ static int acpi_battery_read(struct acpi_battery *battery)
 static int acpi_battery_add(struct acpi_sbs *sbs, int id)
 {
 	struct acpi_battery *battery = &sbs->battery[id];
-	struct power_supply_config psy_cfg = { .drv_data = battery, };
+	struct power_supply_config psy_cfg = {
+		.drv_data = battery,
+		.attr_grp = acpi_battery_groups,
+	};
 	int result;
 
 	battery->id = id;
@@ -548,10 +556,6 @@ static int acpi_battery_add(struct acpi_sbs *sbs, int id)
 		goto end;
 	}
 
-	result = device_create_file(&battery->bat->dev, &alarm_attr);
-	if (result)
-		goto end;
-	battery->have_sysfs_alarm = 1;
       end:
 	pr_info("%s [%s]: Battery Slot [%s] (battery %s)\n",
 	       ACPI_SBS_DEVICE_NAME, acpi_device_bid(sbs->device),
@@ -563,11 +567,8 @@ static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
 {
 	struct acpi_battery *battery = &sbs->battery[id];
 
-	if (battery->bat) {
-		if (battery->have_sysfs_alarm)
-			device_remove_file(&battery->bat->dev, &alarm_attr);
+	if (battery->bat)
 		power_supply_unregister(battery->bat);
-	}
 }
 
 static int acpi_charger_add(struct acpi_sbs *sbs)
-- 
2.43.0



