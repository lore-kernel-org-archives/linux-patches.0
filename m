Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3D1F32A3FD;
	Wed,  8 Apr 2026 18:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673727; cv=none; b=qoN6fsmfnaI22fqEPbsapH1gPLAOgS8FnNwgLTuZHRhFZIvBTdBin1pxXYFs6JKfeEJ8S2gAgy5k4OkpOfKCe51mJIrjS0MOBA0bNlMt87PtQhFa4dorBJEagaYpKSzYGEx7CavB9v9l5CFWdPrAYrlnVKLNsB+GGmr5yNu1SnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673727; c=relaxed/simple;
	bh=UpDJfP3eY9b5BDu8bKu5GgZ1Ub3qfYfGrg/yNAvngmY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bo0YL+Nn5vt6yYZfEY/YcMUfdiBtASdV/9IX5ZV6p4zlQ2uC1IJzAsI/vnBCltE/tQXn6lHyr6cPSia7/k1g9jMsyCI6bm6BtBsEI+XxOOI7Wizmn7j9VQwrJsvfIOQ+X5Y4QNv4mhAq87Tu5tDJBBYqi7YmpJpCi78dBfK+IV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X38rw1Db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X38rw1Db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23692C19421;
	Wed,  8 Apr 2026 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673727;
	bh=UpDJfP3eY9b5BDu8bKu5GgZ1Ub3qfYfGrg/yNAvngmY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=X38rw1DbyUzk/Qwfrh6EF/QvEwaexORqqSsgKVOQMEJGqLnDQqRIW50ZlAPZObCAj
	 AFcSqQ60NLNjyw+58pDxJaI8/2CXSACqSFq/KM1rSXuyzj0X8K5r77p95iLskGOHEb
	 bTBj+MDFThNhlC995sE42e4NvNCk+UUFR8bpAixw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 065/242] ASoC: Intel: boards: fix unmet dependency on PINCTRL
Date: Wed,  8 Apr 2026 20:01:45 +0200
Message-ID: <20260408175929.514467908@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Julian Braha <julianbraha@gmail.com>

[ Upstream commit e920c36f2073d533bdf19ba6ab690432c8173b63 ]

This reverts commit c073f0757663 ("ASoC: Intel: sof_sdw: select PINCTRL_CS42L43 and SPI_CS42L43")

Currently, SND_SOC_INTEL_SOUNDWIRE_SOF_MACH selects PINCTRL_CS42L43
without also selecting or depending on PINCTRL, despite PINCTRL_CS42L43
depending on PINCTRL.

See the following Kbuild warning:

WARNING: unmet direct dependencies detected for PINCTRL_CS42L43
  Depends on [n]: PINCTRL [=n] && MFD_CS42L43 [=m]
  Selected by [m]:
  - SND_SOC_INTEL_SOUNDWIRE_SOF_MACH [=m] && SOUND [=y] && SND [=m] && SND_SOC [=m] && SND_SOC_INTEL_MACH [=y] && (SND_SOC_SOF_INTEL_COMMON [=m] || !SND_SOC_SOF_INTEL_COMMON [=m]) && SND_SOC_SOF_INTEL_SOUNDWIRE [=m] && I2C [=y] && SPI_MASTER [=y] && ACPI [=y] && (MFD_INTEL_LPSS [=n] || COMPILE_TEST [=y]) && (SND_SOC_INTEL_USER_FRIENDLY_LONG_NAMES [=n] || COMPILE_TEST [=y]) && SOUNDWIRE [=m]

In response to v1 of this patch [1], Arnd pointed out that there is
no compile-time dependency sof_sdw and the PINCTRL_CS42L43 driver.
After testing, I can confirm that the kernel compiled with
SND_SOC_INTEL_SOUNDWIRE_SOF_MACH enabled and PINCTRL_CS42L43 disabled.

This unmet dependency was detected by kconfirm, a static analysis
tool for Kconfig.

Link: https://lore.kernel.org/all/b8aecc71-1fed-4f52-9f6c-263fbe56d493@app.fastmail.com/ [1]
Fixes: c073f0757663 ("ASoC: Intel: sof_sdw: select PINCTRL_CS42L43 and SPI_CS42L43")
Signed-off-by: Julian Braha <julianbraha@gmail.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Link: https://patch.msgid.link/20260325001522.1727678-1-julianbraha@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/boards/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/sound/soc/intel/boards/Kconfig b/sound/soc/intel/boards/Kconfig
index aed95d1583e09..1a05e701a9e00 100644
--- a/sound/soc/intel/boards/Kconfig
+++ b/sound/soc/intel/boards/Kconfig
@@ -532,8 +532,6 @@ config SND_SOC_INTEL_SOUNDWIRE_SOF_MACH
 	select SND_SOC_CS42L43_SDW
 	select MFD_CS42L43
 	select MFD_CS42L43_SDW
-	select PINCTRL_CS42L43
-	select SPI_CS42L43
 	select SND_SOC_CS35L56_SPI
 	select SND_SOC_CS35L56_SDW
 	select SND_SOC_DMIC
-- 
2.53.0



