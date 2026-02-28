Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CA933A03F
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301910; cv=none; b=BI3qKEzG4nZfx0liFekljDVUe7jzALakNYALM/QC58aSb5xJeKRUgOoXJ7JzlWvuMS+DMAn/coWZ56wwXWBg5FlkMsJiiWXAuDSnVOSUqPcCIk7YRmoC09MGLlswxxQccad5sQXnTxeByXKrbS12aUychTQauKUfRjq9t8LwiEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301910; c=relaxed/simple;
	bh=sibmR26qkbLRR9WPp9gh1ecBWa6uN53FRacC0ZmYd6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kp37uA6ZeKaJuc99nrbvcgCoAeD9ISm2mB0IkEIPP/IWDgG8b4RTf6Ph3QOD42uw5iKGpvnJSl/cjTTUYA/D2tOc7OyWwF37388KOHhs7mTMw61ErH9lP1hbEQonzEhje3jioMwJ69lcH+naFTm+OPye6WTYTmAua/K6KuLp8yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G01YuNsj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G01YuNsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11179C19423;
	Sat, 28 Feb 2026 18:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301910;
	bh=sibmR26qkbLRR9WPp9gh1ecBWa6uN53FRacC0ZmYd6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G01YuNsjgWfkss3MeSFf1x8LVEVXXeBpSD6QT40tP0F+Bf6qP5gQ3DXhtHxNjowIB
	 JuRdy1N2tqwMgn4CsVvbEuqNvftaGrLDAIVYmOWwP/sjuKCOcl7cnB+0Pawqi4YmC7
	 svjy1NvkdLMnAe78G4a6z6rQ8qPBBlpKunUdVaQhYXds1X83Lo1IwwGtOKiireH8dR
	 ZS178NNF+hXrF5w4OdWdM5Au9tqpXPUae/am0N8dVFwUvbIsSISCtGKzeP1H4yRpoo
	 am27qCKgbeieYtCh1T+SY/cu2Df71SmuwM6Iz/o13Z8bnoL5uIWTwux4CeZQn8FMH5
	 1BK6jVN0p16VQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Svyatoslav Ryhel <clamor95@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 342/385] drivers: iio: mpu3050: use dev_err_probe for regulator request
Date: Sat, 28 Feb 2026 12:59:24 -0500
Message-ID: <20260228180011.1568201-342-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
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
index 35af68b41408f..4dcd0cc545518 100644
--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -1165,10 +1165,8 @@ int mpu3050_common_probe(struct device *dev,
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

