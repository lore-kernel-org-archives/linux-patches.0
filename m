Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51967346E5E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302626; cv=none; b=a3DamBgbpPoElaThc+57Ga4FP8MBtMh6r9plRjbO9NLmC03VYws5T/6yTD5dDIGrFT5f6J0q8V1y8a6eYUS4VkvA/+tWz+UDyLXq1LX9N24EHdEGQz7fDJ5OZ0OnxL+1IibCRaY8P0Keb9s8X0ulRE6a9pgQxb+Oa/lvxwAoMJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302626; c=relaxed/simple;
	bh=cj5WVFXXGOmzUVQeTmTdWQX7sfx6IJ4D+5CQeer7sH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FcbVRDmwO5Xl4pOCh9z7H7GgLDcFzrZN3OqAhltlM8r+huwQFlMq4h4ysDotsFLYWRTb9G3E8jKQcRJTZGgtbHjE2EWhsckEtKryR9ZaX+ONJC3j1O5BFmrchG1SwLvkC97jYPgDfW7GAV9YHpVRAvHRy9MZAlni0uJh87K4G5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GLtL5n3f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GLtL5n3f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3D0FC2BC87;
	Sat, 28 Feb 2026 18:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302626;
	bh=cj5WVFXXGOmzUVQeTmTdWQX7sfx6IJ4D+5CQeer7sH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLtL5n3f/3XP1dm+ydNB9wEH4F/To6gRA9B/K9kuDave3bYQiXNewiImrahCVzREP
	 Hf7n6r0nowtRnEd5ebUaDeD8iwDakW+c6B129Qk74yvJHa8BP9w9Lt1gcMPD3H3EU+
	 WT9MoFRzJNyPngLI4cg+XMGeTyKATkj4A9v07/+p2iEmG2wHbRZBczHnsHKpCPCT4x
	 /9ixbVP9eMHFNPkwXHeNfDD2cD/h0ba//J6srEaM+ml0ExgkOtccRUpLxK1gP+ZTeP
	 Q0j7Y9kd8+tgcXlYmWX3ISNBHeR1lbwio4rPmFx5eqI5hoR5shXtWWIMlRXiRcP4AW
	 AdZnmLUINdCQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/164] iio: sca3000: Fix a resource leak in sca3000_probe()
Date: Sat, 28 Feb 2026 13:14:44 -0500
Message-ID: <20260228181505.1600663-145-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index cb753a43533cd..9174269c7653b 100644
--- a/drivers/iio/accel/sca3000.c
+++ b/drivers/iio/accel/sca3000.c
@@ -1489,7 +1489,11 @@ static int sca3000_probe(struct spi_device *spi)
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

