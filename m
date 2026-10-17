Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0194C391E51;
	Sat, 17 Oct 2026 17:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257043; cv=none; b=iVjXDOKz0l1/1YS+Q5P8vf9irptey9IsZ/H2d8Eq4JoY64s34LxKGNv8OxyywdWtF/YHVrGlvTo3Zp+7WGFHQLZEsEScjy8VbMGU2Q/lMH4Pts3Aeqq3+CX1y3nkFXnINLMwlPiNQ9yCfsAQcV/u/sey4F1+fpAQ84GTUhO71QI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257043; c=relaxed/simple;
	bh=tzAzZ/W6YrFAquxGlUDRsnuKClYdlpqd/4C7Xlb9JBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YJPdcwzs/kKCRZRS9UHxL0HEPjFt26gSrotCSobpYpTEYZnjo5+3KJ7QSbf5BOzIvq7B/C4lIeYOspWIJy2oeaDc5O5CuSsQBW6v7dZRdhWw7NcGY72HWagWwvCoI6xMbQQlHYBZOdUJgna6lsxLP14Je7BAMfZ2wR+w+rLsLGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h0nGiIHX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h0nGiIHX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F4E31F000C4;
	Sat, 17 Oct 2026 17:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257041;
	bh=JRdTxaZA58uwpIHCR9Kh1lM3uyoBFLPFElIwitudchs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h0nGiIHXAiJ/bUFQjE4HOLQ2f9ZeHbLRGxAJSes9wSj7PlWd18ijPdAbYWC7G2OG1
	 j7AyiMR/R/p50jeAXIBdjt0+iH0wz434skAxJ7NFD9OkzeiCvn3pI7fZmOSsSsiunX
	 TEgDHpC4GXJbB8f0FLkOGTuMHKuVvYzw++rj1ULc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Alexandru Ardelean <aardelean@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0431/1674] iio: core: add accessors masklength
Date: Sat, 17 Oct 2026 17:45:03 +0200
Message-ID: <20261017160442.189330082@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit de79583ffe794663c53b77f97be814522d4edc4f ]

'masklength' is supposed to be an IIO private member. However, drivers
(often in trigger handlers) need to access it to iterate over the
enabled channels for example (there are other reasons). Hence, a couple
of new accessors are being added:

 * iio_for_each_active_channel() - Iterates over the active channels;
 * iio_get_masklength() - Get length of the channels mask.

The goal of these new accessors is to annotate 'masklength' as private
as soon as all drivers accessing it are converted to use the new
helpers.

Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Reviewed-by: Alexandru Ardelean <aardelean@baylibre.com>
Link: https://patch.msgid.link/20240702-dev-iio-masklength-private-v1-1-98193bf536a6@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Implement the masklength getter as a single-evaluation macro with an
unsigned result so that no new functions are introduced. Retain the
active-channel iterator and convert the MAX30102 interrupt handler to the
getter, providing the context required by the subsequent interrupt fix.
Omit the unrelated scan-type helper from the surrounding upstream context.

Stable-dep-of: f0ea4824deeb ("iio: health: max30102: fix NULL dereference in interrupt handler")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/health/max30102.c |  2 +-
 include/linux/iio/iio.h       | 15 +++++++++++++++
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/health/max30102.c b/drivers/iio/health/max30102.c
index 37e619827e8a1..43c16fcdeae19 100644
--- a/drivers/iio/health/max30102.c
+++ b/drivers/iio/health/max30102.c
@@ -293,7 +293,7 @@ static irqreturn_t max30102_interrupt_handler(int irq, void *private)
 	struct iio_dev *indio_dev = private;
 	struct max30102_data *data = iio_priv(indio_dev);
 	unsigned int measurements = bitmap_weight(indio_dev->active_scan_mask,
-						  indio_dev->masklength);
+						  iio_get_masklength(indio_dev));
 	int ret, cnt = 0;
 
 	mutex_lock(&data->lock);
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 202e55b0a28b2..3da7f2331cc60 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -756,6 +756,21 @@ static inline struct dentry *iio_get_debugfs_dentry(struct iio_dev *indio_dev)
 }
 #endif
 
+/**
+ * iio_get_masklength - Get length of the channels mask
+ * @indio_dev: the IIO device to get the masklength for
+ */
+#define iio_get_masklength(indio_dev) ((unsigned int)(indio_dev)->masklength)
+
+/**
+ * iio_for_each_active_channel - Iterated over active channels
+ * @indio_dev: the IIO device
+ * @chan: Holds the index of the enabled channel
+ */
+#define iio_for_each_active_channel(indio_dev, chan) \
+	for_each_set_bit((chan), (indio_dev)->active_scan_mask, \
+			 iio_get_masklength(indio_dev))
+
 ssize_t iio_format_value(char *buf, unsigned int type, int size, int *vals);
 
 int iio_str_to_fixpoint(const char *str, int fract_mult, int *integer,
-- 
2.53.0



