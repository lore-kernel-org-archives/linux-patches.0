Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C44120F9D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:19:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A295CC433C7;
	Fri, 21 Jul 2023 19:19:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967156;
	bh=9G3y5jXltNPlZvHjR5h5Ntd0HyB4GnK4Fu4e9Ll5k2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SbzPdzvG48SPJPBdYJGnfv95pgNUO50MYH5qZvJN0h12upd8KMHqmTm/SkYYynKCy
	 ft6hvrhCaIsAoR8SgxU8dv84GvgB37RTWef/lWp4cauyqfwS2AI1PZGdeZDgrmaNDo
	 TY+1CrjthYhukfQ3hZKevgjn4HLGlAAazk0kHsPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangwu Zhang <guazhang@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 064/223] nvme-pci: fix DMA direction of unmapping integrity data
Date: Fri, 21 Jul 2023 18:05:17 +0200
Message-ID: <20230721160523.590565020@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
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
index 145fa7ef3f740..ce2e628f94a05 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1022,7 +1022,7 @@ static __always_inline void nvme_pci_unmap_rq(struct request *req)
 	        struct nvme_iod *iod = blk_mq_rq_to_pdu(req);
 
 		dma_unmap_page(dev->dev, iod->meta_dma,
-			       rq_integrity_vec(req)->bv_len, rq_data_dir(req));
+			       rq_integrity_vec(req)->bv_len, rq_dma_dir(req));
 	}
 
 	if (blk_rq_nr_phys_segments(req))
-- 
2.39.2



