Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD5A1E1A05;
	Mon, 12 May 2025 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072675; cv=none; b=JRjFxS58U51Tolb4PNlMLpZK3/q2o3iHR6sMHFqxLdTI2aD1I2qxaYXpVMZ4U611xfDkB7VZxW4NeJZvNJ9jaHbNbGjSIh0yiwUWM/OpL4Pn7lj8xR3YXvb6+Sxtumw8RsFjJBqqHezdeqAst3/LzZYweEZQd9vPiZGzeEy5BoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072675; c=relaxed/simple;
	bh=EnWf2Q4u75CXMcipGCTn1MIIyj05aESfd9iR/6Vred0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IkGH3fDEhqCEX7Myo1d8J5A9YrFETP5ckluZqG9DYMcYpcEW5jjYJNAJ8M9U1xSYotlK3xOMmYmp87MXEA2vvosQuLpR7l/RR3lmJcW6uts2nvA98xOtVihsBbsbqwXwdZGM/mS41mwR22pIB7ryj14BQXyb4+SPfu0L8HeENys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Usk88KnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Usk88KnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA0C5C4CEE7;
	Mon, 12 May 2025 17:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072675;
	bh=EnWf2Q4u75CXMcipGCTn1MIIyj05aESfd9iR/6Vred0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Usk88KnBdrxD86pd52MJ+g6cqzhpOOHrIDQYWu9+fZbsVAvKhk5CSc769a9k6ufaC
	 aAiAAoKpgedA7b/wUXjMbtPi0slg2833809X0SlOav+8ATZTWUUsEUkI0QOsq7xq0L
	 f7llhMGKMIPpW0o+e2sVqQxWdvKvfzCGt9bY+QoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 021/184] virtio-net: free xsk_buffs on error in virtnet_xsk_pool_enable()
Date: Mon, 12 May 2025 19:43:42 +0200
Message-ID: <20250512172042.556985229@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 4397684a292a71fbc1e815c3e283f7490ddce5ae ]

The selftests added to our CI by Bui Quang Minh recently reveals
that there is a mem leak on the error path of virtnet_xsk_pool_enable():

unreferenced object 0xffff88800a68a000 (size 2048):
  comm "xdp_helper", pid 318, jiffies 4294692778
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc 0):
    __kvmalloc_node_noprof+0x402/0x570
    virtnet_xsk_pool_enable+0x293/0x6a0 (drivers/net/virtio_net.c:5882)
    xp_assign_dev+0x369/0x670 (net/xdp/xsk_buff_pool.c:226)
    xsk_bind+0x6a5/0x1ae0
    __sys_bind+0x15e/0x230
    __x64_sys_bind+0x72/0xb0
    do_syscall_64+0xc1/0x1d0
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Acked-by: Jason Wang <jasowang@redhat.com>
Fixes: e9f3962441c0 ("virtio_net: xsk: rx: support fill with xsk buffer")
Link: https://patch.msgid.link/20250430163836.3029761-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/virtio_net.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 476c8a9cc494a..9493b1134875e 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -5633,8 +5633,10 @@ static int virtnet_xsk_pool_enable(struct net_device *dev,
 
 	hdr_dma = virtqueue_dma_map_single_attrs(sq->vq, &xsk_hdr, vi->hdr_len,
 						 DMA_TO_DEVICE, 0);
-	if (virtqueue_dma_mapping_error(sq->vq, hdr_dma))
-		return -ENOMEM;
+	if (virtqueue_dma_mapping_error(sq->vq, hdr_dma)) {
+		err = -ENOMEM;
+		goto err_free_buffs;
+	}
 
 	err = xsk_pool_dma_map(pool, dma_dev, 0);
 	if (err)
@@ -5662,6 +5664,8 @@ static int virtnet_xsk_pool_enable(struct net_device *dev,
 err_xsk_map:
 	virtqueue_dma_unmap_single_attrs(rq->vq, hdr_dma, vi->hdr_len,
 					 DMA_TO_DEVICE, 0);
+err_free_buffs:
+	kvfree(rq->xsk_buffs);
 	return err;
 }
 
-- 
2.39.5



