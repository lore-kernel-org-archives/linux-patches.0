Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F25214BFA2;
	Sun,  7 Sep 2025 20:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276446; cv=none; b=WxFxExxjY6l1v9vVvN+gSE16AqPQWZS4/ZFyF2wKngqTGZkHeMAXWSwrLL8TGpaM8AAl3HTA6IajXCISqdFYQeVb7Nk0PUQ5/6OwNJCCwzXfM3JTAx3RQ0UgKol/0/MtzFDmkzMcHk+z7fhgmBplU7xjXuEhIs8wpA3DZHXI93g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276446; c=relaxed/simple;
	bh=h4D34a6LLxbF2+UrcJSr8Kv2yF0Pw5bRjDFXiwAMjCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdQr9FrE7mceqw3SiaDA9xMdJ4MYcEcy85TtLV2CVSM7E8GloufIthCO7heqiFuMfOc7QDKr3FZViEacgLxBbi7+Fu5JgE87l5VRnaDTsMY2K5BzG11GMpNO7+hdyZDxL1Ohs1N+NPw7hgDgX+ISa54/AL0K28q6rIchXxeqVTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpFftCz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpFftCz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50B2C4CEF0;
	Sun,  7 Sep 2025 20:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276446;
	bh=h4D34a6LLxbF2+UrcJSr8Kv2yF0Pw5bRjDFXiwAMjCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpFftCz3rbpjquW3CFKPJ5EOA/QkJLPvigOP2he7rGAwiQZ4+U+xhizf3g39ysQe5
	 WAo8aiwzXRp8V5QkmQeo0ZYoJjbH73UtNg7xuesrzv/EqChRC0wuhQskvjxcItuApd
	 Ja+4ZpMIt5uLUZQDcpL0+azdP0twsbRsz45q2KxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Danilenko <al.b.danilenko@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 067/104] spi: tegra114: Remove unnecessary NULL-pointer checks
Date: Sun,  7 Sep 2025 21:58:24 +0200
Message-ID: <20250907195609.416850188@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Danilenko <al.b.danilenko@gmail.com>

[ Upstream commit 373c36bf7914e3198ac2654dede499f340c52950 ]

cs_setup, cs_hold and cs_inactive points to fields of spi_device struct,
so there is no sense in checking them for NULL.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 04e6bb0d6bb1 ("spi: modify set_cs_timing parameter")
Signed-off-by: Alexander Danilenko <al.b.danilenko@gmail.com>
Link: https://lore.kernel.org/r/20230815092058.4083-1-al.b.danilenko@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 4426e6b4ecf6 ("spi: tegra114: Don't fail set_cs_timing when delays are zero")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra114.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -723,27 +723,23 @@ static int tegra_spi_set_hw_cs_timing(st
 	struct spi_delay *setup = &spi->cs_setup;
 	struct spi_delay *hold = &spi->cs_hold;
 	struct spi_delay *inactive = &spi->cs_inactive;
-	u8 setup_dly, hold_dly, inactive_dly;
+	u8 setup_dly, hold_dly;
 	u32 setup_hold;
 	u32 spi_cs_timing;
 	u32 inactive_cycles;
 	u8 cs_state;
 
-	if ((setup && setup->unit != SPI_DELAY_UNIT_SCK) ||
-	    (hold && hold->unit != SPI_DELAY_UNIT_SCK) ||
-	    (inactive && inactive->unit != SPI_DELAY_UNIT_SCK)) {
+	if (setup->unit != SPI_DELAY_UNIT_SCK ||
+	    hold->unit != SPI_DELAY_UNIT_SCK ||
+	    inactive->unit != SPI_DELAY_UNIT_SCK) {
 		dev_err(&spi->dev,
 			"Invalid delay unit %d, should be SPI_DELAY_UNIT_SCK\n",
 			SPI_DELAY_UNIT_SCK);
 		return -EINVAL;
 	}
 
-	setup_dly = setup ? setup->value : 0;
-	hold_dly = hold ? hold->value : 0;
-	inactive_dly = inactive ? inactive->value : 0;
-
-	setup_dly = min_t(u8, setup_dly, MAX_SETUP_HOLD_CYCLES);
-	hold_dly = min_t(u8, hold_dly, MAX_SETUP_HOLD_CYCLES);
+	setup_dly = min_t(u8, setup->value, MAX_SETUP_HOLD_CYCLES);
+	hold_dly = min_t(u8, hold->value, MAX_SETUP_HOLD_CYCLES);
 	if (setup_dly && hold_dly) {
 		setup_hold = SPI_SETUP_HOLD(setup_dly - 1, hold_dly - 1);
 		spi_cs_timing = SPI_CS_SETUP_HOLD(tspi->spi_cs_timing1,
@@ -755,7 +751,7 @@ static int tegra_spi_set_hw_cs_timing(st
 		}
 	}
 
-	inactive_cycles = min_t(u8, inactive_dly, MAX_INACTIVE_CYCLES);
+	inactive_cycles = min_t(u8, inactive->value, MAX_INACTIVE_CYCLES);
 	if (inactive_cycles)
 		inactive_cycles--;
 	cs_state = inactive_cycles ? 0 : 1;


