Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988771D0956;
	Wed,  2 Oct 2024 14:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880026; cv=none; b=sfU+WzJVZEpaksTgSbMs/hYyrYkonZmNRvZaYXS3hjldaqP0g9wiJn8O80wx+Jpa1ELIpqjwy9MZieYu4BrnIGp7BckE6p2axRj9wxGkxWe3akG4q1ZD7o06kheO0ZXMO3fOWhorUjuYhRxBIjXQ52mx+XIPhlBqB6BpVVHUfNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880026; c=relaxed/simple;
	bh=ynJLCK0xyU5ePFuaRMTKGsfZsSXqh0k9ldhHzZGs43M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H2FRiDl/O1LA2e36UOZTayI/5QsqTUBXIDfp5nSuapJtVKbJsmNFdq650ey8oj9ishskA02RbMDjcrmQoe0XqvDAKSynYHyxjZZVRH6NCP9yOKYrQlcSnVEE45djxn5hpJqdjjKRKfbV+UcA72D9dP4Do8quGEpKQb/uNKEBWio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c5WwlzgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c5WwlzgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DC67C4CEC2;
	Wed,  2 Oct 2024 14:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880026;
	bh=ynJLCK0xyU5ePFuaRMTKGsfZsSXqh0k9ldhHzZGs43M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c5WwlzgJ73KQXZMeKReqOb3LbKWCkyIiSdmZWQ5NB8XIRxJkd1XHkcDFdK15tRL0z
	 TNqKEXkKTwPDElRYbj5B3j6b2i5eU+AJLCa49FRphYNg/CmBDaouesrf8iXQe813rn
	 QIci5xci4Rm1yrqm3ME/j6y2LefMh5kGfMVV8/mQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengchang Tang <tangchengchang@huawei.com>,
	Junxian Huang <huangjunxian6@hisilicon.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 318/538] RDMA/hns: Fix spin_unlock_irqrestore() called with IRQs enabled
Date: Wed,  2 Oct 2024 14:59:17 +0200
Message-ID: <20241002125804.980168063@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

From: Chengchang Tang <tangchengchang@huawei.com>

[ Upstream commit 74d315b5af180220d561684d15897730135733a6 ]

Fix missuse of spin_lock_irq()/spin_unlock_irq() when
spin_lock_irqsave()/spin_lock_irqrestore() was hold.

This was discovered through the lock debugging, and the corresponding
log is as follows:

raw_local_irq_restore() called with IRQs enabled
WARNING: CPU: 96 PID: 2074 at kernel/locking/irqflag-debug.c:10 warn_bogus_irq_restore+0x30/0x40
...
Call trace:
 warn_bogus_irq_restore+0x30/0x40
 _raw_spin_unlock_irqrestore+0x84/0xc8
 add_qp_to_list+0x11c/0x148 [hns_roce_hw_v2]
 hns_roce_create_qp_common.constprop.0+0x240/0x780 [hns_roce_hw_v2]
 hns_roce_create_qp+0x98/0x160 [hns_roce_hw_v2]
 create_qp+0x138/0x258
 ib_create_qp_kernel+0x50/0xe8
 create_mad_qp+0xa8/0x128
 ib_mad_port_open+0x218/0x448
 ib_mad_init_device+0x70/0x1f8
 add_client_context+0xfc/0x220
 enable_device_and_get+0xd0/0x140
 ib_register_device.part.0+0xf4/0x1c8
 ib_register_device+0x34/0x50
 hns_roce_register_device+0x174/0x3d0 [hns_roce_hw_v2]
 hns_roce_init+0xfc/0x2c0 [hns_roce_hw_v2]
 __hns_roce_hw_v2_init_instance+0x7c/0x1d0 [hns_roce_hw_v2]
 hns_roce_hw_v2_init_instance+0x9c/0x180 [hns_roce_hw_v2]

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Chengchang Tang <tangchengchang@huawei.com>
Signed-off-by: Junxian Huang <huangjunxian6@hisilicon.com>
Link: https://patch.msgid.link/20240906093444.3571619-6-huangjunxian6@hisilicon.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hns/hns_roce_qp.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index bff00b3af41fb..04063cfacae5f 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -1379,19 +1379,19 @@ void hns_roce_lock_cqs(struct hns_roce_cq *send_cq, struct hns_roce_cq *recv_cq)
 		__acquire(&send_cq->lock);
 		__acquire(&recv_cq->lock);
 	} else if (unlikely(send_cq != NULL && recv_cq == NULL)) {
-		spin_lock_irq(&send_cq->lock);
+		spin_lock(&send_cq->lock);
 		__acquire(&recv_cq->lock);
 	} else if (unlikely(send_cq == NULL && recv_cq != NULL)) {
-		spin_lock_irq(&recv_cq->lock);
+		spin_lock(&recv_cq->lock);
 		__acquire(&send_cq->lock);
 	} else if (send_cq == recv_cq) {
-		spin_lock_irq(&send_cq->lock);
+		spin_lock(&send_cq->lock);
 		__acquire(&recv_cq->lock);
 	} else if (send_cq->cqn < recv_cq->cqn) {
-		spin_lock_irq(&send_cq->lock);
+		spin_lock(&send_cq->lock);
 		spin_lock_nested(&recv_cq->lock, SINGLE_DEPTH_NESTING);
 	} else {
-		spin_lock_irq(&recv_cq->lock);
+		spin_lock(&recv_cq->lock);
 		spin_lock_nested(&send_cq->lock, SINGLE_DEPTH_NESTING);
 	}
 }
@@ -1411,13 +1411,13 @@ void hns_roce_unlock_cqs(struct hns_roce_cq *send_cq,
 		spin_unlock(&recv_cq->lock);
 	} else if (send_cq == recv_cq) {
 		__release(&recv_cq->lock);
-		spin_unlock_irq(&send_cq->lock);
+		spin_unlock(&send_cq->lock);
 	} else if (send_cq->cqn < recv_cq->cqn) {
 		spin_unlock(&recv_cq->lock);
-		spin_unlock_irq(&send_cq->lock);
+		spin_unlock(&send_cq->lock);
 	} else {
 		spin_unlock(&send_cq->lock);
-		spin_unlock_irq(&recv_cq->lock);
+		spin_unlock(&recv_cq->lock);
 	}
 }
 
-- 
2.43.0



