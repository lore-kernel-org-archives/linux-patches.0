Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72DFE14F12C;
	Tue, 10 Sep 2024 09:50:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961858; cv=none; b=n9Fdyahlu1an1kf3zj4M3M2liuee6r8QJb9HnnYRwvmo2Rjkm6L0yksDbb8IeKn9iye4IevY3OnSx59fYdOv1uRV7eu4bQGpFSxvsouHicAPp9RUYab8+DtMH7cWRIsOAYshntwrJaNEkPqb+6+x7cU5KUqhP7F7PstIhAzFonY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961858; c=relaxed/simple;
	bh=pkjUAg19oljSiy5GYBj59PkCwnVUkE33E2m5mo66C3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dnXoLjCuFKNA88dooCLdhAwLyUYcvhNW47X9izDmPKw/Yyaqf+DaJAVscG/l4ffuTS+MJ+CLpVaCFR5TpNVUSFoauBTQXrJsseLSHpZkQ5SuqC6KO9laOBpKWhp5bz7xeDLjwVgauljVCvuBPt9Nh6JeC/bvLvpQoyJY2mzKP1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LR09ru9V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LR09ru9V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD27C4CEC3;
	Tue, 10 Sep 2024 09:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961858;
	bh=pkjUAg19oljSiy5GYBj59PkCwnVUkE33E2m5mo66C3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LR09ru9V0OnlfzjwdoohtAiYIo07bmivlijt1phim1MWvraM7dAZ73D+BPKSks5mI
	 QSoc0vxW3lkhsiuVQu93E1sUoTNrdn3SWDpuCT87p0Pm5sB+3K0olPVkpNDzr/qg13
	 NilKgxQ229DEoEeURIUGxLqAckOxCngKPS9v34/c=
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
Subject: [PATCH 6.10 212/375] virtio_ring: fix KMSAN error for premapped mode
Date: Tue, 10 Sep 2024 11:30:09 +0200
Message-ID: <20240910092629.644022884@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 2a972752ff1b..9d3a9942c8c8 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -3121,8 +3121,10 @@ dma_addr_t virtqueue_dma_map_single_attrs(struct virtqueue *_vq, void *ptr,
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



