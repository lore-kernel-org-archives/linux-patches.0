Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F61817BB0C;
	Tue, 10 Sep 2024 10:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964706; cv=none; b=UIrbOlJ0wFs15bnUyBwF67E5cF9XKTPBy1kPnajoyOqxx8TuXMNlwb7faZacquKu01T6Eww2gfNRTh1F31KCRzxmC8tiXVHuBTyksYWWcpvYNSrI07qrG1/GvLLczwaDgVMP0gRsGr5X9UZAfoktLpRwcOkSebYyz+XYIib0S5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964706; c=relaxed/simple;
	bh=u5Nq6mgrAnEBMOgHmA3DxNZ95zUkOCV8XiTKBZUhmfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6o2a/DK0UWF/BS8twte89btfgF7Bgy7SNihgJHK/UvXQddAtnlLEm3BfzdrStXB/Zco2jTrXW75WWBvsjRCwxHXtTwr8Bi/G7TDteTWHXQ0kp7IUC/euPpYAjbcvksHcAlLDjJDMN4MnwBy2QPio6ImOxCdN/uDr1hMxURDsqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ox7WgGbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ox7WgGbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1A0C4CEC3;
	Tue, 10 Sep 2024 10:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964706;
	bh=u5Nq6mgrAnEBMOgHmA3DxNZ95zUkOCV8XiTKBZUhmfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ox7WgGbYiAFdKgSmwANPN/HD+aHkBqT0SkRteO0d4NxQvViWOgUBYWGOXxVljCWkX
	 SgWlAj7xjvA4JYo68d4efH9czhpapI9iVIZbKOTnKn7/6hu2ET3Udmj0BN2yfuUYal
	 f+/BeYmGZe9JGrWBoZ7NcosViPyZm0vrbHeSy+9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 266/269] spi: spi-fsl-lpspi: Fix off-by-one in prescale max
Date: Tue, 10 Sep 2024 11:34:13 +0200
Message-ID: <20240910092617.214807048@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


