Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2261917E1;
	Tue, 10 Sep 2024 10:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964356; cv=none; b=gWFuP1maAyYkcLJxtPrwsw1xkU4dzxdEId+mN080E9vCgPafFEASucRfVN+qEC8lHGoHGZVuXlRT7PuQgWoU9/cspYHcwxToYAwdwL4LDa7/lsHAOmfCOu1YxpAFZBY5A3eHcILOMyjfSgrFA75EV8fu7QBWOMOf+ODEi+oWfDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964356; c=relaxed/simple;
	bh=p5V55hD9bLDoj8RjJwGIVZ4l90IPTtHOIOO/i9oPmMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mJ6CQ1M3SiWDXe8kPFonooCKjvKV858jeeR4YYvbwC4J8eqnlgXfdcgw3gXY5VWaOiilpWtutRUYGDjrjAUTwt8AOhMarQSghyMs+jt0WGPxnxa+cISq4HVGYF0VE9yxvXeuRP/WKX2I/cChJp0gdDyvJMOSBy0D1UW/k6RbeU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdcrruLE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdcrruLE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61325C4CEC3;
	Tue, 10 Sep 2024 10:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964355;
	bh=p5V55hD9bLDoj8RjJwGIVZ4l90IPTtHOIOO/i9oPmMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hdcrruLE7epuewR/o607hOfdx+b5GuvhGk9giSf59sSkPLyWEHBFKzcugJ2Vc9rDg
	 +PpOVoDGYdLa8tQ6SVODj0zHQg9BYqQ4Fp/VMfFtzlhLhAySdOXlOKg9l0EatihP8/
	 vEvxfYGnfjmeqI6dD4ANuqBVpz0R1aUmDYxqWBlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Alexander Potapenko <glider@google.com>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH 6.6 147/269] virtio_ring: fix KMSAN error for premapped mode
Date: Tue, 10 Sep 2024 11:32:14 +0200
Message-ID: <20240910092613.452975702@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuan Zhuo <xuanzhuo@linux.alibaba.com>

[ Upstream commit 840b2d39a2dc1b96deb3f5c7fef76c9b24f08f51 ]

Add kmsan for virtqueue_dma_map_single_attrs to fix:

BUG: KMSAN: uninit-value in receive_buf+0x45ca/0x6990
 receive_buf+0x45ca/0x6990
 virtnet_poll+0x17e0/0x3130
 net_rx_action+0x832/0x26e0
 handle_softirqs+0x330/0x10f0
 [...]

Uninit was created at:
 __alloc_pages_noprof+0x62a/0xe60
 alloc_pages_noprof+0x392/0x830
 skb_page_frag_refill+0x21a/0x5c0
 virtnet_rq_alloc+0x50/0x1500
 try_fill_recv+0x372/0x54c0
 virtnet_open+0x210/0xbe0
 __dev_open+0x56e/0x920
 __dev_change_flags+0x39c/0x2000
 dev_change_flags+0xaa/0x200
 do_setlink+0x197a/0x7420
 rtnl_setlink+0x77c/0x860
 [...]

Signed-off-by: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Tested-by: Alexander Potapenko <glider@google.com>
Message-Id: <20240606111345.93600-1-xuanzhuo@linux.alibaba.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Ilya Leoshkevich <iii@linux.ibm.com>  # s390x
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_ring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 6f7e5010a673..80669e05bf0e 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -3126,8 +3126,10 @@ dma_addr_t virtqueue_dma_map_single_attrs(struct virtqueue *_vq, void *ptr,
 {
 	struct vring_virtqueue *vq = to_vvq(_vq);
 
-	if (!vq->use_dma_api)
+	if (!vq->use_dma_api) {
+		kmsan_handle_dma(virt_to_page(ptr), offset_in_page(ptr), size, dir);
 		return (dma_addr_t)virt_to_phys(ptr);
+	}
 
 	return dma_map_single_attrs(vring_dma_dev(vq), ptr, size, dir, attrs);
 }
-- 
2.43.0



