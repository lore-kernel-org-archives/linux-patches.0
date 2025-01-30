Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8550D1DDC22;
	Thu, 30 Jan 2025 14:23:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246992; cv=none; b=pTQlFTcAeFc8betVB3WN73B2FcxPnfI30fnWAWjaQuabUrH+TTunRLZwMG4Xn4AidmYWgRNGY/U7mtupidQorPkwH60HZCN10InVUIBIJjAsb4tmziagGbh5UkhEge01Rkp4DclIjjGyITLUWK2lPw/toizWKeO7//URPhlHHmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246992; c=relaxed/simple;
	bh=5GqecZssZM20UJl+tre7+eoVC9wHih4f12WiuvIthos=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgDLIxbnZw6/NvvAWRevGcKKWN4ICxAWr7ktokR8LBYaPU0gbNzALe0jhZ38bePkOBgdtLYUXyuSsxs/afqB+FIbzZg5bIYsQu70Ia9FbL5yJZYjZntppOhHHkH+5rty8e7HoEOULdSO1QFZDWP/gI6w+F606dCEoYidBkEztsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VTD19DG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VTD19DG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ED99C4CED2;
	Thu, 30 Jan 2025 14:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246992;
	bh=5GqecZssZM20UJl+tre7+eoVC9wHih4f12WiuvIthos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VTD19DG4GeV37rLNHFaiuC877mbn+mR9bAaphpmFWSgBpUmMAEYL37eLHCy6SXAEZ
	 OUqk+t4+jVT0kxV/SiRB3ePqSfu0Eqoon5kyy8zGh0RxiELD0Hr22noaMTuSyEaelC
	 Pr+SjGXeTExT9rNLwu3sbODYTqNiMEYvgxEOhJ/4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.10 046/133] iio: adc: ti-ads8688: fix information leak in triggered buffer
Date: Thu, 30 Jan 2025 15:00:35 +0100
Message-ID: <20250130140144.366344160@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -384,7 +384,7 @@ static irqreturn_t ads8688_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	/* Ensure naturally aligned timestamp */
-	u16 buffer[ADS8688_MAX_CHANNELS + sizeof(s64)/sizeof(u16)] __aligned(8);
+	u16 buffer[ADS8688_MAX_CHANNELS + sizeof(s64)/sizeof(u16)] __aligned(8) = { };
 	int i, j = 0;
 
 	for (i = 0; i < indio_dev->masklength; i++) {


