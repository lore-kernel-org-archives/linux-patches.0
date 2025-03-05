Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF52253B4B;
	Wed,  5 Mar 2025 18:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198504; cv=none; b=o3X4DwNOMrQab1uSAKSj6ZydYxsvErOwCbBo255SAalcOC0rCOGCkJyROQx7vLeYHmQ396+CoR6In+YshCqRG/6RaYoVYHPoKl5nxSQOnYN1k5ksRegb2GfdeTgf36+tLObuSTIyq3NjlvmPiso6b1eEZNpuQJPXrge43kPc6iY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198504; c=relaxed/simple;
	bh=34SD2XJBWRvUKJTG0K2q7pHoRA5vuf2RuEj6V+hMClE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lzfh4j0tOnCouaDx1dJq1Y5uAAODXPs+fXtqbAi29bSUIYxVNIIdCzzW0dnVRqT5Of/Tl8A/MKHy/BKRUSW1oOH8/0s7ECVjoICciWzscThgkp9/SREo9yX0rM6UJUcfcnOwyai+5duKH9imEBVPR9TThyjePhNaq3fEjhilgrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yEHodeFv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yEHodeFv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13BB0C4CED1;
	Wed,  5 Mar 2025 18:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198504;
	bh=34SD2XJBWRvUKJTG0K2q7pHoRA5vuf2RuEj6V+hMClE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yEHodeFvh+6l8M7iaCz13Qj6W4GL8wfKsHAQAq/xI8EjnvmlewB2iREjoTxQSI/gY
	 BZOkUa5hp5FrRCmVrfvHb7SEBDwQWkedAsSFKisQyhDmonzGQXZdQSu4mJxyvkvbZd
	 kyjnLguIgmoe0Tkp0VkTVDJnRbS7L25+lJz4tTr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 023/157] RDMA/bnxt_re: Fix the page details for the srq created by kernel consumers
Date: Wed,  5 Mar 2025 18:47:39 +0100
Message-ID: <20250305174506.227810598@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kashyap Desai <kashyap.desai@broadcom.com>

[ Upstream commit b66535356a4834a234f99e16a97eb51f2c6c5a7d ]

While using nvme target with use_srq on, below kernel panic is noticed.

[  549.698111] bnxt_en 0000:41:00.0 enp65s0np0: FEC autoneg off encoding: Clause 91 RS(544,514)
[  566.393619] Oops: divide error: 0000 [#1] PREEMPT SMP NOPTI
..
[  566.393799]  <TASK>
[  566.393807]  ? __die_body+0x1a/0x60
[  566.393823]  ? die+0x38/0x60
[  566.393835]  ? do_trap+0xe4/0x110
[  566.393847]  ? bnxt_qplib_alloc_init_hwq+0x1d4/0x580 [bnxt_re]
[  566.393867]  ? bnxt_qplib_alloc_init_hwq+0x1d4/0x580 [bnxt_re]
[  566.393881]  ? do_error_trap+0x7c/0x120
[  566.393890]  ? bnxt_qplib_alloc_init_hwq+0x1d4/0x580 [bnxt_re]
[  566.393911]  ? exc_divide_error+0x34/0x50
[  566.393923]  ? bnxt_qplib_alloc_init_hwq+0x1d4/0x580 [bnxt_re]
[  566.393939]  ? asm_exc_divide_error+0x16/0x20
[  566.393966]  ? bnxt_qplib_alloc_init_hwq+0x1d4/0x580 [bnxt_re]
[  566.393997]  bnxt_qplib_create_srq+0xc9/0x340 [bnxt_re]
[  566.394040]  bnxt_re_create_srq+0x335/0x3b0 [bnxt_re]
[  566.394057]  ? srso_return_thunk+0x5/0x5f
[  566.394068]  ? __init_swait_queue_head+0x4a/0x60
[  566.394090]  ib_create_srq_user+0xa7/0x150 [ib_core]
[  566.394147]  nvmet_rdma_queue_connect+0x7d0/0xbe0 [nvmet_rdma]
[  566.394174]  ? lock_release+0x22c/0x3f0
[  566.394187]  ? srso_return_thunk+0x5/0x5f

Page size and shift info is set only for the user space SRQs.
Set page size and page shift for kernel space SRQs also.

Fixes: 0c4dcd602817 ("RDMA/bnxt_re: Refactor hardware queue memory allocation")
Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>
Link: https://patch.msgid.link/1740237621-29291-1-git-send-email-selvin.xavier@broadcom.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/bnxt_re/ib_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/bnxt_re/ib_verbs.c b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
index 4b61867188c4c..0ed62d3e494c0 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1872,6 +1872,8 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 	srq->qplib_srq.threshold = srq_init_attr->attr.srq_limit;
 	srq->srq_limit = srq_init_attr->attr.srq_limit;
 	srq->qplib_srq.eventq_hw_ring_id = rdev->nqr->nq[0].ring_id;
+	srq->qplib_srq.sg_info.pgsize = PAGE_SIZE;
+	srq->qplib_srq.sg_info.pgshft = PAGE_SHIFT;
 	nq = &rdev->nqr->nq[0];
 
 	if (udata) {
-- 
2.39.5



