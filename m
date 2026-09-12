Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0847E41B8E4;
	Sat, 12 Sep 2026 10:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210737; cv=none; b=sK2JoUyvHf/8XzUyTLpdH8eH9zbC4+U7aQ/ba0P5CBHC/qS/s5QMURGV7a+pCu2fh8U7oEtpdZAdIZyAbbDq57dHoj2jYsedLM7xIO7kQLVWA2JhOusVy2kGjCRrcQ2ZQucPMS9lu3mFRzirrGmvwvEtoxsLiuwZw7N7aKMrmHI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210737; c=relaxed/simple;
	bh=Yv+c3iuOP9u8YsR0DZgzouxbWdH4Kp9fkQZHID+LXFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NFB4NF4hPaMsdyaNTcykudOF3OXrp4f84xlPGnd4PAyyg/A0ty2xcJ0iDvDoq9DvcB86s5pHsH+jBBmOZPPj4ISGxnacUDDjT6S9wuT0x8TMS6Bmi9IAvGK+fpKJu/WiUVlUc84gPV/q60lLVL+jagm7M7VpFDWWR/OjBCu9GAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRxO+roI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRxO+roI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E869D1F000FF;
	Sat, 12 Sep 2026 10:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210735;
	bh=3enata55WZ1EkdFhr/PQaTUd/4CZo5+S/MyxnBvHUYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PRxO+roIswQJNn4BW48YbwNwz7Usc94+L0nt6pFS+8KHbUHEGQmCU/UphqM+k11PL
	 GQLLn0R7aaYfu6YlSF0br+iHe1f/leRNlIFUFsxhCLGe5qnv9nx9UKm3gkG0kr+r8U
	 xSr169AHaIw9d0xu3pUGuC8R4V8Nyf6WBUiNvsDQ=
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
Subject: [PATCH 6.18 1086/1518] nvme-pci: release descriptor pools on probe failure
Date: Sat, 12 Sep 2026 08:54:15 +0200
Message-ID: <20260912065648.017663070@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 0a46c60583d7b..b8b6d9aaac1a6 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3557,6 +3557,7 @@ static int nvme_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	nvme_dev_remove_admin(dev);
 	nvme_dbbuf_dma_free(dev);
 	nvme_free_queues(dev, 0);
+	nvme_release_descriptor_pools(dev);
 out_release_iod_mempool:
 	mempool_destroy(dev->dmavec_mempool);
 out_dev_unmap:
-- 
2.53.0



