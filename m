Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987DC5101B;
	Mon,  8 Jan 2024 15:39:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZvMMc6d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE6C9C433C8;
	Mon,  8 Jan 2024 15:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728349;
	bh=GCwJgbma+t7FWpPG4RFN0WW59AccJ93I8o9vB2AmV1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZvMMc6dKRaIKHnHAz3VRCQcQIpiIK+YEtdxi/vV7aHRiLyYJuXBCGD29snuPaVMo
	 fI/WjA/8TvcDmsoghH/rcEiOihFEX1j5l011bQ2dgNdztBJVWjtMIn1CNBcDpLPY3S
	 eHSLvndHjo40q9QzK5W2tTGbM41xLsVDNqXMTH5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dinghao Liu <dinghao.liu@zju.edu.cn>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 048/150] net/qla3xxx: fix potential memleak in ql_alloc_buffer_queues
Date: Mon,  8 Jan 2024 16:34:59 +0100
Message-ID: <20240108153513.456789933@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dinghao Liu <dinghao.liu@zju.edu.cn>

[ Upstream commit 89f45c30172c80e55c887f32f1af8e184124577b ]

When dma_alloc_coherent() fails, we should free qdev->lrg_buf
to prevent potential memleak.

Fixes: 1357bfcf7106 ("qla3xxx: Dynamically size the rx buffer queue based on the MTU.")
Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>
Link: https://lore.kernel.org/r/20231227070227.10527-1-dinghao.liu@zju.edu.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/qlogic/qla3xxx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/qlogic/qla3xxx.c b/drivers/net/ethernet/qlogic/qla3xxx.c
index 0d57ffcedf0c6..fc78bc959ded8 100644
--- a/drivers/net/ethernet/qlogic/qla3xxx.c
+++ b/drivers/net/ethernet/qlogic/qla3xxx.c
@@ -2591,6 +2591,7 @@ static int ql_alloc_buffer_queues(struct ql3_adapter *qdev)
 
 	if (qdev->lrg_buf_q_alloc_virt_addr == NULL) {
 		netdev_err(qdev->ndev, "lBufQ failed\n");
+		kfree(qdev->lrg_buf);
 		return -ENOMEM;
 	}
 	qdev->lrg_buf_q_virt_addr = qdev->lrg_buf_q_alloc_virt_addr;
@@ -2615,6 +2616,7 @@ static int ql_alloc_buffer_queues(struct ql3_adapter *qdev)
 				  qdev->lrg_buf_q_alloc_size,
 				  qdev->lrg_buf_q_alloc_virt_addr,
 				  qdev->lrg_buf_q_alloc_phy_addr);
+		kfree(qdev->lrg_buf);
 		return -ENOMEM;
 	}
 
-- 
2.43.0



