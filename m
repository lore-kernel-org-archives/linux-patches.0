Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE04A13AA55;
	Tue, 27 Feb 2024 13:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709042201; cv=none; b=rOISEikMTxYSsYzWJ8QJKktEoSoxkQ4t64lXjI8juUow2Ev3T1KUZsiebiac5MhYyzLcx+Q+YQ156WjgO7Pac2GAQXYmuQ7+76bBDeW04vzEsAz2GTbrvDjQABYoGis1jayFESXJzDJVs2aAZ3dkATDtHnefgAOHmhVuf5c6cSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709042201; c=relaxed/simple;
	bh=qqDdx7MyJQYVoowt3+JZZVvxtP6VfTsNpL02ywaV0j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cp2GaMCP24/vjNtnPNV5ZIuX5YjWJdHeg/O2pjXA2fouhh9bnC5M/3VX2h/9yXX0QFsACY4rLWCinyCK2ZdvwEc9cItkn1irOFvMdBJwSRq7wQLE6e6v5RXkv5wuuWeTtWNYxeFZASyU3rSU9oeUYRp1gNrPEe7m+5M6zZuScE4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ymPk77K3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ymPk77K3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A0CBC433C7;
	Tue, 27 Feb 2024 13:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709042200;
	bh=qqDdx7MyJQYVoowt3+JZZVvxtP6VfTsNpL02ywaV0j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ymPk77K3/6Ek9kch0zqhhHsep0173OmhYaxy37xopgdkV8fNWMYHdKu3490vYNDEY
	 dfKEbbOdVwXNH9VX1NoYRXt14St6MSDYOEDZcZUiyvqdITyruleQlTkMzIu56qe9rl
	 LVi7vl1MG94WEJCABD5uQ1/Z8i98BBpGwRy7TiOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 212/299] RDMA/bnxt_re: Return error for SRQ resize
Date: Tue, 27 Feb 2024 14:25:23 +0100
Message-ID: <20240227131632.610554156@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



