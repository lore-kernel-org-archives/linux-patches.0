Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE6A1F955
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFD4C433C8;
	Tue,  1 Aug 2023 09:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690882037;
	bh=B28jOyjaNmF2IVqKPmCZXi/DGMf3VnPp980hBsyqFxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GYKgiWmfAbUOOFO4nAgANEYepMNBU/Bno1amTg5VwmtvMdtr8hMfFr4khmUy0OlOa
	 BCS51oqqlw9xldVrWko/HiWmsbzlw7ngDCk22yz97ItW+XRC3RX26ECdkJLYICuyBe
	 bJ8fPy3AobcvUDEb4UmN1ALgyVbh81icTpiDCTOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Bogendoerfer <tbogendoerfer@suse.de>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 088/155] RDMA/mthca: Fix crash when polling CQ for shared QPs
Date: Tue,  1 Aug 2023 11:20:00 +0200
Message-ID: <20230801091913.324096885@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091910.165050260@linuxfoundation.org>
References: <20230801091910.165050260@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit dc52aadbc1849cbe3fcf6bc54d35f6baa396e0a1 ]

Commit 21c2fe94abb2 ("RDMA/mthca: Combine special QP struct with mthca QP")
introduced a new struct mthca_sqp which doesn't contain struct mthca_qp
any longer. Placing a pointer of this new struct into qptable leads
to crashes, because mthca_poll_one() expects a qp pointer. Fix this
by putting the correct pointer into qptable.

Fixes: 21c2fe94abb2 ("RDMA/mthca: Combine special QP struct with mthca QP")
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Link: https://lore.kernel.org/r/20230713141658.9426-1-tbogendoerfer@suse.de
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mthca/mthca_qp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index 69bba0ef4a5df..53f43649f7d08 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -1393,7 +1393,7 @@ int mthca_alloc_sqp(struct mthca_dev *dev,
 	if (mthca_array_get(&dev->qp_table.qp, mqpn))
 		err = -EBUSY;
 	else
-		mthca_array_set(&dev->qp_table.qp, mqpn, qp->sqp);
+		mthca_array_set(&dev->qp_table.qp, mqpn, qp);
 	spin_unlock_irq(&dev->qp_table.lock);
 
 	if (err)
-- 
2.40.1



