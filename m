Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C867936C9D0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302235; cv=none; b=pNuUoCzeWZWkG5wJGhoQBiTjCfFMCYHPxy0yNWjAovybbmyVFrw8tSsFyP1kK4ow+knMy3Elr2lIJSSo2qpmOGQ+/hjwXsmrFehYE/cWyrpMdL2HpMRB81ck4Gsq9My9OQLPODDMF9un6rREEqrU17JiD72JIhsYf+u83/SX9tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302235; c=relaxed/simple;
	bh=oNnP7jEHEx/ez04Ua6X0OTzjvAmZLSA9NcxM1gcsYwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FHYproZ4DkFQGICWFbr9IW+xlNohXuZdMITecBe4YjebcBLCebHaWolEewLJlrceGuIFsn9UZ5453QkFgkkW67rDVdqsQDwxHsokUgyIfOrPgthlw6M+IU2nm6tM3lS3EgTsLucsxdFEx/I8Zx7pbCBcxjy9Xaso9XBbnWie00I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DzUV+oYc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DzUV+oYc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20AEDC116D0;
	Sat, 28 Feb 2026 18:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302235;
	bh=oNnP7jEHEx/ez04Ua6X0OTzjvAmZLSA9NcxM1gcsYwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DzUV+oYcLzU31rmw5hhCJCPkYw/A6cmfHf/dcInyI582xuy0tHdqIOPQqLvBrrGob
	 070H22qWSuKPGF2PRtF5hshsGiX/ZgsDGdZwp8y3L1Z5sUb/Z4tn0P3SoyjAFSlcCF
	 1Ak+Vdk29X7Bv+3koClDrhEATPAJ0sx1K8Au76/ybvE2aN8aqd7z12TVhhliZSFrDl
	 TwYPNUYmxewCfb37q8H78Mw9PVK3yTy6Yy8Bsmn+cvzQu9kLvWD8P+apE0XD5wBc8D
	 6Qs62W3IV3O465PtbrgrcHKhDmiJiqA1sRYlaK9mXR+d41fPj6TcXW5Yp3aC6QhnDX
	 RQZ1fdr/lzR6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 246/283] iio: sca3000: Fix a resource leak in sca3000_probe()
Date: Sat, 28 Feb 2026 13:06:28 -0500
Message-ID: <20260228180709.1583486-246-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 87c54e41f6ccd..2b87f7f5508bb 100644
--- a/drivers/iio/accel/sca3000.c
+++ b/drivers/iio/accel/sca3000.c
@@ -1496,7 +1496,11 @@ static int sca3000_probe(struct spi_device *spi)
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

