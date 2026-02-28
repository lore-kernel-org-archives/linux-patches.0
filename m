Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1196313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300996; cv=none; b=XIs7Mu63SRp0lDSXWO3x6Tn9pkm8wOHKop5anfgbw5miR4pMbPekS5qTcW/JOY+gusvuPWkfwHnNnguGOixxRUdMkFrYGJeBZwVzjkst7ci35HSXxHUptm26AKgUR5bkbkUX36HvrJjhNjIP3hoEjT9nHN3k682VuxZ+r7txbOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300996; c=relaxed/simple;
	bh=IsQH2GK7lrSZDfrhWKcM5PD+4pD16JHIZmz5ZCPkWUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kt/0MPx9nvvmkvZ6ZFPltybmR6IxftZHUgUiZ+yeReL7akSu74m4CKaZD1F21GrCmM03rVbM95dp62M5/wkL37GR5L7nJt2q67RVJx1QbaCsplfm05DTIr9R+M6JrCoVzsFtoMaPnBRZ5fsR+n6HckaZNk0Rdkg1K5tIFo3RHtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TAgZO2cS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TAgZO2cS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B5DC116D0;
	Sat, 28 Feb 2026 17:49:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300996;
	bh=IsQH2GK7lrSZDfrhWKcM5PD+4pD16JHIZmz5ZCPkWUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TAgZO2cSSodxmrN33yRy2Iu6oLrDrpnSS4/AQeAA0u41Tn7zDmxOWSZGDTbgNlvXj
	 DVs4ZAZHE0IQNqP0JxL3+6mzsjjOM/FPjrZ/ABj9BA2eg4O/HvGMqOiKYJ7Fxq/eFH
	 zD+SY4xFBrJuVlu/T+8FaWfr1ePE7REV4di9TBH3ckdmzb3BGTXB4DXCdq3t53Zwmh
	 krNEz3E1mmK/BroBhWF1doc2eZ4USZ3pWBn79GKHVr1x1ot+DSMdfAfZJ7dnG9R6Bl
	 mWLjWBeS/547cDbxt+aMvlEjaJ9D1m/tUfNdjOGDEJMYGRgR2TZgDjon1fe4aBLA1k
	 e5N18uyDGRf2Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Deepak Kumar <deepak.kumar01@st.com>,
	Alain Volmat <alain.volmat@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 128/752] spi: stm32: fix Overrun issue at < 8bpw
Date: Sat, 28 Feb 2026 12:37:19 -0500
Message-ID: <20260228174750.1542406-128-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Deepak Kumar <deepak.kumar01@st.com>

[ Upstream commit 1ac3be217c01d5df55ec5052f81e4f1708f46552 ]

When SPI communication is suspended by hardware automatically, it could
happen that few bits of next frame are already clocked out due to
internal synchronization delay.

To achieve a safe suspension, we need to ensure that each word must be
at least 8 SPI clock cycles long. That's why, if bpw is less than 8
bits, we need to use midi to reach 8 SPI clock cycles at least.

This will ensure that each word achieve safe suspension and prevent
overrun condition.

Signed-off-by: Deepak Kumar <deepak.kumar01@st.com>
Signed-off-by: Alain Volmat <alain.volmat@foss.st.com>
Link: https://patch.msgid.link/20251218-stm32-spi-enhancements-v2-2-3b69901ca9fe@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-stm32.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi-stm32.c b/drivers/spi/spi-stm32.c
index 2c804c1aef989..80986bd251d29 100644
--- a/drivers/spi/spi-stm32.c
+++ b/drivers/spi/spi-stm32.c
@@ -1906,11 +1906,12 @@ static void stm32h7_spi_data_idleness(struct stm32_spi *spi, struct spi_transfer
 	cfg2_clrb |= STM32H7_SPI_CFG2_MIDI;
 	if ((len > 1) && (spi->cur_midi > 0)) {
 		u32 sck_period_ns = DIV_ROUND_UP(NSEC_PER_SEC, spi->cur_speed);
-		u32 midi = min_t(u32,
-				 DIV_ROUND_UP(spi->cur_midi, sck_period_ns),
-				 FIELD_GET(STM32H7_SPI_CFG2_MIDI,
-				 STM32H7_SPI_CFG2_MIDI));
+		u32 midi = DIV_ROUND_UP(spi->cur_midi, sck_period_ns);
 
+		if ((spi->cur_bpw + midi) < 8)
+			midi = 8 - spi->cur_bpw;
+
+		midi = min_t(u32, midi, FIELD_MAX(STM32H7_SPI_CFG2_MIDI));
 
 		dev_dbg(spi->dev, "period=%dns, midi=%d(=%dns)\n",
 			sck_period_ns, midi, midi * sck_period_ns);
-- 
2.51.0

