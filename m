Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2750146D6B;
	Mon,  6 Jan 2025 15:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177703; cv=none; b=sLLOrRCfrnSNE+aob607N4vVachYYoZ6P7KDW6p7sauNb1+MySTr4gsMm7nfmsV/cjjsVaTOvDVSAGbf1kjJywSaNQ5CQEirOR/56XMY962mD3peAxiYTr0ddwCV1SAxhya1mgbFRvcPUfPuX5P6C+eVdXaow4DyiOGRkWlqkr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177703; c=relaxed/simple;
	bh=nn0GNFO2o8D8U/i1BvpWrFRbl6XuvPXIfhXp2X9yHmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gA5zx+8IUj38Srm8PNxwV2T8+Sm62B3v+WdOgHJNoT7QSOkZje1/pYMqs68tykrksuyIYtHUb/ELWjwZygK+SNx9sI28AXH7ve8JNTNWZ8HxttlxU5QTDAW5Ty7LBcMihPGOek3s9olwzk+RFz6Sunw4ogPEfGHYdpabomHXNDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjR0PdWp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjR0PdWp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D87CC4CED2;
	Mon,  6 Jan 2025 15:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177703;
	bh=nn0GNFO2o8D8U/i1BvpWrFRbl6XuvPXIfhXp2X9yHmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjR0PdWpXiXx1lQ7plKC6MNXs7lFYHeXtMd/I8w2aVT6WyF2SONQ1kFUonrbs+4sx
	 mMa3sC8p1+avgJXc3ySal9Xxp6TE+3z2I2jL92qCbY83MP9r5lOctsWle2YW2b33oL
	 mOx/f2lfDqbU7j0OuT4P9pcRMwMwY7PM35TClgCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 029/156] RDMA/bnxt_re: Fix MSN table size for variable wqe mode
Date: Mon,  6 Jan 2025 16:15:15 +0100
Message-ID: <20250106151142.837452150@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>

[ Upstream commit bb839f3ace0fee532a0487b692cc4d868fccb7cf ]

For variable size wqe mode, the MSN table size should be
half the size of the SQ depth. Fixing this to avoid wrap
around problems in the retransmission path.

Fixes: de1d364c3815 ("RDMA/bnxt_re: Add support for Variable WQE in Genp7 adapters")
Reviewed-by: Kashyap Desai <kashyap.desai@broadcom.com>
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/20241217102649.1377704-5-kalesh-anakkur.purayil@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_fp.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_fp.c b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
index f5db29707449..3a34154b0d9d 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_fp.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_fp.c
@@ -1032,7 +1032,12 @@ int bnxt_qplib_create_qp(struct bnxt_qplib_res *res, struct bnxt_qplib_qp *qp)
 				    : 0;
 	/* Update msn tbl size */
 	if (qp->is_host_msn_tbl && psn_sz) {
-		hwq_attr.aux_depth = roundup_pow_of_two(bnxt_qplib_set_sq_size(sq, qp->wqe_mode));
+		if (qp->wqe_mode == BNXT_QPLIB_WQE_MODE_STATIC)
+			hwq_attr.aux_depth =
+				roundup_pow_of_two(bnxt_qplib_set_sq_size(sq, qp->wqe_mode));
+		else
+			hwq_attr.aux_depth =
+				roundup_pow_of_two(bnxt_qplib_set_sq_size(sq, qp->wqe_mode)) / 2;
 		qp->msn_tbl_sz = hwq_attr.aux_depth;
 		qp->msn = 0;
 	}
-- 
2.39.5



