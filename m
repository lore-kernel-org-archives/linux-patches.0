Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C875172CF;
	Wed, 30 Sep 2026 16:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784473; cv=none; b=L4Rfey8ppfNu0Xn8j4hsleRKvyPzsxrnxp0m+azwsWdZBZUO0d7SJwRciw9ExG/y+VapXZc1H6TQsIH9aQMEg5QbMDsgD/egCWZvaqUBgG7wWf4DIbp8AxxGO5+xYjKhexuiUudEh7mJnaWmF9a9SXuWBVHMuoveJ1iA7zr1gAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784473; c=relaxed/simple;
	bh=8zTElKiexS5Vi//Jw5byPG83OL7xAKcf2ick7OmMDW8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lMacR7Yib3aJb8kwStesdOK+stLGYbeuatzKsRb+dR0INY+cOjA8MQ1imiKV/JoEWHi0wSECb/84wl5YwHi/5g/2MI5tNyKSwOdb2LbekLpRirIBh3OGE8+VMJmS+FkaPjcovb54ZhBdXOYkJB4Kwk/gb7Utol/p7Smf42zYMZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vs4m6wSV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vs4m6wSV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F121F00898;
	Wed, 30 Sep 2026 16:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784465;
	bh=bNP2A4X7/5N9Aw1qWmXtc+u4h6HPvIomKntaTYi6ibg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vs4m6wSVuxY+zVRLLEbXKiHM5lllt8uImnaTcLqm9lphWEM+pTS6x9wHddlQMNIwk
	 JJoyGayf7Hj0VJczXp3XVnOVjut8M//h87p860NXKTH08sOMf/IyZuRcLvxy9bUzwD
	 0YT5fIQtX4WvasWZrBWDxObXcQJZe7of6unCaagk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 120/982] soundwire: dmi-quirks: Disable ghost Realtek devices
Date: Wed, 30 Sep 2026 17:14:16 +0200
Message-ID: <20260930152419.395539559@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 4dab2b904414fac53535c4e4cdad808132f4cdc2 ]

Many systems ship with a Realtek audio codec in the ACPI that doesn't
physically exist in the system. This confuses the newer function
topology system that creates the soundcard, as it builds the card based
on the ACPI information.

Whilst we are working with the laptop vendors to try and stop this
happening there are quite a few systems where this has shipped. Add a
quirk to disable this "ghost" device.

Currently this patch should cover:
 - Asus UX5406AA
 - Lenovo Yoga Pro 9i (83SF)
 - Lenovo Yoga Slim 7 Ultra (83QK)

Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20260520163631.3300102-4-ckeepax@opensource.cirrus.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 35 ++++++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 5854218e1a274..32a46a2d90f7c 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -90,6 +90,19 @@ static const struct adr_remap intel_rooks_county[] = {
 	{}
 };
 
+/*
+ * Many platforms have ghost realtek devices in the ACPI that don't physically
+ * exist, remove those devices.
+ */
+static const struct adr_remap ghost_realtek[] = {
+	/* rt722 on link3 */
+	{
+		0x000330025d072201ull,
+		0x0000000000000000ull
+	},
+	{}
+};
+
 static const struct dmi_system_id adr_remap_quirk_table[] = {
 	/* TGL devices */
 	{
@@ -164,6 +177,28 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)hp_omen_16,
 	},
+	/* PTL devices */
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "ASUS"),
+			DMI_MATCH(DMI_BOARD_NAME, "UX5406AA"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83QK"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "83SF"),
+		},
+		.driver_data = (void *)ghost_realtek,
+	},
 	{}
 };
 
-- 
2.53.0



