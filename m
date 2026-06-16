Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13AC1E8320;
	Tue, 16 Jun 2026 15:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623376; cv=none; b=spl0UNf6PpIHZ67ZH+oxibFjPEz0XNepFEScexn6e2OcPdsRQI6Wed3yHaA6aFoT7mQhlz9OAffxi4MtA8O2lBJG2EgdFq/HynFJ2ehNEZl7ppz54orYnsDyjrjku3eVRf5nQ91q6ADcdWLizsCbBigU4p+nYoC7yMNndCsxgjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623376; c=relaxed/simple;
	bh=GZWJwvqWOmtadTZv9Evo72J2oCfE2+kzT4bJIH/Rc+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ty33xuncqqz3R6Ngf4eIWOxwIEg7U4sYCa+NS5i47wO+xvoY8RDJApvy3ROB0gUDbI7uaOYrjfh22RC7LLElF1DdYG6O2mwlfuebrRBJxmtcRihpZNcP5m6r9/nR/MW7NhRuPWBU4OzTZnup78IRK35r74qotpZn1TPuPM23rQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FLAZOqqp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FLAZOqqp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A4C1F000E9;
	Tue, 16 Jun 2026 15:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623375;
	bh=1GVhf7ubM3ePhibBrcJ1TbuhxLrLzVbEClpSTp2RLwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLAZOqqpeJvhIlKQgVA+kmRVcUXRCOOf3KoI91gXDIHhqEAw3kQ1jtmlMpvPKrkR9
	 0xxdpYZ6EGSTkMhINCYmVteuhyNINV1daYjVm8MMKr2VBp6P7TlNsu1RXKS1W4ioFc
	 NMYLYWucWpSEG4v4B0yvyl73wp+7ToR5VnSe7q1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiang Mei <xmei5@asu.edu>,
	Weiming Shi <bestswngs@gmail.com>,
	Allison Henderson <achender@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 135/378] net/rds: fix NULL deref in rds_ib_send_cqe_handler() on masked atomic completion
Date: Tue, 16 Jun 2026 20:26:06 +0530
Message-ID: <20260616145117.408351326@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index fcd04c29f543e6..d6be95542119f6 100644
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



