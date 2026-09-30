Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D313A52ED21;
	Wed, 30 Sep 2026 17:38:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789935; cv=none; b=F8XPe2n9UNZ7tBoeNIfiFyPCyA340zjMDIo83xMShCKPGij769qTFyJ4vJLPDXj421K+kP7QNxqOhPEn5yAvTnykm6FccjAKaTVGO1qH/UarVNh17oiJwUW6nBrK+yFZzGxWltc+biI7NDGfjm1R6ZLp8Yva3+owI83JaGFGCc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789935; c=relaxed/simple;
	bh=Dv2EUJ+sVRX7CdnzScoe2qrxij6WWdxQSVNkxeUAEok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b4Oja2gs92N2IVFK9XnpPkygk8G/sZ4Kn/Pi3DdCKaZpUPjBJAAfICDLOSIa448kbmgqUSb0IFl01l05y09lPPAUgeGJh5GI+cScm5d6Csx+GURhS97k8LU4PdEzuBULhueHTijH0QI3Ecx3L6kYEpsiyLgFDqferB+o6FRlkbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TrvwnJ50; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TrvwnJ50"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9C61F00898;
	Wed, 30 Sep 2026 17:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789933;
	bh=KZvW2B1bi+YXXpXW9FYPOCbPGwXGOy1uTYdkhiCH4DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TrvwnJ50xSdkfX8/oNeUqgH2RPvZFHdZ76mOZa/z9bjCLyxgpOoeHtmFWQQIU4vF6
	 MPQIRkLGLfgoyiWClxa9URWWowl/7qnwJll8ez7AkdnxJgyI9Yh5xULYh1aboyy4sy
	 cMt8BW4k2j5sT7GG1hEhMvLnoSx4W2AYlIlSttTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Chen <me@linux.beauty>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 653/877] nvdimm: virtio_pmem: refcount requests for token lifetime
Date: Wed, 30 Sep 2026 17:26:04 +0200
Message-ID: <20260930152428.753869264@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Chen <me@linux.beauty>

[ Upstream commit e57140944b5a47a7fd5a142faab29a02af040bc8 ]

KASAN reports slab-use-after-free in __wake_up_common():
BUG: KASAN: slab-use-after-free in __wake_up_common+0x114/0x160
Read of size 8 at addr ffff88810fdcb710 by task swapper/0/0

CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
6.19.0-next-20260220-00006-g1eae5f204ec3 #4 PREEMPT(full)
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS Arch Linux
1.17.0-2-2 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0x6d/0xb0
 print_report+0x170/0x4e2
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 ? __virt_addr_valid+0x1dc/0x380
 kasan_report+0xbc/0xf0
 ? __wake_up_common+0x114/0x160
 ? __wake_up_common+0x114/0x160
 __wake_up_common+0x114/0x160
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 __wake_up+0x36/0x60
 virtio_pmem_host_ack+0x11d/0x3b0
 ? sched_balance_domains+0x29f/0xb00
 ? __pfx_virtio_pmem_host_ack+0x10/0x10
 ? _raw_spin_lock_irqsave+0x98/0x100
 ? __pfx__raw_spin_lock_irqsave+0x10/0x10
 vring_interrupt+0x1c9/0x5e0
 ? __pfx_vp_interrupt+0x10/0x10
 vp_vring_interrupt+0x87/0x100
 ? __pfx_vp_interrupt+0x10/0x10
 __handle_irq_event_percpu+0x17f/0x550
 ? __pfx__raw_spin_lock+0x10/0x10
 handle_irq_event+0xab/0x1c0
 handle_fasteoi_irq+0x276/0xae0
 __common_interrupt+0x65/0x130
 common_interrupt+0x78/0xa0
 </IRQ>

virtio_pmem_host_ack() wakes a request that has already been freed by the
submitter.

This happens when the request token is still reachable via the virtqueue,
but virtio_pmem_flush() returns and frees it.

Fix the token lifetime by refcounting struct virtio_pmem_request.
virtio_pmem_flush() holds a submitter reference, and the virtqueue holds an
extra reference once the request is queued. The completion path drops the
virtqueue reference, and the submitter drops its reference before
returning.

Fixes: 6e84200c0a29 ("virtio-pmem: Add virtio pmem driver")
Cc: stable@vger.kernel.org
Signed-off-by: Li Chen <me@linux.beauty>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260630092338.2094628-9-me@linux.beauty>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvdimm/nd_virtio.c   |   32 ++++++++++++++++++++++++++++----
 drivers/nvdimm/virtio_pmem.h |    2 ++
 2 files changed, 30 insertions(+), 4 deletions(-)

--- a/drivers/nvdimm/nd_virtio.c
+++ b/drivers/nvdimm/nd_virtio.c
@@ -15,6 +15,14 @@ struct virtio_pmem_flush_work {
 	struct bio *bio;
 };
 
+static void virtio_pmem_req_release(struct kref *kref)
+{
+	struct virtio_pmem_request *req;
+
+	req = container_of(kref, struct virtio_pmem_request, kref);
+	kfree(req);
+}
+
 static void virtio_pmem_wake_one_waiter(struct virtio_pmem *vpmem)
 {
 	struct virtio_pmem_request *req_buf;
@@ -42,6 +50,7 @@ void virtio_pmem_host_ack(struct virtque
 		virtio_pmem_wake_one_waiter(vpmem);
 		WRITE_ONCE(req_data->done, true);
 		wake_up(&req_data->host_acked);
+		kref_put(&req_data->kref, virtio_pmem_req_release);
 	}
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 }
@@ -72,6 +81,7 @@ static int virtio_pmem_flush(struct nd_r
 	if (!req_data)
 		return -ENOMEM;
 
+	kref_init(&req_data->kref);
 	WRITE_ONCE(req_data->done, false);
 	init_waitqueue_head(&req_data->host_acked);
 	init_waitqueue_head(&req_data->wq_buf);
@@ -89,10 +99,23 @@ static int virtio_pmem_flush(struct nd_r
 	  * to req_list and wait for host_ack to wake us up when free
 	  * slots are available.
 	  */
-	while ((err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req_data,
-					GFP_ATOMIC)) == -ENOSPC) {
+	for (;;) {
+		err = virtqueue_add_sgs(vpmem->req_vq, sgs, 1, 1, req_data,
+					GFP_ATOMIC);
+		if (!err) {
+			/*
+			 * Take the virtqueue reference while @pmem_lock is
+			 * held so completion cannot run concurrently.
+			 */
+			kref_get(&req_data->kref);
+			break;
+		}
+
+		if (err != -ENOSPC)
+			break;
 
-		dev_info(&vdev->dev, "failed to send command to virtio pmem device, no free slots in the virtqueue\n");
+		dev_info_ratelimited(&vdev->dev,
+				     "failed to send command to virtio pmem device, no free slots in the virtqueue\n");
 		WRITE_ONCE(req_data->wq_buf_avail, false);
 		list_add_tail(&req_data->list, &vpmem->req_list);
 		spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
@@ -101,6 +124,7 @@ static int virtio_pmem_flush(struct nd_r
 		wait_event(req_data->wq_buf, READ_ONCE(req_data->wq_buf_avail));
 		spin_lock_irqsave(&vpmem->pmem_lock, flags);
 	}
+
 	err1 = virtqueue_kick(vpmem->req_vq);
 	spin_unlock_irqrestore(&vpmem->pmem_lock, flags);
 	/*
@@ -116,7 +140,7 @@ static int virtio_pmem_flush(struct nd_r
 		err = le32_to_cpu(req_data->resp.ret);
 	}
 
-	kfree(req_data);
+	kref_put(&req_data->kref, virtio_pmem_req_release);
 	return err;
 };
 
--- a/drivers/nvdimm/virtio_pmem.h
+++ b/drivers/nvdimm/virtio_pmem.h
@@ -12,12 +12,14 @@
 
 #include <linux/module.h>
 #include <uapi/linux/virtio_pmem.h>
+#include <linux/kref.h>
 #include <linux/libnvdimm.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
 
 struct virtio_pmem_request {
+	struct kref kref;
 	struct virtio_pmem_req req;
 	struct virtio_pmem_resp resp;
 


