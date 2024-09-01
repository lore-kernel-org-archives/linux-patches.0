Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9040F16B391;
	Sun,  1 Sep 2024 16:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209442; cv=none; b=WVAEFmInYdxha+l61w+AWB40zJPsnxYNF9E3/mb9rqr0WsU48QupxBtlC7kw9+6hERUgB+YhRCOK0eojLhUGSJ3A5fFRDGeeods26fcjCccIdvcd40lLXchnwu3vvzGcQPdFYhyQdHeCkfuK1wVvpOWc7Nu7WytbdI1DFrXh/j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209442; c=relaxed/simple;
	bh=amDc0jPnxENiGHOiWzBVVHffXzou77/sCe+3IdiGBvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ta6QRi2sAOsoGK5a/58zKySPRIp4JNxG8A+YAByzQ5NtK268uyedYdax5SP2j/HQbRWj+GSj9q1PJchRwsQihzGCMPa7KA3tLbpEVf0WDLHI9WPg8xyYIVxXnKxkt8VXdPI4KvSGBy44BivrM8Cv+Swq+MON/KaRrA/jkAG58X0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RjKQXxA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RjKQXxA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17753C4CEC3;
	Sun,  1 Sep 2024 16:50:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209442;
	bh=amDc0jPnxENiGHOiWzBVVHffXzou77/sCe+3IdiGBvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RjKQXxA4GaU0PKwznhqB8w7hSrlWqyywYDLrE8DN1ibarWjg0BqQp+Pc2bZZVUFqR
	 TBu1NrHISkjcnNYNV7gZdQuI/RLihQmfW4A+ke5bCu0l3L0cVu3ts0wmHHV4dFCUhe
	 GjExthgkWjFO17VnOmS+UM+xWolm+74Np5zxDSoE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 038/151] staging: iio: resolver: ad2s1210: fix use before initialization
Date: Sun,  1 Sep 2024 18:16:38 +0200
Message-ID: <20240901160815.534627234@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



