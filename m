Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB59E1F1534;
	Sat, 12 Sep 2026 08:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201572; cv=none; b=FXYPeegksirp9h2zZ/Ajbbiu+mrSXtdzblaev4Gazzu+5rccheJ3eyt5/09qeZPJHozbQ1SwPUAHzb9ts1m7SLSJSNTP70sdhShpzG4QFIMCJN90uyJs55UHVcFD4eOVXHbuibEwhr0BnsngGJjF6ZOsonruz6LpHKxYpPpZvEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201572; c=relaxed/simple;
	bh=9ocvAwYW2o30k42i7p2efedb32rngKGZtoj0FBf1mjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGPMKGHqB5uMnks9xRInFgw9wNlaoIYl0eofCo86Y1cA/EoiREQZLYm59zl7ww5VMH1kWNAXUlU6RC6P/dYz25GE7Eb/Y9fKImFw0dMKYhosFK1S60KZGDLFGtMpshy41AzRh87DQExABkzEQ28R8OxmsiCizbIUwj6SKeSSs0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTwPfRFG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTwPfRFG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930091F000FF;
	Sat, 12 Sep 2026 08:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201571;
	bh=QCN+ECSZ6vXkXzUHH3te0FaVJyzzEvgrKkfk0Ffjgvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zTwPfRFGT15ZUW+4JSz9vEYTWcwKf7KPECCGJMsh2cYt2gAc3j7Ct7ULNNk1xSxTK
	 ZY7wIa0tSK5ZiDiC2q8thRmAN5gqZob3lzXW6C3SSXtl2FYIYDSTdSWZmP2bPHPhdD
	 G/sOaA46Um2q79BBWVlBcEeo3xPW1tgVutZqX+nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanshen Cao <alex.caoys@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1023/1815] iio: light: tsl2772: fix ALS calibscale readback
Date: Sat, 12 Sep 2026 08:46:13 +0200
Message-ID: <20260912065713.033197485@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuanshen Cao <alex.caoys@gmail.com>

[ Upstream commit ac75550ab5b5d73649bffea245c2075fd9249bd0 ]

The read_raw() implementation uses IIO_LIGHT to distinguish between the
ambient light and proximity channels when handling
IIO_CHAN_INFO_CALIBSCALE.

However, the ALS channel is registered as IIO_INTENSITY, while
write_raw() correctly writes to IIO_INTENSITY. As a result, reading
in_intensity0_calibscale incorrectly returns the proximity gain instead
of the ALS gain.

This causes the following user-visible behavior:
- Writing in_intensity0_calibscale appears to have no effect because the
  readback reports the proximity gain.
- Writing in_proximity0_calibscale causes both in_proximity0_calibscale
  and in_intensity0_calibscale to report the same value.

Fix this by checking for IIO_INTENSITY in read_raw(), matching the
channel definition and the existing write_raw() implementation.

Fixes: 3c97c08b5735 ("staging: iio: add TAOS tsl2x7x driver")
Signed-off-by: Yuanshen Cao <alex.caoys@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/tsl2772.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/light/tsl2772.c b/drivers/iio/light/tsl2772.c
index 244f44379c369..2287585711c69 100644
--- a/drivers/iio/light/tsl2772.c
+++ b/drivers/iio/light/tsl2772.c
@@ -1274,7 +1274,7 @@ static int tsl2772_read_raw(struct iio_dev *indio_dev,
 		}
 		break;
 	case IIO_CHAN_INFO_CALIBSCALE:
-		if (chan->type == IIO_LIGHT)
+		if (chan->type == IIO_INTENSITY)
 			*val = tsl2772_als_gain[chip->settings.als_gain];
 		else
 			*val = tsl2772_prox_gain[chip->settings.prox_gain];
-- 
2.53.0



