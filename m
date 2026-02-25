Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9752311599;
	Wed, 25 Feb 2026 06:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002691; cv=none; b=tBuf7+IPgeTqxGiMQk4lWN+AqcKQk9/6Z+ApJOMOCRAveQzgphg/Qiryd8zNqf83GIaA+IyimDU8AudxTexoXW8+hLm6Eb8N0za1FrDj12vNPxCAoSKoUbWt7xcJpvfcSFTQ1ClvEH14sj+nR4FgkHP1dvw6/qJ5hBDECaq9fvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002691; c=relaxed/simple;
	bh=ySrb6A5RyWHDiUmqIsmNMsJs8Z3UcTNvYmUnh9Ygy5w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIZ6+Sf6/jiAp6InkCuYf1ziM8JvKBwGSNqLFE3XdnBz3kL+jDk7id/8B8twuWkBRrGJu6WdK1PWQM4PntC/WoYlLr2v2GwtkUC0XC7pBEIx1My8iJ6P+W9flMOUxqS3AxTsEH0cobws+Ph5/mDdXw6asEpuk7UMDDV6gsi98XQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCSig9b1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCSig9b1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921CAC19422;
	Wed, 25 Feb 2026 06:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002691;
	bh=ySrb6A5RyWHDiUmqIsmNMsJs8Z3UcTNvYmUnh9Ygy5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCSig9b1qaiK2/XoUcNl3QfaX7F4cZTPoiOZatZ7b+CD2NL0/39o27akdbPzWbHWO
	 SSaTAWJ3dpjfYvQOgebZzzh+Y+3aK8JJwerr++WnD2t+0CaSkQM93yg3BNlmeBnbPR
	 YTN5+5YxSV1ogQ5RPuyLC7dS6n7OPl2oUruGsmX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 485/641] iio: sca3000: Fix a resource leak in sca3000_probe()
Date: Tue, 24 Feb 2026 17:23:31 -0800
Message-ID: <20260225012400.269812190@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index bfa8a3f5a92f4..9ef4d6e274669 100644
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



