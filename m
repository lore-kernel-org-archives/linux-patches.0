Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46864355031;
	Tue,  6 Jan 2026 17:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721807; cv=none; b=BSIRh8e3XZgDWgCXiq425jgoFK4/O7EKzxfVME7MXJlymTCWTd5vmZcpGBbK+V5NRFDTqdl3+9/zKg6v4XHFg7kve+b88pfZ3ATbD3hjL8SvSsL8rnqJWzlfIcDIG18UNwE85n+yhnN4rrB4Hi3cOCwf+xMYUC5JqzPGZmxua+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721807; c=relaxed/simple;
	bh=TXGPjg5pLXD4yaxDpwEY4b3/k7kPWr52BJuzSfTgzPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OGgxEa6OdeRmBAcAqj4LoZDsACvUkY+LOz5HLjQR8z3M545CkTr+w08q+myLUJTc1bZnxfcn75gZJz+ixclNs7djshPg+16rs5WkNDXmf5OtHMZYhNeoBk1JeMN41W1TdlK7/e4LVoPHgRfdnj0Jw+VDyHcD0edMjtYDhZCo8is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kC6/H7O+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kC6/H7O+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6948CC116C6;
	Tue,  6 Jan 2026 17:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721806;
	bh=TXGPjg5pLXD4yaxDpwEY4b3/k7kPWr52BJuzSfTgzPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kC6/H7O+HBXOsOOL0xCqnIuwSufYi/JUOzdxjS8lGH4yDbqdsSneJlN118e6s4XBz
	 CHf22IV1IHT9zeNyuyNSB5NYW2tW30owYBS5UpVrQe6gpy3ROo/Ld7ZAPTrOc2ofWV
	 7Mmkz9phHrTEO3w8eO2M2psnO97KpADFJP0YJQhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 077/312] RDMA/bnxt_re: Fix to use correct page size for PDE table
Date: Tue,  6 Jan 2026 18:02:31 +0100
Message-ID: <20260106170550.628267231@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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
index 875d7b52c06a..d5c12a51aa43 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -237,7 +237,7 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 			if (npbl % BIT(MAX_PDL_LVL_SHIFT))
 				npde++;
 			/* Alloc PDE pages */
-			sginfo.pgsize = npde * pg_size;
+			sginfo.pgsize = npde * ROCE_PG_SIZE_4K;
 			sginfo.npages = 1;
 			rc = __alloc_pbl(res, &hwq->pbl[PBL_LVL_0], &sginfo);
 			if (rc)
@@ -245,7 +245,7 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 
 			/* Alloc PBL pages */
 			sginfo.npages = npbl;
-			sginfo.pgsize = PAGE_SIZE;
+			sginfo.pgsize = ROCE_PG_SIZE_4K;
 			rc = __alloc_pbl(res, &hwq->pbl[PBL_LVL_1], &sginfo);
 			if (rc)
 				goto fail;
-- 
2.51.0



