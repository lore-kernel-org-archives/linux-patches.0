Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 893E2381A5
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWNvv9qZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33FFBC4E776;
	Wed, 15 Nov 2023 20:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081552;
	bh=rf2bAOSgdAY9GtCzCQG1+nYUcNAVQ9dcW/DJ4kJTNzA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWNvv9qZ0actDQc2oUOXN8h39jjyEnKVzrazhksnJBnnOcu2TgDCzAbNqLrDyOm2C
	 vp2mLR0/P96YPzBDiFUcQARL1DgC2UXRYEt4EqrkpRmcjUjAy353WDzFXC/6681sv1
	 XqtxR/Vpo8/R0B+Qa+4p6AJQmu8ZVrz9K04xyGlk=
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
Subject: [PATCH 5.15 196/244] cxl/mem: Fix shutdown order
Date: Wed, 15 Nov 2023 15:36:28 -0500
Message-ID: <20231115203600.156064434@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/core/memdev.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -139,10 +139,9 @@ static void cxl_memdev_unregister(void *
 	struct cdev *cdev = &cxlmd->cdev;
 	const struct cdevm_file_operations *cdevm_fops;
 
+	cdev_device_del(&cxlmd->cdev, dev);
 	cdevm_fops = container_of(cdev->ops, typeof(*cdevm_fops), fops);
 	cdevm_fops->shutdown(dev);
-
-	cdev_device_del(&cxlmd->cdev, dev);
 	put_device(dev);
 }
 


