Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69820261B6E;
	Tue, 11 Nov 2025 01:28:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824496; cv=none; b=Gkj7cf6YZs4FA7CE/UPUKuFmfGeQINrqe0sncN/iWrghYU0zv9IpXQQYaFjpYZFyq3qvqwdqEn6UBNrw/1XE/hDwn3FH5iQXTBje4ezlx5Jc0CTzYEFTUcPWpO8MyVmdh3QobewxJU+NxzJG7LfX4/DgSHpI3vxF0ebUC9a7EO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824496; c=relaxed/simple;
	bh=AhktqVdWIiQjGV5/olQYNmDCHB7IakILrJKlmI0T+Lo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kSdxZlbrSYA2kIcGPXM8YyGpLSz3GKtpxcADavFhy5LMWpeTewVgoQUlI6FJtYKRvvKVCR2zU3fr1OQ+awlPKC4RXiZ2gRolwRC3zBhCDDv06jaYyWkFbdqR7r8EwXdFOGwB/zqaqQ04bfa2DKmMkyda7+XF+mPoQCXg3Jkz59Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SJ1Dq6MT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SJ1Dq6MT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 054ABC4CEFB;
	Tue, 11 Nov 2025 01:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824496;
	bh=AhktqVdWIiQjGV5/olQYNmDCHB7IakILrJKlmI0T+Lo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SJ1Dq6MTfNJuQhRi8QhJul8Ba4vqlQ+nntL9/acVKeLPt6bM0N4AJnK50GVI1t8fQ
	 RfbmKGs7FhHui/okKa8omu+PYtaInnkdV5qDUoHwYGFsBZAK2TVrmQn55251UZrj6g
	 JxM9wM/wMf0AP5eA8LxemGTgBr3y/AwvG1dBYjNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 457/565] RDMA/irdma: Set irdma_cq cq_num field during CQ create
Date: Tue, 11 Nov 2025 09:45:13 +0900
Message-ID: <20251111004537.177020388@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ba844f4b1c21a..63d07fcab6569 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -2078,6 +2078,7 @@ static int irdma_create_cq(struct ib_cq *ibcq,
 	spin_lock_init(&iwcq->lock);
 	INIT_LIST_HEAD(&iwcq->resize_list);
 	INIT_LIST_HEAD(&iwcq->cmpl_generated);
+	iwcq->cq_num = cq_num;
 	info.dev = dev;
 	ukinfo->cq_size = max(entries, 4);
 	ukinfo->cq_id = cq_num;
diff --git a/drivers/infiniband/hw/irdma/verbs.h b/drivers/infiniband/hw/irdma/verbs.h
index 4381e5dbe782a..36ff8dd712f00 100644
--- a/drivers/infiniband/hw/irdma/verbs.h
+++ b/drivers/infiniband/hw/irdma/verbs.h
@@ -115,7 +115,7 @@ struct irdma_mr {
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



