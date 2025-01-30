Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B99B1E8835;
	Thu, 30 Jan 2025 14:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246688; cv=none; b=o5nopRtRszF8YdnKk9Ojtuu66/ZonLVtrTPp+rU4cyP/TXKlB2HeMTXAsDwKBCaiNrzSp3LB6+tEzSgzpOAnl00pMhg3zEuxAlCOYf2dd0Pff+I/DwykF9KTSnrNIAbxSBmrCVGwv+ISySfCHet0UHqwz9SzYr64E6cwFslqtGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246688; c=relaxed/simple;
	bh=OqDHayMo9Tm/H/cQl/A68axZeOYJzmSXmQwlvOZG42E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U9khnVUSxiUh3cRt83vv6uTDNGfl0+nqQvnzSg/ixdtoQeqfF7yC7ZtQ7JXIMrgV9dFHpWWskgyFkuXPhH3a9wNDHcqhP69BYtRF9EydnthmxRGs+1lTRkVCTQ50j4AZe1fBOmMSVap0GLzVjZ0qvOX/veqQ4qH6VXXn0f+oUW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5hJPFLY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5hJPFLY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5121C4CED2;
	Thu, 30 Jan 2025 14:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246688;
	bh=OqDHayMo9Tm/H/cQl/A68axZeOYJzmSXmQwlvOZG42E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5hJPFLYZq+I/of2oeD3CjfgK8naB5MCG4s9N8iB8cRtlZfVmkEGPO5kpazTryYL8
	 UnbEy/5za5oi9PDXlvzXgpzriOgQ54PthWLsj+fEeyjvoeVjobLyfdfZAagPGGhmQf
	 T7B4etqSAvsW43tMyLEiSOTxOetzjsG2uEr/3m/s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 33/91] iio: adc: ti-ads8688: fix information leak in triggered buffer
Date: Thu, 30 Jan 2025 15:00:52 +0100
Message-ID: <20250130140134.994924010@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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


