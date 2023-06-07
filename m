Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9649810FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15043C433EF;
	Wed,  7 Jun 2023 20:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169640;
	bh=x4vYym9XleYrWZ+rU1tI4zgGL2tm62rFrZqtGJF7b30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ux+gDxicog0VReWTujtEfasB7Fh9T1PDzoqRjtqWUczpQKjQOBlrH2EeCYXes6wez
	 W57LdLdMwKE1eEeHbQoQhsDD7Y2hcm8p0zK2hQnDbrWbK/UeNd0lfTyIwJ1g5tSX1D
	 7l6Qi9/mqyX6IlNphubPOPQl7au50RYxa2ZH9pL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Po-Wen Kao <powen.kao@mediatek.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Stanley Chu <stanley.chu@mediatek.com>,
	Ziqi Chen <quic_ziqichen@quicinc.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 157/286] scsi: ufs: core: Fix MCQ tag calculation
Date: Wed,  7 Jun 2023 22:14:16 +0200
Message-ID: <20230607200928.251618164@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Po-Wen Kao <powen.kao@mediatek.com>

[ Upstream commit 5149452ca66289ef33d13897ee845a2f6f5b680f ]

The transfer command descriptor is allocated in ufshcd_memory_alloc() and
referenced by the transfer request descriptor with stride size
sizeof_utp_transfer_cmd_desc() instead of sizeof(struct
utp_transfer_cmd_desc).

Consequently, computing tag by address offset should also refer to the
same stride.

Signed-off-by: Po-Wen Kao <powen.kao@mediatek.com>
Link: https://lore.kernel.org/r/20230504154454.26654-2-powen.kao@mediatek.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Reviewed-by: Ziqi Chen <quic_ziqichen@quicinc.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufs-mcq.c | 2 +-
 drivers/ufs/core/ufshcd.c  | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c
index 202ff71e1b582..b7c5f39b50e6d 100644
--- a/drivers/ufs/core/ufs-mcq.c
+++ b/drivers/ufs/core/ufs-mcq.c
@@ -265,7 +265,7 @@ static int ufshcd_mcq_get_tag(struct ufs_hba *hba,
 	addr = (le64_to_cpu(cqe->command_desc_base_addr) & CQE_UCD_BA) -
 		hba->ucdl_dma_addr;
 
-	return div_u64(addr, sizeof(struct utp_transfer_cmd_desc));
+	return div_u64(addr, sizeof_utp_transfer_cmd_desc(hba));
 }
 
 static void ufshcd_mcq_process_cqe(struct ufs_hba *hba,
diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 8ac2945e849f4..a80eacbb8ef85 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -8422,7 +8422,7 @@ static void ufshcd_release_sdb_queue(struct ufs_hba *hba, int nutrs)
 {
 	size_t ucdl_size, utrdl_size;
 
-	ucdl_size = sizeof(struct utp_transfer_cmd_desc) * nutrs;
+	ucdl_size = sizeof_utp_transfer_cmd_desc(hba) * nutrs;
 	dmam_free_coherent(hba->dev, ucdl_size, hba->ucdl_base_addr,
 			   hba->ucdl_dma_addr);
 
-- 
2.39.2



