Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59903156C6C;
	Tue, 23 Jul 2024 18:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759430; cv=none; b=sxxVmkDrNdoBYzTiRg1aWN8hfGJy5yYkjzz+c6X6orfnuqqPUkZi4fQ39JPYjAp10pI5hJ6X3PoTY3ZT149y4uLdKNAOuli/U8c0iP1C1hLXjRY7TiZste0rZMv+1l5lRJqrA9o2AvQ+2pArFnedtKbqkBArwgbAg/3iU4ZOQwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759430; c=relaxed/simple;
	bh=L6gLPUGpL300K/wZWjXlSVMli3OZtmHvwpt94/19p8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EfIZGON6SlNBMvaLNzxoDjF+TAORy5+fZXcYK8h1KUP4or0D1GZuxRuDG4GnN9OG189atwx9G4z6+WxOUQkOtIxmv3Bb2Hw0wDitcjqjDEr8AWhYbsUeyggw5DoLlmuUwGeDIf6GVvBsCwS52vD8hWVjnDBGdIXTJKoE29cfWE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EC2YnsDL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EC2YnsDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ACAAC4AF0A;
	Tue, 23 Jul 2024 18:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759429;
	bh=L6gLPUGpL300K/wZWjXlSVMli3OZtmHvwpt94/19p8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EC2YnsDL3bvAnIqJ/+Kny4xst6SP2HpoTCOg1mJVc6RgyJ43WSuJyUcRhSKGyDD7y
	 g/xQqodMRG2l42/8mMJ8foxSpbdmdb00l+zoE2GHbjqSNKHmcZFKzCp+c8qdsYEHrF
	 UYAj5amt9oEB0UZsXHruQxGS66K1UAB1OFT3oVrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 092/105] spi: imx: Dont expect DMA for i.MX{25,35,50,51,53} cspi devices
Date: Tue, 23 Jul 2024 20:24:09 +0200
Message-ID: <20240723180406.792342339@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2c660a95c17e7..93e83fbc3403f 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1040,7 +1040,7 @@ static struct spi_imx_devtype_data imx35_cspi_devtype_data = {
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



