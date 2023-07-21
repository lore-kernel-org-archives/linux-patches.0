Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F11B11F941
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B813C433CA;
	Fri, 21 Jul 2023 16:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689956129;
	bh=5dCexDNdiHu6HITaW+lGTUGOT2B++bd689ibJCIszyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPB0/ciAbpAbvpLlyLaJ9316wGAeQauiEM0xRNRPPBJQlpF5j4o+T7uo8X3SCjXuv
	 2LU7FaucgoGYTecErDF5p7yWLfYFJdlTVcVekCVSKq3mP4gJrVESFEhYZ68IjFK0Bp
	 Ki9a50ckBWJ8g+96NbNLLgpx5VNyeB3vXHHkguXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 107/292] nvme-pci: fix DMA direction of unmapping integrity data
Date: Fri, 21 Jul 2023 18:03:36 +0200
Message-ID: <20230721160533.402608977@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit b8f6446b6853768cb99e7c201bddce69ca60c15e ]

DMA direction should be taken in dma_unmap_page() for unmapping integrity
data.

Fix this DMA direction, and reported in Guangwu's test.

Reported-by: Guangwu Zhang <guazhang@redhat.com>
Fixes: 4aedb705437f ("nvme-pci: split metadata handling from nvme_map_data / nvme_unmap_data")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 492f319ebdf37..5b5303f0e2c20 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -968,7 +968,7 @@ static __always_inline void nvme_pci_unmap_rq(struct request *req)
 	        struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
 		dma_unmap_page(dev->dev, iod->meta_dma,
-			       rq_integrity_vec(req)->bv_len, rq_data_dir(req));
+			       rq_integrity_vec(req)->bv_len, rq_dma_dir(req));
 	}
 
 	if (blk_rq_nr_phys_segments(req))
-- 
2.39.2



