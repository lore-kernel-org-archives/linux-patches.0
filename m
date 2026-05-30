Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 505933C199A;
	Sat, 30 May 2026 18:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780165746; cv=none; b=bJ3ww2pMDcITZnhAcdv/Y8TBD4YmXx4bSSB4zmpj4mKWp7LIzNz9FFJWmuvCBI/a5nT/nwFsRujEcLPAEm3XARtsYgbL/c/6ZF+tM3xIgrza2Pqi2d5WQQSjDCrjAzMbfHjyWLFU+b6nh2tDDjhsfECBZWYILG1xEBewaFuwn2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780165746; c=relaxed/simple;
	bh=DoL4vBzjmntB4W2d6xOmahgPoT5zUNuxXxrmMGa5Ui4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBQOjE3rdLMs2BxrRjQ1PIJhfxcqB5uisGWl8y3yObFU0iKha4s0qmwNHK0jRKHFBlNLUytJprWNuFNisdqwViO51zTus16boAYnD5O7vdJ/E9TOBFeOobk+MGmg8XQK9iL49q2nFLUFQiSWuu2KEmfLRGUAHJjSs+Uhw2a9iJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rcNZXHTJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rcNZXHTJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA181F00893;
	Sat, 30 May 2026 18:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780165745;
	bh=GUYrA0AOhxRkDdUM452xpNvrM9Ar6BIxRpa3Ft9QVkA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rcNZXHTJz6TrYgnTDEpvzT8GILi+FQZgyea0lIf2RzutaSG/phte8Un/RHF49nTGk
	 R2VDnH6OlHTQNFz1CMtQR4k+vcRgkYoiqRTidiHo4k3dKrj/pTmkWnvWlEzc1hIiS7
	 IJcXquURseg786XxI6svXVFLELX50l9Q0LZWIw+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Santos <Jonathan.Santos@analog.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 168/589] iio: adc: ad7768-1: fix one-shot mode data acquisition
Date: Sat, 30 May 2026 18:00:49 +0200
Message-ID: <20260530160229.208659539@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
@@ -240,12 +240,17 @@ static int ad7768_scan_direct(struct iio
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


