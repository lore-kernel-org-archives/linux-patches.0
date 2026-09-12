Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EAC47988C;
	Sat, 12 Sep 2026 16:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230699; cv=none; b=FQWjco34QqYSU0Tj7P6LcJdllkoFOgBUhyxYRVXmvP+0sJs7xjlQZ7HtZDaOdCghvnAAzTPfme6GD8NMCo9FyfF+HEvuIicUwuH58DvqFdR7bMkq+wwlY0hnk88YWcqIe8x2Zp42hTklIr2s3Hl+8g7M/ljYcOnTnCAmQG71o5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230699; c=relaxed/simple;
	bh=UvFeAxhDZPKPQiaUCq7jkODKUILgD4xjFukAC3LDCvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/tur9DCeQjEt/kBIiT0/zXv16G6p7cMNMdZFXLEcIa5Hz5sms5/aHUWjxwi7aW/gQKJF+hDieyni3wTxqoJSUKenioFjXNEEfTjx2LXd3SBoNSghwAUA6sdIbwkSu/RrAQPxx3xFgv8CMRGuBN8QGwEumwkpy1dVtHBKf8xal0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iEMzK1a6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iEMzK1a6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC6E1F000FF;
	Sat, 12 Sep 2026 16:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230697;
	bh=l9/WnvzkZ87SdLrYWepebVSHhDQttyiMshXivY4JAPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iEMzK1a6Wj8VRLUOwHcDIIBEEDyA7upYDHjUohRY875ebKycUBK6l9arngrZlPDpX
	 VvhZ6SzX2+fIjfhCecF5WZXW1UXCmt7Hs9aX3AIGU63TnL4qu0t1dzklFy58qPrdVE
	 sBBb5k6SfO9LO3ogqXR3tvIk+dKOGSzLnSYrlLUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanshen Cao <alex.caoys@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0847/1191] iio: light: tsl2772: fix ALS calibscale readback
Date: Sat, 12 Sep 2026 08:59:35 +0200
Message-ID: <20260912065607.281356591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 13a6c3d078616..ed554927c6c30 100644
--- a/drivers/iio/light/tsl2772.c
+++ b/drivers/iio/light/tsl2772.c
@@ -1263,7 +1263,7 @@ static int tsl2772_read_raw(struct iio_dev *indio_dev,
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



