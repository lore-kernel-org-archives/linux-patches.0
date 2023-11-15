Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45F1D364C8
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="juufLhH8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0459C433C8;
	Wed, 15 Nov 2023 19:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077781;
	bh=z7Z9yZZkftoDIj6SHZQ+ED5/TVcby2v3tAHC1O+Jrpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juufLhH8K7A2rUpcgQWO3GXuuY4M3YfYL3jU79YUJ9rsQ2IFh54W2tkn2sXMrHUh8
	 Zy2pjyyx4CC416muZqrQbwT0BXmHcR6/sx+YenzRYdRDBvx7IqArtzPRQEYFagqSTH
	 sPJLDPPbk/gI2ARSYKWOtuUBQNLS/Q//eT8+BLc0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ira Weiny <ira.weiny@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 494/603] cxl/mem: Fix shutdown order
Date: Wed, 15 Nov 2023 14:17:19 -0500
Message-ID: <20231115191646.476040124@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

[ Upstream commit 88d3917f82ed4215a2154432c26de1480a61b209 ]

Ira reports that removing cxl_mock_mem causes a crash with the following
trace:

 BUG: kernel NULL pointer dereference, address: 0000000000000044
 [..]
 RIP: 0010:cxl_region_decode_reset+0x7f/0x180 [cxl_core]
 [..]
 Call Trace:
  <TASK>
  cxl_region_detach+0xe8/0x210 [cxl_core]
  cxl_decoder_kill_region+0x27/0x40 [cxl_core]
  cxld_unregister+0x29/0x40 [cxl_core]
  devres_release_all+0xb8/0x110
  device_unbind_cleanup+0xe/0x70
  device_release_driver_internal+0x1d2/0x210
  bus_remove_device+0xd7/0x150
  device_del+0x155/0x3e0
  device_unregister+0x13/0x60
  devm_release_action+0x4d/0x90
  ? __pfx_unregister_port+0x10/0x10 [cxl_core]
  delete_endpoint+0x121/0x130 [cxl_core]
  devres_release_all+0xb8/0x110
  device_unbind_cleanup+0xe/0x70
  device_release_driver_internal+0x1d2/0x210
  bus_remove_device+0xd7/0x150
  device_del+0x155/0x3e0
  ? lock_release+0x142/0x290
  cdev_device_del+0x15/0x50
  cxl_memdev_unregister+0x54/0x70 [cxl_core]

This crash is due to the clearing out the cxl_memdev's driver context
(@cxlds) before the subsystem is done with it. This is ultimately due to
the region(s), that this memdev is a member, being torn down and expecting
to be able to de-reference @cxlds, like here:

static int cxl_region_decode_reset(struct cxl_region *cxlr, int count)
...
                if (cxlds->rcd)
                        goto endpoint_reset;
...

Fix it by keeping the driver context valid until memdev-device
unregistration, and subsequently the entire stack of related
dependencies, unwinds.

Fixes: 9cc238c7a526 ("cxl/pci: Introduce cdevm_file_operations")
Reported-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Tested-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/memdev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index a02061028b710..fed9573cf355e 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -559,8 +559,8 @@ static void cxl_memdev_unregister(void *_cxlmd)
 	struct cxl_memdev *cxlmd = _cxlmd;
 	struct device *dev = &cxlmd->dev;
 
-	cxl_memdev_shutdown(dev);
 	cdev_device_del(&cxlmd->cdev, dev);
+	cxl_memdev_shutdown(dev);
 	put_device(dev);
 }
 
-- 
2.42.0



