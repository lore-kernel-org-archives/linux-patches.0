Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB9B1E98F6;
	Wed, 15 Jan 2025 10:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938391; cv=none; b=Oum6eDoJQDWuNq+PIEXZsdnH6F9LqcaAe+FSJuXB4j4TGQeZ9h2T5mpNVWJ44g9npBOj1ztmaQnvA6+AVatxdZEZwhA3SWGG1zyTgIQUpctXRAskcAn2eMrJGiTwlrvCHK/E8FsVm5PrmYUKY0718fJBFWr6HOurJEXnEKDSNgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938391; c=relaxed/simple;
	bh=0Own41rVTkfoGBdI5WOP9h5xBFRsSn35+2eNsIHBjSk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E4+r9ADN8p5tCkCiT0V4I6y5/1mlTOk8r8Addh9GrSpQdfAfKJowSz3WfGB+jEQUKPuC8B3C0ceBX8Zgg3tTlafukn7APukAhExK59VPFs0sEigx9lrkL9LVxn7nenCuKqiZ+nRbEYWbAWkLWz0cDzNiXjJnaPBBesXwUAuxHuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPvhkEJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPvhkEJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB407C4CEDF;
	Wed, 15 Jan 2025 10:53:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938391;
	bh=0Own41rVTkfoGBdI5WOP9h5xBFRsSn35+2eNsIHBjSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPvhkEJ9DoWiSHAU+BS3+pWIZhcorSNAH4CzLOazTlmBtYCFTPEjfh8Qo3vVGlAdo
	 wVbjAwiv1o2DVA6u9NC7Lax/6Du0QcDMTzOPvsfP5AlZlVDr25ta1IstWX43jPtdyb
	 xQcq38lGrbWNDRhO3P0Y5ItRBLz4AV/a3EeBPMa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Fabio Estevam <festevam@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 169/189] iio: adc: ti-ads124s08: Use gpiod_set_value_cansleep()
Date: Wed, 15 Jan 2025 11:37:45 +0100
Message-ID: <20250115103613.152790298@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Estevam <festevam@gmail.com>

commit 2a8e34096ec70d73ebb6d9920688ea312700cbd9 upstream.

Using gpiod_set_value() to control the reset GPIO causes some verbose
warnings during boot when the reset GPIO is controlled by an I2C IO
expander.

As the caller can sleep, use the gpiod_set_value_cansleep() variant to
fix the issue.

Tested on a custom i.MX93 board with a ADS124S08 ADC.

Cc: stable@kernel.org
Fixes: e717f8c6dfec ("iio: adc: Add the TI ads124s08 ADC code")
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Link: https://patch.msgid.link/20241122164308.390340-1-festevam@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads124s08.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ti-ads124s08.c
+++ b/drivers/iio/adc/ti-ads124s08.c
@@ -183,9 +183,9 @@ static int ads124s_reset(struct iio_dev
 	struct ads124s_private *priv = iio_priv(indio_dev);
 
 	if (priv->reset_gpio) {
-		gpiod_set_value(priv->reset_gpio, 0);
+		gpiod_set_value_cansleep(priv->reset_gpio, 0);
 		udelay(200);
-		gpiod_set_value(priv->reset_gpio, 1);
+		gpiod_set_value_cansleep(priv->reset_gpio, 1);
 	} else {
 		return ads124s_write_cmd(indio_dev, ADS124S08_CMD_RESET);
 	}


