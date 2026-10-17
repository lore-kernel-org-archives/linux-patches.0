Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3F138AC99;
	Sat, 17 Oct 2026 17:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257830; cv=none; b=gkqJI24u3gNzzsCXWjt9P1uUKFCgpd+U+DE8LpUql3qKpPIJc6b6OwiIhBENPRI2szXAInDR4KdlrmMGc0Cw5nXDKbg9w/DgXr3bHwinYIQf7MQgs6rX/s0Gjqz0XSRtZ3wTpUjV2osOYTczJnnJD5VisbMC9avxu8+DIkyHlTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257830; c=relaxed/simple;
	bh=gNQue9JdC6rP8xlpqvbZrRz58I/XL6tEAHkv4bhGXtY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OnA00NrcqMTY7qKo/dA2xLYTt2RKlms/stSNFW2oTIY5LuJEH70XD10F0lETX4gWX5PXas3oMb0dxUA4rT/o3cpXcoUzSAr/4OJF2NHWwxW8GGM4eu9T2tf2HSgDLJ4GwTBpnOMZxwaql88kOayYL4RdfRiTntlu74NJgbRPFYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JYSjcieA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JYSjcieA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 348FD1F000C4;
	Sat, 17 Oct 2026 17:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257829;
	bh=6AvHM/70dlU076B/iUOqzJ59W65TVn2bqPl8vYgHFJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JYSjcieAXonf6umaCKhfx+BP/mIckhp5T+N7CWLYPNCAhMyJmRBDmaKW+d8XgmDJp
	 VRHJO6HW57bDcO8H2FyegDunxrXiVidJdWHxolsgmUEe5cuVF8eo61D+vJLrqFLb26
	 /0AC5lewHD9aTbGctCq3SnvGpgNfp9550AmXAq/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Selvin Xavier <selvin.xavier@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0684/1674] RDMA/bnxt_re: Fix the page details for the srq created by kernel consumers
Date: Sat, 17 Oct 2026 17:49:16 +0200
Message-ID: <20261017160448.665169615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
index 7d6c296da3b6e..9ea0c2b352a68 100644
--- a/drivers/infiniband/hw/bnxt_re/ib_verbs.c
+++ b/drivers/infiniband/hw/bnxt_re/ib_verbs.c
@@ -1775,6 +1775,8 @@ int bnxt_re_create_srq(struct ib_srq *ib_srq,
 	srq->qplib_srq.threshold = srq_init_attr->attr.srq_limit;
 	srq->srq_limit = srq_init_attr->attr.srq_limit;
 	srq->qplib_srq.eventq_hw_ring_id = rdev->nq[0].ring_id;
+	srq->qplib_srq.sg_info.pgsize = PAGE_SIZE;
+	srq->qplib_srq.sg_info.pgshft = PAGE_SHIFT;
 	nq = &rdev->nq[0];
 
 	if (udata) {
-- 
2.53.0



