Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EABA453B4
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ADCAC433C7;
	Sun, 17 Sep 2023 19:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979284;
	bh=N+aFPQtEAASxr/DqdlhsAdqbX/l75KZtxABfuz6jWcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OaccUs2jYdqjBY8eFq59PXdHH3Wf0oMGzbpV+uSkJ/V3tAwlMci1UJ4rPQTvmQUYX
	 7+gzVLt3ckBtvZKbyBw69R1PPcGLrFAOP+uSCibJ/Hvbhu3ZJEQMel99RdVL0R3ncg
	 Y2gqSe+Ou40RiRUngF3bSaNWbrRgCyZahfrc7tRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Yao <yuanyaogoog@chromium.org>,
	Jason Wang <jasowang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 267/406] virtio_ring: fix avail_wrap_counter in virtqueue_add_packed
Date: Sun, 17 Sep 2023 21:12:01 +0200
Message-ID: <20230917191108.283053287@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 3cc2a4ee7152c..cf0e8e1893ee6 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -1190,7 +1190,7 @@ static inline int virtqueue_add_packed(struct virtqueue *_vq,
 		}
 	}
 
-	if (i < head)
+	if (i <= head)
 		vq->packed.avail_wrap_counter ^= 1;
 
 	/* We're using some buffers from the free list. */
-- 
2.40.1



