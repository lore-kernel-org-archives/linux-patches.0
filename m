Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159D12BF3E2;
	Tue, 10 Mar 2026 11:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141167; cv=none; b=kJoSINZvoPyXhFhRHd8A4cK+AN/Z4tx7U0xMKdXn0e11ZwBVjmDR8fUd0cGWzpcyOuVl/1bL/XoRUsHwPqRSC1jA4l0QI/xcrTIWLq0u34uQQDtL3SADPsvCo3fIqHHhJGeePqr7VwC1GiCrwxy8Uy4JiT8EYyVU4zbTSQ6BI2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141167; c=relaxed/simple;
	bh=EnVUXXfh2SFNYfCWzl616ycrwrSGOdvuk5GvgqINENg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hh9FUXwNvv7HMYHic2LJli6N1HUrgkuTIUT3hb8XnhHmoC2HNgIcpTKtZtueTb9vhDgY4qW/sKsYJqq1tDMo5WNuFWdEAFxjSN/53kpp9g6Ftzlm6IC2/ubnKLPQ1ODBR8vVuKjjXPjxtz9S6prmCZJd0la1xU9jnIm+EZBMkog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JI4ojYeH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JI4ojYeH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B96C19423;
	Tue, 10 Mar 2026 11:12:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141167;
	bh=EnVUXXfh2SFNYfCWzl616ycrwrSGOdvuk5GvgqINENg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JI4ojYeHD6UOJnAsgY2B8VfK0V04JgGRITi+ZP7qEG6eBgRTqVWo+12NoXp9X6NIB
	 AA5lyYfGrZzPxsghO5Md39CTiBEm0dLZiHqrxlFJL/aqjBjWjEroucK9CaqNRp7Uxn
	 twQjuRmH0ReBl5NZ8/UAWkMyfOnXLejoARX+9AC1zCiUERlIdoe8jhcurvecJ6B0v0
	 CeedhnkjAdJyC1/v1Cr+2MzaN//OfeLAa7pdWSts8Mlylp7vG72VZ1zQH8BDlTurUS
	 4yBfIvUCRn2Dsk9hXhjw0ho8pIlIpfa4z4lWlnKjUYIiPmiNuCOOAbO2Zj+8K3aIDT
	 dHvLvRh8cvN1g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Boris Faure <boris@fau.re>,
	Mark Brown <broonie@kernel.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 169/311] ASoC: sdca: Fix missing regmap dependencies in Kconfig
Date: Tue, 10 Mar 2026 07:03:36 -0400
Message-ID: <ddbc3e6833c67f34a0a3352959ef2ad216f93963.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Boris Faure <boris@fau.re>

commit bbb758a6943e19c483ab752cf8220140b46cf22c upstream.

The SDCA modules failed to build with modpost errors:

  ERROR: modpost: "__devm_regmap_init_sdw" [sound/soc/sdca/snd-soc-sdca-class.ko] undefined!
  ERROR: modpost: "__devm_regmap_init_sdw_mbq" [sound/soc/sdca/snd-soc-sdca-class-function.ko] undefined!

The issue occurs because:
- sdca_class.c calls devm_regmap_init_sdw() which requires REGMAP_SOUNDWIRE
- sdca_class_function.c calls devm_regmap_init_sdw_mbq_cfg() which requires REGMAP_SOUNDWIRE_MBQ

However, the Kconfig didn't select these dependencies, causing the symbols
to be unavailable when the SDCA modules are built.

Fix this by adding:
- select REGMAP_SOUNDWIRE to SND_SOC_SDCA_CLASS
- select REGMAP_SOUNDWIRE_MBQ to SND_SOC_SDCA_CLASS_FUNCTION

This ensures the required regmap drivers are enabled when building SDCA support.

Configuration after fix:
  CONFIG_SND_SOC_SDCA_CLASS=m
  CONFIG_SND_SOC_SDCA_CLASS_FUNCTION=m
  CONFIG_REGMAP_SOUNDWIRE=m
  CONFIG_REGMAP_SOUNDWIRE_MBQ=m

Signed-off-by: Boris Faure <boris@fau.re>
Link: https://patch.msgid.link/20260129141419.13843-1-boris@fau.re
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sdca/Kconfig | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sdca/Kconfig b/sound/soc/sdca/Kconfig
index fabb69a3450d3..87ab2895096c1 100644
--- a/sound/soc/sdca/Kconfig
+++ b/sound/soc/sdca/Kconfig
@@ -46,12 +46,14 @@ config SND_SOC_SDCA_CLASS
 	select SND_SOC_SDCA_FDL
 	select SND_SOC_SDCA_HID
 	select SND_SOC_SDCA_IRQ
+	select REGMAP_SOUNDWIRE
 	help
 	  This option enables support for the SDCA Class driver which should
 	  support any class compliant SDCA part.
 
 config SND_SOC_SDCA_CLASS_FUNCTION
 	tristate
+	select REGMAP_SOUNDWIRE_MBQ
 	help
 	  This option enables support for the SDCA Class Function drivers,
 	  these implement the individual functions of the SDCA Class driver.
-- 
2.51.0

