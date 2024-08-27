Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBFA1A072D;
	Tue, 27 Aug 2024 14:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770036; cv=none; b=qd9qqFrzVmhad+ZfI1sSMuZs3M4xbV5aa2s31fv/pv9JCbjnTNrFWQO+0Z25InUDPARm0CYimARvAyKNQjFLUKcE+niFLZqZ8gwvetMYCbYD9/e+UlnKQIX3uowk7Zv1v8d2YWdOhsuagYL1Ebk9tECmREJYIGMUZmTYSXtGv5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770036; c=relaxed/simple;
	bh=TtZGVnd0c5S3ScyYyC499UDRCHul+OF9eGQFUOpYV/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RUY2/tej1CCvOmvhtuBMp8JQ8X+dGc5qTgSILcz0g4Tr3QGscmiPeZvBI66ilHAtKSe/k+srpRnyM9I/XSB9YfmOJrvbzDf/GOvwR26ENUpvYh6+Y3+wsyF1W6EgfIWMamui822/BbTc6/9txh14bcTZny/UjYQz6YsKcyJk4Oc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z2l0IGNo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z2l0IGNo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F9E9C4AF12;
	Tue, 27 Aug 2024 14:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770036;
	bh=TtZGVnd0c5S3ScyYyC499UDRCHul+OF9eGQFUOpYV/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z2l0IGNoaKwcH7pLd0sczgc5nG1mumZbidR8NlndOeFJwTyUp2AeyYk9PvnFq9gXg
	 DHIsblj3vseq5fGq64qDqEv+6/wxnrPsf9VOtX30uyi7tKr5a/hVqPM9T3g31UvIu3
	 5qgCBIQIYWudR1B7Os1sXx2QZwxv9bNSc9eTBxew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 108/341] staging: iio: resolver: ad2s1210: fix use before initialization
Date: Tue, 27 Aug 2024 16:35:39 +0200
Message-ID: <20240827143847.520779660@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index 06de5823eb8e3..d38c4674cd6d7 100644
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



