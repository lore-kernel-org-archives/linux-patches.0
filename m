Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE7CB35AC06
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:19:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302745; cv=none; b=pAQCoZ+j1CJaUnrn6Dy8aGymqlbBYAcnR8w8c5ElwBvm/ALJMXAzFct70x0niDL+GrMt889ZbB2o9TifX9gcxw5lNNTQvbpANn3LLGyYOQMDNEU79AavU4dr5/TcgQ6P0ls8sXZ8g7UuoJ4jTWGysAaIt/LGeAKCK9MXzFnkBFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302745; c=relaxed/simple;
	bh=EDo7W1uYlGdiidZWiG3rh4kHafjHWj5vI+6XO3d2J1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDOKh+hov6+taZLOn2TGDFQSOFl1HmrpuG/+2w7ZPqPSbXNjdpl04oj9xTPQmdgeoPfd4Wl4/8ZK7iAWxRl/17rEmy7yM5V4MveyBvb5QR5PIxuS3ubaYSvz+wnQN21+yS7OoDv4s9z0P44VULFf8MKfN5AwbAmOVOaohVinlX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lPBVU2iY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lPBVU2iY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8240C19425;
	Sat, 28 Feb 2026 18:19:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302745;
	bh=EDo7W1uYlGdiidZWiG3rh4kHafjHWj5vI+6XO3d2J1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lPBVU2iYNCJ8ril0+64JJPCFN1zw34flrf3ToC8QGBqxtNJGVNveMscyNsgDQRuMX
	 oJJUIDcT+fECTDoUWfIvAXhK8KC6+U5pGMtJB727FHJLH6hOmMJXfkEO8pK5lS5ncx
	 KTfgpNiTVM5bQlL21N2p++gsnnm0imJWFWwijh8CejUfCI/u8xL9bWcDVqNMVitxcR
	 djv5MG+GF2JttaV5RboRN3C8AoSclyqzO2n6rXdYhMRLzrj21QRGxIaG7ho7pCxv4o
	 ZEBwJcLYyiDoBlz7bRxSOM5nnz3WV7CAKew5Bb4Aptpx0QNrbl7/aAkFlfL4ZrEseF
	 11uQe6ffUTN9A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Li Chen <me@linux.beauty>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 112/147] nvdimm: virtio_pmem: serialize flush requests
Date: Sat, 28 Feb 2026 13:17:00 -0500
Message-ID: <20260228181736.1605592-112-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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

