Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1DB230D3A;
	Mon, 10 Mar 2025 17:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627018; cv=none; b=nsSIzdozBNXNHSKAkyewNKES2oUcPLVr31vXCQh+ZMuYnATzZMTSSlm5g915iJavq0Jy/gGocbje1XzdJuxvBSlBiuEgwN70g8ZLNIFHqYEJuDwiYLzgplYa/IdRvwicDJLMVn1wBR0QN2OPEX/GiRuWpTRdLMPl5Twe3hh5+A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627018; c=relaxed/simple;
	bh=2ksU6EGvpL9O8c+U8po51+1f4xZz6A0eXB+luBXLkKA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iBu0hgyRLrH/o/5rJdezhSl7RSQyvWqiJh0db2SK5GzcsFDLfqvoAC38pIwQ4JzVMJJZfHFcQ1KJoeGnCRotIrVGM281gzy5pJFGY7Svmxb+BHrjBP31Ne8FzuRZLt8n2XvnIduhk4WlkgnsfxmvZchkRLwQimcWs8djFj1Gxk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BUoCpsaP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BUoCpsaP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E90C4CEEB;
	Mon, 10 Mar 2025 17:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627017;
	bh=2ksU6EGvpL9O8c+U8po51+1f4xZz6A0eXB+luBXLkKA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BUoCpsaPzE7Gy990B6KBRYkl4EZkxDsoEXdYozeO/RC9QwR+7aStRClSHDmaZvEvS
	 08jYLtjlWof37Tz/m5TitghxVNnCeMErJgYHdbsS76E7WUW0DdWKx/d9iap7f8jzVs
	 4OGpFcLZIhJAsfYCEnPi6iLQ9I0lui3PQbhexZK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Winchenbach <swinchenbach@arka.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.13 192/207] iio: filter: admv8818: Force initialization of SDO
Date: Mon, 10 Mar 2025 18:06:25 +0100
Message-ID: <20250310170455.414284019@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sam Winchenbach <swinchenbach@arka.org>

commit cc2c3540d9477a9931fb0fd851fcaeba524a5b35 upstream.

When a weak pull-up is present on the SDO line, regmap_update_bits fails
to write both the SOFTRESET and SDOACTIVE bits because it incorrectly
reads them as already set.

Since the soft reset disables the SDO line, performing a
read-modify-write operation on ADI_SPI_CONFIG_A to enable the SDO line
doesn't make sense. This change directly writes to the register instead
of using regmap_update_bits.

Fixes: f34fe888ad05 ("iio:filter:admv8818: add support for ADMV8818")
Signed-off-by: Sam Winchenbach <swinchenbach@arka.org>
Link: https://patch.msgid.link/SA1P110MB106904C961B0F3FAFFED74C0BCF5A@SA1P110MB1069.NAMP110.PROD.OUTLOOK.COM
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/filter/admv8818.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/drivers/iio/filter/admv8818.c
+++ b/drivers/iio/filter/admv8818.c
@@ -574,21 +574,15 @@ static int admv8818_init(struct admv8818
 	struct spi_device *spi = st->spi;
 	unsigned int chip_id;
 
-	ret = regmap_update_bits(st->regmap, ADMV8818_REG_SPI_CONFIG_A,
-				 ADMV8818_SOFTRESET_N_MSK |
-				 ADMV8818_SOFTRESET_MSK,
-				 FIELD_PREP(ADMV8818_SOFTRESET_N_MSK, 1) |
-				 FIELD_PREP(ADMV8818_SOFTRESET_MSK, 1));
+	ret = regmap_write(st->regmap, ADMV8818_REG_SPI_CONFIG_A,
+			   ADMV8818_SOFTRESET_N_MSK | ADMV8818_SOFTRESET_MSK);
 	if (ret) {
 		dev_err(&spi->dev, "ADMV8818 Soft Reset failed.\n");
 		return ret;
 	}
 
-	ret = regmap_update_bits(st->regmap, ADMV8818_REG_SPI_CONFIG_A,
-				 ADMV8818_SDOACTIVE_N_MSK |
-				 ADMV8818_SDOACTIVE_MSK,
-				 FIELD_PREP(ADMV8818_SDOACTIVE_N_MSK, 1) |
-				 FIELD_PREP(ADMV8818_SDOACTIVE_MSK, 1));
+	ret = regmap_write(st->regmap, ADMV8818_REG_SPI_CONFIG_A,
+			   ADMV8818_SDOACTIVE_N_MSK | ADMV8818_SDOACTIVE_MSK);
 	if (ret) {
 		dev_err(&spi->dev, "ADMV8818 SDO Enable failed.\n");
 		return ret;


