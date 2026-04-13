Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F23E223DCE;
	Mon, 13 Apr 2026 16:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776098900; cv=none; b=liLoWIpZrvxnySoSHrt51/mjUPZile60Z/bTNAHD2v4mZjjmphVw0tTU74vTycrm12LwFYcO84cU4OzE/v5k6+Ubw7Ba13zmGgt8JWlQxbtMQOucC6C72NeNhsYi+P0dzVSQdeL/MoJ/cw/bANuk4eRrdk1TGmo1p1sBoyWft9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776098900; c=relaxed/simple;
	bh=NXpAc8G0uav4b7Ai+M0t6h7eOjsQq16NpQtAoMMcUWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/ZXAeoACZuiwPB35aFIjcWWzsvp+9dxZQReGQAsvBaVltEdgGvUYZ0lzMPlpwqEHW7SOFGsute3942mZlWrGBGStHUE9SHXhYmptL61+zjxAL50Mds0Qx1QGjySEAyVNhSj3ntE214qb9oDnXyhWX/thFSgm51uX2nRdEcd2mg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYoUA4dM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYoUA4dM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9B85C2BCAF;
	Mon, 13 Apr 2026 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776098900;
	bh=NXpAc8G0uav4b7Ai+M0t6h7eOjsQq16NpQtAoMMcUWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JYoUA4dMvekZncJswKS1ELsoRlaxjUotSR1KtK3FzCxdOMRoCDji3ba6ZGaorG+uA
	 qqEyoysTWWTSGK1g0/06/4NgO+ANOopyxlBh+5liXl7gCGUmf3t2xxNjQzZ/rWxThp
	 6OeRaFPcInU4dIJsvKsl67mW031D12U4vqXRATEg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 132/491] iio: gyro: mpu3050-core: fix pm_runtime error handling
Date: Mon, 13 Apr 2026 17:56:17 +0200
Message-ID: <20260413155823.984241815@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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
@@ -320,7 +320,9 @@ static int mpu3050_read_raw(struct iio_d
 		}
 	case IIO_CHAN_INFO_RAW:
 		/* Resume device */
-		pm_runtime_get_sync(mpu3050->dev);
+		ret = pm_runtime_resume_and_get(mpu3050->dev);
+		if (ret)
+			return ret;
 		mutex_lock(&mpu3050->lock);
 
 		ret = mpu3050_set_8khz_samplerate(mpu3050);
@@ -651,14 +653,20 @@ out_trigger_unlock:
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


