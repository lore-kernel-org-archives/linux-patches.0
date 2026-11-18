Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038066;
	b=SChyqSlCNcpmkV0C0liig7K6HaNMxL9DX1OX6x6GzF2VGeLqlT4W4G0ib+EJSKyOgrEe
	 SGSpcZbZZl9cB1/GV60jw+KBOdm8Hls4CKopnlK+n8vtlquzSaH9felrzwv2CVUPT/bek
	 y+fQNEUtewKrr+gsI2PKUj2CDXwcoJKsl5lvm5l4eF5xbC8NfpNZzGr9cmZ9q+HdN+5On
	 k6aWmWqfE4fAboWbSnlJK9QVtPi0sH/jLa/iymiC5vgBI4ZqO1XXhsT/5iXPNE++mz2wq
	 S1zX00R761u2XQEfL45IV6WTD3YcE9wcp3RjbkWoI8eF79K0fBxZT8Vxt5QwLAOiPLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TywRFB3PhHco/SaoGz0/3mwOPH7q39GInD4k7KQg+x0=;
	b=0/qhIoKliUMIcB0Nn0CSosKjPtiaFeMvQrS9Z/a0ZM/XnlxzOBa+EAM1mir2UKiZo6y4
	 pIuYfhufKl3G44iDx56sTza1zd+arf8Yi0NOM4qIEepGX+FgnK8XM5f6FCCMDy8M/ruk1
	 4w0wUjZSIPRJJIeA7NnYF+qTH82PPPX+GtCTHjxGw9JYIZB/NoGsvtoUPH55x5EwWJ4dk
	 5yOArHD8F8xD9v1gEMh5N74VJ8vr99Xaz7LyyCp5TG4a9b0QD6cNM+snksHp4bBJSik1D
	 tPAgkxJoKK/BUW2DMAYJ3fmLX7Gf+Q5Q5Worxo5uUllyZcqICQM4k+CteNkj3Xxyktw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVXhIghm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44AFE606A325;
	Wed, 18 Nov 2026 21:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVXhIghm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC751F000C4;
	Wed, 18 Nov 2026 21:41:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038066;
	bh=TywRFB3PhHco/SaoGz0/3mwOPH7q39GInD4k7KQg+x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVXhIghmpOWoYXtkoIUfL5GU2vw9NvvCQZYdYtgG/bEPVdNbyl99t8dgCHDKurtEB
	 vj6bFy7gdrRKlewf2jVj5haVxY6+TsBc7PfSLJ+mvjFX2YxbEUk0H6gxQ1cHJjvFTK
	 D6J5J03glSttNa5xKbUn7erJlD3bLCqXHxUCm4QI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Fabio Cesari <fabio.cesari@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1615/3318] iio: light: isl29028: fix runtime PM reference leak on error paths
Date: Wed, 18 Nov 2026 15:37:17 +0100
Message-ID: <20261118150409.640241276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabio Cesari <fabio.cesari@gmail.com>

[ Upstream commit 0e30d15b15647df786e60022650613e16dd70645 ]

isl29028_read_raw() and isl29028_write_raw() take a runtime PM reference
with pm_runtime_resume_and_get() but return directly on their error
paths without dropping it. The usage count never balances again and the
device stops entering autosuspend for good. In isl29028_read_raw() this
needs a regmap access to fail; in isl29028_write_raw() one rejected
sysfs write is enough, for example

  echo 200 > in_proximity_sampling_frequency

which is outside the [1:100] range and returns -EINVAL with the
reference still held.

Take the reference with PM_RUNTIME_ACQUIRE_AUTOSUSPEND() instead, so it
is released on every return path.

This also stops the return value of pm_runtime_put_autosuspend() from
reaching userspace. That value only says whether the device could be
suspended right away, so -EAGAIN or -EPERM turns a successful access
into a failure, and with CONFIG_PM=n the stub returns -ENOSYS on every
access.

Fixes: 2db5054ac28d ("staging: iio: isl29028: add runtime power management support")
Suggested-by: Joshua Crofts <joshua.crofts1@gmail.com>
Cc: stable@vger.kernel.org
Assisted-by: LLM coccinelle
Signed-off-by: Fabio Cesari <fabio.cesari@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
[ sashal: replaced scoped runtime PM guards with explicit isl29028_set_pm_runtime_busy() calls ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/isl29028.c | 23 ++++-------------------
 1 file changed, 4 insertions(+), 19 deletions(-)

diff --git a/drivers/iio/light/isl29028.c b/drivers/iio/light/isl29028.c
index 90099e467b707..15b4cd3555434 100644
--- a/drivers/iio/light/isl29028.c
+++ b/drivers/iio/light/isl29028.c
@@ -407,14 +407,9 @@ static int isl29028_write_raw(struct iio_dev *indio_dev,
 
 	mutex_unlock(&chip->lock);
 
-	if (ret < 0)
-		return ret;
+	isl29028_set_pm_runtime_busy(chip, false);
 
-	ret = isl29028_set_pm_runtime_busy(chip, false);
-	if (ret < 0)
-		return ret;
-
-	return 0;
+	return ret;
 }
 
 static int isl29028_read_raw(struct iio_dev *indio_dev,
@@ -423,7 +418,7 @@ static int isl29028_read_raw(struct iio_dev *indio_dev,
 {
 	struct isl29028_chip *chip = iio_priv(indio_dev);
 	struct device *dev = regmap_get_device(chip->regmap);
-	int ret, pm_ret;
+	int ret;
 
 	ret = isl29028_set_pm_runtime_busy(chip, true);
 	if (ret < 0)
@@ -476,17 +471,7 @@ static int isl29028_read_raw(struct iio_dev *indio_dev,
 
 	mutex_unlock(&chip->lock);
 
-	if (ret < 0)
-		return ret;
-
-	/**
-	 * Preserve the ret variable if the call to
-	 * isl29028_set_pm_runtime_busy() is successful so the reading
-	 * (if applicable) is returned to user space.
-	 */
-	pm_ret = isl29028_set_pm_runtime_busy(chip, false);
-	if (pm_ret < 0)
-		return pm_ret;
+	isl29028_set_pm_runtime_busy(chip, false);
 
 	return ret;
 }
-- 
2.53.0



