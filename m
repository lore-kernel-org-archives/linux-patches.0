Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6054E347FDF
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302457; cv=none; b=ZIVNSCEHmIgukovqGbV5+VDtVkQ2wUrgPaD4+5sfoe81GKFhqKf61aH8k37lSeOh/C7f+LgC5xzH7lxAr9oAHWYBHAhL9URG613/mk+QRJhIUpOQ8YMMXa/b5ABAYczd1u1AjfZ/BKWUWvBN/9HZGi3xUcMi6OzeCQEsgxgwALo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302457; c=relaxed/simple;
	bh=oNnP7jEHEx/ez04Ua6X0OTzjvAmZLSA9NcxM1gcsYwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6XC3wtllPboyr97EwTW4G8Y8hvQOcdClnR5F6skEuxbAjqCymKOl7w4w8cHVehp8mTJVp+yHra8sT19RF/1NvODCUZuq8J2m5sLngFYok384qxVdfQSDDlPQKHQ9kRPgDH9EJ/h9iDQcwX9xbNdMOs35cpfSVxmFIcUJ/nbqQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LQynwtYC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LQynwtYC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC113C19424;
	Sat, 28 Feb 2026 18:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302457;
	bh=oNnP7jEHEx/ez04Ua6X0OTzjvAmZLSA9NcxM1gcsYwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LQynwtYCqu+qiDgssSwtHzFsIhU/xdhhdAUY6ZX32k+hQVrU4Y/x6ecIVJprNRUMo
	 z24ZLIR50B6IN5k0OqeLteUqO8LCk0sz/PQ3qLX8A+0Fnk109kPUH1R0iHxKTx+Ndw
	 OEALj69CaIdhQlXhlPy5QfqyX0EYPfgXWXf7JOxL6M6jcHJ8esMj7J/XtO6oKO3xGK
	 jUsdQv/pssL2ml9iym0/IfXPHztxLUkhYyk0UeZjmVAgdc2wqEPEie/khEtde6rWi7
	 XxoykKdlbGCHHU+4ZtDypCH0ykdX7TUheBWocKvSTaWjB0J4vhAB7jJAyFqELSBToQ
	 bikm9Gd5Oy2LA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/232] iio: sca3000: Fix a resource leak in sca3000_probe()
Date: Sat, 28 Feb 2026 13:10:51 -0500
Message-ID: <20260228181127.1592657-198-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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

