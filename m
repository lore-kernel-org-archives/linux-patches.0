Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A33F21DE894;
	Wed, 19 Feb 2025 08:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739954959; cv=none; b=pg3TgzsjcEnXF9/fS7dcRQI7npITpDbFQnxxWhX09ZmxW0absSlibJ7zNYTUwM+OhdXvKqZTm1D/BeQlq3JXNSmjwA0NHP3tApkh71nvAcqnFLTu0Rn5LBZ+SrU5eaNndF/MnYBm7parniwWvMSMAjgOk23L8fbHqHTyDPKIRwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739954959; c=relaxed/simple;
	bh=Dsy4rUe0dheYVmmdKvXypjVkI/ABehVSn19zTjN0YMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8VkV1qxm3sfUMTd0C+J+nkmbqKPxgY49aYbpSZZ5kMFxBnb3LDDIQCUecb7o05vwa9n5sIbSWFRDnFoQvEiXkHXJG/zW3voN7NrCwpc+5CHen2QI6iVcF/A4LB6+Wtb/5m/qax5To/bvNKu7D1xOPES8DjiPZ4v2hdNu4eU6qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0z3kXvYM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0z3kXvYM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27D49C4CEE8;
	Wed, 19 Feb 2025 08:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739954959;
	bh=Dsy4rUe0dheYVmmdKvXypjVkI/ABehVSn19zTjN0YMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0z3kXvYMwEZZtz/I+VnmqwDR7GHE0klCj9CtVizx0Xjo03pGIdILXyz44hltAJdMQ
	 idf1bq9ebKpEqgt8RtOUGa/lwiyjcREzAVc3EEz4RMg2PKWjRn7BrA24Hh0qTnXG5k
	 laLgMDFahgiwhfUOUKguFG5vUPljvyxdi0I3tWkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 088/230] ACPI: x86: Add skip i2c clients quirk for Vexia EDU ATLA 10 tablet 5V
Date: Wed, 19 Feb 2025 09:26:45 +0100
Message-ID: <20250219082605.142688972@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082601.683263930@linuxfoundation.org>
References: <20250219082601.683263930@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 8f62ca9c338aae4f73e9ce0221c3d4668359ddd8 ]

The Vexia EDU ATLA 10 tablet comes in 2 different versions with
significantly different mainboards. The only outward difference is that
the charging barrel on one is marked 5V and the other is marked 9V.

Both ship with Android 4.4 as factory OS and have the usual broken DSDT
issues for x86 Android tablets.

Add a quirk to skip ACPI I2C client enumeration for the 5V version to
complement the existing quirk for the 9V version.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://patch.msgid.link/20250123132202.18209-1-hdegoede@redhat.com
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/x86/utils.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/acpi/x86/utils.c b/drivers/acpi/x86/utils.c
index cb45ef5240dab..068c1612660bc 100644
--- a/drivers/acpi/x86/utils.c
+++ b/drivers/acpi/x86/utils.c
@@ -407,6 +407,19 @@ static const struct dmi_system_id acpi_quirk_skip_dmi_ids[] = {
 		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
 					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
 	},
+	{
+		/* Vexia Edu Atla 10 tablet 5V version */
+		.matches = {
+			/* Having all 3 of these not set is somewhat unique */
+			DMI_MATCH(DMI_SYS_VENDOR, "To be filled by O.E.M."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "To be filled by O.E.M."),
+			DMI_MATCH(DMI_BOARD_NAME, "To be filled by O.E.M."),
+			/* Above strings are too generic, also match on BIOS date */
+			DMI_MATCH(DMI_BIOS_DATE, "05/14/2015"),
+		},
+		.driver_data = (void *)(ACPI_QUIRK_SKIP_I2C_CLIENTS |
+					ACPI_QUIRK_SKIP_ACPI_AC_AND_BATTERY),
+	},
 	{
 		/* Vexia Edu Atla 10 tablet 9V version */
 		.matches = {
-- 
2.39.5



