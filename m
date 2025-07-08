Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6146618EAB;
	Tue,  8 Jul 2025 16:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993367; cv=none; b=QHvoUlH4IBiGmMOiF/w94Wu3OULIXDN23Ou2ST3L8OJ9CpdnLxnzs+wUtbv/9wo+Al+ytUaFhp6+SzNIVymdGOmqArIK4Ccx6nfFnQLdqDD4+SSMR9yP2ZDIG6fTkazFC/ilOQXbLoRp5/5aLABh0ImWRdKxtjxcCmJZTmDODHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993367; c=relaxed/simple;
	bh=dX/38ODd1F9Q2zsvracwsEotWBU23U1zj2MmJx0nPu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DYokf0jfMJp103H7PvJ+WvTNh5rrTbiwlf3wYp+ZgLL57smSR6wsRoMb19SyFEyvGDOWgXeQ7U8t4wnsO3q7z0OljKWcl51rXYLGYoUFQJbqhts466CQnUVZEuXzMqbYEe+rvSds+cgBO4S+yt7qZlprTAjxb71Sbt9ckxgfgL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yxQGj+nj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yxQGj+nj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCFE0C4CEF5;
	Tue,  8 Jul 2025 16:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993367;
	bh=dX/38ODd1F9Q2zsvracwsEotWBU23U1zj2MmJx0nPu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yxQGj+nj1uGS/nS0G3V0729Gg7eQkX1XduQFgDpPIEfEkqYGhn8/p66kpelmcpWcb
	 mKLhiSvJ7ToPdk53jBeOMHtHOt++McQ63/DB/tAz27GLxe2w3g1/siqcXJjMNCKBMt
	 viCpzKe3H2EVcAnEijE3dROUDjm8c6jykcl+7llI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 050/178] scsi: qla4xxx: Fix missing DMA mapping error in qla4xxx_alloc_pdu()
Date: Tue,  8 Jul 2025 18:21:27 +0200
Message-ID: <20250708162237.991842006@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
References: <20250708162236.549307806@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 00f452a1b084efbe8dcb60a29860527944a002a1 ]

dma_map_XXX() can fail and should be tested for errors with
dma_mapping_error().

Fixes: b3a271a94d00 ("[SCSI] qla4xxx: support iscsiadm session mgmt")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://lore.kernel.org/r/20250618071742.21822-2-fourier.thomas@gmail.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qla4xxx/ql4_os.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index d540d66e6ffc4..80c4b4e7526b1 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -3420,6 +3420,8 @@ static int qla4xxx_alloc_pdu(struct iscsi_task *task, uint8_t opcode)
 		task_data->data_dma = dma_map_single(&ha->pdev->dev, task->data,
 						     task->data_count,
 						     DMA_TO_DEVICE);
+		if (dma_mapping_error(&ha->pdev->dev, task_data->data_dma))
+			return -ENOMEM;
 	}
 
 	DEBUG2(ql4_printk(KERN_INFO, ha, "%s: MaxRecvLen %u, iscsi hrd %d\n",
-- 
2.39.5



