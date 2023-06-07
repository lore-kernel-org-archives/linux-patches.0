Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4971D34CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 21:01:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE31C433EF;
	Wed,  7 Jun 2023 21:01:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171671;
	bh=Esxmlrmc9mh1QxrQ71GoTLvnPfROd8lQzGYmqxLlYeY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xUuye0zdWgB1FZYfDqfyDLLVNzGLmjE4qTECgrDBWO08LWiC0vL6yFAiayO9CWf0U
	 t4kFUFc6wWFkZusuNZSX1R98JfRVVfGXLCiUgwOwhv9XkDed37K5nKtvobIAkSFaK0
	 JuoflyaxGOpNXtbC0I9rTkzv9favAGq9V5RkEb8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Cercueil <paul@crapouillou.net>,
	Alisa Roman <alisa.roman@analog.com>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 106/159] iio: adc: ad7192: Change "shorted" channels to differential
Date: Wed,  7 Jun 2023 22:16:49 +0200
Message-ID: <20230607200907.148743630@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Cercueil <paul@crapouillou.net>

commit e55245d115bb9054cb72cdd5dda5660f4484873a upstream.

The AD7192 provides a specific channel configuration where both negative
and positive inputs are connected to AIN2. This was represented in the
ad7192 driver as a IIO channel with .channel = 2 and .extended_name set
to "shorted".

The problem with this approach, is that the driver provided two IIO
channels with the identifier .channel = 2; one "shorted" and the other
not. This goes against the IIO ABI, as a channel identifier should be
unique.

Address this issue by changing "shorted" channels to being differential
instead, with channel 2 vs. itself, as we're actually measuring AIN2 vs.
itself.

Note that the fix tag is for the commit that moved the driver out of
staging. The bug existed before that, but backporting would become very
complex further down and unlikely to happen.

Fixes: b581f748cce0 ("staging: iio: adc: ad7192: move out of staging")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Co-developed-by: Alisa Roman <alisa.roman@analog.com>
Signed-off-by: Alisa Roman <alisa.roman@analog.com>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20230330102100.17590-1-paul@crapouillou.net
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7192.c |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

--- a/drivers/iio/adc/ad7192.c
+++ b/drivers/iio/adc/ad7192.c
@@ -835,10 +835,6 @@ static const struct iio_info ad7195_info
 	__AD719x_CHANNEL(_si, _channel1, -1, _address, NULL, IIO_VOLTAGE, \
 		BIT(IIO_CHAN_INFO_SCALE), ad7192_calibsys_ext_info)
 
-#define AD719x_SHORTED_CHANNEL(_si, _channel1, _address) \
-	__AD719x_CHANNEL(_si, _channel1, -1, _address, "shorted", IIO_VOLTAGE, \
-		BIT(IIO_CHAN_INFO_SCALE), ad7192_calibsys_ext_info)
-
 #define AD719x_TEMP_CHANNEL(_si, _address) \
 	__AD719x_CHANNEL(_si, 0, -1, _address, NULL, IIO_TEMP, 0, NULL)
 
@@ -846,7 +842,7 @@ static const struct iio_chan_spec ad7192
 	AD719x_DIFF_CHANNEL(0, 1, 2, AD7192_CH_AIN1P_AIN2M),
 	AD719x_DIFF_CHANNEL(1, 3, 4, AD7192_CH_AIN3P_AIN4M),
 	AD719x_TEMP_CHANNEL(2, AD7192_CH_TEMP),
-	AD719x_SHORTED_CHANNEL(3, 2, AD7192_CH_AIN2P_AIN2M),
+	AD719x_DIFF_CHANNEL(3, 2, 2, AD7192_CH_AIN2P_AIN2M),
 	AD719x_CHANNEL(4, 1, AD7192_CH_AIN1),
 	AD719x_CHANNEL(5, 2, AD7192_CH_AIN2),
 	AD719x_CHANNEL(6, 3, AD7192_CH_AIN3),
@@ -860,7 +856,7 @@ static const struct iio_chan_spec ad7193
 	AD719x_DIFF_CHANNEL(2, 5, 6, AD7193_CH_AIN5P_AIN6M),
 	AD719x_DIFF_CHANNEL(3, 7, 8, AD7193_CH_AIN7P_AIN8M),
 	AD719x_TEMP_CHANNEL(4, AD7193_CH_TEMP),
-	AD719x_SHORTED_CHANNEL(5, 2, AD7193_CH_AIN2P_AIN2M),
+	AD719x_DIFF_CHANNEL(5, 2, 2, AD7193_CH_AIN2P_AIN2M),
 	AD719x_CHANNEL(6, 1, AD7193_CH_AIN1),
 	AD719x_CHANNEL(7, 2, AD7193_CH_AIN2),
 	AD719x_CHANNEL(8, 3, AD7193_CH_AIN3),


