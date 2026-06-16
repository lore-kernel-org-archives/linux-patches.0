Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159F144DB64;
	Tue, 16 Jun 2026 15:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625484; cv=none; b=eIRvAZ/T1GaYnD9BO6oWuRQCkfA3bRggc7WAkvv10Jn2A2YeWjy6+W1OOsF598Sq3npM7IgbV6pPSHvyw1EGfZr1yH1eRoJjW/i3MMLVCSQfOIWHnlMYGEjjcwI7oBOZ3+Ghn52S3uwycz/ghwR3KW7s5mtV0vQNtMpecGWy75A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625484; c=relaxed/simple;
	bh=eLd8GE2EHoIb1GOMvxTE3TB1eelAGeP4K3M6vLr9hhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e46XeyC6ceKJI/+GAK41Kzio08tZD/X93fOqCpy5VhVpQi1CV5ysoSwd9cDvIV6XllygfPXoB2xKeCZa2DN9mwj7aS0vzS0L0O4/CDlAEwgOpvTU/rx7oxK233yxBuEH+gUniD+07MpMCOILJrfOrSCf1myhzkVr12+dIbW1wec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sbo3/z8P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sbo3/z8P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ACE51F00A3D;
	Tue, 16 Jun 2026 15:58:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625483;
	bh=Hugzu143pBXspy7P/zv1v3puXUv1hCL3anxq/gQusxk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Sbo3/z8PqMktHCxoKbtZQ85aQnD/5Ep1oKHPMD9AH8zfNE9gWg3McffSMQUGIuYaV
	 6qRqVaI/8DaXDnwAeHCeDWNRZ83lzhHmsXmfPEKIDM3+o4ZYa+SnL1wPpGgr2bZI8s
	 flIkINr2MUF0rCd0k1uDBHbOn5Qg41/syBPrw/aU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 119/325] net/rds: fix NULL deref in rds_ib_send_cqe_handler() on masked atomic completion
Date: Tue, 16 Jun 2026 20:28:35 +0530
Message-ID: <20260616145103.643641707@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

From: Weiming Shi <bestswngs@gmail.com>

[ Upstream commit 34080db3e70ddf94c38512ad2331e3c3afca6cc1 ]

rds_ib_xmit_atomic() always programs a masked atomic opcode
(IB_WR_MASKED_ATOMIC_CMP_AND_SWP or IB_WR_MASKED_ATOMIC_FETCH_AND_ADD)
for every RDS atomic cmsg.  But the completion-side switch in
rds_ib_send_unmap_op() only handles the non-masked opcodes, so a masked
atomic completion falls through to default and returns rm == NULL while
send->s_op is left set.  rds_ib_send_cqe_handler() then dereferences the
NULL rm via rm->m_final_op, oopsing in softirq context.  An unprivileged
AF_RDS sendmsg() of an atomic cmsg over an active RDS/IB connection
triggers it; on hardware that natively accepts masked atomics (mlx4,
mlx5) no extra setup is needed.

  RDS/IB: rds_ib_send_unmap_op: unexpected opcode 0xd in WR!
  Oops: general protection fault [#1] SMP KASAN
  KASAN: null-ptr-deref in range [0x0000000000000190-0x0000000000000197]
  RIP: rds_ib_send_cqe_handler+0x25c/0xb10 (net/rds/ib_send.c:282)
  Call Trace:
   <IRQ>
   rds_ib_send_cqe_handler (net/rds/ib_send.c:282)
   poll_scq (net/rds/ib_cm.c:274)
   rds_ib_tasklet_fn_send (net/rds/ib_cm.c:294)
   tasklet_action_common (kernel/softirq.c:943)
   handle_softirqs (kernel/softirq.c:573)
   run_ksoftirqd (kernel/softirq.c:479)
   </IRQ>
  Kernel panic - not syncing: Fatal exception in interrupt

Handle the masked atomic opcodes in the same case as the non-masked
ones: they map to the same struct rds_message.atomic union member, so
the existing container_of()/rds_ib_send_unmap_atomic() body is correct
for them.

Fixes: 20c72bd5f5f9 ("RDS: Implement masked atomic operations")
Reported-by: Xiang Mei <xmei5@asu.edu>
Signed-off-by: Weiming Shi <bestswngs@gmail.com>
Reviewed-by: Allison Henderson <achender@kernel.org>
Link: https://patch.msgid.link/20260606192447.1179255-2-bestswngs@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/rds/ib_send.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/rds/ib_send.c b/net/rds/ib_send.c
index 4190b90ff3b18a..1909cd440a4b66 100644
--- a/net/rds/ib_send.c
+++ b/net/rds/ib_send.c
@@ -170,6 +170,8 @@ static struct rds_message *rds_ib_send_unmap_op(struct rds_ib_connection *ic,
 		break;
 	case IB_WR_ATOMIC_FETCH_AND_ADD:
 	case IB_WR_ATOMIC_CMP_AND_SWP:
+	case IB_WR_MASKED_ATOMIC_FETCH_AND_ADD:
+	case IB_WR_MASKED_ATOMIC_CMP_AND_SWP:
 		if (send->s_op) {
 			rm = container_of(send->s_op, struct rds_message, atomic);
 			rds_ib_send_unmap_atomic(ic, send->s_op, wc_status);
-- 
2.53.0



