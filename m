Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625E51F12F7;
	Tue,  3 Dec 2024 16:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242079; cv=none; b=Q8zgmQ1I7qZ94cRfXlQpW9SXGoLdWTrHvWHRT2SvWZNJ9x5LBOhzdjxmGwQbjpBmyKxmAPi3EoT8NTwCZpIzvlCKhB9/ylZCoNR/9l9oY0oMH+djub86/z9eNioXVgAp80siYyIJx+9IqO9ARXMbMb5oEmqHxt7ApGN3hAnPxiY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242079; c=relaxed/simple;
	bh=e2Rvau8LMOnssE8W/BLygzCXbPQb8/mFu5i/3wgt6nM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HY7/9OUPTDH5Prpbe2QInB2TlMqXnTT7fRSZ7AupSUclXOAfDALQV80gibcJj7T1M0HaIKFof1t1sY13JiZUPzp13t2AlD0ZYVcrTLZdNg6eR1REItNCMu9QmcHquHtbAmcDhyzUumwuoic/j9pvBM0RwhojrgIvbF+3qaP+TSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BaORvhKQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BaORvhKQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48FAC4CED6;
	Tue,  3 Dec 2024 16:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242079;
	bh=e2Rvau8LMOnssE8W/BLygzCXbPQb8/mFu5i/3wgt6nM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BaORvhKQ860zEKLgsLbC2epXojruwMg9VzylMU3DywxGYKLUgTzk/nuATR+v1kMgx
	 jGv85qC3hFUZe/MHm6cKaN97h+4DVSmCoomEFGS2AggnlUI9iNhWEjPMjpUaAMMPAU
	 fXQvYSXSD3diD9Sjd+bcuA/iHC4PxxH2Z1Li5yMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 601/826] iio: adc: ad4000: Check for error code from devm_mutex_init() call
Date: Tue,  3 Dec 2024 15:45:28 +0100
Message-ID: <20241203144807.200787211@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 8ebfd09255219ae55f8a101f6aeb0f64dd780d88 ]

Even if it's not critical, the avoidance of checking the error code
from devm_mutex_init() call today diminishes the point of using devm
variant of it. Tomorrow it may even leak something. Add the missed
check.

Fixes: 938fd562b974 ("iio: adc: Add support for AD4000")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://patch.msgid.link/20241030162013.2100253-2-andriy.shevchenko@linux.intel.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad4000.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ad4000.c b/drivers/iio/adc/ad4000.c
index fc9c9807f89d2..b3b82535f5c14 100644
--- a/drivers/iio/adc/ad4000.c
+++ b/drivers/iio/adc/ad4000.c
@@ -639,7 +639,9 @@ static int ad4000_probe(struct spi_device *spi)
 	indio_dev->name = chip->dev_name;
 	indio_dev->num_channels = 1;
 
-	devm_mutex_init(dev, &st->lock);
+	ret = devm_mutex_init(dev, &st->lock);
+	if (ret)
+		return ret;
 
 	st->gain_milli = 1000;
 	if (chip->has_hardware_gain) {
-- 
2.43.0



