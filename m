Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7712E738A;
	Sat, 12 Sep 2026 08:50:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203016; cv=none; b=SWNHvo0ZrdfjLrSTQ4uQVB4MlIp1D5/CyZ4ANcXnR8P4GYQYGgEpQWsJKWffAWeMVbqUqdJXlULKQl8hTugjmwIUH6LZjWTdCnZvD2pJb7J05g9uTej/CGsexzYjCqY1GlIIOm88t9OdQ8XliZg8Mdnlku8l+G6r3P8biF0Srpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203016; c=relaxed/simple;
	bh=km4JebUWcmnrfQgO9zkR+1onq8h8DCFACiDZo6+hD1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvq9he5GOONYaXjehAyvwjCKHc6Vxv8vwLJf9oin953O02eL8v2KEb4M2704nsXBo2qbPZS1Kqp3FADyEDIrRN//nRtxVIRLPIXVaQ2nhTheeEJTzzakwRRNmh38761gtFlBUZ97ywzAj06iTIYzS04RWUQX4lFiz64A9W4zs4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jOiFeFff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jOiFeFff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A0C1F000FF;
	Sat, 12 Sep 2026 08:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203015;
	bh=R207BBYsiJ2KeY879bIdFGnkOJhdhpKSy090AEM90c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jOiFeFffoZEP2A08fbMv2JzKo4zNgHgZmJSXoFagT3SRpAbf8RvH4VCoMgatNQAcZ
	 e4rG2ITB2RZ2cTFeChjImlB9NOwENY4nuVS6NrMTkP4iwuP7h+vfA+1mZDQ3OS1zE7
	 VQrqdYO7sH/UPp8Pa0c5M2M/gowOu894AObLymfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guixin Liu <kanie@linux.alibaba.com>,
	Hannes Reinecke <hare@suse.de>,
	Christoph Hellwig <hch@lst.de>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1320/1815] nvme-pci: release descriptor pools on probe failure
Date: Sat, 12 Sep 2026 08:51:10 +0200
Message-ID: <20260912065720.013060583@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixin Liu <kanie@linux.alibaba.com>

[ Upstream commit cb144c2f67128abfa5c7ba33318617d19f192156 ]

The per-NUMA-node descriptor DMA pools are created lazily from
nvme_init_hctx_common() once the admin tag set is allocated, but they are
only destroyed in nvme_remove() via nvme_release_descriptor_pools(). Any
probe failure after the admin tag set has been allocated unwinds through
the out_disable label and nvme_pci_free_ctrl(), neither of which releases
the pools, leaking the dma_pool objects.

Release the descriptor pools in the out_disable error path. It must not
be added to nvme_pci_free_ctrl(), as that would double-free against
nvme_remove() on the normal teardown path.

Fixes: d977506f8863 ("nvme-pci: make PRP list DMA pools per-NUMA-node")
Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 219cda2558284..664a36eed23c3 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3840,6 +3840,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	nvme_dev_remove_admin(dev);
 	nvme_dbbuf_dma_free(dev);
 	nvme_free_queues(dev, 0);
+	nvme_release_descriptor_pools(dev);
 out_release_iod_mempool:
 	mempool_destroy(dev->dmavec_mempool);
 out_dev_unmap:
-- 
2.53.0



