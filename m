Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55BF932ED2A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301914; cv=none; b=MD4Hcoi5HX1CTNiipoh2AOP3wGlWrnGiDsZzdD1Dpf3nnPGWuHM1EiR5yyBdnxH/sc0dhe/Rk/cSLZ2bHkEW4h/fEZ77QFPX5T49bBq0Oo+VpeRkrsTvJUFgptNxsLSw0nPEl4BmVnOlwyB06rJdKD+JHuyNFq08kOPqc0SETxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301914; c=relaxed/simple;
	bh=oNnP7jEHEx/ez04Ua6X0OTzjvAmZLSA9NcxM1gcsYwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uByRM1eXyBx7YC83xzU9KH8YS4iWvoFVX/vGDl0XO2mhmxqfYU5QakB1nVWAJkOrRpb/j94Wjo826ZRsNLoQEisuY8EV/qg3NbMKwUEJQNzTqDo3YRcBNabrG80jlc9qpBWXoz35dh4n6RAsA0P+uMJMn0utd6PD9sW85P2pQYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ELBi67GB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ELBi67GB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FA9C19424;
	Sat, 28 Feb 2026 18:05:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301914;
	bh=oNnP7jEHEx/ez04Ua6X0OTzjvAmZLSA9NcxM1gcsYwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ELBi67GBrnsE3IZxN4TrmKv1Mr64E6nlxsW4FpjnCOhdJMtItud0Y940U+sVky2Je
	 1Fmbi9jCYiBOQY47YSLWQjq59p20nNh7SnhEUhv5y3Wm5vjSBeZ+dYK4tMAR70avcS
	 SAElYqW9eizb2s5Ju9rx61j4ham8kSSapllPj78nHnojSKBiMwu2Q9xjoQmdGBWY8D
	 IR6XllKWNVydV/1KeC3kRKT9i+gwMKyGm3NoednEXmzhypC2Xm+UQXwcYTXsaF3Ybs
	 1x+UX56nUg+Ow+EXwyTEUGupPMAL9aLnXJxrDg4G4WzhOXG+ThnlbOaYqHSjwxpF8b
	 9dmFtnjcOo57g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 346/385] iio: sca3000: Fix a resource leak in sca3000_probe()
Date: Sat, 28 Feb 2026 12:59:28 -0500
Message-ID: <20260228180011.1568201-346-sashal@kernel.org>
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

