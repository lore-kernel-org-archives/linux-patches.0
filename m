Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6470847127A;
	Tue, 21 Jul 2026 18:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659978; cv=none; b=P4hHPKVzNVocUXh3Bqo0Ci61VV00WjG+VfOPBmLMCPeDeUd6loZMFLiYj9gNSalzbNmNhf/IVXk4jl0BTbtXZ6aHrdCH0GYZHW54M5KhY0JILdMuink5+oGI34o22rGsY1xzBHFZZgTwaE0HjyULE3eSVW16tGDY1KfalBBn/YU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659978; c=relaxed/simple;
	bh=1njWW37tsCqOu4/ZuTqd7lPa+5YXrV/WzgBpHRMilNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2M41K7VbR1Kg8927CMvLFlFQCn23r/K/qRArfZuMkAGPqLr1SEe6vMTZwUS9C+cTpiuuUO2WqUSP79nMmlUK3oWxtBZP9INTkJACSe8FrhAqQ285QsEJCs3xJ6+zntxS9hQ7sC6GGeV+wlEHYhYrPywia/ZNZ9WegANqaeXlG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QjiUdFk7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QjiUdFk7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC161F000E9;
	Tue, 21 Jul 2026 18:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659977;
	bh=h1Z/ex0nQ57wL7NHIPQFC4BBcQhAPTasxi1GINIhVp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QjiUdFk7NaWOQ7WS5DYcVhw0B0+oPk2ScwdS99zwD+gOtahXzx6Z7D8KR2Dg0IcEv
	 aTbUC/PbLDeSgXgMCd3/GwI52n61zXMvGcILRuJlwqeCXTflMPp5IZcGb3KmARVfqR
	 XWaxiKk2orKbDaQdOjH2IT81e/2lsPgpUTW67rng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0805/2077] RDMA/bnxt_re: Free CQ toggle page after firmware teardown
Date: Tue, 21 Jul 2026 17:07:58 +0200
Message-ID: <20260721152611.780565075@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Selvin Xavier <selvin.xavier@broadcom.com>

[ Upstream commit bb45e06f9914ca64ac95341a80a0c20bb8dd46a9 ]

Free the toggle page only after firmware teardown completes so that
an NQ interrupt arriving during bnxt_qplib_destroy_cq() won't write
the toggle value to an already-freed page. Move free_page() after
bnxt_qplib_destroy_cq.

Fixes: e275919d9669 ("RDMA/bnxt_re: Share a page to expose per CQ info with userspace")
Link: https://patch.msgid.link/r/20260615224751.232802-4-selvin.xavier@broadcom.com
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 822484f3b95979..7bea3bee434b8c 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -3332,11 +3332,11 @@ int bnxt_re_destroy_cq(struct ib_cq *ib_cq, struct ib_udata *udata)
 	if (ret)
 		return ret;
 
-	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT) {
-		free_page((unsigned long)cq->uctx_cq_page);
+	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT)
 		hash_del(&cq->hash_entry);
-	}
 	bnxt_qplib_destroy_cq(&rdev->qplib_res, &cq->qplib_cq);
+	if (cctx->modes.toggle_bits & BNXT_QPLIB_CQ_TOGGLE_BIT)
+		free_page((unsigned long)cq->uctx_cq_page);
 
 	bnxt_re_put_nq(rdev, nq);
 
-- 
2.53.0



