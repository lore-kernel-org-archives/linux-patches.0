Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 055F139B970
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:16:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302609; cv=none; b=DIoMkdZKYj80AtvQNXhbHbnbfRwQztoW/S5V4XJ7fpHYDJdePq3ESspVLubPlnYGwhh15xZl8FIY6XgxdaT5kEoNTOnsOFnP8uhu3aocCv1JdYydojRuEHG34A/U+h6FRQq7yG5/4MGkfYwV3E+tma2v55A1DWwWdkTfbGqh8oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302609; c=relaxed/simple;
	bh=EDo7W1uYlGdiidZWiG3rh4kHafjHWj5vI+6XO3d2J1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NqA+HrYrK0Dr18Le5rrVOd0HqXcOdBkykoDAJcBUiKcp1wQH3vCLwzzCwObEJX9l4yaMWnRh1omdpwmIiP8sTy+3yd9+uOt42DgBnx9zojKD/ZVTYdYRlJif2q/ow2kcZNFHekdjBRvxBn1ClkamKRbseDyjuHDYtGaRsvyYFPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eA4X32Sn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eA4X32Sn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40ABFC19423;
	Sat, 28 Feb 2026 18:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302608;
	bh=EDo7W1uYlGdiidZWiG3rh4kHafjHWj5vI+6XO3d2J1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eA4X32SnnW9kYT69YPN6lxJUCIBjsRSz86riJNn1xb2J2KmluGoTchtk5mCu90GG+
	 0/y1QCu0mEqIxW5GmFx8ayIsupAc0O0u4bnr+EsJH10D6Z3BqyQmC4coaNJprbOs9Z
	 Q/H/XkBbYErTzDJ0kVZ47y9Mlk+s0/A7EW2EF+Gc4OvNa+8BMtki/CyjYsQo/+djJp
	 nAA9QuZNfniz2HaoYH08C3KLQdymAGNUq2skzX9Jtkb4Dg39MRYnEDRLEm48hPT1bK
	 2xeB4Oi4GVbPQ/pqDTE72hswjlXZ4WEOCNLwpYZvcuaJxNgGApfEh6p7gdItCYmtLa
	 dBKfCv3KRYdsQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Li Chen <me@linux.beauty>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/164] nvdimm: virtio_pmem: serialize flush requests
Date: Sat, 28 Feb 2026 13:14:23 -0500
Message-ID: <20260228181505.1600663-124-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 41e97c6567cf9..204d1a05f8e32 100644
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
index 726c7354d4659..23ce47b67df50 100644
--- a/drivers/nvdimm/virtio_pmem.c
+++ b/drivers/nvdimm/virtio_pmem.c
@@ -50,6 +50,7 @@ static int virtio_pmem_probe(struct virtio_device *vdev)
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

