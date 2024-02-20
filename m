Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82232DF9F;
	Tue, 20 Feb 2024 21:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464903; cv=none; b=pVaT4OeWEFMmkp+06a6DOtFSwlQlCKQuPzdPkwvK6i/GgPC3p9wViuTkRqie4+/z4+vWGkCR5m5atKZT+hHsceRBTfbtrs6I2OUG8xGRLbNIvVfJNNeDJ+QG7oY5zyK3rvAGgb6+yYhaGijqZoNN+xpIPyS3wMv7Ua6Dfm+pDs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464903; c=relaxed/simple;
	bh=AzLZi7piFnx6nKQorzGu5jrOL907E1OIGGooYZKgWOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ER257CqI1eCmuUPmmGum/gXevrDgyk+5B+MgyEHZDiv4D/lW7Jcw812W57iMigYFKjyMgvDrR5moGUgy0rZN731cYdHi0DIx97IYoXHnVAKAA2Qjztq+Ls/WXZUewrzmAPo0QKEwY8744UTLMV6ZPxiRhJ2hk7Qeyf+y7jz94Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qbHPBQyC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qbHPBQyC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1646BC433F1;
	Tue, 20 Feb 2024 21:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464903;
	bh=AzLZi7piFnx6nKQorzGu5jrOL907E1OIGGooYZKgWOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qbHPBQyC1DfxHX1hFHvsV+yoWqhdR/EI7iU262PIWVFtUgKc7MNcialuV1b/Nm0ys
	 Yl6gaj6kVLlZTse+7gkGj5gUPnbtHI1RPTA4alpdD44jFaj5F/90aIv3zKtSvNRQCu
	 RutN3tnUYTHkCW9zmMcT/QHeOc6EalZGieK2kREY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.7 174/309] iio: imu: adis: ensure proper DMA alignment
Date: Tue, 20 Feb 2024 21:55:33 +0100
Message-ID: <20240220205638.594020769@linuxfoundation.org>
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

commit 8e98b87f515d8c4bae521048a037b2cc431c3fd5 upstream.

Aligning the buffer to the L1 cache is not sufficient in some platforms
as they might have larger cacheline sizes for caches after L1 and thus,
we can't guarantee DMA safety.

That was the whole reason to introduce IIO_DMA_MINALIGN in [1]. Do the same
for the sigma_delta ADCs.

[1]: https://lore.kernel.org/linux-iio/20220508175712.647246-2-jic23@kernel.org/

Fixes: ccd2b52f4ac6 ("staging:iio: Add common ADIS library")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240117-adis-improv-v1-1-7f90e9fad200@analog.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/iio/imu/adis.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/iio/imu/adis.h
+++ b/include/linux/iio/imu/adis.h
@@ -11,6 +11,7 @@
 
 #include <linux/spi/spi.h>
 #include <linux/interrupt.h>
+#include <linux/iio/iio.h>
 #include <linux/iio/types.h>
 
 #define ADIS_WRITE_REG(reg) ((0x80 | (reg)))
@@ -131,7 +132,7 @@ struct adis {
 	unsigned long		irq_flag;
 	void			*buffer;
 
-	u8			tx[10] ____cacheline_aligned;
+	u8			tx[10] __aligned(IIO_DMA_MINALIGN);
 	u8			rx[4];
 };
 


