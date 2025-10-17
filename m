Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA293208;
	Fri, 17 Oct 2025 15:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760714928; cv=none; b=mSYvWJtGC6AzYkSAgunnvquB0u0Wid5VLWykvNJhWv7CARuTglqrQ527xljE+/6ROR8Nl+MbuF36LhKNbi1dST5Er8xAeSVW6Q4xSDJHHyl89RHsWn7gMFjFPrf6lmBLdjKJX7EzfbJKP+2cIndOj2C30lpxX3nnCf891glVR4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760714928; c=relaxed/simple;
	bh=Vf6MeSwb7y6e7AmI0QehpWPNBVg64snF10cBQlTMb+Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLlDFE/fL0EVHRkAYReKyLBKXyVaAGn1ACg644VHFt5R8SKyHcD9OE2h1p0cQwFhnxqeFtkOCyz/GE++0l3PrjX5i3pz3Y93ZnAKSOSANX1oHWPZfvSoyz8nJWEFUrreaELOCLtD8QWZV9JlKKzS/ZsnloPLFwas4yJCktc8fxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O2d5NtYr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O2d5NtYr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7D3C4CEE7;
	Fri, 17 Oct 2025 15:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760714928;
	bh=Vf6MeSwb7y6e7AmI0QehpWPNBVg64snF10cBQlTMb+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O2d5NtYrRDhVwbMtNGQ3V3Atb+m7kFxoTcZ99iAgL2ktZ+2Doh4PnxUPwdowpdhzL
	 AJux9Euc9fgg7SC2mBpMLDs/X/l3ylB7eChFreIu7LZ7Mp0KNPx1biTMWqGdkjPx8R
	 5CS6VEQblrEOlEwkZQTxBdb9M3G3aodwwPVTO3cc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 020/371] clk: npcm: select CONFIG_AUXILIARY_BUS
Date: Fri, 17 Oct 2025 16:49:55 +0200
Message-ID: <20251017145202.529734231@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
References: <20251017145201.780251198@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c123519bffd29e6320d3a8c4977f9e5a86d6b83d ]

There are very rare randconfig builds that turn on this driver but
don't already select CONFIG_AUXILIARY_BUS from another driver, and
this results in a build failure:

arm-linux-gnueabi-ld: drivers/clk/clk-npcm8xx.o: in function `npcm8xx_clock_driver_init':
clk-npcm8xx.c:(.init.text+0x18): undefined reference to `__auxiliary_driver_register'

Select the bus here, as all other clk drivers using it do.

Fixes: e0b255df027e ("clk: npcm8xx: add clock controller")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20250807072241.4190376-1-arnd@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
index 4d56475f94fc1..b1425aed65938 100644
--- a/drivers/clk/Kconfig
+++ b/drivers/clk/Kconfig
@@ -364,6 +364,7 @@ config COMMON_CLK_LOCHNAGAR
 config COMMON_CLK_NPCM8XX
 	tristate "Clock driver for the NPCM8XX SoC Family"
 	depends on ARCH_NPCM || COMPILE_TEST
+	select AUXILIARY_BUS
 	help
 	  This driver supports the clocks on the Nuvoton BMC NPCM8XX SoC Family,
 	  all the clocks are initialized by the bootloader, so this driver
-- 
2.51.0



