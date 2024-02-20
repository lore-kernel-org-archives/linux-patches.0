Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF20151CF5;
	Tue, 20 Feb 2024 21:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463107; cv=none; b=LGF3/SIOE5HyCPWqH22JeYBh+8GB2KHv6xBN+Z7rY54abKOb/N9Oq1KfO3JQzZuGiw4GOj1TEkke/64bkYjtOFw0sjkJyEX6YZ4X/58KVbEHEeZ6MJwjqxaO/odLYdpktVA/TvOSqL+eOkW994SDOJH/1l/AnngiPWZBVTlpgmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463107; c=relaxed/simple;
	bh=6MtimzAaYufqI935+rYOs2KpRzsGZlLgZ/t3DLwClqs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0QUNjcxklTdcp6Xf70nu8iNNKb8/p0LGx6NXkz2Yfdt6e3B7hlUAjylWAB1NVaberGa0vmX0WZx/gRCf5qeBEgNsAw/hzWM3Cc8OZGUtg8izJcl7AFGL7aypjARYMjcbH0WvlTnUyd+b7LznjB32AxJJ1P8YoHfuIULdsdgl2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BwjmZJI7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BwjmZJI7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FBDC433F1;
	Tue, 20 Feb 2024 21:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463106;
	bh=6MtimzAaYufqI935+rYOs2KpRzsGZlLgZ/t3DLwClqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BwjmZJI7jvcg5tQ4JEEI2t6FfVm5SgajKiWRlwMZS01DEx7EN/r5txXQvfKakfm0w
	 dLeKCwLbT83+Uzq0YkPadt8vhCrnc55fHhXcJCmTBZBlzZkIiChVzrZJ01YD3QCqXc
	 Y2C9mIM1Z9OdhgLMxBxIldqM/QA9RqIcEs9RO9ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 107/197] iio: imu: adis: ensure proper DMA alignment
Date: Tue, 20 Feb 2024 21:51:06 +0100
Message-ID: <20240220204844.284344523@linuxfoundation.org>
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
 


