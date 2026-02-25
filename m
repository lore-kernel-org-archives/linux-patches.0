Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C22671E2834;
	Wed, 25 Feb 2026 01:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983477; cv=none; b=cbRq5CFe8M1GLmkOPN+AwK/F8aCCaSc9gqxYzzl2ChENvnQKTJ9yCFYLBATSioET+GuielPmgUSdNKdpZ2RbVjRoQFgTXFckokOrQ3B0ew5p3BKlop224lPmofFjozJjlvESNNRtj53zb4VwUSXTWpk2MQDZZdG4l0BGaFKilBs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983477; c=relaxed/simple;
	bh=P3oUGoQqf7MiaVUlycS6VvfSp6+3+yoeKfEXxchKi70=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LtRRtjGN616ewg09L9Jt8sfwJqbptmtm55gcTRXmQ0ULpl+LqeoEQni72An1BVBMvxYbrcvHYWpcCUirSIoO5+V7QUvLmIUwwbgPIGq8VAoh9J+UmKO2hXTkrh+3m7InGihFToxkObvpo13jMd5nUCtdobBuAmh9ABkKjqTIu8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/5El8eQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/5El8eQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83473C116D0;
	Wed, 25 Feb 2026 01:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983477;
	bh=P3oUGoQqf7MiaVUlycS6VvfSp6+3+yoeKfEXxchKi70=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/5El8eQacIdw2/F5CGjLom84ijz9Q1s0mHSsgcIaGA+6ldZhIp0PygHmQMA5ycVz
	 h7+nYWngVDnCquwrAEi1ZeD+Ifpoo+cKpI6n3+xtrjqyyHSZmDey+jEBgqQlR0vNeI
	 qkwIsuKaCsrAlJmGGNNsnSTYsHadB9E+WVlu6edw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Svyatoslav Ryhel <clamor95@gmail.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 592/781] drivers: iio: mpu3050: use dev_err_probe for regulator request
Date: Tue, 24 Feb 2026 17:21:41 -0800
Message-ID: <20260225012414.318077716@linuxfoundation.org>
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
index 67ae7d1012bc2..ee2fcd20545de 100644
--- a/drivers/iio/gyro/mpu3050-core.c
+++ b/drivers/iio/gyro/mpu3050-core.c
@@ -1162,10 +1162,8 @@ int mpu3050_common_probe(struct device *dev,
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



