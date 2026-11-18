Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048813;
	b=ThlfM4QmiLrzKvKXzhFVmv5TVUY/lcvt4HSgPsFpYtT1BCo602fUET+/o7K+QlpDNTrT
	 oBeVLFhfdca7xKuw7lnvt8RqqHSiWEa8p6peiHdDxS9pH8LfpaxXCQrXtfLYP55FBI0LV
	 HnZmvickwofJO7vaZwuQP7OcF8knaLUza8CnXBm5Xa4erNqVFmlIk0GRGWZaOnMWDgKib
	 69CX8jAiJI63EY7rfC1vmqkCHLJxdhdOnozYnc3z4dWbHsNEvXMmLfhNpLqDpKhnQ+MbC
	 joZG/euSOXvAASEfdkMV5mRS6R1bWmqq8esRUnecXj9lTxqCVPPrfbnxVi2AX6/TZsQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LA5N9s5zYFdLLHCIVAB/FKE7LXnXzx9vW7pyCL/mlng=;
	b=FyosLwvt7dhPDIin+GFD7CQmCoyEEXxE0VZ+aIgHeLLAw8MHHedHkZyaBig/i4Vq7+1r
	 0olRufyexOlvmD/7z1aZ2q6xaNUsgycTBnjMTpVR0v+HAq8v+5inFyT06EBX2bMJeJ1E9
	 U32oZxMEicEaMGnm/yYuvAG1Ca1U3nMLDP/oLcZj5MtCCfJojTPnowszv1VqjbOpigLYc
	 k/eawZpuRcrVXqmhuGTW48mSGTeioMJAErLsQMYZ9vzDQDMVJ+lT4UMZZBAJydmcZlnkb
	 kDI2Jr0RyShP0C5xfWjb9W531+IU13VUFrFSj+olHI8HRdQT2B3nGo0r0CS0dgtR2zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ts5SiiOx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4410606A325;
	Thu, 19 Nov 2026 00:40:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ts5SiiOx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3770A1F000C4;
	Thu, 19 Nov 2026 00:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048813;
	bh=LA5N9s5zYFdLLHCIVAB/FKE7LXnXzx9vW7pyCL/mlng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ts5SiiOxl3EIBNJo7HOVlcLfikRfxtxwr739s0i3RMdZS5Y2EbkcEOVVF4SLPpShR
	 g4QzTQrqQ/lDPH6BIc2BI2COqrVoUnWYCollOgvu32iqGNtA9ZoAl6XagT2wlqwvl7
	 oR2FNVJUtbnnLWffk4GWX+P0rx5xv11Lqe3HhJFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dairui Zhang <zhangdairui@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2130/2857] IB/mad: fix UAF and double-free in RMPP receive reassembly
Date: Wed, 18 Nov 2026 15:52:44 +0100
Message-ID: <20261118150318.097224399@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dairui Zhang <zhangdairui@gmail.com>

[ Upstream commit 90e9b6357bec75f627cde1a85b5887215c80aad8 ]

mad_rmpp_recv.state is protected by two locks that do not exclude
each other: recv_timeout_handler() (port workqueue) uses agent->lock,
continue_rmpp() (CQ softirq) uses rmpp_recv->lock. Nothing serializes
the check-then-set sequence on the state word:

  T1 (CQ softirq)              T2 (port workqueue)
  continue_rmpp()
    lock(rmpp_recv->lock)
    state == ACTIVE  [passes]
                               recv_timeout_handler()
                                 lock(agent->lock)
                                 state = TIMEOUT
                                 list_del(&rmpp_recv->list)
                                 unlock(agent->lock)
                                 destroy_rmpp_recv()
                                   wait_for_completion()
                                   [blocks on T1's ref]
    state = COMPLETE
    unlock(rmpp_recv->lock)
    complete_rmpp()
      queue cleanup_work (+10s)
    deref()
                               [unblocks]
                               kfree(rmpp_recv)
                               ib_free_recv_mad(done_wc)

  +10s: recv_cleanup_handler() runs lock/list_del/destroy on the
        freed rmpp_recv -> UAF write and double free; nothing can
        cancel that cleanup_work anymore, the entry is already off
        agent->rmpp_list. done_wc is also returned to
        ib_mad_complete_recv() and freed again -> UAF read and
        double free.

Reaching this requires sending MADs to a kernel RMPP agent from the
InfiniBand/RoCE fabric: the per-port sa_query agent accepts subnet
manager responses whose SLID/GID/TID are not authenticated on the
fabric, and legacy user_mad agents registered without
IB_USER_MAD_USER_RMPP start reassembly on any incoming RMPP DATA
MAD with an attacker-chosen TID, no in-flight send required. The
attacker controls segment timing and can run many transactions in
parallel (agent->rmpp_list has no cap), so landing the
microseconds-wide receive critical section on the 40-second timeout
boundary is a matter of patience, not luck.

Unify state transitions under rmpp_recv->lock in
recv_timeout_handler(), keeping list manipulation under agent->lock
(which preserves the agent->lock -> rmpp_recv->lock ordering used
by continue_rmpp()). State check/set in both paths is then
serialized, so the loser of the race always observes the final
state and bails out. recv_cleanup_handler() needs no change: with
transitions serialized, a cleanup_work can only be pending after
COMPLETE, in which case the timeout handler exits early.

The race is as old as the RMPP implementation itself.

Fixes: fa619a77046b ("[PATCH] IB: Add RMPP implementation")
Assisted-by: LLM
Signed-off-by: Dairui Zhang <zhangdairui@gmail.com>
Link: https://patch.msgid.link/20260922152342.1474845-1-zhangdairui@gmail.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/mad_rmpp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/mad_rmpp.c b/drivers/infiniband/core/mad_rmpp.c
index 8af0619a39cda..2bdebd011dac5 100644
--- a/drivers/infiniband/core/mad_rmpp.c
+++ b/drivers/infiniband/core/mad_rmpp.c
@@ -245,12 +245,15 @@ static void recv_timeout_handler(struct work_struct *work)
 	struct ib_mad_recv_wc *rmpp_wc;
 	unsigned long flags;
 
-	spin_lock_irqsave(&rmpp_recv->agent->lock, flags);
+	spin_lock_irqsave(&rmpp_recv->lock, flags);
 	if (rmpp_recv->state != RMPP_STATE_ACTIVE) {
-		spin_unlock_irqrestore(&rmpp_recv->agent->lock, flags);
+		spin_unlock_irqrestore(&rmpp_recv->lock, flags);
 		return;
 	}
 	rmpp_recv->state = RMPP_STATE_TIMEOUT;
+	spin_unlock_irqrestore(&rmpp_recv->lock, flags);
+
+	spin_lock_irqsave(&rmpp_recv->agent->lock, flags);
 	list_del(&rmpp_recv->list);
 	spin_unlock_irqrestore(&rmpp_recv->agent->lock, flags);
 
-- 
2.53.0



