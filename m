Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD7B39150A;
	Sat, 12 Sep 2026 19:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242975; cv=none; b=JTLIbKHXUcZy6vCS4gi2U0vVVNaeoBV6hKrmumRuQruFtaQ0iRCh9YF7X6F3cMLUphQ3zqRWMvk3U9QUNLrU4/by0a9TlC0T3/FgjDl8rtdH+ERK/aP5bULO8nLVSPpVaZ6yLgVMtJRidEG9RM6RoNUtBBIcglwkGUG0BtfBx0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242975; c=relaxed/simple;
	bh=DIHyp59ghazO9rKI46Lz0OTVsdnld1dtj0hI6wtOTd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=degjWgXX6799Icemb7IHrZmKB2VVIq9s4YBibP4OqzuJW0aOnzpfnnN0SWpQZYT7132g4pPa6He0163R6hjLP7yRrBZTaQkfVuTZVm6ckQ8eI0L2/rfwZWK22GrHStRE0Vx+SnUb7lRtTvc75ODq8Y+BSOrbeUgoJgm49lLV2Z4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=txOKC4m0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="txOKC4m0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D27081F0089A;
	Sat, 12 Sep 2026 19:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242970;
	bh=U4XCxmutKoDe7ZKB3f6IgG8ptAqZ2x942ONdKQjszXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=txOKC4m0rndAkWX8K53WZLq0t3WQJq6ujWV/+7WbwYE0B3ILhPinZ+u6WAcMdO8dc
	 wNwZStKrMdybxZYiVqWaTao0A2BhhaGc3VeQMgztpGJA/lZ4LzZKV0XlTq4av5UhGL
	 Z+Z/J9f39JZXBIlw/imMXxOtZXMqCuzfWqua8Rog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuanshen Cao <alex.caoys@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 590/798] iio: light: tsl2772: fix ALS calibscale readback
Date: Sat, 12 Sep 2026 09:03:38 +0200
Message-ID: <20260912065530.646595484@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ff33ad3714206..b4eb756631735 100644
--- a/drivers/iio/light/tsl2772.c
+++ b/drivers/iio/light/tsl2772.c
@@ -1268,7 +1268,7 @@ static int tsl2772_read_raw(struct iio_dev *indio_dev,
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



