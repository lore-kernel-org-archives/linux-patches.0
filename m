Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AEF1E6DCF;
	Thu, 30 Jan 2025 14:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246682; cv=none; b=nORQHZPeKim9GvaAN0i3kdhomDBxzdTALE9AvMkGJbjqz8C9EhLkCOIlXJFn+uiGs5Ubt7q7il3WVVrUlHGqfP3hQuGpjv/Cn2NqLk5wMGV1S9mKxq0f3FL52CbW8cYVwfXJvV6Kt/QIUr8WgODwW9Svm7GHR4Uz+2339Hhx8eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246682; c=relaxed/simple;
	bh=VN0pufTQa9DPOmPaDvD2xwk+Y6qji4+/PCPq7LrKvRM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mfQo0f5D1x7xjPMVVz/7u5n7IpHR41ae81Sou6y3BwDN0tpGd+re9276jT9lqY84fJt7a10vrP3PkYNbvmtjiNFIbvft43wOr8rnGL/gvKmObQFgtS/Tw2Kwv4rhqR+FFGnoMA9O8iJRvnIi/qvUkmnDox8TA58p4EL93LfbIDU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=li9Hfra2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="li9Hfra2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57696C4CED2;
	Thu, 30 Jan 2025 14:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246682;
	bh=VN0pufTQa9DPOmPaDvD2xwk+Y6qji4+/PCPq7LrKvRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=li9Hfra2QEwQ0fTTE/m1hKVwa/Th2f+j2R4rTR+xrPgovFMKXh49Xtgxxjy63G7iy
	 cDGkHUdvKpPpRzvkqEwBwD3AjIpcrGD6XQw/PSDdnIT7dtroBb06uNBZ2R+hJqhAdK
	 Y1KrPUNgKgRK9JiW+HhydOsqt4lEbY8caTohAgp8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 31/91] iio: light: vcnl4035: fix information leak in triggered buffer
Date: Thu, 30 Jan 2025 15:00:50 +0100
Message-ID: <20250130140134.915697703@linuxfoundation.org>
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

commit 47b43e53c0a0edf5578d5d12f5fc71c019649279 upstream.

The 'buffer' local array is used to push data to userspace from a
triggered buffer, but it does not set an initial value for the single
data element, which is an u16 aligned to 8 bytes. That leaves at least
4 bytes uninitialized even after writing an integer value with
regmap_read().

Initialize the array to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: ec90b52c07c0 ("iio: light: vcnl4035: Fix buffer alignment in iio_push_to_buffers_with_timestamp()")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-6-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/vcnl4035.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/light/vcnl4035.c
+++ b/drivers/iio/light/vcnl4035.c
@@ -105,7 +105,7 @@ static irqreturn_t vcnl4035_trigger_cons
 	struct iio_dev *indio_dev = pf->indio_dev;
 	struct vcnl4035_data *data = iio_priv(indio_dev);
 	/* Ensure naturally aligned timestamp */
-	u8 buffer[ALIGN(sizeof(u16), sizeof(s64)) + sizeof(s64)]  __aligned(8);
+	u8 buffer[ALIGN(sizeof(u16), sizeof(s64)) + sizeof(s64)]  __aligned(8) = { };
 	int ret;
 
 	ret = regmap_read(data->regmap, VCNL4035_ALS_DATA, (int *)buffer);


