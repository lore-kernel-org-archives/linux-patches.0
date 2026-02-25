Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50902F5A2C;
	Wed, 25 Feb 2026 06:57:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002650; cv=none; b=RGkQDuksPd/Fa9fMPGMqvc4bdwUASnIH5WQ43Y3SQ6e9A7yeDyu/aadV5YNmcvn67Zrivb25Bls2Y7ZIeWzNLCdN9UIZO78w94spiUE/KaEBv2TuH7gOviWfIn2MjocD6kwj3dA7spx3U1g4pxyA1+beKasG1EFvZ5sAeZCFsns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002650; c=relaxed/simple;
	bh=871ATZPN+AXVfxoPTHUI4GuFzxRYPQo+amS0qt1fmIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M0YZaGHV6YspwfYDz2wRsDcJuk9suErNEsO3vdAeEuNBqiBaNuPD16Xy+z3xCJSRrBWrGfxpefooztDbHQEhOXDwuXfVjhzQblQmnU4pozmLgyfZ74KVA94lpP5E/fV0aKd/SYl6fdML50GlK12m+0YahQ+/NvM2TucWX5yf1Ik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Oem0mruU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Oem0mruU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BFE1C116D0;
	Wed, 25 Feb 2026 06:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002650;
	bh=871ATZPN+AXVfxoPTHUI4GuFzxRYPQo+amS0qt1fmIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Oem0mruUEK+ncMKMDrS+32MurmsPZ7cJUX9MgrJXXLpZGO7y7FMrCISvJoUNu6Mw6
	 mnmDlCtggJA8jFx7W0QZwjO6MtkyPQVWSOPY6dr4kE/SoQlmpXFdTAmXEDi9pEblY7
	 xBkLd5JeC1Vb/1KsAUfY5ExaRUECYCuw2MtogK08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 381/641] RDMA/rxe: Fix race condition in QP timer handlers
Date: Tue, 24 Feb 2026 17:21:47 -0800
Message-ID: <20260225012357.825716502@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Li Zhijian <lizhijian@fujitsu.com>

[ Upstream commit 87bf646921430e303176edc4eb07c30160361b73 ]

I encontered the following warning:
 WARNING: drivers/infiniband/sw/rxe/rxe_task.c:249 at rxe_sched_task+0x1c8/0x238 [rdma_rxe], CPU#0: swapper/0/0
...
  libsha1 [last unloaded: ip6_udp_tunnel]
 CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Tainted: G         C          6.19.0-rc5-64k-v8+ #37 PREEMPT
 Tainted: [C]=CRAP
 Hardware name: Raspberry Pi 4 Model B Rev 1.2
 Call trace:
  rxe_sched_task+0x1c8/0x238 [rdma_rxe] (P)
  retransmit_timer+0x130/0x188 [rdma_rxe]
  call_timer_fn+0x68/0x4d0
  __run_timers+0x630/0x888
...
 WARNING: drivers/infiniband/sw/rxe/rxe_task.c:38 at rxe_sched_task+0x1c0/0x238 [rdma_rxe], CPU#0: swapper/0/0
...
 WARNING: drivers/infiniband/sw/rxe/rxe_task.c:111 at do_work+0x488/0x5c8 [rdma_rxe], CPU#3: kworker/u17:4/93400
...
 refcount_t: underflow; use-after-free.
 WARNING: lib/refcount.c:28 at refcount_warn_saturate+0x138/0x1a0, CPU#3: kworker/u17:4/93400

The issue is caused by a race condition between retransmit_timer() and
rxe_destroy_qp, leading to the Queue Pair's (QP) reference count dropping
to zero during timer handler execution.

It seems this warning is harmless because rxe_qp_do_cleanup() will flush
all pending timers and requests.

Example of flow causing the issue:

CPU0                                   CPU1
retransmit_timer() {
    spin_lock_irqsave
                           rxe_destroy_qp()
                            __rxe_cleanup()
                              __rxe_put() // qp->ref_count decrease to 0
                            rxe_qp_do_cleanup() {
    if (qp->valid) {
        rxe_sched_task() {
            WARN_ON(rxe_read(task->qp) <= 0);
        }
    }
    spin_unlock_irqrestore
}
                              spin_lock_irqsave
                              qp->valid = 0
                              spin_unlock_irqrestore
                            }

Ensure the QP's reference count is maintained and its validity is checked
within the timer callbacks by adding calls to rxe_get(qp) and corresponding
rxe_put(qp) after use.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Fixes: d94671632572 ("RDMA/rxe: Rewrite rxe_task.c")
Link: https://patch.msgid.link/20260120074437.623018-1-lizhijian@fujitsu.com
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_comp.c | 3 +++
 drivers/infiniband/sw/rxe/rxe_req.c  | 3 +++
 2 files changed, 6 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_comp.c b/drivers/infiniband/sw/rxe/rxe_comp.c
index a5b2b62f596b0..1390e861bd1d7 100644
--- a/drivers/infiniband/sw/rxe/rxe_comp.c
+++ b/drivers/infiniband/sw/rxe/rxe_comp.c
@@ -119,12 +119,15 @@ void retransmit_timer(struct timer_list *t)
 
 	rxe_dbg_qp(qp, "retransmit timer fired\n");
 
+	if (!rxe_get(qp))
+		return;
 	spin_lock_irqsave(&qp->state_lock, flags);
 	if (qp->valid) {
 		qp->comp.timeout = 1;
 		rxe_sched_task(&qp->send_task);
 	}
 	spin_unlock_irqrestore(&qp->state_lock, flags);
+	rxe_put(qp);
 }
 
 void rxe_comp_queue_pkt(struct rxe_qp *qp, struct sk_buff *skb)
diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 373b03f223beb..12d03f390b097 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -102,6 +102,8 @@ void rnr_nak_timer(struct timer_list *t)
 
 	rxe_dbg_qp(qp, "nak timer fired\n");
 
+	if (!rxe_get(qp))
+		return;
 	spin_lock_irqsave(&qp->state_lock, flags);
 	if (qp->valid) {
 		/* request a send queue retry */
@@ -110,6 +112,7 @@ void rnr_nak_timer(struct timer_list *t)
 		rxe_sched_task(&qp->send_task);
 	}
 	spin_unlock_irqrestore(&qp->state_lock, flags);
+	rxe_put(qp);
 }
 
 static void req_check_sq_drain_done(struct rxe_qp *qp)
-- 
2.51.0



