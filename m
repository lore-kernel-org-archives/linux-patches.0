Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEC8934844D;
	Tue, 16 Dec 2025 12:29:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888174; cv=none; b=BBT5y5dcgZJSusYwvaizyRIIXVGxrJ1fG9wwpFr1e383K2T2l9b/llt/CBR+XILj/dMA0eGcKkrWoSZqd2+z94xix35NziexKa/JHX03V1Cg9lbkr46cI4gz96fzYYgQU42orexsoVd/PNqCJQer1XGhuxSB719m5xpvW6Z2fbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888174; c=relaxed/simple;
	bh=gI6ECz17m1Bv9NDDmlad6FxkPHh3dnqsP7fZH1MHCW4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DC9I0jyhsQqtCINtjcTwBjCqonXif6CfTYe5ml66uSOjfadmsyYrehsmYbObaxUJfAEg90IewAptxN0cjX11Deo1IYRgv+3nIrKA7Gkooq8wX92gWCgsfvOV8VgwvMBuZuNYH0rwnVlt2i90oZFygXFz+S9nCXjpe5mmGe4Kd9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HM8v/hgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HM8v/hgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77111C4CEF1;
	Tue, 16 Dec 2025 12:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888173;
	bh=gI6ECz17m1Bv9NDDmlad6FxkPHh3dnqsP7fZH1MHCW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HM8v/hgxhsyZArpcIYhXwfG3to3iZEuNIrFe2iSCgTCEs9svnRtoTCmbhA04idG/2
	 ZZ7OHqq2USHk8uqkqx6HWOQE1Sa96l6ogS7MOV8G1Hv4lgOeGY7SdX8iH6/ipd/pZk
	 PGCMGpI+UkW9PONd99JYcx+w3sd2fZNVr5Ygn9Zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 421/614] RDMA/irdma: Fix data race in irdma_sc_ccq_arm
Date: Tue, 16 Dec 2025 12:13:08 +0100
Message-ID: <20251216111416.623692046@linuxfoundation.org>
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

[ Upstream commit a521928164433de44fed5aaf5f49aeb3f1fb96f5 ]

Adds a lock around irdma_sc_ccq_arm body to prevent inter-thread data race.
Fixes data race in irdma_sc_ccq_arm() reported by KCSAN:

BUG: KCSAN: data-race in irdma_sc_ccq_arm [irdma] / irdma_sc_ccq_arm [irdma]

read to 0xffff9d51b4034220 of 8 bytes by task 255 on cpu 11:
 irdma_sc_ccq_arm+0x36/0xd0 [irdma]
 irdma_cqp_ce_handler+0x300/0x310 [irdma]
 cqp_compl_worker+0x2a/0x40 [irdma]
 process_one_work+0x402/0x7e0
 worker_thread+0xb3/0x6d0
 kthread+0x178/0x1a0
 ret_from_fork+0x2c/0x50

write to 0xffff9d51b4034220 of 8 bytes by task 89 on cpu 3:
 irdma_sc_ccq_arm+0x7e/0xd0 [irdma]
 irdma_cqp_ce_handler+0x300/0x310 [irdma]
 irdma_wait_event+0xd4/0x3e0 [irdma]
 irdma_handle_cqp_op+0xa5/0x220 [irdma]
 irdma_hw_flush_wqes+0xb1/0x300 [irdma]
 irdma_flush_wqes+0x22e/0x3a0 [irdma]
 irdma_cm_disconn_true+0x4c7/0x5d0 [irdma]
 irdma_disconnect_worker+0x35/0x50 [irdma]
 process_one_work+0x402/0x7e0
 worker_thread+0xb3/0x6d0
 kthread+0x178/0x1a0
 ret_from_fork+0x2c/0x50

value changed: 0x0000000000024000 -> 0x0000000000034000

Fixes: 3f49d6842569 ("RDMA/irdma: Implement HW Admin Queue OPs")
Signed-off-by: Krzysztof Czurylo <krzysztof.czurylo@intel.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Link: https://patch.msgid.link/20251125025350.180-2-tatyana.e.nikolova@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/ctrl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/hw/irdma/ctrl.c b/drivers/infiniband/hw/irdma/ctrl.c
index 4ef1c29032f77..991ce4890bfb2 100644
--- a/drivers/infiniband/hw/irdma/ctrl.c
+++ b/drivers/infiniband/hw/irdma/ctrl.c
@@ -3950,11 +3950,13 @@ int irdma_sc_cqp_destroy(struct irdma_sc_cqp *cqp)
  */
 void irdma_sc_ccq_arm(struct irdma_sc_cq *ccq)
 {
+	unsigned long flags;
 	u64 temp_val;
 	u16 sw_cq_sel;
 	u8 arm_next_se;
 	u8 arm_seq_num;
 
+	spin_lock_irqsave(&ccq->dev->cqp_lock, flags);
 	get_64bit_val(ccq->cq_uk.shadow_area, 32, &temp_val);
 	sw_cq_sel = (u16)FIELD_GET(IRDMA_CQ_DBSA_SW_CQ_SELECT, temp_val);
 	arm_next_se = (u8)FIELD_GET(IRDMA_CQ_DBSA_ARM_NEXT_SE, temp_val);
@@ -3965,6 +3967,7 @@ void irdma_sc_ccq_arm(struct irdma_sc_cq *ccq)
 		   FIELD_PREP(IRDMA_CQ_DBSA_ARM_NEXT_SE, arm_next_se) |
 		   FIELD_PREP(IRDMA_CQ_DBSA_ARM_NEXT, 1);
 	set_64bit_val(ccq->cq_uk.shadow_area, 32, temp_val);
+	spin_unlock_irqrestore(&ccq->dev->cqp_lock, flags);
 
 	dma_wmb(); /* make sure shadow area is updated before arming */
 
-- 
2.51.0



