Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04BA1990DD;
	Thu, 25 Jul 2024 14:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721919223; cv=none; b=XA1EGn5WAfH8kB75IQZddB9ipJO3w+9oVjhjcNx1QNvzf7plT6HtvZ1gHQgVj1oErhD+ozmHvnSL1/AEALShQJm9eogwxxBSSivRSm2xrelWq4Etx/3C+7a2Kv1LGNq2yAEm/8qyXJ5BFmBtrjlgCpLsrwsfBwTRB57w11YS2VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721919223; c=relaxed/simple;
	bh=tDD6lYNeZDVjrkyL19zC00jX9m6AGtxPKOhOmz25ucw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=k/IjhbqJ9OLKzlZuBNT+/2gPAryk03xdiu616s0nIbWvGT9gUYxxTrN4PmvtfkRmmVHm66/sWgX7w/LIwslEiNL6FXrkQvyDIxmpSVtxJpL5uYk5w0i1SouAdBrsMfJaxsBVAq/g0CYZPRPiXAADwTP1kRbA98Uem9k2Kv81VnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wJOjniCH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wJOjniCH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301CBC32782;
	Thu, 25 Jul 2024 14:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721919223;
	bh=tDD6lYNeZDVjrkyL19zC00jX9m6AGtxPKOhOmz25ucw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wJOjniCHfvOinXeQBCviWwYDzKR3RBCLloRe4e/sW9F7+9BdJM/guTvYBp0Czrpbd
	 QTDo464bTX3qd3nkZfh/PRRR6zSXNKLRNQBG963L97rx3THjzR4xGcweYMKYsYRX8E
	 FRbpimQ3ks+Xly4BY3c86rJq5Pl2va9akKdLq0D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 60/87] spi: imx: Dont expect DMA for i.MX{25,35,50,51,53} cspi devices
Date: Thu, 25 Jul 2024 16:37:33 +0200
Message-ID: <20240725142740.694574529@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142738.422724252@linuxfoundation.org>
References: <20240725142738.422724252@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f201653931d89..c806ee8070e5a 100644
--- a/drivers/spi/spi-imx.c
+++ b/drivers/spi/spi-imx.c
@@ -1016,7 +1016,7 @@ static struct spi_imx_devtype_data imx35_cspi_devtype_data = {
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



