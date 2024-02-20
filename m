Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE01B14AD12;
	Tue, 20 Feb 2024 21:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463103; cv=none; b=GCedpT8B0XobDfn+FuQYuRB6hAdjE6jxML7uHksRPXrVLrWz6emTLVmi5z4pIS+yfWcP552CgReQfknH2gypx2KMBeXS895nyYmsIjVy0g6JZYIrlpZ5W7VePx1m2jGA0SuaXhMH3in+sTHD4FHT8xpg5VahXGshu7ypsGPnCug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463103; c=relaxed/simple;
	bh=qtyhnqpyyXdu7lfJNHkOO63mUxYd93Dx6ryw3G+8YWc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZkRw/9/aqYsFs/tEuf9mNI2iDIFADfNU1A+8xVObandNx+RVQcwKb60EH58e0BnqyvP5ICVvBRpphePNLCAnD5j9vR00Xp0IOc8I2bzgvjtHi7C2C3wUmwvgatALvfF8FSK0YI//gRHjeIEpS4Rnexsv0cE9/b4y3LTFk41EwaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tP2+BDdh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tP2+BDdh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328EBC433C7;
	Tue, 20 Feb 2024 21:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463103;
	bh=qtyhnqpyyXdu7lfJNHkOO63mUxYd93Dx6ryw3G+8YWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tP2+BDdhH+kFZSdxh9tSv84uelJ1bizi9VNYojHLTcL9hHX3MuXj9Sa6EL2hgjyLX
	 QATXh2Y8r32z4cvFWkq6bjOYJith8JRfzZFV2IE8JCEM97RIANtne9VWeWdPmie1RO
	 Sh6th3iw3aTDxTWMI079JQnSSRiAQa+OXYuKWCe4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 106/197] iio: adc: ad_sigma_delta: ensure proper DMA alignment
Date: Tue, 20 Feb 2024 21:51:05 +0100
Message-ID: <20240220204844.255219144@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


