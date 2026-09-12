Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B03A36EA88;
	Sat, 12 Sep 2026 07:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197543; cv=none; b=FdsncsmIm+sjv48tNaMw5Ex9juVlIELKqwclPWw2KkhChSKlIFo+gkim4W9EZlZGGOb+cZ2cJbP7BdC3m0H10cM2hnVkLsiUzwvsYNccBhfAajQQYmnc5p7FuyIEJnB75OLgn/81Qg8VzktsseQg6PVBkDDqzT+F1CzYXoU5LvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197543; c=relaxed/simple;
	bh=U1Epby5ucX3nUh4Md7qrvkzK2S9OpU3gO/GkRk5X7r0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BCC5i6WmbuxjRw/2nrJjY2H94idc8N/s2QHDxt5+JUZ8LbhsVnALZp2Kaftp1GnnN0+VCAZPKYYdO+fMN13Vz8LRoJoVqQY3kKMB5I/+j5/T3qT12W7rrx/GWbqazqTdWHP/A1eb5j1mC/pCg5FukNTxN2CYnuTpLKry1ptpCR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vzy+XPGT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vzy+XPGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1116F1F000FF;
	Sat, 12 Sep 2026 07:19:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197541;
	bh=JYMuViLfOY1AFk8VxNkGLotlBxlj1qlvVs2aJXOJuuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vzy+XPGT/Sp9O3fXNmxvz9JIaJUNx+yJFkosOSX+SEtcxn7cnRB/01kKLrCLnR7Q5
	 dMYlosdN7xfP3WyqKkccAv846i2q4fgo1CR/I+JYU3pF6UeSZePih/bqyeecAoFcDs
	 fNa88eJ8dznNjl/BpXDuzgPa+wKOuafLqRTCR1ak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0197/1815] RDMA/irdma: Deduplicate the irdma_del_memlist logic
Date: Sat, 12 Sep 2026 08:32:27 +0200
Message-ID: <20260912065653.629551201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 097f50384e1877b7cf3ace12ff0d1beed19f2088 ]

Simplify/dedup the irdma_del_memlist logic in preparation for
the QP/CQ/SRQ ring MR refcounting change that will follow in
a subsequent commit.

Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260618201458.875740-2-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Stable-dep-of: f67d8a08f60c ("RDMA/irdma: Add refcounting to user ring MRs")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 31 +++++++++++------------------
 1 file changed, 12 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index b7388b41ed958..e81a7502a457c 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3935,35 +3935,28 @@ static void irdma_del_memlist(struct irdma_mr *iwmr,
 {
 	struct irdma_pbl *iwpbl = &iwmr->iwpbl;
 	unsigned long flags;
+	spinlock_t *lock;
 
 	switch (iwmr->type) {
 	case IRDMA_MEMREG_TYPE_CQ:
-		spin_lock_irqsave(&ucontext->cq_reg_mem_list_lock, flags);
-		if (iwpbl->on_list) {
-			iwpbl->on_list = false;
-			list_del(&iwpbl->list);
-		}
-		spin_unlock_irqrestore(&ucontext->cq_reg_mem_list_lock, flags);
+		lock = &ucontext->cq_reg_mem_list_lock;
 		break;
 	case IRDMA_MEMREG_TYPE_QP:
-		spin_lock_irqsave(&ucontext->qp_reg_mem_list_lock, flags);
-		if (iwpbl->on_list) {
-			iwpbl->on_list = false;
-			list_del(&iwpbl->list);
-		}
-		spin_unlock_irqrestore(&ucontext->qp_reg_mem_list_lock, flags);
+		lock = &ucontext->qp_reg_mem_list_lock;
 		break;
 	case IRDMA_MEMREG_TYPE_SRQ:
-		spin_lock_irqsave(&ucontext->srq_reg_mem_list_lock, flags);
-		if (iwpbl->on_list) {
-			iwpbl->on_list = false;
-			list_del(&iwpbl->list);
-		}
-		spin_unlock_irqrestore(&ucontext->srq_reg_mem_list_lock, flags);
+		lock = &ucontext->srq_reg_mem_list_lock;
 		break;
 	default:
-		break;
+		return;
+	}
+
+	spin_lock_irqsave(lock, flags);
+	if (iwpbl->on_list) {
+		iwpbl->on_list = false;
+		list_del(&iwpbl->list);
 	}
+	spin_unlock_irqrestore(lock, flags);
 }
 
 /**
-- 
2.53.0



