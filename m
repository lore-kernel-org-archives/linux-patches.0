Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBEBB35A93D;
	Fri,  9 Jan 2026 12:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960908; cv=none; b=AwXU8Gw8p8sMuPSu+/xLuDAKEF5kKghAfBcixKwF/QV6iBp6mkb9skIZkzAxEPeWB5CyDJ6y6dt7Kuhlhz8yHp4fCd9tDKtORRxRPEErHTy2N4Aeuzo1TFgrndRln7gLLvriPRWlNXCYhNT3++8/cX7+P3F44Q4zxwtBtavuSnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960908; c=relaxed/simple;
	bh=C2Xlm8nBaL7WUIFNPmy53+qNLoNi8z1DzIsJ95sONLY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8ozkF6oBbt8SRnO/FhrHAMJdbXlJXYbTekW1QZyyx4zdn+wnOf30ULzTzA0tnjYFYiO2YmN32XqHlMuBwHLg9Oc1Oy4CbI4NtoYQVHrf5JahCaCLoapA2jLI/xZ3ajKtT5W41UkPiJ+TvpTbdEKx+fIqTZe37pOPPOYGpeOplM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mw9PFT+K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mw9PFT+K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 480B6C16AAE;
	Fri,  9 Jan 2026 12:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960908;
	bh=C2Xlm8nBaL7WUIFNPmy53+qNLoNi8z1DzIsJ95sONLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mw9PFT+KAOM59ViSztAmMOdZLFw2O5ZQ94QVazvpMNe4SZxSygpGWoQMRxeKZv63o
	 u8kcQat3nu9fGAHWc7zwehCWgQk83zGnDQESV373sL9ZtFoOKUgoq0vocOkLrlS/h6
	 z+8ZpPDwXhRR32TXJdqPvoW6xy9n2jMKB4Tl7fGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 534/737] RDMA/bnxt_re: Fix to use correct page size for PDE table
Date: Fri,  9 Jan 2026 12:41:13 +0100
Message-ID: <20260109112154.083593602@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>

[ Upstream commit 3d70e0fb0f289b0c778041c5bb04d099e1aa7c1c ]

In bnxt_qplib_alloc_init_hwq(), while allocating memory for PDE table
driver incorrectly is using the "pg_size" value passed to the function.
Fixed to use the right value 4K. Also, fixed the allocation size for
PBL table.

Fixes: 0c4dcd602817 ("RDMA/bnxt_re: Refactor hardware queue memory allocation")
Signed-off-by: Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>
Signed-off-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Link: https://patch.msgid.link/20251223131855.145955-1-kalesh-anakkur.purayil@broadcom.com
Reviewed-by: Selvin Xavier <selvin.xavier@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/qplib_res.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/bnxt_re/qplib_res.c b/drivers/infiniband/hw/bnxt_re/qplib_res.c
index 77da7cf34427..1c56a0107d1e 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -243,7 +243,7 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 			if (npbl % BIT(MAX_PDL_LVL_SHIFT))
 				npde++;
 			/* Alloc PDE pages */
-			sginfo.pgsize = npde * pg_size;
+			sginfo.pgsize = npde * ROCE_PG_SIZE_4K;
 			sginfo.npages = 1;
 			rc = __alloc_pbl(res, &hwq->pbl[PBL_LVL_0], &sginfo);
 			if (rc)
@@ -251,7 +251,7 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 
 			/* Alloc PBL pages */
 			sginfo.npages = npbl;
-			sginfo.pgsize = PAGE_SIZE;
+			sginfo.pgsize = ROCE_PG_SIZE_4K;
 			rc = __alloc_pbl(res, &hwq->pbl[PBL_LVL_1], &sginfo);
 			if (rc)
 				goto fail;
-- 
2.51.0



