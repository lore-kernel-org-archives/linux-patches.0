Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BF74B5AE;
	Mon,  8 Jan 2024 15:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zn01sYau"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE17DC433C7;
	Mon,  8 Jan 2024 15:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704726857;
	bh=nrSuUnoPo/KFEJyJ9+8xtCInMPMV6w3l/aPhCsDnOtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zn01sYau0jQpR7DR30W4663KW4xyhE9+hCRUGIyWk2SviCQygC2/PoZ1HNqbCMOIX
	 QStUk/dcF9yhIHzAFSG/9rd7+O+jVGGYGTirXubK8trdKe0InK8CN0mQE+jr9iuYOq
	 yb4x4mvVSjvhwF6Yy/7xumDsA3AGDiDlIk42PoDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guanjun <guanjun@linux.alibaba.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Fenghua Yu <fenghua.yu@intel.com>,
	Lijun Pan <lijun.pan@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/124] dmaengine: idxd: Protect int_handle field in hw descriptor
Date: Mon,  8 Jan 2024 16:08:47 +0100
Message-ID: <20240108150607.603651734@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108150602.976232871@linuxfoundation.org>
References: <20240108150602.976232871@linuxfoundation.org>
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

From: Guanjun <guanjun@linux.alibaba.com>

[ Upstream commit 778dfacc903d4b1ef5b7a9726e3a36bc15913d29 ]

The int_handle field in hw descriptor should also be protected
by wmb() before possibly triggering a DMA read.

Fixes: eb0cf33a91b4 (dmaengine: idxd: move interrupt handle assignment)
Signed-off-by: Guanjun <guanjun@linux.alibaba.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fenghua Yu <fenghua.yu@intel.com>
Reviewed-by: Lijun Pan <lijun.pan@intel.com>
Link: https://lore.kernel.org/r/20231211053704.2725417-2-guanjun@linux.alibaba.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/submit.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/dma/idxd/submit.c b/drivers/dma/idxd/submit.c
index c01db23e3333f..3f922518e3a52 100644
--- a/drivers/dma/idxd/submit.c
+++ b/drivers/dma/idxd/submit.c
@@ -182,13 +182,6 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 
 	portal = idxd_wq_portal_addr(wq);
 
-	/*
-	 * The wmb() flushes writes to coherent DMA data before
-	 * possibly triggering a DMA read. The wmb() is necessary
-	 * even on UP because the recipient is a device.
-	 */
-	wmb();
-
 	/*
 	 * Pending the descriptor to the lockless list for the irq_entry
 	 * that we designated the descriptor to.
@@ -199,6 +192,13 @@ int idxd_submit_desc(struct idxd_wq *wq, struct idxd_desc *desc)
 		llist_add(&desc->llnode, &ie->pending_llist);
 	}
 
+	/*
+	 * The wmb() flushes writes to coherent DMA data before
+	 * possibly triggering a DMA read. The wmb() is necessary
+	 * even on UP because the recipient is a device.
+	 */
+	wmb();
+
 	if (wq_dedicated(wq)) {
 		iosubmit_cmds512(portal, desc->hw, 1);
 	} else {
-- 
2.43.0



