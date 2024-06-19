Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F04B82495;
	Wed, 19 Jun 2024 13:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718803225; cv=none; b=A4xRj7vY5KH1+8Ei8hCVwY6EciDmU1i8SNVFT1wywp0PiXOcqzqbtUDa289TQcDZUy/94LJNiGy73uUDWh3la6PsELCo8EfoipSzQdupQuz3FkEEZvQz6N4sofpjW2fRJe2X0qYftCRx7Xv+XKOuKazqQy7hcF7RxVTePRIJja0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718803225; c=relaxed/simple;
	bh=bbNcgGhRhWqmC5DOxqEaloZJwSzNk0OTrFKkgkO3Z3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oIc8wLYMNR9ggdBj7oQYqLpNp7F6s3VyJoEJDvB6e2WU6JehX9AvFvFVwduqeIuY0vha0gTxIi3yrkb2pSS3yaMQkWb7vrCRwEMJZ83i98BEyuQajacZh+wnNkjqAFHvjcs4NOH+Sm2WFSwedlMpa96SiOzYmiq3LrlbMFT4+34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i0/G8NGf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i0/G8NGf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20585C32786;
	Wed, 19 Jun 2024 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718803225;
	bh=bbNcgGhRhWqmC5DOxqEaloZJwSzNk0OTrFKkgkO3Z3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i0/G8NGfUvciq+fddsWdRwiX9f6/3OthdAQ6usZrCyw58oxW0Pm1tKNCs674SxKaZ
	 Su0DdKDhj89qCbEh7UpkkRAyrtve18o4tSi4zy0cHlpaRtj+l03fx06gaa9l2aNcad
	 ssJbpjYD9WTvfymDcHwcNgEBRt54fw7dHpnbPIzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vasileios Amoiridis <vassilisamir@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 195/281] iio: imu: bmi323: Fix trigger notification in case of error
Date: Wed, 19 Jun 2024 14:55:54 +0200
Message-ID: <20240619125617.455356863@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

From: Vasileios Amoiridis <vassilisamir@gmail.com>

commit bedb2ccb566de5ca0c336ca3fd3588cea6d50414 upstream.

In case of error in the bmi323_trigger_handler() function, the
function exits without calling the iio_trigger_notify_done()
which is responsible for informing the attached trigger that
the process is done and in case there is a .reenable(), to
call it.

Fixes: 8a636db3aa57 ("iio: imu: Add driver for BMI323 IMU")
Signed-off-by: Vasileios Amoiridis <vassilisamir@gmail.com>
Link: https://lore.kernel.org/r/20240508155407.139805-1-vassilisamir@gmail.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/bmi323/bmi323_core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/imu/bmi323/bmi323_core.c
+++ b/drivers/iio/imu/bmi323/bmi323_core.c
@@ -1391,7 +1391,7 @@ static irqreturn_t bmi323_trigger_handle
 				       &data->buffer.channels,
 				       ARRAY_SIZE(data->buffer.channels));
 		if (ret)
-			return IRQ_NONE;
+			goto out;
 	} else {
 		for_each_set_bit(bit, indio_dev->active_scan_mask,
 				 BMI323_CHAN_MAX) {
@@ -1400,13 +1400,14 @@ static irqreturn_t bmi323_trigger_handle
 					      &data->buffer.channels[index++],
 					      BMI323_BYTES_PER_SAMPLE);
 			if (ret)
-				return IRQ_NONE;
+				goto out;
 		}
 	}
 
 	iio_push_to_buffers_with_timestamp(indio_dev, &data->buffer,
 					   iio_get_time_ns(indio_dev));
 
+out:
 	iio_trigger_notify_done(indio_dev->trig);
 
 	return IRQ_HANDLED;


