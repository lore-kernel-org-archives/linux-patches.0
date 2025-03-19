Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D776221ABB9;
	Wed, 19 Mar 2025 14:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395103; cv=none; b=rrUTzwFWSD4gzIkD7MtuZgmoJChUNFX10Ujbx6VK6q6cAev/sNbte+/r/0ZugxSvMk3p9pGz0cdfDOqpAtJnxrqbp3y8hBdtxmGHqweXrg6vq14V+ZHqK3/6ORjMWuHyWyywo9mGmrzMci58eEi5Rb1ogej1TbyGwlW0/362VeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395103; c=relaxed/simple;
	bh=S0cjj1F9U3/7stkTzX7RlkrO/0YK1rcoO/LAwweV+ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o7h+BZLh1xlfc9H4L3+c1PswIAryth8uj3alqTEhnVAy+6aRIFlQCCfY629dyuITTIYJuNkdaRjYPNNkCJcYsTJz7ZxvOxQwV5FDgd6lysX7wTZJ5DXqW2YCdHhbSrUedeBTGtYxwoxj0dK37H4DMaw0lvkAJXxqfl4Pvski+yE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P6bu8uXw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P6bu8uXw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8027C4CEE4;
	Wed, 19 Mar 2025 14:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395103;
	bh=S0cjj1F9U3/7stkTzX7RlkrO/0YK1rcoO/LAwweV+ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P6bu8uXw4knVNezwYV0y6glCeFya1t2PHG9tyQID7xaRIBdyWaat3F/BFK5ks+deg
	 G/NPpkzfCyB12XH2xpsShRxAN/OiJQ98zmVIN07mBvE5MsRl5gM0B7UXFeIUdgRvmd
	 FhnKSij894yk79R+wZ8h2Xm7rJNL5pNZ3EoHEhCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Werner Sembach <wse@tuxedocomputers.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.12 155/231] Input: i8042 - add required quirks for missing old boardnames
Date: Wed, 19 Mar 2025 07:30:48 -0700
Message-ID: <20250319143030.665345076@linuxfoundation.org>
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


