Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE531F12F7;
	Tue,  3 Dec 2024 16:08:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242086; cv=none; b=cn8EW/iO9w+bT0LgC3hPXQ2xzxmN7Gh7OeLWPJ6UzsbdqUPEIsy8p8/XqCzQwJTuK1HVEQr2+yF+YgI1948iRbmL0qnZJ/OczSMwyn+PnrlkNPNtllYQG6KrW1PlyBe/aKA+Pfj0wLuhz/p337tZWf9IX+jHwkGUkhKLuXtDbF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242086; c=relaxed/simple;
	bh=y4XtsR+jC1aSBUyrikDzvZ2vluFNDR+iIZPZjA3DUrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dOAotQQrl05z6KZ54S3lM11+GGofpUenpe9IGgoUIt6yPJMqYB9ZYS1jUe7B196dXwNexkFhFORKfIK9T+65H3zEeA73kBDR9646In4oMaQa9Bslayf8MkhoBXvEqivXDj8n4iIwIKtzp84Ymg9bqUGmOLwM+oqaDAewS3b7zHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XHsFaIgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XHsFaIgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC7DC4CECF;
	Tue,  3 Dec 2024 16:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242085;
	bh=y4XtsR+jC1aSBUyrikDzvZ2vluFNDR+iIZPZjA3DUrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XHsFaIgSQPVhbpdp4wyZ8SHzcyOGerqa+1UDysyx48HXXY2KdLf4FBQ9Ah3e0Nl6o
	 +mDZ9T0l5ZtTW8gJssdjutHTaWyKySbXwkMp6e9Ve9bvnslMzIoa4OxMJIpT2YzKIU
	 FKWFREExr+3oToc+o/C8ibbnsCbsoKRi+vH3FEv0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antoniu Miclaus <antoniu.miclaus@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 603/826] iio: accel: adxl380: fix raw sample read
Date: Tue,  3 Dec 2024 15:45:30 +0100
Message-ID: <20241203144807.278049701@linuxfoundation.org>
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

From: Antoniu Miclaus <antoniu.miclaus@analog.com>

[ Upstream commit bfa335f18d91c52fa0f8ba3e4d49afebbd9ee792 ]

The adxl380_read_chn function returns either a negative value in case an
error occurs or the actual sample.

Check only for negative values after a channel is read.

Fixes: df36de13677a ("iio: accel: add ADXL380 driver")
Signed-off-by: Antoniu Miclaus <antoniu.miclaus@analog.com>
Link: https://patch.msgid.link/20241101095202.20121-1-antoniu.miclaus@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/adxl380.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/accel/adxl380.c b/drivers/iio/accel/adxl380.c
index f80527d899be4..b19ee37df7f12 100644
--- a/drivers/iio/accel/adxl380.c
+++ b/drivers/iio/accel/adxl380.c
@@ -1181,7 +1181,7 @@ static int adxl380_read_raw(struct iio_dev *indio_dev,
 
 		ret = adxl380_read_chn(st, chan->address);
 		iio_device_release_direct_mode(indio_dev);
-		if (ret)
+		if (ret < 0)
 			return ret;
 
 		*val = sign_extend32(ret >> chan->scan_type.shift,
-- 
2.43.0



