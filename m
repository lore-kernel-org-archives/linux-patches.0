Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F36C2210DF;
	Thu, 12 Dec 2024 15:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016569; cv=none; b=h7sMLScHDndhC967u/27I41nVIgYiaVpB1S5Mz0QILVFgcN56nhKTejEdMgVzmfn7w0TNfAJJmVHA87kSV/DBmZNAe6WjHFUjwdN575GsXUGhpbpcbjo1+IzgT9YTJD0lQ4oJZmxXGpKn9sOrh+2myuV4LQZC1hSn+SJMFgO5SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016569; c=relaxed/simple;
	bh=/hu+UM0g7byTMxdX7pwy15YoI/wG254KuSMs4nLyZZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W9Aizp7qOT2m+AqdoqJ4cbHndNEvDeCAxYPdY4gkq8SCtjgEcp1XTjEtI+mu8kKEVxNN6k+StGMlQAFMuObszg9M948xep/CNqQFcY6yK7updsTdaaLd5OX46Wu4Epfm4YODJw0vsvdohzcz9BgwGpWAsaQvSX0Kuucfh62TjyA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMPk/7au; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMPk/7au"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C641AC4CECE;
	Thu, 12 Dec 2024 15:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016569;
	bh=/hu+UM0g7byTMxdX7pwy15YoI/wG254KuSMs4nLyZZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMPk/7auj3GonQMAvsZoKUcigCVDebDWZ0NcrXfixaSEaDjwUjYF7msZ1OsorqvaT
	 fqCyC1RwWIVydKggyd99dRrL66P8NUJsbLqbJ4dlUaHQXQpLw4qElkTiFMwWnRGOPf
	 ua1dvIA96I79xfSBMZDpZUiU0GUTYwL7OkrkYS1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefan Wahren <wahrenst@gmx.net>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 236/466] spi: spi-fsl-lpspi: Adjust type of scldiv
Date: Thu, 12 Dec 2024 15:56:45 +0100
Message-ID: <20241212144316.103679702@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Wahren <wahrenst@gmx.net>

[ Upstream commit fa8ecda9876ac1e7b29257aa82af1fd0695496e2 ]

The target value of scldiv is just a byte, but its calculation in
fsl_lpspi_set_bitrate could be negative. So use an adequate type to store
the result and avoid overflows. After that this needs range check
adjustments, but this should make the code less opaque.

Signed-off-by: Stefan Wahren <wahrenst@gmx.net>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20240930093056.93418-2-wahrenst@gmx.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-fsl-lpspi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-fsl-lpspi.c b/drivers/spi/spi-fsl-lpspi.c
index 9573b8fa4fbfc..29b9676fe43d8 100644
--- a/drivers/spi/spi-fsl-lpspi.c
+++ b/drivers/spi/spi-fsl-lpspi.c
@@ -315,9 +315,10 @@ static void fsl_lpspi_set_watermark(struct fsl_lpspi_data *fsl_lpspi)
 static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 {
 	struct lpspi_config config = fsl_lpspi->config;
-	unsigned int perclk_rate, scldiv, div;
+	unsigned int perclk_rate, div;
 	u8 prescale_max;
 	u8 prescale;
+	int scldiv;
 
 	perclk_rate = clk_get_rate(fsl_lpspi->clk_per);
 	prescale_max = fsl_lpspi->devtype_data->prescale_max;
@@ -338,13 +339,13 @@ static int fsl_lpspi_set_bitrate(struct fsl_lpspi_data *fsl_lpspi)
 
 	for (prescale = 0; prescale <= prescale_max; prescale++) {
 		scldiv = div / (1 << prescale) - 2;
-		if (scldiv < 256) {
+		if (scldiv >= 0 && scldiv < 256) {
 			fsl_lpspi->config.prescale = prescale;
 			break;
 		}
 	}
 
-	if (scldiv >= 256)
+	if (scldiv < 0 || scldiv >= 256)
 		return -EINVAL;
 
 	writel(scldiv | (scldiv << 8) | ((scldiv >> 1) << 16),
-- 
2.43.0



