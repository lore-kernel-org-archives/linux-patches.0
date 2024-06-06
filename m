Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9EE19CD14;
	Thu,  6 Jun 2024 14:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683448; cv=none; b=HEQgZlCVSzBS1vcF/p2HBSy8XKCMy5/12xL5hH7bOzzF8XRRhis72jcQ+BIH4kA3zYgxG5KeCcvwZ6H56xeYkBslTQ7kVc48NYc091gbMlZmeeDTH35Zyxj1agKaGStwHm16B3vzZUeI3eq++eeFcatpTWRlaY9fW3wZGHWk+U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683448; c=relaxed/simple;
	bh=/kDsV/9tVNwkguakiQyY2b62zKkv1l3sH9p12uma1lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rh5E/Emb9AckNNmH4WWSx4NjjuwcayQJir1VeHiIvUVQIx0YN/F488GnKmgaspWHkKmaVCRFoiAtRXRTV+fiH8aC5mJ8HpRL/fOynKco4G/h0tTqyCe6HhB4flI6MC13slJEI/fAXfARGmYJfICLJpS6OWBkua0iHc9YE7kDCUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2GAHqhz6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2GAHqhz6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BD21C2BD10;
	Thu,  6 Jun 2024 14:17:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683448;
	bh=/kDsV/9tVNwkguakiQyY2b62zKkv1l3sH9p12uma1lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2GAHqhz6Hj77+HsHH9lga7/tWedprGl1J91FZL9+m3hxSFMH5mQm3w2EL0wYb+xDA
	 xtm0mRXqDMghBMNHBR0j/tc6GPvjxJTYI8GwFA6KUc7bgAO7GBxomRBndOmRU48/D2
	 qNypVmE07g2akonOC794Not7ITIRmduej+uQcVfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	David Lechner <dlechner@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 392/744] iio: core: Leave private pointer NULL when no private data supplied
Date: Thu,  6 Jun 2024 16:01:04 +0200
Message-ID: <20240606131745.034879247@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index feec93adb0651..5e1a85ca12119 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1649,8 +1649,10 @@ struct iio_dev *iio_device_alloc(struct device *parent, int sizeof_priv)
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



