Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A18B2571DC;
	Tue, 25 Mar 2025 12:28:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905739; cv=none; b=MgEuykZnhLMSei7sInR0+Ql6OG0h36NlmF9x312hpJ5eF3XnaHJRFAap0A/y85y4uadRFjWBQszuAmKWjBy3uFy7V+o26YHWStnGWck522rFvisq9sfcqLgf4KEkSCvlhCDh2hKkX+8HqkkqvCtu3YOVfur462sHtXjSwzLij64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905739; c=relaxed/simple;
	bh=EYVUaRgPZq/5DH0C84qC8dhNBfemQuKgqcXIb9gwg4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cm7Vg2YDLtsIqQP4W7FEZxh3dLIo8OKJw+9NkttBcSaK5MXHu+qQDqBOdV58BqgESyGQ5bPFb1N0eduOC5thEhmyWVNla8H0GtenbI4MuYs0DRDZPapiyjnU5VK0XJmu4fW0/uLLkE61GoyU8Pq8QABW3te5AxCH+Jzi4LrhK4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q9Gb/WvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q9Gb/WvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47A28C4CEE4;
	Tue, 25 Mar 2025 12:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905739;
	bh=EYVUaRgPZq/5DH0C84qC8dhNBfemQuKgqcXIb9gwg4c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q9Gb/WvCaoCP+tdyzJFuySwnYwaIGV8FskW5HN+/rr0S+B0vo0633IGA5RK8aevYK
	 3mEPJVM9VBgcTMeIkjXQ2dNNjcTxndR7wItA7JqREqADfd3lTOwfhIt8lN7iyNzwZM
	 bd1430T4bt8v6+mLaa6mueKw/Sw7F+Rpdx1/olao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.1 107/198] Input: i8042 - swap old quirk combination with new quirk for more devices
Date: Tue, 25 Mar 2025 08:21:09 -0400
Message-ID: <20250325122159.460125072@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


