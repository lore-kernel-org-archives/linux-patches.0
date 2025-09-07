Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC3C5189BB0;
	Sun,  7 Sep 2025 20:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276430; cv=none; b=itmSOqf+3RhrzXlCUoa8RDQTgUQkyGZUtv0Mzms1oZEAXeaUEfMFdGotfQ2WNsUMz7tFxowGQrK2ZdjhdEF8DsLnaRs6d1Df7et87vb51j8YHodRR2sML+e8f1fk/kLGNEy5l9ASbXGWegSr5RFVX+Yg4x0M9CL+ur3hiNj35FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276430; c=relaxed/simple;
	bh=BhtLdr2Kj6lsvaUhgdZfeD/s6wDdlbCk9QvVAGbvwdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FXgrz+G0WmVtTkyT0yyNd6cl0u/Uk1dMKRpjOIlpgaT3PM/lSuJQc25Cf8Ii5eS5wzmTFtRT8Jh2BCyeV1VvdFxltpvCsucGVktdVbRQAFTgUTZKqRiLU/NUKLPhEFdkmoO1qjZJR3pydWY2YcEeIjNkYMG/Gn+v2xNjorNoBVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2U9zkRgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2U9zkRgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34899C4CEF0;
	Sun,  7 Sep 2025 20:20:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276430;
	bh=BhtLdr2Kj6lsvaUhgdZfeD/s6wDdlbCk9QvVAGbvwdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2U9zkRgZ+hPTeEZO1qgHTmykxuUka3ilzqbrxRv3uHYu9p5vFpuwMvtOpVMDN0sCk
	 pN2S0+kXdFXO7+dexNeHkWFyouRU0Q8FJLxD4OWN7vAZ+aTd9EJwrmhV5epvUrdEAE
	 6n3ZeQwLfKCOU7dHr1WKaXMIyNi+fMoeORrynJFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 101/104] spi: tegra114: Use value to check for invalid delays
Date: Sun,  7 Sep 2025 21:58:58 +0200
Message-ID: <20250907195610.283808506@linuxfoundation.org>
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

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit e979a7c79fbc706f6dac913af379ef4caa04d3d5 ]

A delay unit of 0 is a valid entry, thus it is not valid to check for
unused delays. Instead, check the value field; if that is zero, the
given delay is unset.

Fixes: 4426e6b4ecf6 ("spi: tegra114: Don't fail set_cs_timing when delays are zero")
Cc: stable@vger.kernel.org
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://patch.msgid.link/20250506-spi-tegra114-fixup-v1-1-136dc2f732f3@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 60799ab60eb45..12085f4621a0c 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -729,9 +729,9 @@ static int tegra_spi_set_hw_cs_timing(struct spi_device *spi)
 	u32 inactive_cycles;
 	u8 cs_state;
 
-	if ((setup->unit && setup->unit != SPI_DELAY_UNIT_SCK) ||
-	    (hold->unit && hold->unit != SPI_DELAY_UNIT_SCK) ||
-	    (inactive->unit && inactive->unit != SPI_DELAY_UNIT_SCK)) {
+	if ((setup->value && setup->unit != SPI_DELAY_UNIT_SCK) ||
+	    (hold->value && hold->unit != SPI_DELAY_UNIT_SCK) ||
+	    (inactive->value && inactive->unit != SPI_DELAY_UNIT_SCK)) {
 		dev_err(&spi->dev,
 			"Invalid delay unit %d, should be SPI_DELAY_UNIT_SCK\n",
 			SPI_DELAY_UNIT_SCK);
-- 
2.51.0



