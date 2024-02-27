Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE5713B7A0;
	Tue, 27 Feb 2024 13:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041138; cv=none; b=cmWVLwEqm369+t6clIHAN6w7j/MTPwzQmufDoaDdjRctELBkLJQWa/aSJLJRMavFXQrL353zlf/XgmdUxKa1A+557ofGMAjPZfBgeT51S/p+lJoWntGG8+zsZxIyLu7znbiBs2l8p1RRF9WfzIf1oqIabrULOuR8SO+fE4S3SbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041138; c=relaxed/simple;
	bh=OyUNUzSA0/GMSy2WxIIduMTmfZKqMhBVkqbZYxSTDbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A0kPb3ii4bzylYCCyKrDFWW4v7cuLHujch6vskkT0RAj3OEuvj/4yf82zsvaDbKLvpaUt61agVogUzi43qOTVPwuc/1R6zcsUxJee2zpNVO5yAbc7bpg6pxxIioyCt/TTT63KQHCULj02FXxlRX1osKqGDIEhfw6E33GKCK2qV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w/3io/Qx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w/3io/Qx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DE32C433C7;
	Tue, 27 Feb 2024 13:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041137;
	bh=OyUNUzSA0/GMSy2WxIIduMTmfZKqMhBVkqbZYxSTDbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w/3io/QxDi/mb5HR/qrQ34OMEoYFrgG+pMAhXux/mbKhQP5zAVpFzyKnze2rMJm2q
	 43FmGRHf3H98H5bMk2brjNE15wKdPQ4GHfEMgpftlvW5yHVeovv7HVPbZCXG8VPRS0
	 FC19nxX3zEbfRmIqNJNZw1VCn9X3Nadgq2dwide0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 233/334] RDMA/bnxt_re: Return error for SRQ resize
Date: Tue, 27 Feb 2024 14:21:31 +0100
Message-ID: <20240227131638.365175427@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 3687b450c5f32e80f179ce4b09e0454da1449eac ]

SRQ resize is not supported in the driver. But driver is not
returning error from bnxt_re_modify_srq() for SRQ resize.

Fixes: 37cb11acf1f7 ("RDMA/bnxt_re: Add SRQ support for Broadcom adapters")
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://lore.kernel.org/r/1705985677-15551-5-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index faa88d12ee868..cc466dfd792b0 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1809,7 +1809,7 @@ int bnxt_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
 	switch (srq_attr_mask) {
 	case IB_SRQ_MAX_WR:
 		/* SRQ resize is not supported */
-		break;
+		return -EINVAL;
 	case IB_SRQ_LIMIT:
 		/* Change the SRQ threshold */
 		if (srq_attr->srq_limit > srq->qplib_srq.max_wqe)
@@ -1824,13 +1824,12 @@ int bnxt_re_modify_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr,
 		/* On success, update the shadow */
 		srq->srq_limit = srq_attr->srq_limit;
 		/* No need to Build and send response back to udata */
-		break;
+		return 0;
 	default:
 		ibdev_err(&rdev->ibdev,
 			  "Unsupported srq_attr_mask 0x%x", srq_attr_mask);
 		return -EINVAL;
 	}
-	return 0;
 }
 
 int bnxt_re_query_srq(struct ib_srq *ib_srq, struct ib_srq_attr *srq_attr)
-- 
2.43.0



