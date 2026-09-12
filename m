Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA0343A4508;
	Sat, 12 Sep 2026 20:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243386; cv=none; b=vDiiCQNidHa7A9G9fLA5w/nmM7VKTrgqA8xJAXafnLDiTTCvfq3QrXMOFy0FaTcU4SUXbUDr8tRtxfesA9qs7K6Nj8SC5XpXETGzkPgz3qUCg/UgKQj/4FZ+GoueWpVL0Nb/0MTDrNTyw75yu2gIgFcayX7CAEwQN+FEi76ufAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243386; c=relaxed/simple;
	bh=HhC6eWiId7tA74UNaMrmJ29MME3uh0tu18HLJ2EOdFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IOR+JVzSY15RO06ZXTl3o3ag+EE5NI93E6y1ZowxxPMulIgwFm0PahHTsv1OYgtnzlOXC7Bw51hnC3onQUeu9UCe143xm2WzFvk5HvWgXYE7MdFkypJylZu2co6UFZjUOeHY+8vz1fRFQGTm3ndUXimrAE7zmGPVUvC2GL6vKPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J90hjpLZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J90hjpLZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407921F000FF;
	Sat, 12 Sep 2026 20:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243384;
	bh=LvZmikLq2fL/KiGfvkCB7HDyJtnqqZRqRC2duAD+2/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J90hjpLZUyrEy0Jtqg57H3vUjwJXp7akMDDCcWwbFCyHHJp4DbE4jEpyEgXZ02kwO
	 94caTi0qfh/ABpOGqi4f1QHHEd+yNcK7uIKVrOjzzCYDWVPyz13VO/ceCS6MdR7pNe
	 WRPUUBmyaYj41Q7jTdilAYs1rlO3eIeORIm6rnCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 735/798] virtio_balloon: disable indirect descriptors
Date: Sat, 12 Sep 2026 09:06:03 +0200
Message-ID: <20260912065533.923078905@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 281eb4732aae5473141b84e106fe906c69b2ff3d ]

The page reporting callback submits an sg list to the reporting
virtqueue.  With VIRTIO_RING_F_INDIRECT_DESC negotiated and
total_sg > 1 (which it typically is), virtqueue_add reports it to the
host by allocating an indirect descriptor via kmalloc(GFP_KERNEL).

This is not pretty: the reporting worker isolates potentially hundreds
of MB of free pages from the buddy allocator (reported pages are at
least pageblock_order, and the sg can contain up to
PAGE_REPORTING_CAPACITY entries of varying orders).  As the result,
very theoretically, the kmalloc might trigger OOM when we have in fact a
ton of free memory.

Clear VIRTIO_RING_F_INDIRECT_DESC, to avoid using indirect descriptors.

Fixes: b0c504f15471 ("virtio-balloon: add support for providing free page reports to host")
Assisted-by: Claude:claude-opus-4-6
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <73fac8a629fd9aca7bb3265ac243a769c28af25d.1783232420.git.mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_balloon.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 98e9d77911bc5..6de5c4a290ff9 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/virtio.h>
+#include <uapi/linux/virtio_ring.h>
 #include <linux/virtio_balloon.h>
 #include <linux/swap.h>
 #include <linux/workqueue.h>
@@ -1123,6 +1124,11 @@ static int virtballoon_validate(struct virtio_device *vdev)
 	else if (!virtio_has_feature(vdev, VIRTIO_BALLOON_F_PAGE_POISON))
 		__virtio_clear_bit(vdev, VIRTIO_BALLOON_F_REPORTING);
 
+	/*
+	 * Disable indirect descriptors to avoid memory allocation in
+	 * virtqueue_add during page reporting.
+	 */
+	__virtio_clear_bit(vdev, VIRTIO_RING_F_INDIRECT_DESC);
 	__virtio_clear_bit(vdev, VIRTIO_F_ACCESS_PLATFORM);
 	return 0;
 }
-- 
2.53.0



