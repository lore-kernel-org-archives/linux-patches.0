Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 206B04F3EB9;
	Thu, 17 Sep 2026 17:55:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667710; cv=none; b=ChIdWfEvm1R7qqGh8tilDNdkuECMeXf90XT3WeE7xpExhfoIjP9IaHsDFqN0GMe7KUzyiqBvNl7QH7eTuvgetst/Vvlx1uUksSOPfxDYL7m52LktGcJDPYI8ZlZYb7HCN1nSJW1ds/bzrvqaPlW+jFH7Ec0yL5HsHPokdV3nHKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667710; c=relaxed/simple;
	bh=Bdqu7XJMK9uofCNRDQBdepjf0y0kL4qAPUs98PiWHOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfZ9XKCxleEk36ilkWC805yVu30MlWFA2xrF8d5hU0/j/XyUbKGYG5vaI56+BA33JK4rxJeRJY+yHRnP862eycN3iQoG2nLSxTcjtJHjokfQCvyp1pj7TWDW8CmTuKQeHAmodlRqDQercj5Q+kw2mXVJEgJZ2kHMAlE6bf4aJuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZLINb0qC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZLINb0qC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68F911F000FF;
	Thu, 17 Sep 2026 17:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667709;
	bh=SNHcqfS8fa3L5gKFbpefTZLsQRp69Z42QTB2M90Xjj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZLINb0qCEQPDF0V3W9glPasTWWT/eyqbSQnmzN61PLbtvWhADtrEFPygIutFyGm0j
	 ++hKUxBFpq8UFUVDAOvkullJRHOSNTg3EaMdHWyKrIWOthaN7YqjCnXTysc3squLGe
	 5rq2QCF30U46qj/Gsp3oVRhcymoGxq7o/Eaa/jQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0184/1102] soundwire: dmi-quirks: Disable ghost Realtek devices
Date: Thu, 17 Sep 2026 16:02:07 +0100
Message-ID: <20260917151544.182254535@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



