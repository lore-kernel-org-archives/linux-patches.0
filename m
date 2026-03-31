Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D2482D595D;
	Tue, 31 Mar 2026 17:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976572; cv=none; b=iUm8VGT5pKi2jsjfnQ5qWAPl3gkdDB7sBvkwVt8n08Slhbr4GRJAvk1eZ+xR1StR7RVrYVgCV4cxJcH9PlOnqp/Xv9N+z8wV+UFqh5+8AYSKhHMHpTkhEZskGw7DhZWZ680bEXMwSFjcUjJnVDaNaLXQC3S3GY4rXSfjbOeqyEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976572; c=relaxed/simple;
	bh=N/ax9PDc2mjYXCj9gDdgM9agE/idi1gvi1oziusdAN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSEwp1z78VYvKwbzZR5EWqatvPJ6DuNGheBZRgrzSLcJCV+hHT0MHEHbwa9GMC7sfuJ+PSpKU0gjK7fEx6CnNXVz2fM/RaTXBHGtoIUtN/oYWhADkTLbKaRUZ6CuED8ZlYwZ9bQusRNypeJuonOSHx8mXZG8W69zlaKaj17YhsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PUHvho52; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PUHvho52"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4139C19423;
	Tue, 31 Mar 2026 17:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976572;
	bh=N/ax9PDc2mjYXCj9gDdgM9agE/idi1gvi1oziusdAN0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PUHvho52L3yVTYepuPOznb0t9FRu9t56BFdYCvwp0r5rlHDeoYEbKlZoZrlOMRrnY
	 g4kdp08oPCX7iXbs7cHqr6oV+bkbS8h4soJbka1WXBXUiFx21uVVHLi5WirxRWSe+t
	 3wg9QpEAq0P3j03OYg9CXfW93gqu2kpxhS8SnETY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 145/309] RDMA/irdma: Remove reset check from irdma_modify_qp_to_err()
Date: Tue, 31 Mar 2026 18:20:48 +0200
Message-ID: <20260331161758.809783978@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b6c4ccf38eb78..e5e226b346211 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2325,8 +2325,6 @@ void irdma_modify_qp_to_err(struct irdma_sc_qp *sc_qp)
 	struct irdma_qp *qp = sc_qp->qp_uk.back_qp;
 	struct ib_qp_attr attr;
 
-	if (qp->iwdev->rf->reset)
-		return;
 	attr.qp_state = IB_QPS_ERR;
 
 	if (rdma_protocol_roce(qp->ibqp.device, 1))
-- 
2.53.0



