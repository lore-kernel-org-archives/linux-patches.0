Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322FB42CAFB;
	Tue, 21 Jul 2026 20:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664993; cv=none; b=A2iDNGSbtA2H5U5tzqTB5/2Fhsb1fB6B6v28/uTLInATm4gTokC8pUsWCOtGGwxPsIUlbaQuLU2brTjCjOf9d9EwcWgKjOs/cMNDqPQl50r+n5lHgjpZ4Vd+8tH4e4OZDReWlAViXLsQAkRNdx9gYiq/aUncf7tRGQda5OKtnCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664993; c=relaxed/simple;
	bh=KedYCEWfNmrqJNdHPj16KZ6edyz//EoPaonZJQowkac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doWGx2OLRgWqKCMyDanM4GVwXdHIF4W0fYdK4G5XZlmkfFEtHDCgoE4e181+gy6hpNCvcodKpzIOIdlOQnIfT3Z76LAyeZ7Qtm3wi0A8IKBb5dAML38E5FAFzy2Zq19iXV0zhDubWed5Yo419Ej1cW37bhut/gr9rTfsrUZ3hD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HbVS9to5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HbVS9to5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9736F1F000E9;
	Tue, 21 Jul 2026 20:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664992;
	bh=dpQVYHhHh5SzwRqoJJeGca9E6YExGBLrGrUL+drzUFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HbVS9to53qDcvYYW18iGT2xF3mVl0kfhSpiiYNe86SapBK9nn4Ai2tM4d0/Y9aLf7
	 hL+MwTHUduLdJe9KG643NL52BLPA6PW71kiL7yRhVJt192TRC8+U7nWXxUo+lfwd7y
	 t4jqRu7T0bXgJaZPktjqFR9pBxTiivwsn+lyne/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.6 0093/1266] iio: imu: inv_icm42600: fix timestamp clock period by using lower value
Date: Tue, 21 Jul 2026 17:08:50 +0200
Message-ID: <20260721152443.886774573@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>

commit 8b0b864c11a2e2ada470f9d5010e1c2bf1eceef2 upstream.

Clock period value is used for computing periods of sampling. There is
no need for it to be higher than the maximum odr, otherwise we are
losing precision in the computation for nothing.

Switch clock period value to maximum odr period (8kHz).

Fixes: 0ecc363ccea7 ("iio: make invensense timestamp module generic")
Cc: stable@vger.kernel.org
Signed-off-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c |    4 ++--
 drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c  |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_accel.c
@@ -718,10 +718,10 @@ struct iio_dev *inv_icm42600_accel_init(
 		return ERR_PTR(-ENOMEM);
 
 	/*
-	 * clock period is 32kHz (31250ns)
+	 * clock period is 8kHz (125000ns)
 	 * jitter is +/- 2% (20 per mille)
 	 */
-	ts_chip.clock_period = 31250;
+	ts_chip.clock_period = 125000;
 	ts_chip.jitter = 20;
 	ts_chip.init_period = inv_icm42600_odr_to_period(st->conf.accel.odr);
 	ts = iio_priv(indio_dev);
--- a/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
+++ b/drivers/iio/imu/inv_icm42600/inv_icm42600_gyro.c
@@ -729,10 +729,10 @@ struct iio_dev *inv_icm42600_gyro_init(s
 		return ERR_PTR(-ENOMEM);
 
 	/*
-	 * clock period is 32kHz (31250ns)
+	 * clock period is 8kHz (125000ns)
 	 * jitter is +/- 2% (20 per mille)
 	 */
-	ts_chip.clock_period = 31250;
+	ts_chip.clock_period = 125000;
 	ts_chip.jitter = 20;
 	ts_chip.init_period = inv_icm42600_odr_to_period(st->conf.accel.odr);
 	ts = iio_priv(indio_dev);


