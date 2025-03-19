Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C6620A5D3;
	Wed, 19 Mar 2025 14:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395239; cv=none; b=g88L7jciYvHrS4Ltt6PQOQ0tKUFCs125e+e3PLyn/goX9Em54eFv6Vj6gSkjn8QfuMc4Z1EgbCTwmC9DATCXpVESZnJir5nw0povChsubLkg8muMHgLv5XV4CRy2AnvKNg4IDO+mLQS/WGTG2DP6WTPn0AI+b+Pkq4TSpfq1jlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395239; c=relaxed/simple;
	bh=f8Yi7WaVglQDNALOHcXRNxxRByxWSIug6KQK1UaNK4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ftf6XZFI54tLTZzWi60krkRLdkUczjaI/RI1U3HYvkRqx6cjD0v2yrRCaefwXnJ8kRxbeMgnshuGqkxAX5TAuHSmUMAObJm6EXNHDXVbBU0rljAxyp8N/TjPjVMxGhGDJ50vzmxTn27jqQEZm3ZnPB4ndXIzeQck6mDv4axPBnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMIwDwGO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMIwDwGO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19FA3C4CEE8;
	Wed, 19 Mar 2025 14:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395239;
	bh=f8Yi7WaVglQDNALOHcXRNxxRByxWSIug6KQK1UaNK4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMIwDwGOOGx8osskq8jRDmpy4USUa6BzRUoQRUMiOMPYXHB4KUyq93CuodZTgb08w
	 0NwUjuqntl3fM+Bda/iKStRb1qJsp5wGVm5Q0tU7gOmF9+oESQGfv1z8Bwt+9RNySc
	 iEZVDGWyAJfkVfcnlLuuVjIz9KAC1CI3SCoAKOeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 112/166] Input: i8042 - add required quirks for missing old boardnames
Date: Wed, 19 Mar 2025 07:31:23 -0700
Message-ID: <20250319143023.048920538@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Werner Sembach <wse@tuxedocomputers.com>

commit 9ed468e17d5b80e7116fd35842df3648e808ae47 upstream.

Some older Clevo barebones have problems like no or laggy keyboard after
resume or boot which can be fixed with the SERIO_QUIRK_FORCENORESTORE
quirk.

The PB71RD keyboard is sometimes laggy after resume and the PC70DR, PB51RF,
P640RE, and PCX0DX_GN20 keyboard is sometimes unresponsive after resume.
This quirk fixes that.

Cc: stable@vger.kernel.org
Signed-off-by: Werner Sembach <wse@tuxedocomputers.com>
Link: https://lore.kernel.org/r/20250221230137.70292-2-wse@tuxedocomputers.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/serio/i8042-acpipnpio.h |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/drivers/input/serio/i8042-acpipnpio.h
+++ b/drivers/input/serio/i8042-acpipnpio.h
@@ -1261,6 +1261,12 @@ static const struct dmi_system_id i8042_
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
 	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "P640RE"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
+	},
+	{
 		/*
 		 * This is only a partial board_name and might be followed by
 		 * another letter or number. DMI_MATCH however does do partial
@@ -1337,11 +1343,35 @@ static const struct dmi_system_id i8042_
 	},
 	{
 		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "PB51RF"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "PB71RD"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "PC70DR"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
+	},
+	{
+		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "PCX0DX"),
 		},
 		.driver_data = (void *)(SERIO_QUIRK_NOMUX | SERIO_QUIRK_RESET_ALWAYS |
 					SERIO_QUIRK_NOLOOP | SERIO_QUIRK_NOPNP)
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_BOARD_NAME, "PCX0DX_GN20"),
+		},
+		.driver_data = (void *)(SERIO_QUIRK_FORCENORESTORE)
+	},
 	/* See comment on TUXEDO InfinityBook S17 Gen6 / Clevo NS70MU above */
 	{
 		.matches = {


