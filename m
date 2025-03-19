Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7641DD0EF;
	Wed, 19 Mar 2025 14:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395104; cv=none; b=i1xRoobLSxI9NQuHPZkQNKEW3JxzS4wDBZY5p5dsTkUI/dAsjqWfiXUKUyk0jegFQDP5l05JGdrjGLp98HPEi1e2eWYG5uwPMb9OsqgKluHj1rPvYVQumK/Oa04eRZTVePPapbQCgq5S2va9Ljh16hT7PWBSL6PqAzqxagVa/TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395104; c=relaxed/simple;
	bh=FFGLL8CjhzJbQKGEo3TpZEJii0EaX8O/hLxzIWYt7/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZQCM6PaMjdG4GDiBMebOVRPZE5kFVO4JgYibUWvyyOESCC7TolAyF4z2hFq/c/BuUUMufOMkS9jq1nx5Pr/BwPkfiomGFmnH3vMOl2j9nRPNW6ntu+lFw5gvV2W5QEYlBM2qA1q7WZGrl88pT0HmdBtqfygmMus7jTTLYvRx+EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtePv8AX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtePv8AX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62D79C4CEE4;
	Wed, 19 Mar 2025 14:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395104;
	bh=FFGLL8CjhzJbQKGEo3TpZEJii0EaX8O/hLxzIWYt7/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtePv8AXBEYYOl+11c2vGdQA/7EFC2LYfEhA7l5hBW7ibrONLDmywdHaD8/4Gt1vi
	 uuG+Ocst2bRw5MzFdIFhNCKo5qNb5MCYWdELw7i4BWo2REdx4BNVTKHSa0UfYMGuDW
	 lsbQq1L7bLrDKPPrADlpLIegRmOnjCipwJihaonQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 156/231] Input: i8042 - swap old quirk combination with new quirk for several devices
Date: Wed, 19 Mar 2025 07:30:49 -0700
Message-ID: <20250319143030.689482138@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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

From: Werner Sembach <wse@tuxedocomputers.com>

commit 75ee4ebebbbe8dc4b55ba37f388924fa96bf1564 upstream.

Some older Clevo barebones have problems like no or laggy keyboard after
resume or boot which can be fixed with the SERIO_QUIRK_FORCENORESTORE
quirk.

While the old quirk combination did not show negative effects on these
devices specifically, the new quirk works just as well and seems more
stable in general.

Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://lore.kernel.org/r/20250221230137.70292-3-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   40 +++++++++++-----------------------
 1 file changed, 14 insertions(+), 26 deletions(-)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1080,16 +1080,14 @@ static const struct dmi_system_id i8042_
 			DMI_MATCH(DMI_BOARD_VENDOR, "TUXEDO"),
 			DMI_MATCH(DMI_BOARD_NAME, "AURA1501"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "TUXEDO"),
 			DMI_MATCH(DMI_BOARD_NAME, "EDUBOOK1502"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		/* Mivvy M310 */
@@ -1171,8 +1169,7 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "LAPQC71A"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {
@@ -1205,8 +1202,7 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "NH5xAx"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {
@@ -1218,8 +1214,7 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "NL5xRU"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	/*
 	 * At least one modern Clevo barebone has the touchpad connected both
@@ -1235,17 +1230,15 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "NS50MU"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOAUX | SERIO_QUIRK_NOMUX |
-					SERIO_QUIRK_RESET_ALWAYS | SERIO_QUIRK_NOLOOP |
-					SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_NOAUX |
+					SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "NS50_70MU"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOAUX | SERIO_QUIRK_NOMUX |
-					SERIO_QUIRK_RESET_ALWAYS | SERIO_QUIRK_NOLOOP |
-					SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_NOAUX |
+					SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {
@@ -1319,8 +1312,7 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "P65_67RS"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		/*
@@ -1338,8 +1330,7 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "PB50_70DFx,DDx"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {
@@ -1363,8 +1354,7 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "PCX0DX"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {
@@ -1383,15 +1373,13 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "X170SM"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "X170KM-G"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		/*


