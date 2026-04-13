Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 211D7238D27;
	Mon, 13 Apr 2026 16:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097989; cv=none; b=lhfbtZp/GWCNYF28oPNhpWCjtFlts8temPejjp4QFugN9NOSrZTNBkSU1NqPY0hlO6gxRJ0AXetD7fn4AbKxAKuTtREzhwjOLO+bZRxpl1jvty87HzzxJwjJq1/IYRItS3ZG7067hoexYUed/BSiRRR+HgwZTX7ShKfo6lb3RzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097989; c=relaxed/simple;
	bh=23dM+7IZslBMgyVZ6M951wL7Z8EcahGWVLupWe46Ks4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bl57EylagO7aeK4bGT5XeKw7wOikLucMzkiR9BjKpuKhoxmIBq5r0HI9v/jFkS4luOdKwCFa9ZCQk7xKQd/SOYcb1gGEyS+eUkbScdmhkOhQuI2GocbhPRmt/h1WhzsaeAWll1pj96P/XrIKLQqdEHGGk0j8uaoyN7u6HQLNhNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q/8EG7Jw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q/8EG7Jw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC40C2BCAF;
	Mon, 13 Apr 2026 16:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097989;
	bh=23dM+7IZslBMgyVZ6M951wL7Z8EcahGWVLupWe46Ks4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q/8EG7JwAgYrFvO0Yx3/bgsg61t9i5JcYwx3gWKghkAY3wZFx3+GrH/tQ52H3Plj7
	 bPlCpb7pMxgI6abR4gN5uzxBBVZfjC9meV7+eBEcLaXOyLw/0QOsaGoVLk4cthMGve
	 Hulis30F3YHfIzX0fCP4Bt3lhKjZXY1xSpwhWdfg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 350/570] RDMA/irdma: Remove reset check from irdma_modify_qp_to_err()
Date: Mon, 13 Apr 2026 17:58:01 +0200
Message-ID: <20260413155843.597686614@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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
index 235515e8bf9b7..5a0672345cab1 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2512,8 +2512,6 @@ void irdma_modify_qp_to_err(struct irdma_sc_qp *sc_qp)
 	struct irdma_qp *qp = sc_qp->qp_uk.back_qp;
 	struct ib_qp_attr attr;
 
-	if (qp->iwdev->rf->reset)
-		return;
 	attr.qp_state = IB_QPS_ERR;
 
 	if (rdma_protocol_roce(qp->ibqp.device, 1))
-- 
2.53.0



