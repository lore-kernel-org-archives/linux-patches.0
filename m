Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF670345CAA;
	Tue, 16 Dec 2025 12:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887663; cv=none; b=sThn/e4s5AmOa7g65Nw4QJSV15Hh9pOD7ACBr/EbDYEw+vV2px0EVqRwZfLZr/q7TE/Vm/Y/LgKwjXX+3RDtQbuLINZxqk6PIUdFXw//4zKcEkkT1GAHP3OTnJctboXnrvO9JW9zC86DYUyme3B2EFOcILf7z68JugEeGj863rU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887663; c=relaxed/simple;
	bh=DPFvvmMq7UrAuURi44czb9DfP0d64ZH6ZsoWj6IqYGc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PuZBNSmf4Zc275kLGlRevYfwuyK8eo0fiZqS90S91iYadTPLxOQknUH2Qj4ExMuH686h3YM63OcPb2i/pzdUJUV3jCeMhe5eabz63YR7WnZeLJgUMd0I8WSyj5sknBm+CBS6NpHwAZ0OAbpz/Xr63tnO3FQ7KvKSKFAHyRjPyaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RA8hRf5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RA8hRf5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31F9BC4CEF1;
	Tue, 16 Dec 2025 12:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887663;
	bh=DPFvvmMq7UrAuURi44czb9DfP0d64ZH6ZsoWj6IqYGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RA8hRf5F6djIq8ChGFMUd57HuTXBwgGM2S6jzKb9q7a3eDB1zD0oZYyr6DJwj3iVb
	 Q+uNNcZnm0L7qMyKDPa2e/edOezBylhB8pLjehnRn/ET8Dpirhr1PrMxq18BZ18wmB
	 0bOKPlhXLPtNBe4BeO/r8JjdGY2CuAU/Zs+sBhlY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 300/614] iio: core: Clean up device correctly on iio_device_alloc() failure
Date: Tue, 16 Dec 2025 12:11:07 +0100
Message-ID: <20251216111412.239275277@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit b0e6871415b25f5e84a79621834e3d0c9d4627a6 ]

Once we called device_initialize() we have to call put_device()
on it. Refactor the code to make it in the right order.

Fixes: fe6f45f6ba22 ("iio: core: check return value when calling dev_set_name()")
Fixes: 847ec80bbaa7 ("Staging: IIO: core support for device registration and management")
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/industrialio-core.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 93d6e5b101cf1..5d2f35cf18bc3 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1697,11 +1697,6 @@ struct iio_dev *iio_device_alloc(struct device *parent, int sizeof_priv)
 		ACCESS_PRIVATE(indio_dev, priv) = (char *)iio_dev_opaque +
 			ALIGN(sizeof(*iio_dev_opaque), IIO_DMA_MINALIGN);
 
-	indio_dev->dev.parent = parent;
-	indio_dev->dev.type = &iio_device_type;
-	indio_dev->dev.bus = &iio_bus_type;
-	device_initialize(&indio_dev->dev);
-
 	INIT_LIST_HEAD(&iio_dev_opaque->channel_attr_list);
 
 	iio_dev_opaque->id = ida_alloc(&iio_ida, GFP_KERNEL);
@@ -1727,6 +1722,11 @@ struct iio_dev *iio_device_alloc(struct device *parent, int sizeof_priv)
 	mutex_init(&iio_dev_opaque->mlock);
 	mutex_init(&iio_dev_opaque->info_exist_lock);
 
+	indio_dev->dev.parent = parent;
+	indio_dev->dev.type = &iio_device_type;
+	indio_dev->dev.bus = &iio_bus_type;
+	device_initialize(&indio_dev->dev);
+
 	return indio_dev;
 }
 EXPORT_SYMBOL(iio_device_alloc);
-- 
2.51.0



