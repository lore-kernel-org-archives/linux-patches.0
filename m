Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F12C1C1AAA;
	Tue, 12 Aug 2025 19:03:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025439; cv=none; b=GgPGa+SJGFoPamPjYxKiHXmtp+ZdKDDTW+aFXkSjrPNgX/1fTWTKjUxQsP6xoP4E97wgbyK7W1/R7YgQZJ/HswMu0tGWCFZ28yfzR5MVzaHW5fsfxun+MM+v69vhnv8glJEJUilHe9/o9lZWAaFr3HnWJSsiF1KRIOK0+aduc3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025439; c=relaxed/simple;
	bh=i15njEBIMFrLRN69e/zLVYSQHZ9u97oTY8nUbTtCZKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dGaJMDsSQ+2MlySfhp2lYSvShBWh18opL4tzNsBzHYDHx9hpneyLEwWLfcswjx9m1+viLsdRgEJBP1UtGTZnXXVK+NhF/Km6pQVj/aEecDA6Cy8eUMpQwB4xgqAqcorhVJ0n3yKOMDPdBTNISJriclW3X18TrYd6371X7JFvOq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QzT896mg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QzT896mg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3AF3C4CEF0;
	Tue, 12 Aug 2025 19:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025439;
	bh=i15njEBIMFrLRN69e/zLVYSQHZ9u97oTY8nUbTtCZKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QzT896mgC0HNIAS0jHx8+//jbyOMdSakprCueOY7eKHa8d2lABScnT3f23QdZIWbT
	 2KKZ6mjh3yO82d5eAqz4ZC1GWGVDOc1bbbRs086FWsAs3GvPRySvRZe9mGWuCkD4iw
	 bCFaRUDyHDGNBjZafHkBn0IhRUvgG1XgzhcN4Bjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 007/480] ASoC: Intel: fix SND_SOC_SOF dependencies
Date: Tue, 12 Aug 2025 19:43:35 +0200
Message-ID: <20250812174357.612076309@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e837b59f8b411b5baf5e3de7a5aea10b1c545a63 ]

It is currently possible to configure a kernel with all Intel SoC
configs as loadable modules, but the board config as built-in. This
causes a link failure in the reference to the snd_soc_sof.ko module:

x86_64-linux-ld: sound/soc/intel/boards/sof_rt5682.o: in function `sof_rt5682_hw_params':
sof_rt5682.c:(.text+0x1f9): undefined reference to `sof_dai_get_mclk'
x86_64-linux-ld: sof_rt5682.c:(.text+0x234): undefined reference to `sof_dai_get_bclk'
x86_64-linux-ld: sound/soc/intel/boards/sof_rt5682.o: in function `sof_rt5682_codec_init':
sof_rt5682.c:(.text+0x3e0): undefined reference to `sof_dai_get_mclk'
x86_64-linux-ld: sound/soc/intel/boards/sof_cs42l42.o: in function `sof_cs42l42_hw_params':
sof_cs42l42.c:(.text+0x2a): undefined reference to `sof_dai_get_bclk'
x86_64-linux-ld: sound/soc/intel/boards/sof_nau8825.o: in function `sof_nau8825_hw_params':
sof_nau8825.c:(.text+0x7f): undefined reference to `sof_dai_get_bclk'
x86_64-linux-ld: sound/soc/intel/boards/sof_da7219.o: in function `da7219_codec_init':
sof_da7219.c:(.text+0xbf): undefined reference to `sof_dai_get_mclk'
x86_64-linux-ld: sound/soc/intel/boards/sof_maxim_common.o: in function `max_98373_hw_params':
sof_maxim_common.c:(.text+0x6f9): undefined reference to `sof_dai_get_tdm_slots'
x86_64-linux-ld: sound/soc/intel/boards/sof_realtek_common.o: in function `rt1015_hw_params':
sof_realtek_common.c:(.text+0x54c): undefined reference to `sof_dai_get_bclk'
x86_64-linux-ld: sound/soc/intel/boards/sof_realtek_common.o: in function `rt1308_hw_params':
sof_realtek_common.c:(.text+0x702): undefined reference to `sof_dai_get_mclk'
x86_64-linux-ld: sound/soc/intel/boards/sof_cirrus_common.o: in function `cs35l41_hw_params':
sof_cirrus_common.c:(.text+0x2f): undefined reference to `sof_dai_get_bclk'

Add an optional dependency on SND_SOC_SOF_INTEL_COMMON, to ensure that whenever
the SOF support is in a loadable module, none of the board code can be built-in.

This may be be a little heavy-handed, but I also don't see a reason why one would
want the boards to be built-in but not the SoC, so it shouldn't actually cause
any usability problems.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20250709145626.64125-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/boards/Kconfig b/sound/soc/intel/boards/Kconfig
index 4db7931ba561..4a9324232936 100644
--- a/sound/soc/intel/boards/Kconfig
+++ b/sound/soc/intel/boards/Kconfig
@@ -11,7 +11,7 @@ menuconfig SND_SOC_INTEL_MACH
 	 kernel: saying N will just cause the configurator to skip all
 	 the questions about Intel ASoC machine drivers.
 
-if SND_SOC_INTEL_MACH
+if SND_SOC_INTEL_MACH && (SND_SOC_SOF_INTEL_COMMON || !SND_SOC_SOF_INTEL_COMMON)
 
 config SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES
 	bool "Use more user friendly long card names"
-- 
2.39.5



