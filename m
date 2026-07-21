Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB8547141A;
	Tue, 21 Jul 2026 17:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656280; cv=none; b=nAqGy55Sp/0URtH5Lqu/wBCvlE9Se5o8OMRVPQaUERg/yOShh+eL1YjNeZ3UPrGn4h5pNWnbFE4/oiDfd8bHV/vLy9klpeg6DLRSBFaQUaUt/7TZeSwzGCZtV+Z67reDzM9DejcfWMjwEUMf27yl8n6KjRAH/9CHFTEvlJnZMSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656280; c=relaxed/simple;
	bh=MJCYJLKW4PEAmGocVGlirpDMJdokNHQOmjTtJtr7ZRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oztOhQ4kXehOlVyqBu11QogwJxIpnQmmermnrn/M+GG9ccil1VFyCLsPxXixp2kU1Fjv8+u/CS+hyRtLlB7tsHapXL42+dW8csXIZMi1fW2+uTXcN84MYxfkk0mTFnd22O0hBHGLDTGXtr6N2k5IAE4KBAg3yilG/WyG05b2Ovk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UyV/hF+0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UyV/hF+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4641A1F00A3A;
	Tue, 21 Jul 2026 17:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656278;
	bh=7bQloNj/YmKYUrFv8vRMamEkpAzxBcZT2Bd7Zi2l7Jc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UyV/hF+0LbalV2H3eQZ94bnWZ4JnNiVOXrgD/FXILv5GkRsi/wdE0JKEYmpVHXNaH
	 dgv5yh0aI+BPuIYaMc7G7ijX9QC1573O79c9cr5PeZZIbkdoKrS1Jyt8FpRgjiOVCH
	 fWw8sG/pAizX9migYWwQcL38FB4g2kyGz+LtmPVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ShuangYu <shuangyu@yunyoo.cc>,
	Stefan Hajnoczi <stefanha@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0325/1611] vhost: fix vhost_get_avail_idx for a non empty ring
Date: Tue, 21 Jul 2026 17:07:21 +0200
Message-ID: <20260721152522.401281059@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Michael S. Tsirkin <mst@redhat.com>

[ Upstream commit 09861858a68342f851f71c669ac0f69865c32151 ]

vhost_get_avail_idx is supposed to report whether it has updated
vq->avail_idx. Instead, it returns whether all entries have been
consumed, which is usually the same. But not always - in
drivers/vhost/net.c and when mergeable buffers have been enabled, the
driver checks whether the combined entries are big enough to store an
incoming packet. If not, the driver re-enables notifications with
available entries still in the ring. The incorrect return value from
vhost_get_avail_idx propagates through vhost_enable_notify and causes
the host to livelock if the guest is not making progress, as vhost will
immediately disable notifications and retry using the available entries.

This goes back to commit d3bb267bbdcb ("vhost: cache avail index in
vhost_enable_notify()") which changed vhost_enable_notify() to compare
the freshly read avail index against vq->last_avail_idx instead of the
previously cached vq->avail_idx. Commit 7ad472397667 ("vhost: move
smp_rmb() into vhost_get_avail_idx()") then carried over the same
comparison when refactoring vhost_enable_notify() to call the unified
vhost_get_avail_idx().

The obvious fix is to make vhost_get_avail_idx do what the comment
says it does and report whether new entries have been added.

Reported-by: ShuangYu <shuangyu@yunyoo.cc>
Fixes: d3bb267bbdcb ("vhost: cache avail index in vhost_enable_notify()")
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-Id: <559b04ae6ce52973c535dc47e461638b7f4c3d63.1772441455.git.mst@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vhost/vhost.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index bccdc9eab267a7..6a7b22650aa721 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1526,6 +1526,7 @@ static void vhost_dev_unlock_vqs(struct vhost_dev *d)
 static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
 {
 	__virtio16 idx;
+	u16 avail_idx;
 	int r;
 
 	r = vhost_get_avail(vq, idx, &vq->avail->idx);
@@ -1536,17 +1537,19 @@ static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
 	}
 
 	/* Check it isn't doing very strange thing with available indexes */
-	vq->avail_idx = vhost16_to_cpu(vq, idx);
-	if (unlikely((u16)(vq->avail_idx - vq->last_avail_idx) > vq->num)) {
+	avail_idx = vhost16_to_cpu(vq, idx);
+	if (unlikely((u16)(avail_idx - vq->last_avail_idx) > vq->num)) {
 		vq_err(vq, "Invalid available index change from %u to %u",
-		       vq->last_avail_idx, vq->avail_idx);
+		       vq->last_avail_idx, avail_idx);
 		return -EINVAL;
 	}
 
 	/* We're done if there is nothing new */
-	if (vq->avail_idx == vq->last_avail_idx)
+	if (avail_idx == vq->avail_idx)
 		return 0;
 
+	vq->avail_idx = avail_idx;
+
 	/*
 	 * We updated vq->avail_idx so we need a memory barrier between
 	 * the index read above and the caller reading avail ring entries.
-- 
2.53.0



