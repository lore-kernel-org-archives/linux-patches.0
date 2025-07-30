Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CA7526CE18;
	Wed, 30 Jul 2025 09:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753868605; cv=none; b=Aawhtlz8r66RY6OReK9scdoXZxogkEYmujwXTnKfRYt5j4UvPm4CHNcaKxcCLtdXRtPNkOue0zCRHud4FiWV5yMnepWsTX5eHOcZ3vKBpDwiwa8ffLv/mi/mL2bHEjB2MzBD/A3D0NB7aEO3nZ2E4kGR21Yhqilg/kHhE4z6oxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753868605; c=relaxed/simple;
	bh=fSVM9vckrCpnHUshR6i/5BJfSd+OeWm/R74freDJ54o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iyvJGaRGSRgxGDoyeTQYMMjWbXwPeqMYhcNGOCVkBkhWg9UA8SYzBe7jfmY+bJ/TbkY0UezokGW4LsBlzeDIPkeVkntbPCMaZbuSHJlRhL6Vf0ymppnKQaWWqoD9Q48gIkGZ3rfuX/0g+oqMaHiL9+NBVNFB+DwYnL79COUS3Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAKVm39l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAKVm39l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6FC2C4CEE7;
	Wed, 30 Jul 2025 09:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753868605;
	bh=fSVM9vckrCpnHUshR6i/5BJfSd+OeWm/R74freDJ54o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JAKVm39lDifRLBjK9J7L5lywM1U+rxiwge0adFMcH8KoMPnPR0TURfKKLTU6hnRl4
	 Q4sCwRaSZvE7Yj9U8G40hJHPIqYM931rRRgcKtnE1ibjVKFcXuRlttvGRxzZJkv1lg
	 M0ISy5LxJCeUpVYWK73uJ+EWv86CBSnE1MFUc2mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	xuanzhuo@linux.alibaba.com,
	Laurent Vivier <lvivier@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Lei Yang <leiyang@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/117] virtio_ring: Fix error reporting in virtqueue_resize
Date: Wed, 30 Jul 2025 11:34:33 +0200
Message-ID: <20250730093233.764957669@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093233.592541778@linuxfoundation.org>
References: <20250730093233.592541778@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Laurent Vivier <lvivier@redhat.com>

[ Upstream commit 45ebc7e6c125ce93d2ddf82cd5bea20121bb0258 ]

The virtqueue_resize() function was not correctly propagating error codes
from its internal resize helper functions, specifically
virtqueue_resize_packet() and virtqueue_resize_split(). If these helpers
returned an error, but the subsequent call to virtqueue_enable_after_reset()
succeeded, the original error from the resize operation would be masked.
Consequently, virtqueue_resize() could incorrectly report success to its
caller despite an underlying resize failure.

This change restores the original code behavior:

       if (vdev->config->enable_vq_after_reset(_vq))
               return -EBUSY;

       return err;

Fix: commit ad48d53b5b3f ("virtio_ring: separate the logic of reset/enable from virtqueue_resize")
Cc: xuanzhuo@linux.alibaba.com
Signed-off-by: Laurent Vivier <lvivier@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Link: https://patch.msgid.link/20250521092236.661410-2-lvivier@redhat.com
Tested-by: Lei Yang <leiyang@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 147926c8bae09..c0276979675df 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -2741,7 +2741,7 @@ int virtqueue_resize(struct virtqueue *_vq, u32 num,
 		     void (*recycle_done)(struct virtqueue *vq))
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
-	int err;
+	int err, err_reset;
 
 	if (num > vq->vq.num_max)
 		return -E2BIG;
@@ -2763,7 +2763,11 @@ int virtqueue_resize(struct virtqueue *_vq, u32 num,
 	else
 		err = virtqueue_resize_split(_vq, num);
 
-	return virtqueue_enable_after_reset(_vq);
+	err_reset = virtqueue_enable_after_reset(_vq);
+	if (err_reset)
+		return err_reset;
+
+	return err;
 }
 EXPORT_SYMBOL_GPL(virtqueue_resize);
 
-- 
2.39.5



