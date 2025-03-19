Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2143F1DE2D8;
	Wed, 19 Mar 2025 14:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394967; cv=none; b=UFFLl7dNj9xfUJVBuS3K7etLascC4WWqkn0SGyb8q2RKPjGVzG3UhWIg8oUnyzg1KwxtraM7WcYmK0m0PrzRuQXUq2HLX4UMV6IOhXoZgv/5F17LYOMhSQTL6dp7frxPq7hPbBL5ZutaRGMXmMRhSKdustGe0r9Vz6EYUatSGFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394967; c=relaxed/simple;
	bh=rlx30Z1s9G6QeKpt82oe2ScVuc14I8yPIB25Sc4RFRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFWlmPRmLMY1M6emAb2n5uSz2P8DCsZRWzeXNAyCipQpAXY+2QU7CmJ5crBQc4R+eWHMVN/yW/mwIET7d4tr/DGYbrrjXo5DdA92KBmPqPueJKKoV6oFeKKnjrJDmDjLzzENN61JY+iLK/PrbmXP3seOD89so5hLuTMR1jSykaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WF8ZZqgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WF8ZZqgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37EFC4CEE4;
	Wed, 19 Mar 2025 14:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394967;
	bh=rlx30Z1s9G6QeKpt82oe2ScVuc14I8yPIB25Sc4RFRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WF8ZZqgTwEQfT7P5fODTPtxkyUh7YuFF9u7QNivNHL6JuiWeftqlyZF5x/dxGukmy
	 f6IKfvUjww7BrO8WLb9txO1ka4sErVf4PEVZl+wTKfAhV9VDp5MRpdx8Nc+FExsD4A
	 1hHCMgQc8hGmZi4rlipTknmqvdalMwdNRCztRI7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.13 159/241] Input: i8042 - add required quirks for missing old boardnames
Date: Wed, 19 Mar 2025 07:30:29 -0700
Message-ID: <20250319143031.659601085@linuxfoundation.org>
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


