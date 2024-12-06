Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6C4153836;
	Fri,  6 Dec 2024 15:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497477; cv=none; b=OdA8Y27lWidVRWCUtSSOvLuM50RSl0wamZL+78UCjbbiN57+bNX8h2R/9QcRfGNKyK5jl+X1m7ygyK/O7ye0h8TW0J6UuI4rnaVb5bOTKsOA9VRHrxJR10s7l4b+jnlUiyKP5q8cwkWjzBUb7hanFq7/SPxQ2ugHuPnIh8nmZZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497477; c=relaxed/simple;
	bh=lvTkXHhMdubuLiAQ0IMLFbHTy33HsnCuwbTG9nw6lkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iYeTDY4suRrEc3xOuKRaZkEYGGUaVOSa3vfhElqHO6j7djGFj37za8BCwM40GJb4uTWO6CsnTfBjSKfJQnMLrBhinNImdh+1z/0O/jz2XGAYoKy6ZLH53R/Vqt5aYy+6+GLxqiIx5655pP/yBdNiqOWB/YOntRyW4sbgwb5ThHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPapV0PK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPapV0PK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC91AC4CEE0;
	Fri,  6 Dec 2024 15:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497477;
	bh=lvTkXHhMdubuLiAQ0IMLFbHTy33HsnCuwbTG9nw6lkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPapV0PKI0wDf7FLuSrCMuZ7kx8BCy0FnR1Pm1d9SqGfdx0pQg8c48BTIIXdyFCMQ
	 7kP1SvnYAdhZlhYDL9iWsmjPwmaYZbOF8mLu25fZVUuGkCqsWAJOsnEaOaJWwzNEbF
	 VDRTVqQb8fpeBniCB/l9ksejbAQSN9sdKUCHDg/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 303/676] scsi: qedf: Fix a possible memory leak in qedf_alloc_and_init_sb()
Date: Fri,  6 Dec 2024 15:32:02 +0100
Message-ID: <20241206143705.177225297@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit c62c30429db3eb4ced35c7fcf6f04a61ce3a01bb ]

Hook "qed_ops->common->sb_init = qed_sb_init" does not release the DMA
memory sb_virt when it fails. Add dma_free_coherent() to free it. This
is the same way as qedr_alloc_mem_sb() and qede_alloc_mem_sb().

Fixes: 61d8658b4a43 ("scsi: qedf: Add QLogic FastLinQ offload FCoE driver framework.")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20241026125711.484-2-thunder.leizhen@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedf/qedf_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedf/qedf_main.c b/drivers/scsi/qedf/qedf_main.c
index 14625e6bc8824..9a81d14aef6b9 100644
--- a/drivers/scsi/qedf/qedf_main.c
+++ b/drivers/scsi/qedf/qedf_main.c
@@ -2737,6 +2737,7 @@ static int qedf_alloc_and_init_sb(struct qedf_ctx *qedf,
 	    sb_id, QED_SB_TYPE_STORAGE);
 
 	if (ret) {
+		dma_free_coherent(&qedf->pdev->dev, sizeof(*sb_virt), sb_virt, sb_phys);
 		QEDF_ERR(&qedf->dbg_ctx,
 			 "Status block initialization failed (0x%x) for id = %d.\n",
 			 ret, sb_id);
-- 
2.43.0



