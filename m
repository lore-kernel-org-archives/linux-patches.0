Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F82248BA0;
	Wed, 15 Jan 2025 10:42:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937756; cv=none; b=Fo9I9DZoH3GiRMr16Lw7Blg5uPBRrdrFPOyi2zuSkXogkbwlV0SbmbUbQyPRfBL759ITYMOs/ZZXz4zPdNDg+D+7lUdcnE4beD7o+I7fN45k85cwdE7tMqil3RWHxD3IrF9aeeYKqEfVFhzWkDSQIOOjhlJktz5NYKFqRiVBwkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937756; c=relaxed/simple;
	bh=/JkeAwBa0FInAiQHPvNoQfXQ1bVTJvyDMQftg2kFiX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/QtD430X2Vm1M2JyvCjLpSHWUyz0hbnqVDzvrz7FUtixBbc/P/8dzt7/+NHD3CcghZB9tDOcD5MNnGgwoMCSZOOE2xDIUuLbQYBHoqD0bvy4lyGva5y8A/WImRsJYmozHiBDDWGvhEGoL/z0CeKLm3pW2hdsg53YfQ7AFn2eMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VvzDa6ob; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VvzDa6ob"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCDBCC4CEDF;
	Wed, 15 Jan 2025 10:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937756;
	bh=/JkeAwBa0FInAiQHPvNoQfXQ1bVTJvyDMQftg2kFiX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VvzDa6obOtwxqmkUOcJ4fTl5mwM8TKyPz9VUzx57Ru0va1fZtId7gHqGlBp4plIoO
	 VGvcNKrP9z2K3qxJptfktF73RkH8m0LvSQEacGpjPW90ZQNwLwJh/EnXxnwFFjkSQs
	 cELBZ0uIubaRWWgFgSSPrr8A0An79zeVA5lbj2+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 73/92] iio: adc: ti-ads8688: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:31 +0100
Message-ID: <20250115103550.471931025@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 2a7377ccfd940cd6e9201756aff1e7852c266e69 upstream.

The 'buffer' local array is used to push data to user space from a
triggered buffer, but it does not set values for inactive channels, as
it only uses iio_for_each_active_channel() to assign new values.

Initialize the array to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: 61fa5dfa5f52 ("iio: adc: ti-ads8688: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-8-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads8688.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-ads8688.c
+++ b/drivers/iio/adc/ti-ads8688.c
@@ -382,7 +382,7 @@ static irqreturn_t ads8688_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	/* Ensure naturally aligned timestamp */
-	u16 buffer[ADS8688_MAX_CHANNELS + sizeof(s64)/sizeof(u16)] __aligned(8);
+	u16 buffer[ADS8688_MAX_CHANNELS + sizeof(s64)/sizeof(u16)] __aligned(8) = { };
 	int i, j = 0;
 
 	for (i = 0; i < indio_dev->masklength; i++) {


