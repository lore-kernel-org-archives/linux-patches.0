Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BA3233145;
	Mon, 10 Mar 2025 17:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627806; cv=none; b=HcXU7PS9nk2HyIasGW27f95osdLOgiEEXwgGXtO+ZtakvAjgUYdjBzS8s87kjQ6RUzqe7o328pVah3bKmwa5kRcXj1i8rM1nhYqCRSr/w8v38E3XMfXgfMZEQMe9q0ZQFKtZvRylfE7wumq8HIQdn2lmURokDvTaWeLfhrfSlSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627806; c=relaxed/simple;
	bh=KPMo/zi66tQnE2BRIY9sze22+u1FRAMtcHNUDIAGLZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RxBHUTnfJgG1n0C9OmS7yVMzV9DoA/Lym3jAmvXoChQGarwqa0BAHWt9+lcjH59iCH8uwc8aZG3XeyEsen7nmYC2W/s8UZ1oVfF9e+cR82PhVEqnOvZHffXYXYnpXlzXJBjKZsVTM4j3IamLPoCCzLHj/+DDqLeBCp6j/QJJoxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zd5igt7S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zd5igt7S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B25BC4CEE5;
	Mon, 10 Mar 2025 17:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627806;
	bh=KPMo/zi66tQnE2BRIY9sze22+u1FRAMtcHNUDIAGLZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zd5igt7S53MznAce4KRZ9gj1QVoH4brbyLdvu5wn2jrttXqdHnCKy186TPtsvN/Q/
	 fQtFd8/Q5cqzBU/MULXmLngplG4tXfIYU2SB3L0fw118zFA8+RtTN1YRxQ4lOwVb+4
	 vo5VvlZ6pcQEjHnRoSQ5Psp0eez8m8OcTwvYZp3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Winchenbach <swinchenbach@arka.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 249/269] iio: filter: admv8818: Force initialization of SDO
Date: Mon, 10 Mar 2025 18:06:42 +0100
Message-ID: <20250310170507.722846014@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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


