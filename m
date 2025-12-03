Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6F6634F484;
	Wed,  3 Dec 2025 16:05:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777925; cv=none; b=DqkYiS5lQotxDJdNpI091UNBYvtBb9R/B1siIw2ngBBguKOWsT0B1XOcgYIOhsehaMVQ7/3gvz3tMSG0cOx27Idm4f1IJKBnRmaNcuDCZpsZ/V1YWYstbQlLNrOALuUy5gn9IY/ZSpCZGGpaDzpMNjafXyC+46JJluYgaXnQvw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777925; c=relaxed/simple;
	bh=HppNYPLxqAPafxWQ6DW+XFb1/Ui2DVkn79FITK37K4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HgME0XZmlKq9GsZ6XEkB/4bT72QZTsIGhP2MSPgM3NCySfGjXDEEJHCU5LmlyO7o7sAWkOFTs3Y6BM0IPeHZwILutL/SttyibFHM9fJD6QnnCNT7trGCWNduD6O4dBYpN9u4Tq2ctp1ZWLRUWla2ZBMEK+Ukytt8trtpKfdqWpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L2Jt1TjD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L2Jt1TjD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E52AC4CEF5;
	Wed,  3 Dec 2025 16:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777925;
	bh=HppNYPLxqAPafxWQ6DW+XFb1/Ui2DVkn79FITK37K4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L2Jt1TjDYeuYtSVwga8/hlmunsge7eV25ZBBy70sxXHO9KT5wvhBk+m1yNzDeOTB3
	 TzPrTQC0NIOAABU33wP9Z2mN4SufsKjL/VyaktApHMzwSScGLiBg7K5//HhlQbE873
	 /3v9/ZDK/6g1qKgozHYfbcyigKU2DXTE+qIKVFOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 189/392] RDMA/irdma: Set irdma_cq cq_num field during CQ create
Date: Wed,  3 Dec 2025 16:25:39 +0100
Message-ID: <20251203152421.032726689@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 8896cbf9ec4d0..e62a825622834 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -1968,6 +1968,7 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 	spin_lock_init(&iwcq->lock);
 	INIT_LIST_HEAD(&iwcq->resize_list);
 	INIT_LIST_HEAD(&iwcq->cmpl_generated);
+	iwcq->cq_num = cq_num;
 	info.dev = dev;
 	ukinfo->cq_size = max(entries, 4);
 	ukinfo->cq_id = cq_num;
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index a74b24429b246..13c66908411f7 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -107,7 +107,7 @@ struct irdma_mr {
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



