Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F865426D2B;
	Tue, 31 Mar 2026 16:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975852; cv=none; b=E85kzITGB4mTMsE28VcfNV6/ClY7l/NbNxZPB327M4aMBV2oyvu75v4aGUuRjzHxDbnuPS7ZZFdASGBuAEN8CRJOOQtN96EtSwsd5REKjfnaWcD24DWerR4PNEqmUePwWophtRdINMaV+dPi2t4cWN4Uzf/5ITtZo7nKRGMu69Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975852; c=relaxed/simple;
	bh=oTFjn7np7mNBqcyeL26y6PUEajoicRjugZ2rcQqsXUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pl+sN4m9WXg1Nbs+nzWyCtkHkPAmzQdoikpyHP9f2FMbeIomZFJpMTNlXHE5w7CU+IStKlpwhkM8/Od4OHH/5ts25M/H7EoBEalQ+f4L2wjOGSss1svcLuE2cys9r7aBD9DuWn+chuepGG1Z7Hn4hl9aH/V6rC0uhUTC2Nz0aHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TgrWZ+k9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TgrWZ+k9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164E5C19423;
	Tue, 31 Mar 2026 16:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975852;
	bh=oTFjn7np7mNBqcyeL26y6PUEajoicRjugZ2rcQqsXUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TgrWZ+k9f0d6t7/VzYw9wMbL1AJENxALWw8E32P48xLL5fEMY+GdQlA6zT0hpOJsx
	 4YJiULcRvOVz12pVzNvTvE9BJ6DNYB/dzdDVXXkXE4q+yAVIfXMaAA/SzSWw8DC+HZ
	 ZaauAUN/RcCnKZiflgrQSf9KaNmwqVkIyuG2rV7w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 112/244] RDMA/irdma: Remove reset check from irdma_modify_qp_to_err()
Date: Tue, 31 Mar 2026 18:21:02 +0200
Message-ID: <20260331161745.802297841@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Tatyana Nikolova <tatyana.e.nikolova@intel.com>

[ Upstream commit c45c6ebd693b944f1ffe429fdfb6cc1674c237be ]

During reset, irdma_modify_qp() to error should be called to disconnect
the QP. Without this fix, if not preceded by irdma_modify_qp() to error, the
API call irdma_destroy_qp() gets stuck waiting for the QP refcount to go
to zero, because the cm_node associated with this QP isn't disconnected.

Fixes: 915cc7ac0f8e ("RDMA/irdma: Add miscellaneous utility definitions")
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/utils.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index 87a6d58663ded..a88f93b961682 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2340,8 +2340,6 @@ void irdma_modify_qp_to_err(struct irdma_sc_qp *sc_qp)
 	struct irdma_qp *qp = sc_qp->qp_uk.back_qp;
 	struct ib_qp_attr attr;
 
-	if (qp->iwdev->rf->reset)
-		return;
 	attr.qp_state = IB_QPS_ERR;
 
 	if (rdma_protocol_roce(qp->ibqp.device, 1))
-- 
2.53.0



