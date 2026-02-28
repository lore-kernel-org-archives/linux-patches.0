Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D65BE35AC28
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302763; cv=none; b=MO/7Jw1Jg+kxR4+jG1XcKsPpsA8Fh28tWXDD6plgNl29pB2oFxKwn4YunItfcgAyHWjmKdKsOinLBsYGVgWWuWAeHcRFDUjPzvbkdU7kI9jV1t29DKvwJJD2XhL2bGgaKdq74fYOs6JyZ/UHABuwSsOCC+/Qr5ZbOrBO98Y1DMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302763; c=relaxed/simple;
	bh=Y+7EBLlx3XvRZIAFGAYWoimeyMNTYn2SPBM1t1h4aPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rRyXF3J7d57dDXCe2MSEfKteTNy9ITc/CJ2EewQ4msfpkI2YspxI5xdkOh/WSKnyNk4HN4D422ZcLTB7vJ4uZCIWlgVcg0u37oBXXTGRZj9bl2+C6UeJm86DRoysXXS7TSs0Xbfs8x2DQH5vQjX8rxK3tTIOfMQwzCBpdLzO9Dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QEQT7p/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QEQT7p/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0783FC116D0;
	Sat, 28 Feb 2026 18:19:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302763;
	bh=Y+7EBLlx3XvRZIAFGAYWoimeyMNTYn2SPBM1t1h4aPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QEQT7p/0zZhtHGsS2+NUK91Ek+etP/4RbP3pIxnsHOYn1hoKRsPFD51tjVzEj/aSm
	 gs3WG23rzOFyZLRCc2VBXARg2M9zRBLnULIVrLf8/eINjesCQXCu2b4KLSZcM8/bqz
	 08sxRjVrsbd99GAhrBoT0DkTJm2ahpZE7rHNStdSHxEGIGUl7KnGrUJKnhE+m7DasX
	 3PHHXFbYk2OUcukCwxODQl/6HOfhzPWby4ct8DN32Kf7bwkJIxccw9SYTkURqd/Viu
	 a7DPdqt/gQ+5vvV6ud7YrThrcIhIKTEWBwO6iRWESnXJuWKYtRCeWBDso1CgQtI4Yg
	 wKOlFk3adipBQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/147] iio: sca3000: Fix a resource leak in sca3000_probe()
Date: Sat, 28 Feb 2026 13:17:22 -0500
Message-ID: <20260228181736.1605592-134-sashal@kernel.org>
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

From: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

[ Upstream commit 62b44ebc1f2c71db3ca2d4737c52e433f6f03038 ]

spi->irq from request_threaded_irq() not released when
iio_device_register() fails. Add an return value check and jump to a
common error handler when iio_device_register() fails.

Fixes: 9a4936dc89a3 ("staging:iio:accel:sca3000 Tidy up probe order to avoid a race.")
Signed-off-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/accel/sca3000.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/accel/sca3000.c b/drivers/iio/accel/sca3000.c
index 194738660523d..10a4bf32918a7 100644
--- a/drivers/iio/accel/sca3000.c
+++ b/drivers/iio/accel/sca3000.c
@@ -1502,7 +1502,11 @@ static int sca3000_probe(struct spi_device *spi)
 	if (ret)
 		goto error_free_irq;
 
-	return iio_device_register(indio_dev);
+	ret = iio_device_register(indio_dev);
+	if (ret)
+		goto error_free_irq;
+
+	return 0;
 
 error_free_irq:
 	if (spi->irq)
-- 
2.51.0

