Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2CC547988D;
	Sat, 12 Sep 2026 12:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214468; cv=none; b=VvNL1mZXVyVA8M6u/6ZgMB3hYYu4FHMSF7KMPh0VDf0sx2M9yr6L3AuE5jY/gabGx4G0Q58TDo8QhR9tiJGfq92a2g33/9gCg4POLZ9AOOFFjsW/kZZkN0e+MYecDu92dnuuV1l7hpvYQmNTdaa6HZk6ON1IiGabTlczCUOw978=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214468; c=relaxed/simple;
	bh=/1pyAp54JaFavOJp50kXFTTonX6H34WigpZ8az9x7Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LiV/crttT9Hvxq13Pxx8tuBvtfRPIb08M8STjy95oG+fzzZtKy8uEBCbBOH2NdId5Ez+H9YoA2TKb6cXabDnstz41sSYslneEd/NvaCcOIREzsiqXZG2YxnbJLaQgVRuInuF1WGXR+X4QC0Z7sWNhX/NeJ1ulWU4/CK+PrZQ/cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JAtUvujA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JAtUvujA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD5801F000FF;
	Sat, 12 Sep 2026 12:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214466;
	bh=2ThC3wk0BuYk1hPlqhA9eup7ZBLbz+8pwFDRCi/UUWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JAtUvujATx6BU0P0m9w3XvQ1PldV3D30S30sLTIi4KBu8icmpO4H7j9AcwaEPVcZH
	 tokYVR3u9NqlmQS0tWifeU82wmbva3t7fyxKOvaSXv5Fk8TSih1I0Z4dNG2D/met6V
	 vSOVUPWL02rv+fRcHBEo3y/vrGg/FtelljQExV1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Saab <ps@mu.org>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0289/1376] net/mlx5e: xsk: Fix unlocked writing to ICOSQ
Date: Sat, 12 Sep 2026 08:45:15 +0200
Message-ID: <20260912065613.987069114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

commit c326f9c68921e2f14dfcecb2f6b4216313d50248 upstream.

During napi poll, when the affinity changes and there's still XSK work
to be done, we trigger an ICOSQ interrupt on the new CPU. However, this
triggering on the ICOSQ is done unprotected.

There are 2 such races:

A) mlx5e_trigger_irq() is called while mlx5e_xsk_alloc_rx_mpwqe() is
running from a different CPU due to affinity change. This can happen
because IRQ triggering is done after napi_complete_done(). At this point
the NAPI can be scheduled on a different CPU. Like this:

  CPU A (old affinity, NAPI tail)    CPU B (new affinity, fresh NAPI)
  -------------------------------    --------------------------------
  napi_complete_done()  clears SCHED
  mlx5e_cq_arm(...)
                                     napi_schedule_prep() sets SCHED
                                     mlx5e_napi_poll()
                                       mlx5e_xsk_alloc_rx_mpwqe()
                                         mlx5e_icosq_sync_lock() // noop
                                         memcpy 640 B UMR body
                                         advance sq->pc by 10
  mlx5e_trigger_irq(&c->icosq)
    wqe_info[pi] = {NOP, 1}
    mlx5e_post_nop() advances sq->pc

B) mlx5e_trigger_irq() is called on the ICOSQ when
mlx5e_trigger_napi_icosq() is running.

The obvious fix would be to lock the ICOSQ. But ICOSQ has an optimized
locking scheme that doesn't work for this scenario. Kick the async ICOSQ
instead which is always locked.

This issue was noticed in the wild with the following splat:

  netdevice: ge-0-0-1: Bad OP in ICOSQ CQE: 0xd
  WARNING: drivers/net/ethernet/mellanox/mlx5/core/en_rx.c:826 [...]
  [...]
  Call Trace:
   <IRQ>
   mlx5e_napi_poll+0x11d/0x7f0 [mlx5_core]
   __napi_poll+0x30/0x200
   ? skb_defer_free_flush+0x9c/0xc0
   net_rx_action+0x2fe/0x3f0
   handle_softirqs+0xd8/0x340
   __irq_exit_rcu+0xbc/0xe0
   common_interrupt+0x85/0xa0
   </IRQ>
   <TASK>
   asm_common_interrupt+0x26/0x40
  [...]
  ---[ end trace 0000000000000000 ]---
  mlx5_core 0000:08:00.0 ge-0-0-1: Error cqe on cqn 0x548, ci 0x2022, qn 0x8f4,
  opcode 0xd, syndrome 0x2, vendor syndrome 0x68
  00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00000030: 00 00 00 00 01 00 68 02 01 00 08 f4 de 14 59 d2
  WQE DUMP: WQ size 16384 WQ cur size 0, WQE index 0x1e14, len: 64
  00000000: 00 00 00 01 d9 ed 80 02 00 00 00 01 d9 ed 90 02
  00000010: 00 00 00 01 d9 ed a0 02 00 00 00 01 d9 ed b0 02
  00000020: 00 00 00 01 d9 ed c0 02 00 00 00 01 d9 ed d0 02
  00000030: 00 00 00 01 d9 ed e0 02 00 00 00 01 d9 ed f0 02
  mlx5_core 0000:08:00.0 ge-0-0-1: Error cqe on cqn 0x548, ci 0x2023, qn 0x8f4,
  opcode 0xd, syndrome 0x5, vendor syndrome 0xf9
  00000000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00000010: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  00000030: 00 00 00 00 01 00 f9 05 01 00 08 f4 de 15 cf d2

[ Backport to 6.18.y and older: upstream commit calls
  mlx5e_trigger_napi_async_icosq(), which was introduced by commit
  0da1dba72616 ("net/mlx5e: XSK, Fix unintended ICOSQ change") and is not
  present here. In these trees mlx5e_trigger_napi_icosq() is the
  equivalent helper: it takes c->async_icosq_lock and triggers
  c->async_icosq, which is unconditionally opened, activated, polled and
  armed for every channel. Race B does not apply, as it concerns the
  sync-ICOSQ variant of mlx5e_trigger_napi_icosq() that only exists
  upstream, and mlx5e_icosq_sync_lock() in the race A diagram has no
  equivalent here. ]

Fixes: db05815b36cb ("net/mlx5e: Add XSK zero-copy support")
Reported-by: Paul Saab <ps@mu.org>
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260513064613.334602-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
index 5873fde65c2e3..e9912369e361b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -245,7 +245,7 @@ int mlx5e_napi_poll(struct napi_struct *napi, int budget)
 	}
 
 	if (unlikely(aff_change && busy_xsk)) {
-		mlx5e_trigger_irq(&c->icosq);
+		mlx5e_trigger_napi_icosq(c);
 		ch_stats->force_irq++;
 	}
 
-- 
2.53.0



