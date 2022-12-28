Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C33751C07
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:03:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44F88C433F2;
	Wed, 28 Dec 2022 16:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243410;
	bh=7BpzwdmDy+xaT05IDMCufGrbqVqTFHheSke/BsajTqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jWGDl8p38yckesABlLcasQVwT/FdNcjCdj76Lq5/F+Reoxq2jOJWecAg7USmApJ+E
	 SgYtE63Es2S7tVZgVw0iA4LrPEKgETF74FsVgozE8Akxw2n8xmpvzC0WH89x87sUcO
	 vXxNPgohcrl9NOsuJDgK0Cv1Bb9I7oUOF2nuKpsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zeng Heng <zengheng4@huawei.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 718/731] iio: fix memory leak in iio_device_register_eventset()
Date: Wed, 28 Dec 2022 15:43:45 +0100
Message-Id: <20221228144317.254764399@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zeng Heng <zengheng4@huawei.com>

commit 86fdd15e10e404e70ecb2a3bff24d70356d42b36 upstream.

When iio_device_register_sysfs_group() returns failed,
iio_device_register_eventset() needs to free attrs array.

Otherwise, kmemleak would scan & report memory leak as below:

unreferenced object 0xffff88810a1cc3c0 (size 32):
  comm "100-i2c-vcnl302", pid 728, jiffies 4295052307 (age 156.027s)
  backtrace:
    __kmalloc+0x46/0x1b0
    iio_device_register_eventset at drivers/iio/industrialio-event.c:541
    __iio_device_register at drivers/iio/industrialio-core.c:1959
    __devm_iio_device_register at drivers/iio/industrialio-core.c:2040

Fixes: 32f171724e5c ("iio: core: rework iio device group creation")
Signed-off-by: Zeng Heng <zengheng4@huawei.com>
Link: https://lore.kernel.org/r/20221115023712.3726854-1-zengheng4@huawei.com
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-event.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-event.c
+++ b/drivers/iio/industrialio-event.c
@@ -549,7 +549,7 @@ int iio_device_register_eventset(struct
 
 	ret = iio_device_register_sysfs_group(indio_dev, &ev_int->group);
 	if (ret)
-		goto error_free_setup_event_lines;
+		goto error_free_group_attrs;
 
 	ev_int->ioctl_handler.ioctl = iio_event_ioctl;
 	iio_device_ioctl_handler_register(&iio_dev_opaque->indio_dev,
@@ -557,6 +557,8 @@ int iio_device_register_eventset(struct
 
 	return 0;
 
+error_free_group_attrs:
+	kfree(ev_int->group.attrs);
 error_free_setup_event_lines:
 	iio_free_chan_devattr_list(&ev_int->dev_attr_list);
 	kfree(ev_int);


