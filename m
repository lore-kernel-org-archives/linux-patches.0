Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3760E1549F
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:00:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77C08C433D2;
	Mon,  8 May 2023 10:00:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540025;
	bh=uFdnm6oDQNvJJlSMqWdEciZCwq9VWtlp2q1WAeJTGCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Rv7QtpS1OctDydfVooWFBPUZYWJ2AeHimFh2+OOAgUHBMzV8nGWhw1E/YX0L7qXt
	 u+mTkKVNJX2GYqSIujhRn6OyTMAqKG49yItDQjzzGl357LQcbT51jyrFiuE9odvwlF
	 EdGrw9dJFIWGhQ/YguOAl1ZFljv5MYJ4ivkpQqSE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/611] gpu: host1x: Fix memory leak of device names
Date: Mon,  8 May 2023 11:40:49 +0200
Message-Id: <20230508094429.109932336@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 55879dad0f3ae8468444b42f785ad79eac05fe5b ]

The device names allocated by dev_set_name() need be freed
before module unloading, but they can not be freed because
the kobject's refcount which was set in device_initialize()
has not be decreased to 0.

As comment of device_add() says, if it fails, use only
put_device() drop the refcount, then the name will be
freed in kobejct_cleanup().

device_del() and put_device() can be replaced with
device_unregister(), so call it to unregister the added
successfully devices, and just call put_device() to the
not added device.

Add a release() function to device to avoid null release()
function WARNING in device_release(), it's empty, because
the context devices are freed together in
host1x_memory_context_list_free().

Fixes: 8aa5bcb61612 ("gpu: host1x: Add context device management code")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/context.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/gpu/host1x/context.c b/drivers/gpu/host1x/context.c
index 291f34562e2e6..047696432eb21 100644
--- a/drivers/gpu/host1x/context.c
+++ b/drivers/gpu/host1x/context.c
@@ -13,6 +13,11 @@
 #include "context.h"
 #include "dev.h"
 
+static void host1x_memory_context_release(struct device *dev)
+{
+	/* context device is freed in host1x_memory_context_list_free() */
+}
+
 int host1x_memory_context_list_init(struct host1x *host1x)
 {
 	struct host1x_memory_context_list *cdl = &host1x->context_list;
@@ -53,28 +58,30 @@ int host1x_memory_context_list_init(struct host1x *host1x)
 		dev_set_name(&ctx->dev, "host1x-ctx.%d", i);
 		ctx->dev.bus = &host1x_context_device_bus_type;
 		ctx->dev.parent = host1x->dev;
+		ctx->dev.release = host1x_memory_context_release;
 
 		dma_set_max_seg_size(&ctx->dev, UINT_MAX);
 
 		err = device_add(&ctx->dev);
 		if (err) {
 			dev_err(host1x->dev, "could not add context device %d: %d\n", i, err);
-			goto del_devices;
+			put_device(&ctx->dev);
+			goto unreg_devices;
 		}
 
 		err = of_dma_configure_id(&ctx->dev, node, true, &i);
 		if (err) {
 			dev_err(host1x->dev, "IOMMU configuration failed for context device %d: %d\n",
 				i, err);
-			device_del(&ctx->dev);
-			goto del_devices;
+			device_unregister(&ctx->dev);
+			goto unreg_devices;
 		}
 
 		fwspec = dev_iommu_fwspec_get(&ctx->dev);
 		if (!fwspec || !device_iommu_mapped(&ctx->dev)) {
 			dev_err(host1x->dev, "Context device %d has no IOMMU!\n", i);
-			device_del(&ctx->dev);
-			goto del_devices;
+			device_unregister(&ctx->dev);
+			goto unreg_devices;
 		}
 
 		ctx->stream_id = fwspec->ids[0] & 0xffff;
@@ -82,9 +89,9 @@ int host1x_memory_context_list_init(struct host1x *host1x)
 
 	return 0;
 
-del_devices:
+unreg_devices:
 	while (i--)
-		device_del(&cdl->devs[i].dev);
+		device_unregister(&cdl->devs[i].dev);
 
 	kfree(cdl->devs);
 	cdl->devs = NULL;
@@ -98,7 +105,7 @@ void host1x_memory_context_list_free(struct host1x_memory_context_list *cdl)
 	unsigned int i;
 
 	for (i = 0; i < cdl->len; i++)
-		device_del(&cdl->devs[i].dev);
+		device_unregister(&cdl->devs[i].dev);
 
 	kfree(cdl->devs);
 	cdl->len = 0;
-- 
2.39.2



