Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA141917D7;
	Tue, 10 Sep 2024 09:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962354; cv=none; b=W2DjOtHY/C3IYcAq3pOa7oVk5oziC/fUKvHUbJYc1KxTi44nufpmX61eyOiwfgPDxqqy3oJ7/iCooN6g/8o1nhK/eKhKFPHKZzpdY/XDhR3L+Z7EA673P7QQBuQIzGiWnnnb+uSnOpuS5Qr+mOGHJPbA/23i7rmEi8c0n8kFuPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962354; c=relaxed/simple;
	bh=Uj/ap+Dep7AePOyqp2uTvDEaiLrp7cE+aYm+lEMMp08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WS4NR3BE9n3eL/a5Y05MyubpBrb+cJaKeUaf4e3vcBJ0PRJ4248Py1W2xuQLo7zgoRPdnzSvNJJUc/NWB9ma17WDBBQi/jxXnAhG8DAwtS6jWSPghURp2nkbgvVKfej7EtTtj7hAR3jdLB9BK+AR6rKkNCLOMSbATugz2aaTQNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SFamBgeo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SFamBgeo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2361BC4CEC3;
	Tue, 10 Sep 2024 09:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962354;
	bh=Uj/ap+Dep7AePOyqp2uTvDEaiLrp7cE+aYm+lEMMp08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SFamBgeofU7qFClfrjocYqvuXYnDuhoDAqCDEOtLRcXsaeo+CFfi9qQVU0UmY7mTR
	 5xOALr5JYF2hBLq7kjQAcO95UOZfWjB0BdJ6WI3QKTKRTNYdqWpB5mNlNR5haoVwf5
	 9MQWhINRprEI95m/CsPAevT96A8d6O+0d+huaAus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.10 374/375] spi: spi-fsl-lpspi: Fix off-by-one in prescale max
Date: Tue, 10 Sep 2024 11:32:51 +0200
Message-ID: <20240910092635.190119737@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

commit ff949d981c775332be94be70397ee1df20bc68e5 upstream.

The commit 783bf5d09f86 ("spi: spi-fsl-lpspi: limit PRESCALE bit in
TCR register") doesn't implement the prescaler maximum as intended.
The maximum allowed value for i.MX93 should be 1 and for i.MX7ULP
it should be 7. So this needs also a adjustment of the comparison
in the scldiv calculation.

Fixes: 783bf5d09f86 ("spi: spi-fsl-lpspi: limit PRESCALE bit in TCR register")
Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Link: https://patch.msgid.link/20240905111537.90389-1-wahrenst@gmx.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-lpspi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -136,7 +136,7 @@ static struct fsl_lpspi_devtype_data imx
 };
 
 static struct fsl_lpspi_devtype_data imx7ulp_lpspi_devtype_data = {
-	.prescale_max = 8,
+	.prescale_max = 7,
 };
 
 static const struct of_device_id fsl_lpspi_dt_ids[] = {
@@ -336,7 +336,7 @@ static int fsl_lpspi_set_bitrate(struct
 
 	div = DIV_ROUND_UP(perclk_rate, config.speed_hz);
 
-	for (prescale = 0; prescale < prescale_max; prescale++) {
+	for (prescale = 0; prescale <= prescale_max; prescale++) {
 		scldiv = div / (1 << prescale) - 2;
 		if (scldiv < 256) {
 			fsl_lpspi->config.prescale = prescale;


