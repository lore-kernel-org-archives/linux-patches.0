Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C273BD64B;
	Mon, 23 Mar 2026 16:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282751; cv=none; b=FfoUrY0arBIpsU7DE/zF+cBAVHjwAiDZSWSuWw4plwa2j5tZXWGMLrxC1oC8r4huPj+NW6TkJQ2MQwaVAaCXDOt1ybH++QH2msNu+Mre5cwgYd3rlhyXKMLXcMqWoTzMamEwFs7SPdjM8kjixZNbEVZXIV02htI8cEtuaiF+nDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282751; c=relaxed/simple;
	bh=PSy81XKGvG0UkrkQeHMqskJEVi7aWVCR4vBFGkc69o4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tMyJvEhQznTya3LKT5mUhL3An50fRJ8VFMdv082PtLuoIfCN7F1loU9gBdFsHlvreZyF12h/dBr8jWUXH2Aglli9436vqk9T1CaJGqPTgmCcL0PcALx22uZrriawtbbvWNl8CZRnLKVqPRQ2hBiSRRqNe7Lu9lwHIX0GTEtmZHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7LdITvd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7LdITvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45950C4CEF7;
	Mon, 23 Mar 2026 16:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282751;
	bh=PSy81XKGvG0UkrkQeHMqskJEVi7aWVCR4vBFGkc69o4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7LdITvdyJSwaRZM9tcUOYvf/P9BhMC4GKOpNVLY0XYYN8VspDYxTMvHJNJ2p4Ngg
	 cR9LxMoh8r2J35C1VBshW3ZhM5k1oAJMUQ7l3XV+VK7h+rMEFl9gzBA+uZBMNtEflo
	 XoeuL8ofw2TWr9YFB60AwkblVKFcX6VtVZOY5DZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 270/481] iio: gyro: mpu3050-core: fix pm_runtime error handling
Date: Mon, 23 Mar 2026 14:44:12 +0100
Message-ID: <20260323134531.713043747@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
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


