Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C481FB3;
	Tue, 27 May 2025 17:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367915; cv=none; b=dTNGndjWGlIgsC0sdYeSiGSl6oqk2Ri6u+PFlCKT5QOWG6qhOBeCuczo4XOm1GQWsu7KZHj153MDCLQpIwrHbMKE+nP76OkBA59VDKQfQu9fJLcBWCSRu1gjkwUa3jebbG3VjA2yFECT5GxkOoYi8ayRjpYIruJ14m9iNaeIvfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367915; c=relaxed/simple;
	bh=mnufLOfQ4VRmrCWUJSTzBHMJYlX0gjWmUsBjDEDeA40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KMDfHsCyl8sAhOy28hpJbslXl7juKy3HgIzQrL8lQkhjXiCB/yO3iDNyFoZUqsNJR8R3InDaNz/txcO2Taycdueswxmkd6VnVMQxGzoBw+Hq4bRFDjO5gEAato1ce1Ymi1zknSCEAG4QxFixto4ZecGE5RtGIYbR4LddTbQwLPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Epci5Knn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Epci5Knn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64B42C4CEE9;
	Tue, 27 May 2025 17:45:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367914;
	bh=mnufLOfQ4VRmrCWUJSTzBHMJYlX0gjWmUsBjDEDeA40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Epci5KnnETgGh4GN/FS4Zbvoifayc7+xN50KJfl/m67I9GpKmByM8VRITxLR9yxfY
	 RH+7dEc5NIyAV+gkrPB5vG+DpdZGgaWqIOydQVnOZm7hkP6ySdn6al3ayq4Fh3CuSa
	 PSkh7fw+ih6sMJqeDUCMR/YHTLYwT0Ewk71sADnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 512/783] iio: adc: ad7606: protect register access
Date: Tue, 27 May 2025 18:25:09 +0200
Message-ID: <20250527162533.991056701@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Angelo Dureghello <adureghello@baylibre.com>

[ Upstream commit 0f65f59e632d942cccffd12c36036c24eb7037eb ]

Protect register (and bus) access from concurrent
read / write. Needed in the backend operating mode.

Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Link: https://patch.msgid.link/20250210-wip-bl-ad7606_add_backend_sw_mode-v4-7-160df18b1da7@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7606.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/iio/adc/ad7606.c b/drivers/iio/adc/ad7606.c
index 0339e27f92c32..1c547e8d52ac0 100644
--- a/drivers/iio/adc/ad7606.c
+++ b/drivers/iio/adc/ad7606.c
@@ -862,7 +862,12 @@ static int ad7606_write_raw(struct iio_dev *indio_dev,
 		}
 		val = (val * MICRO) + val2;
 		i = find_closest(val, scale_avail_uv, cs->num_scales);
+
+		ret = iio_device_claim_direct_mode(indio_dev);
+		if (ret < 0)
+			return ret;
 		ret = st->write_scale(indio_dev, ch, i + cs->reg_offset);
+		iio_device_release_direct_mode(indio_dev);
 		if (ret < 0)
 			return ret;
 		cs->range = i;
@@ -873,7 +878,12 @@ static int ad7606_write_raw(struct iio_dev *indio_dev,
 			return -EINVAL;
 		i = find_closest(val, st->oversampling_avail,
 				 st->num_os_ratios);
+
+		ret = iio_device_claim_direct_mode(indio_dev);
+		if (ret < 0)
+			return ret;
 		ret = st->write_os(indio_dev, i);
+		iio_device_release_direct_mode(indio_dev);
 		if (ret < 0)
 			return ret;
 		st->oversampling = st->oversampling_avail[i];
-- 
2.39.5



