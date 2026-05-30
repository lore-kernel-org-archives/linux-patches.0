Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1141732BF24;
	Sat, 30 May 2026 16:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780159981; cv=none; b=ZzHDVa4xDLvgbfKF2RoHJClcGqC6MRrtLqNTF1Gyylkr1yCM1elsUZ6Jg3HJQNW4FSd+WPP0kjRd5A4TBLxygyDJI8MHdgAT/XuWH/SV2xmUYFpV1rlfbym1+DUdM+5rrVrlKqB5AsN3NpykIKpaSFi8LBksrC4hjWKfwvLWi+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780159981; c=relaxed/simple;
	bh=n3BZe6eV9iSeANIPYAIWTy+VaiobGIveR+Q6StVYnQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NeNPPTu6V4YjVw1JsJv9U/ucWgwudMmYJCds/NiFXcwyD8XKiYD2Vs98Mcy+EdCi/Z+eyMmBlKI4X8U3sk5w+sQT2z9C0QAZ4eeicr1WhN6DeFSJSkmCc3S/1QJKcmBsyi/SZOpID/BvyxeSQn+8gMaEy/J2YspjgqVHu2NGzr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aB4s3gRI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aB4s3gRI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC2D1F00893;
	Sat, 30 May 2026 16:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780159979;
	bh=ysR5uUuUBvY/FciMbbLOP9xqo+4NPQrYV8296Om2aNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aB4s3gRI7Ea+Z0yXBZdET5dWPb/rF5NJy8eENfpN5DsVj+hHAQq52K1ovQlOikJx9
	 s2NAu4YkM1UJFUQhylJCDje/aI8lNMn58VkbqS9XxRrJWxlzSKlQyBHXJ71BoEkZM/
	 45X2oene7yN6RPSqzpxHMOKQUL8DZSfj35m0dvHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 212/969] iio: adc: ad7768-1: fix one-shot mode data acquisition
Date: Sat, 30 May 2026 17:55:36 +0200
Message-ID: <20260530160306.314606599@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Jonathan Santos <Jonathan.Santos@analog.com>

commit 8be19e233744961db6069da9c9ab63eb085a0447 upstream.

According to the datasheet, one-shot mode requires a SYNC_IN pulse to
trigger a new sample conversion. In the current implementation, No sync
pulse was sent after switching to one-shot mode and reinit_completion()
was called before mode switching, creating a race condition where spurious
interrupts during mode change could trigger completion prematurely.

Fix by sending a sync pulse after configuring one-shot mode and
reinit_completion() to ensure it only waits for the actual conversion
completion.

Fixes: a5f8c7da3dbe ("iio: adc: Add AD7768-1 ADC basic support")
Signed-off-by: Jonathan Santos <Jonathan.Santos@analog.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7768-1.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/iio/adc/ad7768-1.c
+++ b/drivers/iio/adc/ad7768-1.c
@@ -241,12 +241,17 @@ static int ad7768_scan_direct(struct iio
 	struct ad7768_state *st = iio_priv(indio_dev);
 	int readval, ret;
 
-	reinit_completion(&st->completion);
-
 	ret = ad7768_set_mode(st, AD7768_ONE_SHOT);
 	if (ret < 0)
 		return ret;
 
+	reinit_completion(&st->completion);
+
+	/* One-shot mode requires a SYNC pulse to generate a new sample */
+	ret = ad7768_send_sync_pulse(st);
+	if (ret)
+		return ret;
+
 	ret = wait_for_completion_timeout(&st->completion,
 					  msecs_to_jiffies(1000));
 	if (!ret)


