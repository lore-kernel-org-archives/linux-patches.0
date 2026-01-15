Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794913C0094;
	Thu, 15 Jan 2026 17:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499633; cv=none; b=N5OVLkynKcS/MxCINdxEC/1zhHssncMJgD4Ktk2jO01lZCI+G2PS/wlPdW+HqdpPWcEmSxMHjVnntDYammxjCO5+5xgmGjho1mXYruRJm1E5oIsfMAvDKjvbd9EfVRYr0JigtcLWw3XFtHmatCvejgiKpuyKcWYdS8eK33Rxbv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499633; c=relaxed/simple;
	bh=E4YHxKS4aifImUFxlxyr0VK8FK/11gp5HfupGYB+Oa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qu1FvHCttdB1wJ9+wQGSca15zq7g3/+ZYqE9V63Xjb2uigjPAkVECUF7nQC2JC2AEq+AUbQ2JxfeuJ7+VH3r0GIRswU2YisfQDwYFB5aP+TI3zfjYI944tzT3NwYVjK3EgA0OxmpLm3UoPbaMfljtZBbP4WFIMYiyyhJB51pqs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYXaXlf0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYXaXlf0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0602AC116D0;
	Thu, 15 Jan 2026 17:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499633;
	bh=E4YHxKS4aifImUFxlxyr0VK8FK/11gp5HfupGYB+Oa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tYXaXlf0Z919nzvt6kO2fjnofwFUeaWk74V1WjLioFQiZv4M3zXhL4FUqqPKq8Y43
	 OLnIWwTMZIYmegf50KDJGv2Af2A7cYW6B3QVHmaMGMY1a/bmXK7sZQRjoWVvLMlHp8
	 VXTlKquWvUWp6Xo5xcIGSic9zCy9RkDwxFC7gLwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damodharam Ammepalli <damodharam.ammepalli@broadcom.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 295/451] RDMA/bnxt_re: Fix to use correct page size for PDE table
Date: Thu, 15 Jan 2026 17:48:16 +0100
Message-ID: <20260115164241.561883973@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index be98b23488b4..64e88104165e 100644
--- a/drivers/infiniband/hw/bnxt_re/qplib_res.c
+++ b/drivers/infiniband/hw/bnxt_re/qplib_res.c
@@ -242,7 +242,7 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 			if (npbl % BIT(MAX_PDL_LVL_SHIFT))
 				npde++;
 			/* Alloc PDE pages */
-			sginfo.pgsize = npde * pg_size;
+			sginfo.pgsize = npde * ROCE_PG_SIZE_4K;
 			sginfo.npages = 1;
 			rc = __alloc_pbl(res, &hwq->pbl[PBL_LVL_0], &sginfo);
 			if (rc)
@@ -250,7 +250,7 @@ int bnxt_qplib_alloc_init_hwq(struct bnxt_qplib_hwq *hwq,
 
 			/* Alloc PBL pages */
 			sginfo.npages = npbl;
-			sginfo.pgsize = PAGE_SIZE;
+			sginfo.pgsize = ROCE_PG_SIZE_4K;
 			rc = __alloc_pbl(res, &hwq->pbl[PBL_LVL_1], &sginfo);
 			if (rc)
 				goto fail;
-- 
2.51.0



