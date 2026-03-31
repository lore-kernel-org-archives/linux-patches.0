Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212E6423149;
	Tue, 31 Mar 2026 16:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974514; cv=none; b=LJfPWd6Ocss0c0Ut3Rs5moxRrkTeam1T9BkNhsX9Fs4TDV02q9dJYKJ6HYXxEw/U0LLTgyyGGVZGtgheya/+FCN79ByNFDN2vAGbASSqUF7uvJ9qyBQ9XswkzVQbbKx5cNpCoEBjJ3+IJ26SaPrCqlX4gOUbiWFfCWJfgzwA4ME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974514; c=relaxed/simple;
	bh=9IBRfvT9VqNGn4ZotC91Aeep4C3t+688FptX0hxrzvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lAhke+G85RIdD8WpmpcfRuvX2MaKeT+Lr70RnG8pfhZ9oR5yoq4Z9wPHKuQoG5v5OmlQ4F2lUeBgDtto3SIdZDYxJg9MHdSGTLVTsJHRgjY9tVhbt5hzTt9uB1CCwGgxoCcFcpe7HUIDAdEiuix9CBq03jjJIUIR593fun7on2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRUkOR88; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRUkOR88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A73EC19423;
	Tue, 31 Mar 2026 16:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974513;
	bh=9IBRfvT9VqNGn4ZotC91Aeep4C3t+688FptX0hxrzvY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nRUkOR88iQk0TSA1IO1xJUk03SFrp7MMjI2NjiUuIc7bNiLfvmAEDrP+6Gbll0oD/
	 b1W642LMY81nXwwNWdzeLvMyjXNzS1rxKrT9FjZOTBuuFIGOX5uzYoPmqQPnEcd5mC
	 MQns/9zPnWd0I+CW0z10dTPqLJ+AugmZXGewrqa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 081/175] RDMA/irdma: Remove reset check from irdma_modify_qp_to_err()
Date: Tue, 31 Mar 2026 18:21:05 +0200
Message-ID: <20260331161732.749784537@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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
index 91ed7edcd788b..0571544e045e8 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2345,8 +2345,6 @@ void irdma_modify_qp_to_err(struct irdma_sc_qp *sc_qp)
 	struct irdma_qp *qp = sc_qp->qp_uk.back_qp;
 	struct ib_qp_attr attr;
 
-	if (qp->iwdev->rf->reset)
-		return;
 	attr.qp_state = IB_QPS_ERR;
 
 	if (rdma_protocol_roce(qp->ibqp.device, 1))
-- 
2.53.0



