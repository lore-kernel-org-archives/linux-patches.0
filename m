Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43D31347517;
	Wed,  8 Apr 2026 18:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775671794; cv=none; b=mKOs+glZjU1N7rVbToF2xmtr53sy1EPqgAvJXIHSqS/CuQj/rtT0aoG6zMBBINorpgGKigFziLkKeZ2cbWC8MYIvPjxFaCJDRGiiOOwEnNZHh3FM+tWQQRLSb0HURE1NfkLONXd7VomNBauX3oiKteg2sA88WRrRhwyR9xrr3y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775671794; c=relaxed/simple;
	bh=AggdHI+Znr7zTQreb9Nlw5j3IQDJVrRdP5nOcoLq3Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RN7hc+czhlASaQ3L21X7Wi2G0T6C6XMBELjmnHZf9D5yRjziFtppFyE5DRaUf79SMiU/ukJvDFNzYtqkNUaMvabJTgOwsOR2w1eTEbSlVgMOUtzxfxTBGuVVOZGFxvosOb4P0qWxQToduRsKjdi26BHjTkx1VMTVilGKndpzSRU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2lwImlom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2lwImlom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE5DEC19421;
	Wed,  8 Apr 2026 18:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775671794;
	bh=AggdHI+Znr7zTQreb9Nlw5j3IQDJVrRdP5nOcoLq3Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lwImlomkphGpCDvWOIFPvWtcBBpWCHdxqA/V8Spqb6mbkq9DeefVZlh6RmI6ikPv
	 ncZyl+Pt5S+MbhfqOdifk4vqZNqKl+sYwI1YeuY5v8rswVkWwYkAzDVGmlXY1M8yWX
	 W9iRlpUzPeISUtoWlLDvO5q3ptI5lOsXdUIc6GOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 070/312] RDMA/irdma: Remove reset check from irdma_modify_qp_to_err()
Date: Wed,  8 Apr 2026 19:59:47 +0200
Message-ID: <20260408175936.355113199@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d236e4a27ca92..98a3849c39bf0 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -2456,8 +2456,6 @@ void irdma_modify_qp_to_err(struct irdma_sc_qp *sc_qp)
 	struct irdma_qp *qp = sc_qp->qp_uk.back_qp;
 	struct ib_qp_attr attr;
 
-	if (qp->iwdev->rf->reset)
-		return;
 	attr.qp_state = IB_QPS_ERR;
 
 	if (rdma_protocol_roce(qp->ibqp.device, 1))
-- 
2.53.0



