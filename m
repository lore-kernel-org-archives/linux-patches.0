Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 453F81F55E5;
	Tue, 21 Jan 2025 18:08:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482930; cv=none; b=Rkr22Mu1FuACqy8OxLCfHVg//Zl1DbDWWlICyUtGc86RoVRxV3QcbH3L45VExuLJg/FXjXF1n5o0zf9gr7iP/dSKaDDqeked75qqXtd19rd5s4TEl6HnbODKPTF98Ov5p6GHzPGaSJSSJTuUMID3n4iBYDej5BI8c/nsgp55GEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482930; c=relaxed/simple;
	bh=aRWcYY5eNIBuyRItaM2O0yKD2y6ukXf5ZkHfcxNfnhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=chlb1Z6r/0nKfeeNM8M3bAgMXbYcgzWhZjFbIDx3SJbtyut43pYOa5rTH6UUzC6FSwDwx3NxuOaEnA6+FMbNHinSwXV3CaP/DmirOcuJEhRTzJiHCJjNrTFdBA25pWbFswu1YaBbssHXi/bepyr8RRCBBYQEQd6jX89iGMHVcAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bhSxLk6F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bhSxLk6F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF923C4CEDF;
	Tue, 21 Jan 2025 18:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482930;
	bh=aRWcYY5eNIBuyRItaM2O0yKD2y6ukXf5ZkHfcxNfnhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bhSxLk6FpuKFt3EEpnVB4s28855dIvFQsqEkkL7o4kwRA+QMevcOfp9yC4zCw50dz
	 SykZ0yaBT1HfUjo2bGLcj3ggFOWEVLpIXYVryR7UPfsE9LFM1sRQoyre2HxWIErE+4
	 7nPjLwoVGWs+jNUA7ZZFc4QDpQ+LgK1Bshvff/cI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 057/127] iio: adc: ti-ads8688: fix information leak in triggered buffer
Date: Tue, 21 Jan 2025 18:52:09 +0100
Message-ID: <20250121174531.863511365@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

commit 2a7377ccfd940cd6e9201756aff1e7852c266e69 upstream.

The 'buffer' local array is used to push data to user space from a
triggered buffer, but it does not set values for inactive channels, as
it only uses iio_for_each_active_channel() to assign new values.

Initialize the array to zero before using it to avoid pushing
uninitialized information to userspace.

Cc: stable@vger.kernel.org
Fixes: 61fa5dfa5f52 ("iio: adc: ti-ads8688: Fix alignment of buffer in iio_push_to_buffers_with_timestamp()")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20241125-iio_memset_scan_holes-v1-8-0cb6e98d895c@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads8688.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ti-ads8688.c
+++ b/drivers/iio/adc/ti-ads8688.c
@@ -384,7 +384,7 @@ static irqreturn_t ads8688_trigger_handl
 	struct iio_poll_func *pf = p;
 	struct iio_dev *indio_dev = pf->indio_dev;
 	/* Ensure naturally aligned timestamp */
-	u16 buffer[ADS8688_MAX_CHANNELS + sizeof(s64)/sizeof(u16)] __aligned(8);
+	u16 buffer[ADS8688_MAX_CHANNELS + sizeof(s64)/sizeof(u16)] __aligned(8) = { };
 	int i, j = 0;
 
 	for (i = 0; i < indio_dev->masklength; i++) {


