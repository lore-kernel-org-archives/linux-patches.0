Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2089235AC28
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302760; cv=none; b=bKSzqUbDFVsthHc3GePaOsLQZ2xrRNSFYK/WPhhMZ8E3482YQ9Tzkh9S0ZviQEynmj410DDPhjhowZqCjMeZVnBkK87ARWXHWAm54EOlGYqo3woe+GIw6kg+03T0gV0fTpgx4xsBTpRlHmz8ozxwMQP5e2Txzu2R0918/AT2ZRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302760; c=relaxed/simple;
	bh=E9eW5ErHLkvilAYMwJOaKYQsIyu4pcvHiZv2fo0Lt6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khHaDEBD7/OCOG4kAU+us4wfcobNVu4LzTmu2fywy7E3sMo2HS7HOxKaCwibKGtjjwmON/WLOVj7nmeWoji72VzhgxJpfrYxKcUMIAKpnPSoLLnT6NsbmV1yqyxUpmoBWBoEAp+Zpd4F/SSGO5hcovlwZhurlOZJfvW4yszvUiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZxFaEZ9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZxFaEZ9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71DB9C19423;
	Sat, 28 Feb 2026 18:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302760;
	bh=E9eW5ErHLkvilAYMwJOaKYQsIyu4pcvHiZv2fo0Lt6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZxFaEZ9sAoonJ4J02m2ixld4ucWyiMitsMxcFeEzGiwoXP46dHnzAoTJO6JOmVQ1K
	 1Q0DxRkqxvgG2eplfh/dpSPhVhIyb64+Go26W9zFI5ux98SAqG8B7ghjfR2y2OIFyn
	 e1BkBIbWuVntWHSxWsMKeRpH4p4uFDigxOdKBKKIMwsGV5fhwYtgG2QieDk9uk4oCg
	 IZKQVjBasVq6mKJ6ixHuB67ZJ/TdquAO6Zu6QeyhSSpccFQ+oPwamilpR3NkEho8uj
	 gr+hOj3tmje+lM0AAQCtj3S5UsYvhouJQGcGb6pmPuWc8XqsjfyKV4dmBLVLjvPdGd
	 7voRTMgY1bTjw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Svyatoslav Ryhel <clamor95@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/147] drivers: iio: mpu3050: use dev_err_probe for regulator request
Date: Sat, 28 Feb 2026 13:17:18 -0500
Message-ID: <20260228181736.1605592-130-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Svyatoslav Ryhel <clamor95@gmail.com>

[ Upstream commit b010880b9936da14f8035585ab57577aa05be23a ]

Regulator requesting may result in deferred probing error which will
abort driver probing. To avoid this just use dev_err_probe which handles
deferred probing.

Fixes: 3904b28efb2c ("iio: gyro: Add driver for the MPU-3050 gyroscope")
Signed-off-by: Svyatoslav Ryhel <clamor95@gmail.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/gyro/mpu3050-core.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/iio/gyro/mpu3050-core.c b/drivers/iio/gyro/mpu3050-core.c
index 84c6ad4bcccba..7803173c50639 100644
--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -1170,10 +1170,8 @@ int mpu3050_common_probe(struct device *dev,
 	mpu3050->regs[1].supply = mpu3050_reg_vlogic;
 	ret = devm_regulator_bulk_get(dev, ARRAY_SIZE(mpu3050->regs),
 				      mpu3050->regs);
-	if (ret) {
-		dev_err(dev, "Cannot get regulators\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "Cannot get regulators\n");
 
 	ret = mpu3050_power_up(mpu3050);
 	if (ret)
-- 
2.51.0

