Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FACA28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C3AC433F0;
	Mon, 12 Dec 2022 13:37:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670852271;
	bh=1RtQOr6Pm3gzyXCV3JM2ZfhuUTmH4IJTkWD3almcbfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ieayzy0/blVVhqJCNg1lmsanYMlXRZT1IWizVE8XuzN6vu7HIHM+x0nbezM+97vg1
	 UeADhroFlQRByuvFxV3K3WPib10JV8+pwFu6kJ/uguY/LU5dntMrDW2rjE0pkYtn/s
	 uhOeMEqvdHIGGKrgY8QOiqeNe5cv/gmtm6uHFBZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 048/157] soundwire: dmi-quirks: add remapping for HP Omen 16-k0005TX
Date: Mon, 12 Dec 2022 14:16:36 +0100
Message-Id: <20221212130936.482261581@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit df55100551a34bddab02dff48d0296bda0659c02 ]

The DSDT for this device has a number of problems:
a) it lists rt711 on link0 and link1, but link1 is disabled
b) the rt711 entry on link0 uses the wrong v2 instead of v3 (SDCA)
c) the rt1316 amplifier on link3 is not listed.

Add a remapping table to work-around these BIOS shenanigans.

BugLink: https://github.com/thesofproject/sof/issues/5955
Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Link: https://lore.kernel.org/r/20220823030919.2346629-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/dmi-quirks.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/drivers/soundwire/dmi-quirks.c b/drivers/soundwire/dmi-quirks.c
index 747983743a14..f81cdd83ec26 100644
--- a/drivers/soundwire/dmi-quirks.c
+++ b/drivers/soundwire/dmi-quirks.c
@@ -55,7 +55,26 @@ static const struct adr_remap dell_sku_0A3E[] = {
 	{}
 };
 
+/*
+ * The HP Omen 16-k0005TX does not expose the correct version of RT711 on link0
+ * and does not expose a RT1316 on link3
+ */
+static const struct adr_remap hp_omen_16[] = {
+	/* rt711-sdca on link0 */
+	{
+		0x000020025d071100ull,
+		0x000030025d071101ull
+	},
+	/* rt1316-sdca on link3 */
+	{
+		0x000120025d071100ull,
+		0x000330025d131601ull
+	},
+	{}
+};
+
 static const struct dmi_system_id adr_remap_quirk_table[] = {
+	/* TGL devices */
 	{
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
@@ -78,6 +97,14 @@ static const struct dmi_system_id adr_remap_quirk_table[] = {
 		},
 		.driver_data = (void *)dell_sku_0A3E,
 	},
+	/* ADL devices */
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "OMEN by HP Gaming Laptop 16-k0xxx"),
+		},
+		.driver_data = (void *)hp_omen_16,
+	},
 	{}
 };
 
-- 
2.35.1



