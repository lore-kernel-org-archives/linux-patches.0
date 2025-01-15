Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DAC248BA1;
	Wed, 15 Jan 2025 10:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938470; cv=none; b=fH8vprWBHXuXHQ/v25fv0NiLsM0AaXn0zg/ZzjeoflzAcBSIWYNpbDPEWXCR9LQWPKLPtt97y92vU4ImnddR3etlAmpqzqq4a88lUEsx25OgK2B7N0HN1KT26cGz9hIaeVKJusS8FOk0CnWO/QfNjQXGEpRTXhe6Bf97LL1kbDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938470; c=relaxed/simple;
	bh=MrP6nkUfxV+hphMk0nq8CU9bPjkcahOuGJ3ZKotSLFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvLKwOC0pnKamAAJce0qd4r4wiOlyJbX1XhggyTzbvPdKyxQ88HwyEr4sUg+BNcuqYcJfqB7O11UNQfdphHky98Hl5mu0CHTVnPyTOrvbSbxtPhxgrDF4IZZJf0NYYFdIrn9D41lSTblCgwQAPPZhkdH6AKGhT6d7LPkGUzNlKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tY/8+YXN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tY/8+YXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA777C4CEDF;
	Wed, 15 Jan 2025 10:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938470;
	bh=MrP6nkUfxV+hphMk0nq8CU9bPjkcahOuGJ3ZKotSLFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tY/8+YXN0ZOJWFgcUkKHUxLgbGHnrunQ6Yj8NCeiGGMu8E+mh2K3DnJwD7VTcbrdl
	 QQkI94RtxxK8S3YUnqsryW/AkxMEybY60H5HXJ40SaKoiSEU4uNbhpAW5jWXFBz8qV
	 rRQPSCluPYsz5iABPFmelYSveIfcm89BUm4nuOgw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 163/189] iio: adc: ti-ads8688: fix information leak in triggered buffer
Date: Wed, 15 Jan 2025 11:37:39 +0100
Message-ID: <20250115103612.905987478@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -381,7 +381,7 @@ static irqreturn_t ads8688_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	/* Ensure naturally aligned timestamp */
-	u16 buffer[ADS8688_MAX_CHANNELS + sizeof(s64)/sizeof(u16)] __aligned(8);
+	u16 buffer[ADS8688_MAX_CHANNELS + sizeof(s64)/sizeof(u16)] __aligned(8) = { };
 	int i, j = 0;
 
 	iio_for_each_active_channel(indio_dev, i) {


