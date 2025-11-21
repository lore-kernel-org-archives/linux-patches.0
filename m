Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5CA4345751;
	Fri, 21 Nov 2025 13:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732958; cv=none; b=dfB7iqpo30NFj62Bmu30L5m7sUCamRw8PwqxuKAJ0m/M8zGXGK87gBPOcfNFFYmJami8VZBU/j+z1LQUjXB483/xY8CmNrnXQEwhGRqjacHkdu5syjP/DZWVYOMyfE7h3ewP9WhTj1pGsRjzB6wfSqqgyCgoAcZGm6uKmN/ixj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732958; c=relaxed/simple;
	bh=rHnfaeFpej2EKEjUGZ7b3tAYfFV5vgLFHgjgRioDni4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jgFe6bMcsngpFiUquvVEu59nszgLKWw1t4hFd9s0z8w6HS/WL09WlY6rdAjE/m0WcmL9MmknzBG31jFb5c3SxNRB2MYKteBm8rpd4h/Pk4Tupf6xqQ6xyGzYyi/76zY+jfunBeEth87Vblxo+Cn/uot8vVgs7bAJDQhX4Mory7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bf98Ibyh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bf98Ibyh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17966C4CEF1;
	Fri, 21 Nov 2025 13:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732958;
	bh=rHnfaeFpej2EKEjUGZ7b3tAYfFV5vgLFHgjgRioDni4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bf98IbyhnSJEl0sUY6aNnyD6wV9zeJX9dwl8/HjxFioMaKUho/av9zMmwU9BP5P9e
	 zGbDjOYHa9IrzFGahp1tMXmqomBEcZTWMqv3w8blZR/7jrluOrG7vFfulIrM4WjM/n
	 0Td8phvkX5Kls/BVx4ng7QBlEG/pFyaBN8q7NRnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 302/529] RDMA/irdma: Set irdma_cq cq_num field during CQ create
Date: Fri, 21 Nov 2025 14:10:01 +0100
Message-ID: <20251121130241.770777580@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 5575b7646b94c0afb0f4c0d86e00e13cf3397a62 ]

The driver maintains a CQ table that is used to ensure that a CQ is
still valid when processing CQ related AEs. When a CQ is destroyed,
the table entry is cleared, using irdma_cq.cq_num as the index. This
field was never being set, so it was just always clearing out entry
0.

Additionally, the cq_num field size was increased to accommodate HW
supporting more than 64K CQs.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20250923142439.943930-1-jmoroni@google.com
Acked-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 1 +
 drivers/infiniband/hw/irdma/verbs.h | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 7243255c224f4..29540b2b2373c 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2077,6 +2077,7 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 	spin_lock_init(&iwcq->lock);
 	INIT_LIST_HEAD(&iwcq->resize_list);
 	INIT_LIST_HEAD(&iwcq->cmpl_generated);
+	iwcq->cq_num = cq_num;
 	info.dev = dev;
 	ukinfo->cq_size = max(entries, 4);
 	ukinfo->cq_id = cq_num;
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index 50c2610d1cbfb..bb9ab945938e0 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -113,7 +113,7 @@ struct irdma_mr {
 struct irdma_cq {
 	struct ib_cq ibcq;
 	struct irdma_sc_cq sc_cq;
-	u16 cq_num;
+	u32 cq_num;
 	bool user_mode;
 	atomic_t armed;
 	enum irdma_cmpl_notify last_notify;
-- 
2.51.0



