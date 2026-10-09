Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9FE3399CE9;
	Fri,  9 Oct 2026 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557512; cv=none; b=ksG02Gh6OEPXH08CvgOkt+eQLejru0GgUBZ7yOz6LQ8CLzesaoZrZ1ypYXsA78+Xk5xLAKiKZUCZFnuRmIvqI6FHm7h9OX4fkXoGhLTDgIP3F9iS89pwNO97hix94PhIIBAksnFsxEbLXa3r306x+5PlT7P3pYhZ00vW4cpFGRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557512; c=relaxed/simple;
	bh=3sAafAo/Goo70vXklHANWBk5oJLcjqJqx6IHxcrNPZE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JljA7bKYRfcgRF6u8A+8CTZd70VEKPpCmNKFPeJTFO/YmZ9RSqFEoA0A7/T3nMvzq3wKIuVWv1lild3t3C6SEUxxgK4nxhpgXgYPIeMGba54uabCGxkHVzZOhAlwDLlvoj0XW0uW5HHuaFwr7sS1zGOJ5f3JdytDrrdw1Laca20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zwU+EIsz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zwU+EIsz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED9B1F000FF;
	Fri,  9 Oct 2026 14:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557509;
	bh=gZj2OzWi2jYgig7yTsfwA72n7bpPCEj2YjSUMA2uA6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwU+EIsz4OOSuO0qu08VvpjlW1faeITIgzNTON899siP1qQXvxUJPXIlQiffQp8sB
	 Q0Qfm4RC2D8a08/uZZOnVeHPtIauOLojR4xZczyN0wdJFW93AzQCtX3h/qIQ61iTwx
	 7eabGPTqi8/iaw34oJVYX8wLKAuJYMxfYXRnkBeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 383/428] iio: adc: max1363: sign-extend bipolar differential channel reads
Date: Fri,  9 Oct 2026 16:12:00 +0200
Message-ID: <20261009140954.607917969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

commit 91908c0a78baddc8572aa3ab69e62ee2eb496ba4 upstream.

MAX1363 differential channels are bipolar, but max1363_read_single_chan()
masks the raw value to the ADC resolution without sign-extending it.
Negative differential readings are therefore reported to userspace as
large positive values (e.g. -1 as 4095 on a 12-bit part).

Sign-extend the masked value from the resolution bit for differential
channels. Single-ended channels are unipolar and are left unchanged.

Fixes: d1325cf45077 ("Staging: IIO: max1363 ADC driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-4
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/max1363.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/iio/adc/max1363.c
+++ b/drivers/iio/adc/max1363.c
@@ -404,6 +404,14 @@ static int max1363_read_single_chan(stru
 
 		data = rxbuf[0];
 	}
+
+	/*
+	 * Differential channels are bipolar and the device returns the sample
+	 * in two's complement, so sign-extend it from the resolution bit.
+	 */
+	if (chan->differential)
+		data = sign_extend32(data, st->chip_info->bits - 1);
+
 	*val = data;
 
 	return 0;


