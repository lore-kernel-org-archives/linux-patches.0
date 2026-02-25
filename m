Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39BA2D29C2;
	Wed, 25 Feb 2026 06:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002631; cv=none; b=qqFD1hAQfetJkjv+aQomYQkJseP3OhbDjiBqEhubT+mkdP3+3M78p0EJtvCSpy1ndaGU7VMSrAmhSXWAKOr8JaicHqeL+if8ZOGsC14amqx3nLn1eFN+9FEqsCPe/2QhbWP8YOca/Ei2hmXr2iEZFtqdV7B12hWeRdFSdSg7MLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002631; c=relaxed/simple;
	bh=tLk7mMCq7sir67GEulzq4kdBRHXuXyZezOKUUCnTS40=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Cm+jIra7oL8W+MiuKxjwuTt85kj1u3rJgVKtbU+tcnLMmz1JRrwtJTQG3VwatZOcSx85IdMos+npzjbdA7jYNkz6tZ6ExIetQdoxneymye/rK4fdgdm6jsrlepfCfmD7Uah6m8RNv8pGIB3aUv+JhrO3NBnGPY3+Z2XcilPMliw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w4qMSsr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w4qMSsr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C855C116D0;
	Wed, 25 Feb 2026 06:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002631;
	bh=tLk7mMCq7sir67GEulzq4kdBRHXuXyZezOKUUCnTS40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w4qMSsr34IW87fwr2fp/Lmd3qu6FmMJd5DxWAk4lp0qzp5GuQS++LgByINC9QwboS
	 eedt9EuHgUSRa3OE+JwfZyh8Xxmx7iBrebZUEbdYGJSv2a6Z8O0oZpXV09kpv/wD8/
	 qh2o0WD68hPUy3zwaOxURCbjYmZXwZkwxymWrJfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <me@linux.beauty>,
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 394/641] nvdimm: virtio_pmem: serialize flush requests
Date: Tue, 24 Feb 2026 17:22:00 -0800
Message-ID: <20260225012358.122987395@linuxfoundation.org>
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
index c3f07be4aa22a..af82385be7c6a 100644
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
index 2396d19ce5496..77b1966619059 100644
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



