Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C43817C96;
	Tue, 27 Aug 2024 15:22:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772147; cv=none; b=qBNUlN5j0+Z/E6v8h9Kamn9IE6JzrYbBIBBFbcHusDaU7il4arwxIGizUG6bqisdNEcVdyotCXlwk9gfuCuzv8MR6u6IaieNWQp0ms6SQkDeb+mL0dqRQXmxcTivN2ib4T1bZaHcuPQ9SwWVqGhFTce88xe1TnnqD5gZgr+Fk7o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772147; c=relaxed/simple;
	bh=UqzBvJruT0QSET6LHNQOsvcwzr7Mqhh+MU9VIyGDN4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ps1QGGVU9HrR9RRUq9k1ST4qo57O84FBHGsoKtFCLYOeNeW93SY9MitlAcrJnFJ/pVojw+FNywzHa1WBKg4SmW10o6E4cd5ONkItUeltiZpOv/SKfFg7ZwW5oV/oEs/D7V/ghCZTu0WEFq9kCHUuP7OdjHGkR4hoo6NIFy1NSRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cs1lmyEg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cs1lmyEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BAFDC61041;
	Tue, 27 Aug 2024 15:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772147;
	bh=UqzBvJruT0QSET6LHNQOsvcwzr7Mqhh+MU9VIyGDN4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cs1lmyEgc0ImMiFJfSXkYPljc5CZUoadyNt0f0FnByfdBz9oFEQWZpfMKkH9Qbegn
	 xiSO3nW/cpGnKoNiASJk10IcKw7isCK1Ulp4ZhSdou8PYjA+f1uSyO0fptMzwqvkzi
	 CB8J4RxMSdCCJ/OmlAGIG3QDMio0B5qgQM0S2mKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 127/321] staging: iio: resolver: ad2s1210: fix use before initialization
Date: Tue, 27 Aug 2024 16:37:15 +0200
Message-ID: <20240827143843.078635046@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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
index 636c45b128438..afe89c91c89ea 100644
--- a/drivers/staging/iio/resolver/ad2s1210.c
+++ b/drivers/staging/iio/resolver/ad2s1210.c
@@ -657,9 +657,6 @@ static int ad2s1210_probe(struct spi_device *spi)
 	if (!indio_dev)
 		return -ENOMEM;
 	st = iio_priv(indio_dev);
-	ret = ad2s1210_setup_gpios(st);
-	if (ret < 0)
-		return ret;
 
 	spi_set_drvdata(spi, indio_dev);
 
@@ -670,6 +667,10 @@ static int ad2s1210_probe(struct spi_device *spi)
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



