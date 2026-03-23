Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787EE1FFC48;
	Mon, 23 Mar 2026 14:22:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275762; cv=none; b=Y6b5BdD6jeReq6+g0Ch/notQcRxEumW02dXNgqgCrCPWH816Vm+3/8t//uHbmRP/NUxOlO3OOFl+h+b8BDLykm36LAag1tmnLanDaevXmksl7L2Wkn8qBtMSegVsK1ObVY2F7FCGyMluoeaHaVZrult+uuGlVcva+OyPAAURey4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275762; c=relaxed/simple;
	bh=yFMXBRcDVDw9G1z8b4lHqLW8/Am9IWI7f2Wi8cSOMsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OAlAc4qNee9PqXD5Q/R561bDGYTHrcx63t46OHB7Yod3GchU4kKsNUrfKVytHHenkX/meAD3H/OysXNLkTEDqjllcjKlFjUovGaB8/NHH4dixLbSt/4C0J8u/ue03ECnqO3vdsCvuEqR9MMBbFgyGTnN3F67j0xmj/tCB7oJ/n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGYUyBwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGYUyBwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3950C4CEF7;
	Mon, 23 Mar 2026 14:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275762;
	bh=yFMXBRcDVDw9G1z8b4lHqLW8/Am9IWI7f2Wi8cSOMsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGYUyBwGD0LzVyKf6XGbKoLXeLxr+dVatmPudpxQvznwnDdclJSSsLanDPuwGzWUu
	 aEN7ZQt06s4TPMM+wSwl2mFngaiAY3dQKmKFZoXg1CFdmQJeo9sXkR9B4okRyG3XtE
	 OPZJxjfP2KJ8J1v8RynUSxTWhi7IVE8vRjRNUdNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 210/460] iio: gyro: mpu3050-core: fix pm_runtime error handling
Date: Mon, 23 Mar 2026 14:43:26 +0100
Message-ID: <20260323134531.679139155@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

commit acc3949aab3e8094641a9c7c2768de1958c88378 upstream.

The return value of pm_runtime_get_sync() is not checked, allowing
the driver to access hardware that may fail to resume. The device
usage count is also unconditionally incremented. Use
pm_runtime_resume_and_get() which propagates errors and avoids
incrementing the usage count on failure.

In preenable, add pm_runtime_put_autosuspend() on set_8khz_samplerate()
failure since postdisable does not run when preenable fails.

Fixes: 3904b28efb2c ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Reviewed-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/gyro/mpu3050-core.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -322,7 +322,9 @@ static int mpu3050_read_raw(struct iio_d
 		}
 	case IIO_CHAN_INFO_RAW:
 		/* Resume device */
-		pm_runtime_get_sync(mpu3050->dev);
+		ret = pm_runtime_resume_and_get(mpu3050->dev);
+		if (ret)
+			return ret;
 		mutex_lock(&mpu3050->lock);
 
 		ret = mpu3050_set_8khz_samplerate(mpu3050);
@@ -648,14 +650,20 @@ out_trigger_unlock:
 static int mpu3050_buffer_preenable(struct iio_dev *indio_dev)
 {
 	struct mpu3050 *mpu3050 = iio_priv(indio_dev);
+	int ret;
 
-	pm_runtime_get_sync(mpu3050->dev);
+	ret = pm_runtime_resume_and_get(mpu3050->dev);
+	if (ret)
+		return ret;
 
 	/* Unless we have OUR trigger active, run at full speed */
-	if (!mpu3050->hw_irq_trigger)
-		return mpu3050_set_8khz_samplerate(mpu3050);
+	if (!mpu3050->hw_irq_trigger) {
+		ret = mpu3050_set_8khz_samplerate(mpu3050);
+		if (ret)
+			pm_runtime_put_autosuspend(mpu3050->dev);
+	}
 
-	return 0;
+	return ret;
 }
 
 static int mpu3050_buffer_postdisable(struct iio_dev *indio_dev)


