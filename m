Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E568343E06E;
	Thu, 30 Jul 2026 14:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421339; cv=none; b=oUDOhIzTeQl8xoJYi1b4sR+CH6D5BpmnuI/cpvzxExdvu0r27Nch0cHCsqlXPT85sx3i44n/oS7H2+HrT32alQ3w8RB/H8GLI8FvUxpv19qY3iWG0xKLw2cqSD03wUNnouDnY7FEsMzxdpStzhTj4tP5MqyVc7p+mKBgZ+BNUDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421339; c=relaxed/simple;
	bh=UT8IWBe/Bv/4f7G5Z1WrGM/XKY6qbIzFjXlsm0P3zo4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOBv4VDByFoB/rr9F/h5sN7uCmSBgEBpLnybwA3SflhQH3ZtZCZGeaUqJnTXMvKdzDnFDMHGA4qMUjtoAKRB8d8hEfIVqwV936vrT+94Xls5yD9rO51FZDIlpPKo7wvxFsRAA2MhGEm36KZv5BVW7t8LZREWC5snbr81/L0qugs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W/SbMGrK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W/SbMGrK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D39E1F000E9;
	Thu, 30 Jul 2026 14:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421337;
	bh=ER4iv3w3nEtLMmkhMVohcu8Kjb+jge6pfm0MO7ZtBcA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W/SbMGrKrTX8MuE3UTbhQNCM/78fDTjUQWx8gggYVwDA1ZNzG2zCcBhdBkGcULjud
	 NrQl05zi6logUBuavXbHd8EMwuGml1g8hbzHRFLvsoHS/KMLXJBeZEevPYTMKeCSa4
	 K4Q3PaMAcGta+V8zkeZDhPPQrSGBuoMXJo99Ew6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Syed Saba Kareem <Syed.SabaKareem@amd.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 069/744] ASoC: amd: acp: Fix linker error with SDCA quirks
Date: Thu, 30 Jul 2026 16:05:42 +0200
Message-ID: <20260730141445.742870928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Syed Saba Kareem <Syed.SabaKareem@amd.com>

[ Upstream commit dbbb5bc5176e36b13aa22e2174ab4779c5ae1dca ]

Fix undefined reference to `snd_soc_acpi_amd_sdca_is_device_rt712_vb`
linker error when CONFIG_SND_SOC_ACPI_AMD_MATCH=y and
CONFIG_SND_SOC_ACPI_AMD_SDCA_QUIRKS=m, which causes built-in code to
reference a symbol only available in a module.

Fix this by changing SND_SOC_ACPI_AMD_SDCA_QUIRKS from tristate to bool
and compiling the quirks code directly into snd-soc-acpi-amd-match
rather than as a separate module. This ensures the quirks symbols are
always available at link time when the match tables reference them.

Fixes: 10d366a846be ("ASoC: amd: acp: Fix Kconfig dependencies for SND_SOC_ACPI_AMD_SDCA_QUIRKS")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Syed Saba Kareem <Syed.SabaKareem@amd.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20260703123314.147977-1-syed.sabakareem@amd.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/Kconfig                    | 10 +++++++---
 sound/soc/amd/acp/Makefile                   |  3 +--
 sound/soc/amd/acp/amd-acp70-acpi-match.c     |  2 +-
 sound/soc/amd/acp/soc-acpi-amd-sdca-quirks.c |  4 ----
 4 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/sound/soc/amd/acp/Kconfig b/sound/soc/amd/acp/Kconfig
index 977e4f2a7a7015..a04c301df4d616 100644
--- a/sound/soc/amd/acp/Kconfig
+++ b/sound/soc/amd/acp/Kconfig
@@ -15,13 +15,17 @@ config SND_SOC_AMD_ACP_COMMON
 
 config SND_SOC_ACPI_AMD_MATCH
 	tristate
-        select SND_SOC_ACPI_AMD_SDCA_QUIRKS if SND_SOC_SDCA
         select SND_SOC_ACPI if ACPI
 
 config SND_SOC_ACPI_AMD_SDCA_QUIRKS
-	tristate
-	depends on ACPI
+	bool "AMD ACPI SDCA quirks"
+	depends on SND_SOC_ACPI_AMD_MATCH
 	depends on SND_SOC_SDCA
+	depends on SND_SOC_ACPI_AMD_MATCH = m || SND_SOC_SDCA = y
+	default y
+	help
+	  Enable SDCA quirk support for AMD ACPI match tables.
+	  This is compiled into the snd-soc-acpi-amd-match module.
 
 if SND_SOC_AMD_ACP_COMMON
 
diff --git a/sound/soc/amd/acp/Makefile b/sound/soc/amd/acp/Makefile
index 81d23aded348d1..ab5f9dc871a677 100644
--- a/sound/soc/amd/acp/Makefile
+++ b/sound/soc/amd/acp/Makefile
@@ -24,10 +24,10 @@ snd-acp-mach-y     := acp-mach-common.o
 snd-acp-legacy-mach-y     := acp-legacy-mach.o acp3x-es83xx/acp3x-es83xx.o
 snd-acp-sof-mach-y     := acp-sof-mach.o
 snd-soc-acpi-amd-match-y := amd-acp63-acpi-match.o amd-acp70-acpi-match.o
+snd-soc-acpi-amd-match-$(CONFIG_SND_SOC_ACPI_AMD_SDCA_QUIRKS) += soc-acpi-amd-sdca-quirks.o
 snd-acp-sdw-mach-y     := acp-sdw-mach-common.o
 snd-acp-sdw-sof-mach-y += acp-sdw-sof-mach.o
 snd-acp-sdw-legacy-mach-y += acp-sdw-legacy-mach.o
-snd-soc-acpi-amd-sdca-quirks-y += soc-acpi-amd-sdca-quirks.o
 
 obj-$(CONFIG_SND_SOC_AMD_ACP_PCM) += snd-acp-pcm.o
 obj-$(CONFIG_SND_SOC_AMD_ACP_I2S) += snd-acp-i2s.o
@@ -41,7 +41,6 @@ obj-$(CONFIG_SND_AMD_ASOC_REMBRANDT) += snd-acp-rembrandt.o
 obj-$(CONFIG_SND_AMD_ASOC_ACP63) += snd-acp63.o
 obj-$(CONFIG_SND_AMD_ASOC_ACP70) += snd-acp70.o
 
-obj-$(CONFIG_SND_SOC_ACPI_AMD_SDCA_QUIRKS) += snd-soc-acpi-amd-sdca-quirks.o
 obj-$(CONFIG_SND_AMD_SOUNDWIRE_ACPI) += snd-amd-sdw-acpi.o
 obj-$(CONFIG_SND_SOC_AMD_MACH_COMMON) += snd-acp-mach.o
 obj-$(CONFIG_SND_SOC_AMD_LEGACY_MACH) += snd-acp-legacy-mach.o
diff --git a/sound/soc/amd/acp/amd-acp70-acpi-match.c b/sound/soc/amd/acp/amd-acp70-acpi-match.c
index 18f2918d4ada4d..9e97a805d0dffa 100644
--- a/sound/soc/amd/acp/amd-acp70-acpi-match.c
+++ b/sound/soc/amd/acp/amd-acp70-acpi-match.c
@@ -775,5 +775,5 @@ MODULE_DESCRIPTION("AMD ACP7.0 & ACP7.1 tables and support for ACPI enumeration"
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Vijendar.Mukunda@amd.com");
 #if IS_ENABLED(CONFIG_SND_SOC_ACPI_AMD_SDCA_QUIRKS)
-MODULE_IMPORT_NS("SND_SOC_ACPI_AMD_SDCA_QUIRKS");
+MODULE_IMPORT_NS("SND_SOC_SDCA");
 #endif
diff --git a/sound/soc/amd/acp/soc-acpi-amd-sdca-quirks.c b/sound/soc/amd/acp/soc-acpi-amd-sdca-quirks.c
index 63bf9e3c0ae180..9248b6d09e76fe 100644
--- a/sound/soc/amd/acp/soc-acpi-amd-sdca-quirks.c
+++ b/sound/soc/amd/acp/soc-acpi-amd-sdca-quirks.c
@@ -35,8 +35,4 @@ bool snd_soc_acpi_amd_sdca_is_device_rt712_vb(void *arg)
 
 	return false;
 }
-EXPORT_SYMBOL_NS(snd_soc_acpi_amd_sdca_is_device_rt712_vb, "SND_SOC_ACPI_AMD_SDCA_QUIRKS");
 
-MODULE_DESCRIPTION("ASoC ACPI AMD SDCA quirks");
-MODULE_LICENSE("GPL");
-MODULE_IMPORT_NS("SND_SOC_SDCA");
-- 
2.53.0



