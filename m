Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF09547277D;
	Sat, 12 Sep 2026 13:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218840; cv=none; b=pxW2xIlZSldlu/9azodv/+Q2T39392FFk7TNmWabOwfPdzeORrG0R9LOFNecMprUrdGqbD3ntH4Lg6X2SV25wufitFaei5cmz4QceGQ21LBpFfklQPJG+98o1b5JX07vWtUW/E06Mm2QsyZo6Gm1/0m8a6yY+iPeBofCIEEyyAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218840; c=relaxed/simple;
	bh=wMMtXHVLpt+q5hO6Z0Lrw+5m17OzXgiCf9swKtf8rJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EIGDZW4cTWjSS9MYMiSMYIBE7lxKs5bzy3I7JN43W+z5ZYfAx1t83x2mOs7jFz4/MxBNxVw48kDMabrbJL9nsYkoah22phWbdhU2nmUZg04TZbIbcNH3h23WcOigVOuM6aO4v1XQkEzEL8iitI9viVWF7lEIpb+5rU2rEae87gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tpx+zPSK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tpx+zPSK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B79251F000FF;
	Sat, 12 Sep 2026 13:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218838;
	bh=TTnwR/k00sKKxCgzLVCeXs2VTFZQDoRuU0J7vvzCah0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tpx+zPSKqLyc4yJZOYYpYZTa4MHU0T0qaMXszjpAR9vQPCeN+CQRryqhcNVMv+z3d
	 I3axo97Psho8bxOrXilKiGklSyHecc+8oV6ifkWM/ikg0ZT1lLEAWBhNyuFjBMWx/H
	 2cAo+PrT5WQShLz5VueNZ4spVy8/WGK3fIjauXSw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1228/1376] virtio_balloon: disable indirect descriptors
Date: Sat, 12 Sep 2026 09:00:54 +0200
Message-ID: <20260912065634.914657942@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index b7b9fb80d6a0e..02236ee98e596 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/virtio.h>
+#include <uapi/linux/virtio_ring.h>
 #include <linux/virtio_balloon.h>
 #include <linux/swap.h>
 #include <linux/workqueue.h>
@@ -1187,6 +1188,11 @@ static int virtballoon_validate(struct virtio_device *vdev)
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



