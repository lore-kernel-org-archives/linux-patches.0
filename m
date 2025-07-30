Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7B3736124;
	Wed, 30 Jul 2025 09:41:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868485; cv=none; b=bCHFaBXQeM0P7/p2F6sOVdCltXhDkKRmThS7h+T5fdXDUj7iwu3+5BzHvVAz4LJdu9NN58OfDB51ZdhzQBT225c20tLw63OE4QBWY7P+e15o2AR5R0YmQfYYrauVVFGAa30zVVTKXgmeecI4BnKGLOx0I8VHrNMniFmePqveqqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868485; c=relaxed/simple;
	bh=8ZNJtwV+Gh/qH0L+zVZ13tgcw+UUlBL167u+61xOR7c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+3Tth9M/u5NgRTzmvRbyUAd7UsjGf3s9cPPeMX8hMeIu32sU6nJDk2H/9FZM5Qjn4ZKfLx6DA23fL5Yd6sBBfxbbtOYtskdw1SdWkXv3QotMvY0E7cng88lVhH1NCcLRhb8bP3X4VHWRj6zeOJ/MxfTAw75CsNBsXjbKyvQWoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/W9C5bu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/W9C5bu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DB8AC4CEE7;
	Wed, 30 Jul 2025 09:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868484;
	bh=8ZNJtwV+Gh/qH0L+zVZ13tgcw+UUlBL167u+61xOR7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/W9C5buOgDe+LE1Hjyd9r/ebmHG31iOJdhVrQhJXjYGU0Vc/aX+Vne8fotIoZh62
	 aIi20FSr99Dx9M9qvZNDMIN4j8qMQZOKCNx4buslN1x0s8YhlVmphhfBBHW29giAX2
	 FZ7kv0EShH2T6aA3iTlTpSZ/yF9zl8Uq8KNWjo6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Lixu <lixu.zhang@intel.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 62/76] iio: hid-sensor-prox: Fix incorrect OFFSET calculation
Date: Wed, 30 Jul 2025 11:35:55 +0200
Message-ID: <20250730093229.271800678@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
References: <20250730093226.854413920@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Lixu <lixu.zhang@intel.com>

[ Upstream commit 79dabbd505210e41c88060806c92c052496dd61c ]

The OFFSET calculation in the prox_read_raw() was incorrectly using the
unit exponent, which is intended for SCALE calculations.

Remove the incorrect OFFSET calculation and set it to a fixed value of 0.

Cc: stable@vger.kernel.org
Fixes: 39a3a0138f61 ("iio: hid-sensors: Added Proximity Sensor Driver")
Signed-off-by: Zhang Lixu <lixu.zhang@intel.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20250331055022.1149736-4-lixu.zhang@intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
[ adapted prox_attr array access to single structure member access ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/light/hid-sensor-prox.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/iio/light/hid-sensor-prox.c
+++ b/drivers/iio/light/hid-sensor-prox.c
@@ -102,8 +102,7 @@ static int prox_read_raw(struct iio_dev
 		ret_type = prox_state->scale_precision;
 		break;
 	case IIO_CHAN_INFO_OFFSET:
-		*val = hid_sensor_convert_exponent(
-				prox_state->prox_attr.unit_expo);
+		*val = 0;
 		ret_type = IIO_VAL_INT;
 		break;
 	case IIO_CHAN_INFO_SAMP_FREQ:


