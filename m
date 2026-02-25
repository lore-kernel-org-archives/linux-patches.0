Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179061D5141;
	Wed, 25 Feb 2026 01:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983514; cv=none; b=spUc7UxQ8droy4YmFjd9JNk/SDZn35qOSY0TJtFUAAHuNPlaWtEb5q8wtdtfm7YjASJvpPB8UVDur9kT7bp1hz4jSedzLR3y08JAW0VxagDFC9mzpCWv5mfjwP6/POeIVdCorkXwQbWnDbQKEZBJDg0IonEAaLGJAcy10+3+VfQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983514; c=relaxed/simple;
	bh=IjgV1Eg5xXCteAMTuSBvD84uAMQKL3Ew4kaWmV+q4MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jdXhcZFUyopSElZfCxl/PUl0qjTSqAo5l7xdhH9AbvNnrlIOrViS7SCJRnX52KFsBenB5a1OHya0/J71mINVoCGZXANPjxK8ECwVNHsklDw5Bq1PYnZB7fAAJ5eKmQxsxIovAqBMCKt+aBQUJAczC76+BENVL5zxA1mIfSJFv0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qDpmd6nG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qDpmd6nG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1CB1C116D0;
	Wed, 25 Feb 2026 01:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983513;
	bh=IjgV1Eg5xXCteAMTuSBvD84uAMQKL3Ew4kaWmV+q4MA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qDpmd6nGU1JZBUv8SwXl7+UGag2ig6znC+3RfZoSrIkUMK7KjXs4KYROVjj4WD6v4
	 uu6OgJ0FbtbhzN5gZO//akYbW8mmW5/biMGFbLM9nn7Rn68n506+yGB4WTK+6SHyRN
	 DL6+3C5nE9W7Bduoq5B+e0oDuildKNT0n6t2eNMc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Petre Rodan <petre.rodan@subdimension.ro>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 579/781] iio: pressure: mprls0025pa: fix interrupt flag
Date: Tue, 24 Feb 2026 17:21:28 -0800
Message-ID: <20260225012413.999554105@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petre Rodan <petre.rodan@subdimension.ro>

[ Upstream commit fff3f1a7d805684e4701a70bfaeba39622b59dbc ]

Interrupt falling/rising flags should only be defined in the device tree.

Fixes: 713337d9143e ("iio: pressure: Honeywell mprls0025pa pressure sensor")
Signed-off-by: Petre Rodan <petre.rodan@subdimension.ro>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/pressure/mprls0025pa.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/pressure/mprls0025pa.c b/drivers/iio/pressure/mprls0025pa.c
index 2336f2760eaeb..4b23f87a822b1 100644
--- a/drivers/iio/pressure/mprls0025pa.c
+++ b/drivers/iio/pressure/mprls0025pa.c
@@ -418,10 +418,8 @@ int mpr_common_probe(struct device *dev, const struct mpr_ops *ops, int irq)
 	data->offset = div_s64_rem(offset, NANO, &data->offset2);
 
 	if (data->irq > 0) {
-		ret = devm_request_irq(dev, data->irq, mpr_eoc_handler,
-				       IRQF_TRIGGER_RISING,
-				       dev_name(dev),
-				       data);
+		ret = devm_request_irq(dev, data->irq, mpr_eoc_handler, 0,
+				       dev_name(dev), data);
 		if (ret)
 			return dev_err_probe(dev, ret,
 					  "request irq %d failed\n", data->irq);
-- 
2.51.0



