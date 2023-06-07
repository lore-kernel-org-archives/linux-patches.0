Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C524610FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:28:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42C91C433EF;
	Wed,  7 Jun 2023 20:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169734;
	bh=gSbcBNbOwZfJxOexHtXFEOBQ4Ysueu2dROvycjVgz5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t09u2iIQ4lVEzO9afu/ywSmRqfo+3cxMV40oiyvRsSqRNrrMvEikAARaLB0O1sobq
	 7YpxUCYtiSq5PG743cKLn9nwsjjcGVADzG6J5P3dApt+fDKKaFKicv3JFeZC+bkzPy
	 BeiMtKdgq4vL9Rl6dNKs9mgDBz+73jpVahHMZTv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lars-Peter Clausen <lars@metafoo.de>,
	Gerald Loacker <gerald.loacker@wolfvision.net>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.3 192/286] iio: tmag5273: Fix runtime PM leak on measurement error
Date: Wed,  7 Jun 2023 22:14:51 +0200
Message-ID: <20230607200929.537809289@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lars-Peter Clausen <lars@metafoo.de>

commit 265c82ea8b172129cb6d4eff41af856c3aff6168 upstream.

The tmag5273 gets a runtime PM reference before reading a measurement and
releases it when done. But if the measurement fails the tmag5273_read_raw()
function exits before releasing the reference.

Make sure that this error path also releases the runtime PM reference.

Fixes: 866a1389174b ("iio: magnetometer: add ti tmag5273 driver")
Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
Acked-by: Gerald Loacker <gerald.loacker@wolfvision.net>
Reviewed-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20230414013752.498767-1-lars@metafoo.de
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/magnetometer/tmag5273.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/magnetometer/tmag5273.c
+++ b/drivers/iio/magnetometer/tmag5273.c
@@ -296,12 +296,13 @@ static int tmag5273_read_raw(struct iio_
 			return ret;
 
 		ret = tmag5273_get_measure(data, &t, &x, &y, &z, &angle, &magnitude);
-		if (ret)
-			return ret;
 
 		pm_runtime_mark_last_busy(data->dev);
 		pm_runtime_put_autosuspend(data->dev);
 
+		if (ret)
+			return ret;
+
 		switch (chan->address) {
 		case TEMPERATURE:
 			*val = t;


