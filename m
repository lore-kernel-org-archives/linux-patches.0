Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B37461E5216;
	Wed, 19 Mar 2025 14:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394940; cv=none; b=sd5aJN7ttLfRrZ2H8SBRjT3P02N3rfIrslQ4vQwvTCUPFRWg+izNTvTcNL1EXLCBeR9NvXIvs5KgFUFE89Jf1zd11E/CTcTliU0OEUnuidkXNFPttHOrp/8eE/aGRrKaIb7toKTHRxrrs4DxfeYlZfKyD5cdXubGxlFWOTwBD0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394940; c=relaxed/simple;
	bh=Y3uW+pitzf359CHR2nIQBZwh8t6yu++cROukhqDuohE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mmy+bgW9/J3TUrmcWQaKsmHq9ODVqNSBWgF1+2U2PyU6QjTO+Sx9qArgczR9y/I+V5Vk3jD/e4bYSIMWOb0s+h8tm8Oxg5e9DtCEwIiY8GfzOtdl/CVRS9c77p6N0A/mtYylxPN6J1EfSixxenniW4BJ8eLQuRnJrqYRwlIlN7I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Pw65nsZ0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Pw65nsZ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80DF1C4CEE8;
	Wed, 19 Mar 2025 14:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394940;
	bh=Y3uW+pitzf359CHR2nIQBZwh8t6yu++cROukhqDuohE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Pw65nsZ0XXOs8909qIL5us6guHAYvhlkS7b4ElzJFvt0w22wzW3uGF5a8IXDC21Fn
	 okDA5XL+ld4fUw7qwvs5DyfZxYRNc8BcadOBHc5HhzB1OPnMemDzpZ9WHz0q2Tnk1b
	 UQS0xQA2DC09UCEfm9vNmyZBslCWkNHVfC9g8K4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.13 161/241] Input: i8042 - swap old quirk combination with new quirk for more devices
Date: Wed, 19 Mar 2025 07:30:31 -0700
Message-ID: <20250319143031.709551231@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit d85862ccca452eeb19329e9f4f9a6ce1d1e53561 upstream.

Some older Clevo barebones have problems like no or laggy keyboard after
resume or boot which can be fixed with the SERIO_QUIRK_FORCENORESTORE
quirk.

We could not activly retest these devices because we no longer have them in
our archive, but based on the other old Clevo barebones we tested where the
new quirk had the same or a better behaviour I think it would be good to
apply it on these too.

Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://lore.kernel.org/r/20250221230137.70292-4-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   31 ++++++++++---------------------
 1 file changed, 10 insertions(+), 21 deletions(-)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1157,9 +1157,7 @@ static const struct dmi_system_id i8042_
 	},
 	/*
 	 * A lot of modern Clevo barebones have touchpad and/or keyboard issues
-	 * after suspend fixable with nomux + reset + noloop + nopnp. Luckily,
-	 * none of them have an external PS/2 port so this can safely be set for
-	 * all of them.
+	 * after suspend fixable with the forcenorestore quirk.
 	 * Clevo barebones come with board_vendor and/or system_vendor set to
 	 * either the very generic string "Notebook" and/or a different value
 	 * for each individual reseller. The only somewhat universal way to
@@ -1175,22 +1173,19 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "LAPQC71B"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "N140CU"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "N141CU"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {
@@ -1250,8 +1245,7 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "NJ50_70CU"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {
@@ -1268,16 +1262,14 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "P65xH"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		/* Clevo P650RS, 650RP6, Sager NP8152-S, and others */
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "P65xRP"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		/*
@@ -1288,8 +1280,7 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "P65_P67H"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		/*
@@ -1300,8 +1291,7 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "P65_67RP"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		/*
@@ -1323,8 +1313,7 @@ static const struct dmi_system_id i8042_
 		.matches = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "P67xRP"),
 		},
-		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
-					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
 	},
 	{
 		.matches = {


