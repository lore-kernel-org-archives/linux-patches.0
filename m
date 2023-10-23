Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB38615484
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkrR3IV1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43C7AC433C7;
	Mon, 23 Oct 2023 11:23:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060190;
	bh=Th1z5anTtlk1THDLH2N6t1tbqqcInv901s3CtuG/HBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkrR3IV1sPVAJGz4SvOHWxQNp9Z35ePz8wVLWaFrftPMJ4gGAlJFsb1B6eSJkweGk
	 G8svmR/Ki1bwLZ8abgf0PKdqthxglZd0C63EUiv7zaSs7ZnSlaHCWzRDQg885fTe7G
	 eEGCD7qic5IlxBUQQqEkuf8rPg9uEHOe3hADO0x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 089/196] iio: adc: ad7192: Simplify using devm_regulator_get_enable()
Date: Mon, 23 Oct 2023 12:55:54 +0200
Message-ID: <20231023104831.055671591@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 1ccef2e6e9205e209ad958d2e591bcca60981007 ]

Use devm_regulator_get_enable() instead of open coded get, enable,
add-action-to-disable-at-detach - pattern. Also drop the seemingly unused
struct member 'dvdd'.

Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Link: https://lore.kernel.org/r/9719c445c095d3d308e2fc9f4f93294f5806c41c.1660934107.git.mazziesaccount@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 7e7dcab620cd ("iio: adc: ad7192: Correct reference voltage")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7192.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/iio/adc/ad7192.c b/drivers/iio/adc/ad7192.c
index 80eff7090f14a..18520f7bedccd 100644
--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -177,7 +177,6 @@ struct ad7192_chip_info {
 struct ad7192_state {
 	const struct ad7192_chip_info	*chip_info;
 	struct regulator		*avdd;
-	struct regulator		*dvdd;
 	struct clk			*mclk;
 	u16				int_vref_mv;
 	u32				fclk;
@@ -1011,19 +1010,9 @@ static int ad7192_probe(struct spi_device *spi)
 	if (ret)
 		return ret;
 
-	st->dvdd = devm_regulator_get(&spi->dev, "dvdd");
-	if (IS_ERR(st->dvdd))
-		return PTR_ERR(st->dvdd);
-
-	ret = regulator_enable(st->dvdd);
-	if (ret) {
-		dev_err(&spi->dev, "Failed to enable specified DVdd supply\n");
-		return ret;
-	}
-
-	ret = devm_add_action_or_reset(&spi->dev, ad7192_reg_disable, st->dvdd);
+	ret = devm_regulator_get_enable(&spi->dev, "dvdd");
 	if (ret)
-		return ret;
+		return dev_err_probe(&spi->dev, ret, "Failed to enable specified DVdd supply\n");
 
 	ret = regulator_get_voltage(st->avdd);
 	if (ret < 0) {
-- 
2.40.1



