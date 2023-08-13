Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7B9B9443
	for <patches@lists.linux.dev>; Sun, 13 Aug 2023 21:28:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D8C9C433C8;
	Sun, 13 Aug 2023 21:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691962133;
	bh=Cr9ZUSlMl1lnmSLYnJQh1VTBXkWsb0/BDXeYN2MNiOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ghpnQianc5Txp+FJzAaHyScyCDqnKtTwu4caNy9Dz2lOipxCGdFaBt4o8QkSXUbiY
	 272o4Yqm7xPDymPHTyH0EG0CZk/SKOS6NAojMm0ufejGnCER/eawjHUFs+LRjks+fT
	 zia8HEcT5Vcl7u0I8ot1hGfuwQqzW6kZM0qL5O3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Milan Zamazal <mzamazal@redhat.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.4 095/206] iio: core: Prevent invalid memory access when there is no parent
Date: Sun, 13 Aug 2023 23:17:45 +0200
Message-ID: <20230813211727.783594833@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230813211724.969019629@linuxfoundation.org>
References: <20230813211724.969019629@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Milan Zamazal <mzamazal@redhat.com>

commit b2a69969908fcaf68596dfc04369af0fe2e1d2f7 upstream.

Commit 813665564b3d ("iio: core: Convert to use firmware node handle
instead of OF node") switched the kind of nodes to use for label
retrieval in device registration.  Probably an unwanted change in that
commit was that if the device has no parent then NULL pointer is
accessed.  This is what happens in the stock IIO dummy driver when a
new entry is created in configfs:

  # mkdir /sys/kernel/config/iio/devices/dummy/foo
  BUG: kernel NULL pointer dereference, address: ...
  ...
  Call Trace:
  __iio_device_register
  iio_dummy_probe

Since there seems to be no reason to make a parent device of an IIO
dummy device mandatory, let’s prevent the invalid memory access in
__iio_device_register when the parent device is NULL.  With this
change, the IIO dummy driver works fine with configfs.

Fixes: 813665564b3d ("iio: core: Convert to use firmware node handle instead of OF node")
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Milan Zamazal <mzamazal@redhat.com>
Link: https://lore.kernel.org/r/20230719083208.88149-1-mzamazal@redhat.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1888,7 +1888,7 @@ static const struct iio_buffer_setup_ops
 int __iio_device_register(struct iio_dev *indio_dev, struct module *this_mod)
 {
 	struct iio_dev_opaque *iio_dev_opaque = to_iio_dev_opaque(indio_dev);
-	struct fwnode_handle *fwnode;
+	struct fwnode_handle *fwnode = NULL;
 	int ret;
 
 	if (!indio_dev->info)
@@ -1899,7 +1899,8 @@ int __iio_device_register(struct iio_dev
 	/* If the calling driver did not initialize firmware node, do it here */
 	if (dev_fwnode(&indio_dev->dev))
 		fwnode = dev_fwnode(&indio_dev->dev);
-	else
+	/* The default dummy IIO device has no parent */
+	else if (indio_dev->dev.parent)
 		fwnode = dev_fwnode(indio_dev->dev.parent);
 	device_set_node(&indio_dev->dev, fwnode);
 


