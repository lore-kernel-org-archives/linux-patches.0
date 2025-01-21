Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E477D1F55F3;
	Tue, 21 Jan 2025 18:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482936; cv=none; b=ANQlMbWbX8VNmvXBIdu9RshUjTq5PwzggSp+zw23wwNrpE5c4tjaNaGWHkGS11NPEW/Ot7pI5OVOfOkHbqVSlEJ+Q8XL/OEeQQ8Cg3nTE3cwxoDlk5ikL4K/8Te3kV8oEgzyQ8MNTNtYTcMQRC0c/pFMMmVMddCZOruNbnWisys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482936; c=relaxed/simple;
	bh=I85g4DXsvhiGd5k2b2XIBCrHMLkgYvWTTKSJLxG/n/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T4J6Yd34O9+Qn5hg9lBYlpSx/8vYIghNUnB93lY0F829cRra6aXruPIttvUOeUoHJjH9IfZNn3lhyPZQCKcltSO9Y7QcA+qcv30KH65fnY4FteWtA6md1RdkDCT6yaVpYAvwtKSV6AUIdbI41s2yorPcnNrcsR39cuo5ENV9q0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MaQP22X4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MaQP22X4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600AEC4CEE1;
	Tue, 21 Jan 2025 18:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482935;
	bh=I85g4DXsvhiGd5k2b2XIBCrHMLkgYvWTTKSJLxG/n/w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MaQP22X4OF2hLnabPyid96mtPY/KQfiJEdWh19PAWflyT07pK39XrKwglOj5bLQod
	 NTGr5ANfKI4AiR9pI6iC/OB5xqN1Et8LJjl3XkqcQXegAifWCmllpnEXXUWD1QiwhN
	 uo2tuVA9pZgWOLGuoM48qIcQ9lQhSEjgoRn1VMEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Fabio Estevam <festevam@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 059/127] iio: adc: ti-ads124s08: Use gpiod_set_value_cansleep()
Date: Tue, 21 Jan 2025 18:52:11 +0100
Message-ID: <20250121174531.938011974@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -184,9 +184,9 @@ static int ads124s_reset(struct iio_dev
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


