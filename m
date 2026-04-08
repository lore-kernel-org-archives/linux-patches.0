Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E696525A321;
	Wed,  8 Apr 2026 18:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672993; cv=none; b=RGt9UJ78Z6D9x9lWlHXRZ5zAkABV1LWeCgtr37juorjSdAp6WPg1iaOoE57JZpw9itHCzGcn93LsvdFMn6CP+BKZekfiksmViLKSeofyG1zIl0nwaA91zq0NtSc5/m3j6vynnu5NVaWIbzzQhv0g8GwhrRYnzjg7Q+b5TuHtFdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672993; c=relaxed/simple;
	bh=m0vZxFtZj3S4WMsXJ5mU1wtC0lR46wT79Cq1htyqw+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XOIbrckRo4DSvix+8cKoZ2A6fRdyEcBNC6fcdTfwsrxtrpPE5qRhzI2ezLwdI7k5pJJ18YKNgPbQKPg/j0ulXr+BgX419V9n6/xM7l2YQfkZO8kW0EQ1mbSI3bjEtau+V8C5VfwJuaA8ZhZdQotXY9nI6CKYwzFQ30pUn2iUJk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lz/zJ9+U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lz/zJ9+U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2729CC19421;
	Wed,  8 Apr 2026 18:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672992;
	bh=m0vZxFtZj3S4WMsXJ5mU1wtC0lR46wT79Cq1htyqw+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lz/zJ9+UDvT/uUbOQUt8bqtwdajPQrScs+INF0Z0mAriST2CdgIUs3mnyxDe5f4KA
	 Rr1WxbuHnIxuOW1J1icoiPjH+sMkFj+PBRU4Fu0Jt0OGtf2PJhix+EC4YQgC+SQK0n
	 beWU1F6qX/IQoCVMfZaAM6I04DVYPEN6Q6f5bfcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Braha <julianbraha@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 059/277] ASoC: Intel: boards: fix unmet dependency on PINCTRL
Date: Wed,  8 Apr 2026 20:00:44 +0200
Message-ID: <20260408175936.064214829@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c23fdb6aad4ca..1031d6497f55e 100644
--- a/sound/soc/intel/boards/Kconfig
+++ b/sound/soc/intel/boards/Kconfig
@@ -525,8 +525,6 @@ config SND_SOC_INTEL_SOUNDWIRE_SOF_MACH
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



