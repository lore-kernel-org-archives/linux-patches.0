Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06467377ABA;
	Sat, 12 Sep 2026 16:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231778; cv=none; b=s0Tn53dmpDRJxrUQM9rCshEz6PCyLFny2YecNGkEwkDNyRtkxWUno4oEz6gB8yS0q1TZJk09MykED4IKvy9Sr/Y3AzbPl6OeY+sFQoI201eEmqBck+o9VtreHFlc04PY8xmE3bM3u9mVDXXxjwvJyRapzxgQHSY6eGrMonxr6WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231778; c=relaxed/simple;
	bh=KeuHIRQjDqZiMPUZBKROOzP0kIiSdyF+eFlFxRJ9VaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XArzLLspumZDuZk13/gj+ICjANekMV5x57n5cmpDQatiDy9uXbp1XodrMa2Fq453fTOSO3Bav1Q9SNG/FqdVIUg9QUG7GD1xvPcjUrSDCs3pxvomi+wp4zYL1rupzQtX0oAW9EPJGuy/XnNDCFqOvMsAfWd2s8MyN35m4FRkZcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xg7cZIB1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xg7cZIB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949D21F000FF;
	Sat, 12 Sep 2026 16:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231776;
	bh=1yQM1y1CjlvA7SKci5h8ZT1/AUQenG0wu0r0ASgIYPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xg7cZIB17RFojEASuj1Qu2z81q59DxaBFwXYySTj52V+MvGLXRDgVBIjjRQ7iE390
	 w3hnllgI8bVCNiloLg2DLFmG8FDrBOaU67NcosXP0m0PzfbWfethdQtiCdnMm5Td2+
	 Sc9OvwSpAx34KMIwkPpqpuDFOceEeyUcUvaXOsI8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1069/1191] virtio_balloon: disable indirect descriptors
Date: Sat, 12 Sep 2026 09:03:17 +0200
Message-ID: <20260912065612.183814840@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 41fa694d82577..e9abd958f69e3 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/virtio.h>
+#include <uapi/linux/virtio_ring.h>
 #include <linux/virtio_balloon.h>
 #include <linux/swap.h>
 #include <linux/workqueue.h>
@@ -1095,6 +1096,11 @@ static int virtballoon_validate(struct virtio_device *vdev)
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



