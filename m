Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B99422550;
	Thu, 16 Jul 2026 13:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209065; cv=none; b=A8lgmaT8K1ZLNbH4/Q8dW3IZKGOk9ZpeRxmOLcdFVkKnfi4wmKHOLsm1nZqzFygNUCJ9buDtohs3Wo8jCj1FKO7IZDT4Md482nveckzT8xlWnkfzIqCSup8Hi/Q73IDICWv5726TCYa/kg2Eq6+Opy4ASctfJIni0ULouimcOMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209065; c=relaxed/simple;
	bh=mYAcivXiQOFuVtaPNHGQYL9uO0Ox8tzTxZuDYDNayRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvANMD1yXcW5W5hZC0crsG45qF2Ncf3nfi6F8L43yWxUik9wwxjIqIE/W4PulsmH8ZVKtIzXSzsCu5S+h87vUy8fnS+fHo4g+/pHV+I2lAxJYpLs7joDDS4+/2xv8MU9CiEfRZ0zO6vlrsk1Q/tNj36RAjv+oqRSBvL8tn6sW3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5wimzm1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5wimzm1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02EB1F000E9;
	Thu, 16 Jul 2026 13:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209063;
	bh=Hqvq6Njh2ybPJEBKGAgm8oKaYb1OubBPu3YOLX2Pao4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l5wimzm1OYsecqcs/5hS5Q/9kKJ9H8ceFJZHbp/RAccbRT2lDMUAnby0U3ieawneO
	 RLS/GsaT5KalPHuigAVMuBPrb+wtz/C+l6swA+/RvMHwU+4EnxH9KGGclgWcxyc1Hs
	 UTXSfWiAMSE9nNjoUGbxEo18BD20oGcslQLJvVMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 044/518] iio: adc: ti-ads1119: fix PM reference leak in buffer preenable
Date: Thu, 16 Jul 2026 15:25:12 +0200
Message-ID: <20260716133048.746945240@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guangshuo Li <lgs201920130244@gmail.com>

commit adf4bc07f814da8329278d32600147f5a150938c upstream.

ads1119_triggered_buffer_preenable() resumes the device with
pm_runtime_resume_and_get() before starting a conversion.

If i2c_smbus_write_byte() fails, the function returns the error directly
and leaves the runtime PM usage counter elevated. The matching
postdisable callback is not called when preenable fails, so the reference
is leaked and the device may remain runtime-active indefinitely.

Store the I2C transfer result in ret and drop the runtime PM reference on
failure before returning the error.

Fixes: a9306887eba41 ("iio: adc: ti-ads1119: Add driver")
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads1119.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-ads1119.c
+++ b/drivers/iio/adc/ti-ads1119.c
@@ -459,7 +459,11 @@ static int ads1119_triggered_buffer_pree
 	if (ret)
 		return ret;
 
-	return i2c_smbus_write_byte(st->client, ADS1119_CMD_START_SYNC);
+	ret = i2c_smbus_write_byte(st->client, ADS1119_CMD_START_SYNC);
+	if (ret)
+		pm_runtime_put_autosuspend(dev);
+
+	return ret;
 }
 
 static int ads1119_triggered_buffer_postdisable(struct iio_dev *indio_dev)


