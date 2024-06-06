Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32FF6196434;
	Thu,  6 Jun 2024 14:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682897; cv=none; b=LD/QHp6bqSr7ahApuhMyEhO4JEGWUnQpkFVZCERoV5zwZRfopLf0RAYMXHboCT+TwXEazlnwNUDJlDmb307Tswzh9hZPoca/U8cndXw32ZG61o+JcZ7K9hPOOjzE7CI8JWlPuuT5CCSvJR2fKpPSqBY67ifCnivumzvjN3ScXUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682897; c=relaxed/simple;
	bh=uaj1zIvfl8wEk0tyoefNK2XNDfpbPWyQ+Ov7EKqo704=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZB7ds1ubGZsKkkYs09zmn0Rcz5KffQVllsPHJyHbw5rAh6p1eSnvhUNTXcV2LwrM7NQo5Y4qk+sTE8YHLzdzrANZ04rcLwWW3XN8MMZ37BSxv8W0/2S23k0mX7roWZkd3AKQixT+C+MKSzHY2JJI+U9D/lRRgfzFUuzVekVGo/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yMb63b1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yMb63b1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C244CC32781;
	Thu,  6 Jun 2024 14:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682896;
	bh=uaj1zIvfl8wEk0tyoefNK2XNDfpbPWyQ+Ov7EKqo704=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yMb63b1k3rHkr04SjyXFfZFJrkxZirfbyi4a1L5bgHANPfgvml8RuOgaYxrg4cMgk
	 2LekFvOmgyVT1VyMNK8HymmFh1lfAKtzV4UXK3zdgrH/1uNJT4aLxhGMKm6A0QBw1L
	 uUR6q92gyWnom4pLbU2RuFUvbRCg+6rSdYW1IuA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 005/374] iio: core: Leave private pointer NULL when no private data supplied
Date: Thu,  6 Jun 2024 15:59:44 +0200
Message-ID: <20240606131651.895384522@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f0245ab389330cbc1d187e358a5b890d9f5383db ]

In iio_device_alloc() when size of the private data is 0,
the private pointer is calculated to point behind the valid data.
Leave it NULL when no private data supplied.

Fixes: 6d4ebd565d15 ("iio: core: wrap IIO device into an iio_dev_opaque object")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Link: https://lore.kernel.org/r/20240304140650.977784-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-core.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 4302093b92c75..8684ba246969b 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1654,8 +1654,10 @@ struct iio_dev *iio_device_alloc(struct device *parent, int sizeof_priv)
 		return NULL;
 
 	indio_dev = &iio_dev_opaque->indio_dev;
-	indio_dev->priv = (char *)iio_dev_opaque +
-		ALIGN(sizeof(struct iio_dev_opaque), IIO_DMA_MINALIGN);
+
+	if (sizeof_priv)
+		indio_dev->priv = (char *)iio_dev_opaque +
+			ALIGN(sizeof(*iio_dev_opaque), IIO_DMA_MINALIGN);
 
 	indio_dev->dev.parent = parent;
 	indio_dev->dev.type = &iio_device_type;
-- 
2.43.0



