Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215601;
	b=bP+xe+AhqsjA7nyyo2h99y3JqODAt+HdfnYiqPxMlaj7o/pwptZOcdGizS2FR1q0zXQe
	 HiimjxqAolTvMpJkwp9z9KDXQ/AsAVM2T7Dzu/5kXe5apGFXN0Nq2wB87jOCThv7B0dCl
	 1UGrEDTlq0Ls1ib9Mo48s5DtFVE+3HfhyFzEyY+er/AIhzCcc3K6MYgtSsv/FCrriiYE6
	 CpRwBj8jl4W4aq3FeKbzE734PWtv0oigIbzaTHJLVEp/B4B6fRqFiF+Gzd8Wb6Y1vzX2g
	 8/Yka76ePCaDkSFahpdVBQ1930rHiuyQ6odQJUMQ8RUTKCYKa7bj+mkMADFThdcNVbw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215601;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EpG0AjdU7MwFkJtK45rJ2Gg5u7UTm2uNVmPfL7YH8n4=;
	b=Mu5hAxDjFU2uo9FXOsGq+AWii5K7h3idgMpIzu/0ljK6A3UbAX4oEC3++KTWa3j/kokl
	 6sl2ChGn4TxV+b07ZXOSHG6a/N0V0+G0baf8Nu4iIF95TE/IhAW7ZYUUbDFlqLJfpHdCv
	 4bdgBc61qS4MLZTYYznN2xtf5dOOJtl4mRPaWlp4zcC+lpYX4J3/GFaWxP2+OSgVT1+6r
	 /fvJ0Kcy2+6qesVzNbiK9gVNs3rInOhbGvcqsinQ911bMe0BqOUzpbBc5UMpq0MpanRWM
	 7bz0oZRmGfaMSjLzc+/IJ6VnueS+78pgCI3P/NB/WHwj2mto4SGwe8hJssoaq2MFreA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPjCyBzq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C131B606A31A;
	Wed, 28 Oct 2026 19:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZPjCyBzq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226391F01825;
	Wed, 28 Oct 2026 19:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215600;
	bh=EpG0AjdU7MwFkJtK45rJ2Gg5u7UTm2uNVmPfL7YH8n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPjCyBzqlWS/HFaApywdz2l5ELZhXg6a94A1qs2t61bE9OHx1HyBjRlFjtZpXMBGa
	 AmmJ0CPmB7KvAuPersqDLONJFo5TKjH/QJMM9EUdqCnP/je+DHx+qlX/vgK7EAFgxq
	 87fUt9qay8+cir2OPEI8v/sqoL4UefrkUYHH3J7o=
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
Subject: [PATCH 6.1 1265/1887] vhost: fix vhost_get_avail_idx for a non empty ring
Date: Wed, 28 Oct 2026 17:56:01 +0100
Message-ID: <20261028170528.210635618@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5958bca8e2720..85d4585c526cc 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1011,6 +1011,7 @@ static void vhost_dev_unlock_vqs(struct vhost_dev *d)
 static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
 {
 	__virtio16 idx;
+	u16 avail_idx;
 	int r;
 
 	r = vhost_get_avail(vq, idx, &vq->avail->idx);
@@ -1021,17 +1022,19 @@ static inline int vhost_get_avail_idx(struct vhost_virtqueue *vq)
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



