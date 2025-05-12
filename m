Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0B2295DAB;
	Mon, 12 May 2025 17:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071772; cv=none; b=KhORGlP4eRHR081amO9DEj5O7ZTOz5MDRFmlEOlFqHkcFQrg7U4UL4m6YjjXie0NdfIM0gVKcw9WliOXttaGlvnloV7kWK7BXWC0becEG1dpaFwNsvlTq7t1hjL1Eekhkwa4GCZqyiQkmkd03diS40JmNIjNcqtzch72GMTU51g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071772; c=relaxed/simple;
	bh=B01VrlQhZGxLVMl8Z+ii1RwYLad+ZxOEnT2A/xZAGmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqubtHOzlya//2zYD8KkyxHm4NvFeRV2c4ZjZw9P1iGBCWxRW/eOd6ZA/12+y9+PdQlA/s2Lva8ZWtacOhBdK6G4I+a2seigs7E0g0V2XtQzC0W47PI4lQgD8caAOSe+LEyKn8YBi0NO5UryQq24bU13NO0HDpWuqeBRzecInMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qYp5EHKz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qYp5EHKz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B3AEC4CEE7;
	Mon, 12 May 2025 17:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071772;
	bh=B01VrlQhZGxLVMl8Z+ii1RwYLad+ZxOEnT2A/xZAGmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qYp5EHKzBrxjNy1e1ECCUmupgjxMVJXbXL1X3HOxUhZDqM3ipnS1c2/1eLrWdhER8
	 DKJ1NoKB5Qbl/ml3bl8bWTHEMIE0pxKawyNBtLIHIPswo0EQWN1FUMTE3K3M8ZtaXW
	 rq+Y4bboJmlJ1+zMCDNETcK2drtrqImH8nztGFRY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Wang <jasowang@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 021/197] virtio-net: free xsk_buffs on error in virtnet_xsk_pool_enable()
Date: Mon, 12 May 2025 19:37:51 +0200
Message-ID: <20250512172045.208759577@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 2c3c6e8e3f35b..54f883c962373 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -5870,8 +5870,10 @@ static int virtnet_xsk_pool_enable(struct net_device *dev,
 
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
@@ -5899,6 +5901,8 @@ static int virtnet_xsk_pool_enable(struct net_device *dev,
 err_xsk_map:
 	virtqueue_dma_unmap_single_attrs(rq->vq, hdr_dma, vi->hdr_len,
 					 DMA_TO_DEVICE, 0);
+err_free_buffs:
+	kvfree(rq->xsk_buffs);
 	return err;
 }
 
-- 
2.39.5



