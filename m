Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F301170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:20:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49E39C433C7;
	Mon, 11 Sep 2023 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442053;
	bh=5qCZuv4FOK8ViwJYPnkVyvrjOLOY4Cw7r9HhE2L09mU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z9b+iMQ14Oxq8sBqdFD6cpgZt5yeBusQ9W946lBiZ8t57l+s+egFJxVNdmJRF83IH
	 FcvwsWt5P0vHazG3LtVN9xI/n0ZuM3+D770HEX6w/bpjJ4FNShfOrcjQtP3Gt62tkD
	 1aJySzVVF37AecXC7XbVVscJpZmcRNPmvD75mQ8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Yao <yuanyaogoog@chromium.org>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 629/739] virtio_ring: fix avail_wrap_counter in virtqueue_add_packed
Date: Mon, 11 Sep 2023 15:47:08 +0200
Message-ID: <20230911134708.665326359@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuan Yao <yuanyaogoog@chromium.org>

[ Upstream commit 1acfe2c1225899eab5ab724c91b7e1eb2881b9ab ]

In current packed virtqueue implementation, the avail_wrap_counter won't
flip, in the case when the driver supplies a descriptor chain with a
length equals to the queue size; total_sg == vq->packed.vring.num.

Let’s assume the following situation:
vq->packed.vring.num=4
vq->packed.next_avail_idx: 1
vq->packed.avail_wrap_counter: 0

Then the driver adds a descriptor chain containing 4 descriptors.

We expect the following result with avail_wrap_counter flipped:
vq->packed.next_avail_idx: 1
vq->packed.avail_wrap_counter: 1

But, the current implementation gives the following result:
vq->packed.next_avail_idx: 1
vq->packed.avail_wrap_counter: 0

To reproduce the bug, you can set a packed queue size as small as
possible, so that the driver is more likely to provide a descriptor
chain with a length equal to the packed queue size. For example, in
qemu run following commands:
sudo qemu-system-x86_64 \
-enable-kvm \
-nographic \
-kernel "path/to/kernel_image" \
-m 1G \
-drive file="path/to/rootfs",if=none,id=disk \
-device virtio-blk,drive=disk \
-drive file="path/to/disk_image",if=none,id=rwdisk \
-device virtio-blk,drive=rwdisk,packed=on,queue-size=4,\
indirect_desc=off \
-append "console=ttyS0 root=/dev/vda rw init=/bin/bash"

Inside the VM, create a directory and mount the rwdisk device on it. The
rwdisk will hang and mount operation will not complete.

This commit fixes the wrap counter error by flipping the
packed.avail_wrap_counter, when start of descriptor chain equals to the
end of descriptor chain (head == i).

Fixes: 1ce9e6055fa0 ("virtio_ring: introduce packed ring support")
Signed-off-by: Yuan Yao <yuanyaogoog@chromium.org>
Message-Id: <20230808051110.3492693-1-yuanyaogoog@chromium.org>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index c5310eaf8b468..da1150d127c24 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1461,7 +1461,7 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 		}
 	}
 
-	if (i < head)
+	if (i <= head)
 		vq->packed.avail_wrap_counter ^= 1;
 
 	/* We're using some buffers from the free list. */
-- 
2.40.1



