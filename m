Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA7A2DF9F;
	Tue, 20 Feb 2024 21:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464900; cv=none; b=Bm6DY16z44i4bdWIEe3oGl+TH6gGGU3qoPFkSOwV0LWLzgSjw/5JX6+QJ8PYRasvfTTNYzbfP6LS8um2Kwrghw/BZ+TD4d4xPdRZhBZCZ6bFwAZlPEFyxzH8IKMs7/1eU9TQvb3AG6KrGtr64C854GF9pfWkYK03JjYdJNvZOr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464900; c=relaxed/simple;
	bh=w+lHkJSyFcmzFjZTjaPZaqU+YJ9y1Fctpr5vIGOaTmM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQdyF4IA6ap9I6PsXPLRUzFxmdGQdHdJHBWw/OU9s4FT/PkwSietIVIo0PphPoElwQI91Wo9+QnY/btUUzltHn6TnEHw5nEAxYLL7RQ5j9NjU/EFPE9jhjHYM66aUn4AmjyHq1PY2F/C9Lq2ZZMRLshxyVQcqwAesAgSaEcgAes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUnamBpF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUnamBpF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0334C433F1;
	Tue, 20 Feb 2024 21:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464900;
	bh=w+lHkJSyFcmzFjZTjaPZaqU+YJ9y1Fctpr5vIGOaTmM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUnamBpF/6PwaZVN4a8Fia2t+k4JfSZSUZgLJopsZpEc9XHGYpwYQDooqw5hzjBL/
	 qKXn9eMw/WC2ChNgzrfmO/qLjGCJDV/aZmXm+Rd2o/eymAT4cr6OtfNePmNbngqPct
	 NG5uIQgHwzHSFwOXTBVz2NSbiGPAvCynliTg01uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.7 173/309] iio: adc: ad_sigma_delta: ensure proper DMA alignment
Date: Tue, 20 Feb 2024 21:55:32 +0100
Message-ID: <20240220205638.563413061@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

commit 59598510be1d49e1cff7fd7593293bb8e1b2398b upstream.

Aligning the buffer to the L1 cache is not sufficient in some platforms
as they might have larger cacheline sizes for caches after L1 and thus,
we can't guarantee DMA safety.

That was the whole reason to introduce IIO_DMA_MINALIGN in [1]. Do the same
for the sigma_delta ADCs.

[1]: https://lore.kernel.org/linux-iio/20220508175712.647246-2-jic23@kernel.org/

Fixes: 0fb6ee8d0b5e ("iio: ad_sigma_delta: Don't put SPI transfer buffer on the stack")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240117-dev_sigma_delta_no_irq_flags-v1-1-db39261592cf@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/iio/adc/ad_sigma_delta.h |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/include/linux/iio/adc/ad_sigma_delta.h
+++ b/include/linux/iio/adc/ad_sigma_delta.h
@@ -8,6 +8,8 @@
 #ifndef __AD_SIGMA_DELTA_H__
 #define __AD_SIGMA_DELTA_H__
 
+#include <linux/iio/iio.h>
+
 enum ad_sigma_delta_mode {
 	AD_SD_MODE_CONTINUOUS = 0,
 	AD_SD_MODE_SINGLE = 1,
@@ -99,7 +101,7 @@ struct ad_sigma_delta {
 	 * 'rx_buf' is up to 32 bits per sample + 64 bit timestamp,
 	 * rounded to 16 bytes to take into account padding.
 	 */
-	uint8_t				tx_buf[4] ____cacheline_aligned;
+	uint8_t				tx_buf[4] __aligned(IIO_DMA_MINALIGN);
 	uint8_t				rx_buf[16] __aligned(8);
 };
 


