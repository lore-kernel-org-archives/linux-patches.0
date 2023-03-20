Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF741C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:08:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2C5DC433D2;
	Mon, 20 Mar 2023 15:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324890;
	bh=QBTVzXkEmgZMK00TO/lAoTF1TCKogf4wzNTQyGugT6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p5czpAwfm1IVO3tjhzLBVn+YpTM6S9cAidFq3rhKtBlA3dmDFqw0KcTGeiOCH9M3I
	 sixcoYqYVNdFUv5Bp4QkHYaUSvgjtf4zNEyclDbJaefchX0zFxQxz8HJEm8//MwAc4
	 Es8ImYSqnsEIFdToK34KvNauuQoCeFEarqe6azTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/198] scsi: mpi3mr: Fix config page DMA memory leak
Date: Mon, 20 Mar 2023 15:52:35 +0100
Message-Id: <20230320145508.227640527@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit 7d2b02172b6a2ae6aecd7ef6480b9c4bf3dc59f4 ]

A fix for:

DMA-API: pci 0000:83:00.0: device driver has pending DMA allocations while released from device [count=1]

Fixes: 32d457d5a2af ("scsi: mpi3mr: Add framework to issue config requests")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20230302234336.25456-3-thenzl@redhat.com
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 2d46a0b04f345..f6b726359a1cc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -4351,7 +4351,11 @@ void mpi3mr_free_mem(struct mpi3mr_ioc *mrioc)
 		    mrioc->admin_req_base, mrioc->admin_req_dma);
 		mrioc->admin_req_base = NULL;
 	}
-
+	if (mrioc->cfg_page) {
+		dma_free_coherent(&mrioc->pdev->dev, mrioc->cfg_page_sz,
+		    mrioc->cfg_page, mrioc->cfg_page_dma);
+		mrioc->cfg_page = NULL;
+	}
 	if (mrioc->pel_seqnum_virt) {
 		dma_free_coherent(&mrioc->pdev->dev, mrioc->pel_seqnum_sz,
 		    mrioc->pel_seqnum_virt, mrioc->pel_seqnum_dma);
-- 
2.39.2



