Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23344FC19;
	Thu, 25 Jul 2024 14:49:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918955; cv=none; b=pN0uTelanuWajKf+Hf9syBmB8gHvjphIUcJY1JOFUMMi7qwYS6RLROo9catVCq+T+lnGyf1QuSugHrNih7idi8rTC6C0qTJTXte3mDg+qOKMukSUTfoLl+pdEtqCe64c0F3gfFj+8eHdkvYX4+rOUjFJ66Nxv3FTioS5jLRTtUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918955; c=relaxed/simple;
	bh=z56eoMfQxmMfPXHOv013zor4B4YqjIej8S0ov3qL3AI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ml8NuFjrkWfv4qnYnHszpfSbGOHd20rEDYgrD+sCl/u3h54uHjh5I8pAUXDF8nJkh++paVnT1kwPOSmRRtP1yPxaqfovM0y1CmO+uY5MdTj7eh1r/Cy9ptCjXDdhbQyLclZaxkd/HXgUSV0fO9n77jNz2SdVTw/uztKSkB6V3WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a4wWvOS6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a4wWvOS6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4072C116B1;
	Thu, 25 Jul 2024 14:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918955;
	bh=z56eoMfQxmMfPXHOv013zor4B4YqjIej8S0ov3qL3AI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a4wWvOS6DFVgELWOhjRlc5UEEHcmPR2P55/L+NvR57GOdNyL4lU+alid1tggqOY9h
	 quolJQKNI+KK4BOdpsr/Y118F81NWDSLdBR/LCEPjUiXNQKhUoy5whZG/xHrr2kCir
	 ALI4GZCsMirymZJwbe+sTGX8ND0dg1FzIH+O6Qho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 40/59] spi: imx: Dont expect DMA for i.MX{25,35,50,51,53} cspi devices
Date: Thu, 25 Jul 2024 16:37:30 +0200
Message-ID: <20240725142734.778928029@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142733.262322603@linuxfoundation.org>
References: <20240725142733.262322603@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit ce1dac560a74220f2e53845ec0723b562288aed4 ]

While in commit 2dd33f9cec90 ("spi: imx: support DMA for imx35") it was
claimed that DMA works on i.MX25, i.MX31 and i.MX35 the respective
device trees don't add DMA channels. The Reference manuals of i.MX31 and
i.MX25 also don't mention the CSPI core being DMA capable. (I didn't
check the others.)

Since commit e267a5b3ec59 ("spi: spi-imx: Use dev_err_probe for failed
DMA channel requests") this results in an error message

	spi_imx 43fa4000.spi: error -ENODEV: can't get the TX DMA channel!

during boot. However that isn't fatal and the driver gets loaded just
fine, just without using DMA.

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://patch.msgid.link/20240508095610.2146640-2-u.kleine-koenig@pengutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-imx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
index 21297cc62571a..8566da12d15e3 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1001,7 +1001,7 @@ static struct spi_imx_devtype_data imx35_cspi_devtype_data = {
 	.rx_available = mx31_rx_available,
 	.reset = mx31_reset,
 	.fifo_size = 8,
-	.has_dmamode = true,
+	.has_dmamode = false,
 	.dynamic_burst = false,
 	.has_slavemode = false,
 	.devtype = IMX35_CSPI,
-- 
2.43.0



