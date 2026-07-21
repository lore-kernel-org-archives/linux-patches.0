Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6C1470102;
	Tue, 21 Jul 2026 19:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661888; cv=none; b=FVO1sWI8lrDSpgy3zWq1AlRhzirV+zefiaq801Rmx43oIyIv20UuAE67Vf6J1Q2GzIfFV0CzW6/GmGv9fRpOAVujZXJOD3KDNp0AldZS3kwKWqRdS8fVvTgzXXBZiwmbO4jA2/mXPgIjoN7Rq4D69XeoFHDk2MkcXu7rTXmob38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661888; c=relaxed/simple;
	bh=ntIa+zejJ9p1uuHwkEzgLtyTgGDmb9jj1YVLtnKvL68=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RcO8jVuEM/B1zz4oD1gQvRAftAw6wQn+2qvRi186rxgJQ7U1Z7FZFFrXcCWcx1a1ahH+zV33JEdtA7BWyX4cac/m8n9BVqxVs+aEEkFwkXCY1D8UzgpnPOKyhM3pevEQmKt0ZuAftDuMscavj0N3EsjiTXhZmvwraR7WZQickwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RhHPx+fr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RhHPx+fr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BED1F00A3A;
	Tue, 21 Jul 2026 19:24:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661886;
	bh=zokeVtMpEpz9c/OWA+d8w2evw+V2w0bxqH+yRPJa8f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RhHPx+frRJ8uvJK+ut1boe5Dz1P5qYvtia4JqgrwRrYMmho/95YXWnvDfJ5nv0kTG
	 ff34oUiggkn7+cU2hTTxfwm+A96AQGsfY+dZmNXIg2nJGxl/iOLMzOz0KxMn8XRofI
	 3cQGlG7R6uIaTz0L0XXPJgCCKv0hj6vCxvMjB4SI=
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
Subject: [PATCH 6.12 0229/1276] vhost: fix vhost_get_avail_idx for a non empty ring
Date: Tue, 21 Jul 2026 17:11:12 +0200
Message-ID: <20260721152451.216399733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index 276dded52212cd..68027fd993e386 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1520,6 +1520,7 @@ static void vhost_dev_unlock_vqs(struct vhost_dev *d)
 static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
 {
 	__virtio16 idx;
+	u16 avail_idx;
 	int r;
 
 	r = vhost_get_avail(vq, idx, &vq->avail->idx);
@@ -1530,17 +1531,19 @@ static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
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



