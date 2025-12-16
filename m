Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74873344052;
	Tue, 16 Dec 2025 12:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888184; cv=none; b=Hl57mgstjB40TIs5h/tUpQFr+mn2CD2J0QHa7teymKs+NKjmKVZa3wdxwLzmGjS3OQB00xIuSDC+XRcdtAgrVOcSqG86CFI0hkvyBLRqP6WL8F6XzlI7UsQdDUfZXtKnAjp8Xs27wKn2nJBTY4mZIcMOLove1dfn2m0wHwpLuEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888184; c=relaxed/simple;
	bh=8q5haPDxKM/EAqwGfoQ6Ne5Qv/Uw9DIGvzIKbqaaPno=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=un1AITcOp9DOp1NP8BDf9ZcaMyIMMf5YFMovJKR3jK4k4mScHXOCi+l48O9f++BaypbUTeTtJ5CWLfsVV9zEZQP6zZjmDJPm3ZCeiKyu/0ZnPty9pyhyW0CqlIG1atw3BSG14cIg+MlTkJbU649/DVx5E2mpeBXk3/8H9Wao9K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hgNZmTg3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hgNZmTg3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6327C4CEF1;
	Tue, 16 Dec 2025 12:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888184;
	bh=8q5haPDxKM/EAqwGfoQ6Ne5Qv/Uw9DIGvzIKbqaaPno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hgNZmTg36FJW7D1J+7Ku+5cuKM1FxpiOtDFZTnIrsetrj0vRB2bj2bXRE73X3zofi
	 wqRRI09udgLkmpuzmyQ24AdiTb5G2rYlEmyvTqc2Cs178KmlOpvL4SHTm1xOxGyahB
	 R6GTGn4QZ2wB/zAjd0XHkQajg5am2fZ8/ioqsaAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 424/614] RDMA/irdma: Fix SIGBUS in AEQ destroy
Date: Tue, 16 Dec 2025 12:13:11 +0100
Message-ID: <20251216111416.736096690@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Krzysztof Czurylo <krzysztof.czurylo@intel.com>

[ Upstream commit 5eff1ecce30143c3f8924d91770d81d44bd5abe5 ]

Removes write to IRDMA_PFINT_AEQCTL register prior to destroying AEQ,
as this register does not exist in GEN3+ hardware and this kind of IRQ
configuration is no longer required.

Fixes: b800e82feba7 ("RDMA/irdma: Add GEN3 support for AEQ and CEQ")
Signed-off-by: Krzysztof Czurylo <krzysztof.czurylo@intel.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Link: https://patch.msgid.link/20251125025350.180-5-tatyana.e.nikolova@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/ctrl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index 991ce4890bfb2..cb970c9090ee0 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -4734,7 +4734,8 @@ static int irdma_sc_aeq_destroy(struct irdma_sc_aeq *aeq, u64 scratch,
 	u64 hdr;
 
 	dev = aeq->dev;
-	if (dev->privileged)
+
+	if (dev->hw_attrs.uk_attrs.hw_rev <= IRDMA_GEN_2)
 		writel(0, dev->hw_regs[IRDMA_PFINT_AEQCTL]);
 
 	cqp = dev->cqp;
-- 
2.51.0



