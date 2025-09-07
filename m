Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB34314BFA2;
	Sun,  7 Sep 2025 20:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276450; cv=none; b=GjsT6NTrJjj5W/EIRgPbwIeYKeOh4F4ZrrDChz1PuCUcD4NMjh4vyCvbbIi7sjQjL3nClSBwHL+/oyrFrophSQvuk1TDfzNLoHukuFXDHHrbd4/wzcUNBFHQ40P+U5DTcJeao3aqhJJFdXT/CJE3KsN+Heofp8LBfmuSMxsFSFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276450; c=relaxed/simple;
	bh=sf1/1Bleub35k/LReXxkyGKs1Y5Xdto1xwb1ndoZayY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kUDgh90k556X33SPJp5Ctd1UtdrYOsOXkXpmwUSXJYHLdEl2yhNrsAiLws76t4ZXEnSS6dgi+4SE/vcRRSXp6AgEi+bOz9Tx9zDwhqqklHoGpeVBzu8ql3kFwwidpno28PudXG89A03BLVlrAY2A0YN9ahQmE+gzqPz31KmX+xU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HD32Vq21; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HD32Vq21"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB423C4CEF0;
	Sun,  7 Sep 2025 20:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276449;
	bh=sf1/1Bleub35k/LReXxkyGKs1Y5Xdto1xwb1ndoZayY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HD32Vq21/dJmEEoygYY0TUc61LaMehn7cseRdQb8keANPPrsBSjWqzzls/51fox7l
	 I/vtP/z8E9+z24kJnXFjBORKIryR3ZsEtIl7PJSun+vDnxeqjWzh3Arq8XVHQ69TQc
	 8pa7v/EhG2RlI3XBpbVT1dR7wdpvJwHLZ4QPqFO4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aaron Kling <webgeek1234@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/104] spi: tegra114: Dont fail set_cs_timing when delays are zero
Date: Sun,  7 Sep 2025 21:58:25 +0200
Message-ID: <20250907195609.442035200@linuxfoundation.org>
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

[ Upstream commit 4426e6b4ecf632bb75d973051e1179b8bfac2320 ]

The original code would skip null delay pointers, but when the pointers
were converted to point within the spi_device struct, the check was not
updated to skip delays of zero. Hence all spi devices that didn't set
delays would fail to probe.

Fixes: 04e6bb0d6bb1 ("spi: modify set_cs_timing parameter")
Cc: stable@vger.kernel.org
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20250423-spi-tegra114-v1-1-2d608bcc12f9@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-tegra114.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -729,9 +729,9 @@ static int tegra_spi_set_hw_cs_timing(st
 	u32 inactive_cycles;
 	u8 cs_state;
 
-	if (setup->unit != SPI_DELAY_UNIT_SCK ||
-	    hold->unit != SPI_DELAY_UNIT_SCK ||
-	    inactive->unit != SPI_DELAY_UNIT_SCK) {
+	if ((setup->unit && setup->unit != SPI_DELAY_UNIT_SCK) ||
+	    (hold->unit && hold->unit != SPI_DELAY_UNIT_SCK) ||
+	    (inactive->unit && inactive->unit != SPI_DELAY_UNIT_SCK)) {
 		dev_err(&spi->dev,
 			"Invalid delay unit %d, should be SPI_DELAY_UNIT_SCK\n",
 			SPI_DELAY_UNIT_SCK);


