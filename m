Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7553D34403E
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301869; cv=none; b=m21s6hKKx7ZdhikPQozELac3RJX2cNjvReEh9EaHgncJxJ/giyTcSo2cpBSLiU9LVF6iMr4ZWyuzKo74AGtlK1iK1200aXKcDjfZltIfg6XmfnXsb0SM1bn9KHUPaLNiGM1gdVHVtXZvm7doxPz9xpGHhtr1qL8JO4pQN52jN+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301869; c=relaxed/simple;
	bh=1NQb8Yx0yK2ImUcbxRPFSawaCwZSgKe6Ur7h/zC8Y/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CGNwtA6FgbqAXMCJO18p9q5cUaW96rkiTwcvp3Wojs7z5IVQhBkCOftADBftvbyBwQC23Q73UaZ32/t3DZRKKyLEmSDfg8OxkGQsg4io67IyZommydJGkM9rfqCiSrRdR8FOK0+tO9mi6H368UtByMf81ZbfRK143ZndcTHACV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SaJZIZST; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SaJZIZST"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE28C116D0;
	Sat, 28 Feb 2026 18:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301869;
	bh=1NQb8Yx0yK2ImUcbxRPFSawaCwZSgKe6Ur7h/zC8Y/o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SaJZIZST/SQr2DV0Wv1Rcae5YVku+SvIFliGmD0ZijbfWE7WmSc64JUio6Xw0JtFL
	 cLSnOfvi9aPfO3kA+5UeTbrY0kY47X0zZ8fFhbsDpKRIFL82R4m0e1fkfVou2mUylP
	 f5KAXpon1J2uNsjpJaeAcOMQpxHT2LU8Aa/E/yEdDu9bEXbw6zIkpLB/xcfsU7n3uI
	 ixsg2F2B7o50ewXIiEXT06DVQQNLEMaQzii/ywc2y2RrJs8pJIPfoKK42m8t+BmFrr
	 dfO1JajsXwobFzmggUH0xcR6rzgnAin/oKLh7jBs0JLP54Xn3m1kFebaIo+gqFje3I
	 rNl1fabGSDvdw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Li Chen <me@linux.beauty>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 293/385] nvdimm: virtio_pmem: serialize flush requests
Date: Sat, 28 Feb 2026 12:58:35 -0500
Message-ID: <20260228180011.1568201-293-sashal@kernel.org>
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

From: Li Chen <me@linux.beauty>

[ Upstream commit a9ba6733c7f1096c4506bf4e34a546e07242df74 ]

Under heavy concurrent flush traffic, virtio-pmem can overflow its request
virtqueue (req_vq): virtqueue_add_sgs() starts returning -ENOSPC and the
driver logs "no free slots in the virtqueue". Shortly after that the
device enters VIRTIO_CONFIG_S_NEEDS_RESET and flush requests fail with
"virtio pmem device needs a reset".

Serialize virtio_pmem_flush() with a per-device mutex so only one flush
request is in-flight at a time. This prevents req_vq descriptor overflow
under high concurrency.

Reproducer (guest with virtio-pmem):
  - mkfs.ext4 -F /dev/pmem0
  - mount -t ext4 -o dax,noatime /dev/pmem0 /mnt/bench
  - fio: ioengine=io_uring rw=randwrite bs=4k iodepth=64 numjobs=64
        direct=1 fsync=1 runtime=30s time_based=1
  - dmesg: "no free slots in the virtqueue"
           "virtio pmem device needs a reset"

Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
Signed-off-by: Li Chen <me@linux.beauty>
Acked-by: Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Link: https://patch.msgid.link/20260203021353.121091-1-me@linux.beauty
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvdimm/nd_virtio.c   | 3 ++-
 drivers/nvdimm/virtio_pmem.c | 1 +
 drivers/nvdimm/virtio_pmem.h | 4 ++++
 3 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/nvdimm/nd_virtio.c b/drivers/nvdimm/nd_virtio.c
index f55d60922b87d..e8ac7425c97cd 100644
--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -44,6 +44,8 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 	unsigned long flags;
 	int err, err1;
 
+	guard(mutex)(&vpmem->flush_lock);
+
 	/*
 	 * Don't bother to submit the request to the device if the device is
 	 * not activated.
@@ -53,7 +55,6 @@ static int virtio_pmem_flush(struct nd_region *nd_region)
 		return -EIO;
 	}
 
-	might_sleep();
 	req_data = kmalloc(sizeof(*req_data), GFP_KERNEL);
 	if (!req_data)
 		return -ENOMEM;
diff --git a/drivers/nvdimm/virtio_pmem.c b/drivers/nvdimm/virtio_pmem.c
index c9b97aeabf854..89d3d4fc3ce89 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -64,6 +64,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
 		goto out_err;
 	}
 
+	mutex_init(&vpmem->flush_lock);
 	vpmem->vdev = vdev;
 	vdev->priv = vpmem;
 	err = init_vq(vpmem);
diff --git a/drivers/nvdimm/virtio_pmem.h b/drivers/nvdimm/virtio_pmem.h
index 0dddefe594c46..f72cf17f9518f 100644
--- a/drivers/nvdimm/virtio_pmem.h
+++ b/drivers/nvdimm/virtio_pmem.h
@@ -13,6 +13,7 @@
 #include <linux/module.h>
 #include <uapi/linux/virtio_pmem.h>
 #include <linux/libnvdimm.h>
+#include <linux/mutex.h>
 #include <linux/spinlock.h>
 
 struct virtio_pmem_request {
@@ -35,6 +36,9 @@ struct virtio_pmem {
 	/* Virtio pmem request queue */
 	struct virtqueue *req_vq;
 
+	/* Serialize flush requests to the device. */
+	struct mutex flush_lock;
+
 	/* nvdimm bus registers virtio pmem device */
 	struct nvdimm_bus *nvdimm_bus;
 	struct nvdimm_bus_descriptor nd_desc;
-- 
2.51.0

