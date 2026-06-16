Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE493C4178;
	Tue, 16 Jun 2026 17:40:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781631608; cv=none; b=bhjYjn8/GHVCo1jxmczzY0NoTMDH7GY/k0MXlsg8wkxfn0yeHSMDEUp9tjZ3PbMA2boXTxWtvukjL/wJDblx5CcXXnCa4a5Z4a4zCAC2FYxfUkOZ18VMQRGzWS5ik+g7xR2BS3K5C6Floo4BUPuaRTgj/U4TU43Ax67fAiOB4cI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781631608; c=relaxed/simple;
	bh=F9+Kuhq2NxP/V62WL845l05Jlx5KYn17gPoAv0BaXh4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lnM2WNgtp/giOrLliwooY5YKLpDg1DmMGPS/vZVDrOuQzVgxavUtihM3lDF3Lr1b9Lp7NRLqSvQo3RpWvfxIGd620LDKR6T6PlaHn8pJ4jw8MIZLFBKOXK9fEbdjf+NPqKIjjMUg+Qe3DHf9GMyhThLX28dw1OdmYsGsfqDNZQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EB7d/0MQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EB7d/0MQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8212B1F000E9;
	Tue, 16 Jun 2026 17:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781631607;
	bh=iOl++sduk7MK8bvQ/AZ8FFjheumrWL3CmTwZMmENnqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EB7d/0MQ7hu9ySlD3eRx5MX+wVRiIpPwfbZs7mtlZoGzbqwU7kI8ZKn+S9PGV+U26
	 14lXxndhnU+xI9f9woOwicRWjapuG7rUjwvbG6MSe9/JJHPNyRNAwjv6Po///x8bY1
	 RZdopWN3fgnfkLJJBAcxEwgOEE1hKDVGqKrb9kIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 253/522] net/rds: fix NULL deref in rds_ib_send_cqe_handler() on masked atomic completion
Date: Tue, 16 Jun 2026 20:26:40 +0530
Message-ID: <20260616145137.798512154@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



