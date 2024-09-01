Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54BC817E00C;
	Sun,  1 Sep 2024 16:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209987; cv=none; b=rxhQtHvyrb/uzd5xg6gL06dRVFCPN8cInHP+09hXg/Vnnrnv592GU/VUx+cuYAm6VY2nyQ1kiT/R4D1Rb5FpKtAzxIKw6rpzV6gOcFS3rx3BXjbIjBY+kCGrtBQjaWebrKAlRbaXSmoaYAb1xBVp+acV9xUlFvJSKzxmS9z8fo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209987; c=relaxed/simple;
	bh=4a3Y+h+qSB+2W+3itSursoWQT+I9tbDhRHfMfmJBB6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnhCDyjhKRhFZpmoWze3EGQpTJ4WBBEe1S/xspTf8yAZdb8z72P0SjYN34+C6rS2jK5H/Ja6AmyZLs9i59n9ZfNs8q8DLeJASY2i2FrzXxJ1gg0gq8Wxh+Zj8Y+J6I6cemSLCtUQA9ujNkZ5fopwsGW0Sx28ahR/Iehg7+4UASI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A6vml63h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A6vml63h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADD4C4CEC3;
	Sun,  1 Sep 2024 16:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209987;
	bh=4a3Y+h+qSB+2W+3itSursoWQT+I9tbDhRHfMfmJBB6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A6vml63hUFeQa1U93lTVOoX9X7dIMGQ6hrw64uTOyr7zLbNwrP6dBmf8MYQUIZ+B1
	 O2jJieaKYGib74v5cqzPE6e1NfJYJVCxV8Fr4VKBDDYcwFWhUc1l0nxGZC3jFigTX5
	 NIqlBm6HPqRQbWDGsrpLB+pg89m9p77Xb/vi0bUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/215] staging: iio: resolver: ad2s1210: fix use before initialization
Date: Sun,  1 Sep 2024 18:16:05 +0200
Message-ID: <20240901160825.356813166@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit 7fe2d05cee46b1c4d9f1efaeab08cc31a0dfff60 ]

This fixes a use before initialization in ad2s1210_probe(). The
ad2s1210_setup_gpios() function uses st->sdev but it was being called
before this field was initialized.

Signed-off-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20230929-ad2s1210-mainline-v3-2-fa4364281745@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/resolver/ad2s1210.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/iio/resolver/ad2s1210.c b/drivers/staging/iio/resolver/ad2s1210.c
index a19cfb2998c93..f19bb5c796cf7 100644
--- a/drivers/staging/iio/resolver/ad2s1210.c
+++ b/drivers/staging/iio/resolver/ad2s1210.c
@@ -658,9 +658,6 @@ static int ad2s1210_probe(struct spi_device *spi)
 	if (!indio_dev)
 		return -ENOMEM;
 	st = iio_priv(indio_dev);
-	ret = ad2s1210_setup_gpios(st);
-	if (ret < 0)
-		return ret;
 
 	spi_set_drvdata(spi, indio_dev);
 
@@ -671,6 +668,10 @@ static int ad2s1210_probe(struct spi_device *spi)
 	st->resolution = 12;
 	st->fexcit = AD2S1210_DEF_EXCIT;
 
+	ret = ad2s1210_setup_gpios(st);
+	if (ret < 0)
+		return ret;
+
 	indio_dev->info = &ad2s1210_info;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->channels = ad2s1210_channels;
-- 
2.43.0



