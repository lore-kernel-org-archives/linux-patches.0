Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549DB1DB142;
	Wed, 15 Jan 2025 10:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938404; cv=none; b=A8v0hWLDrAJUywTKtjETx07Xl3T5DDZcVeGsd16CTj1j+aW6zIQM2taEUQ0zKN4GazL7sXmKGBJJ0mqK0MJfpKTgJ5Dhj4Qi80RJcPIyDsYgsnzwHpQyT38GT6Gmx72BNYUk1unH8hEjoyFG0SKwUQNRcQWjARHpYTq2K/aLqkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938404; c=relaxed/simple;
	bh=uRGYcRnXwcuO7y54xG+EtU+8j1iG0qge34FuxYROSY0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VVcC/lRsd9CNdN7wRktiGhe6LJ4FnoHA0N/gp+QO+jRqNNfhrLWSA3mE0aEKOYRwfTkQoaR5lGik7lsqxaTeFPZpZFwsURZ8iLEtcT/395nDqrLcFBMl493haN+d17bucXi3Mhy2b+1Z66GMPfNhlxQR0J3Kgl0X06nB8CH0whI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ut4Rk1PD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ut4Rk1PD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D472BC4CEDF;
	Wed, 15 Jan 2025 10:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938404;
	bh=uRGYcRnXwcuO7y54xG+EtU+8j1iG0qge34FuxYROSY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ut4Rk1PDo4XmzLJJxMftatx/Z+Jz2tA4k5SyB5gLo68Rt5xOCNx1oxw6rbIQ4Kmim
	 bg7GZdRI8BsxBkJ4MFvYJUYZlovr/Dv5Kf9DrLE3nQIo6ubCm/LRGxK+qeHasHL/IO
	 etrxZ8mXl9vCvTx1M1rXA4TmBV9duWTVs4TIbj3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 173/189] iio: adc: ad7124: Disable all channels at probe time
Date: Wed, 15 Jan 2025 11:37:49 +0100
Message-ID: <20250115103613.307820468@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>

commit 4be339af334c283a1a1af3cb28e7e448a0aa8a7c upstream.

When during a measurement two channels are enabled, two measurements are
done that are reported sequencially in the DATA register. As the code
triggered by reading one of the sysfs properties expects that only one
channel is enabled it only reads the first data set which might or might
not belong to the intended channel.

To prevent this situation disable all channels during probe. This fixes
a problem in practise because the reset default for channel 0 is
enabled. So all measurements before the first measurement on channel 0
(which disables channel 0 at the end) might report wrong values.

Fixes: 7b8d045e497a ("iio: adc: ad7124: allow more than 8 channels")
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
Link: https://patch.msgid.link/20241104101905.845737-2-u.kleine-koenig@baylibre.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7124.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iio/adc/ad7124.c
+++ b/drivers/iio/adc/ad7124.c
@@ -917,6 +917,9 @@ static int ad7124_setup(struct ad7124_st
 		 * set all channels to this default value.
 		 */
 		ad7124_set_channel_odr(st, i, 10);
+
+		/* Disable all channels to prevent unintended conversions. */
+		ad_sd_write_reg(&st->sd, AD7124_CHANNEL(i), 2, 0);
 	}
 
 	ret = ad_sd_write_reg(&st->sd, AD7124_ADC_CONTROL, 2, st->adc_control);


