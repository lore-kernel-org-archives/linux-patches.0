Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061015;
	b=5gJqi814I5p4zYql08arLJMSPc6y2Rb+GQM5eDbziJfO/2e9v5Av5sUny9y5Y3T57WoL
	 cYWzzPGgbezwmKfN2hq3sdZOQ32lBIaNbLAOzUpCeiouJIDD9DuYq8xmsKI9dkqw/5i2r
	 qWmQZ2wJ77WTWVO8UxXLYzkn93QL2KDuZ2hcdqj3cCEuCehamfkxRIBibxbjI0hIdmclg
	 IfiEiZJd64bBOgvQFSeLcpim91JtuUFZBEjQKKJw4D3udYAFuet8cXvgbbQbknCryfVeC
	 gGMH0Hj5PNR7x2e2yXxfemLkUC9mBD9v2IghfoZ8vkrrMk2WDkRbk5YAf4qqZc/UiBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061015;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cQmx5Cj+f9T6iqdm2Itxo4VmFXzOL2sWU3vDQCer2ic=;
	b=v25sAL+QOR5tpYDFc4psoResLB28IM1ncI19ehlcdcvMBviESLXLWu4hQNQB41OLlPQ/
	 FKUpOSVUONqIndSnHhTG4U259nLJfSoGGZNyZIxfCiZfnJbp50EsazWI23v6eNCm11ZOW
	 vjYI2n7vWaKqQW/XTUPCaDrhQ2hmc2+bH+kM+A7TqZoKLOrpiAOKm1g7mInZj5v5l/30R
	 vF7FNqKDeE5JiQK0+Z0VzzkoMKGiWw5EV5SLMudpU1LdZ+h/Q7bZ4HBGYhSXzzCj618Aj
	 k/hjJQTIcYhA3z95+x6Fd6fgeg+VlB8oKDEualD3E9lI8VBwTn6I1vvU0+JTjiLpeig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSpcQwkJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48042606A32A;
	Thu, 19 Nov 2026 04:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QSpcQwkJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FD151F000C4;
	Thu, 19 Nov 2026 04:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061015;
	bh=cQmx5Cj+f9T6iqdm2Itxo4VmFXzOL2sWU3vDQCer2ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QSpcQwkJRb/9g94nWASlJBPG9H3/C5P4ADBKj0i6je5tVPt/SCSQcr0fqsdstm8i6
	 n1rXAdStXddJjzAMnXR1jaDBvgMIZgITH9iM6TiS165qtaqt+w+i/7/6R2uHsSelLl
	 7cTCNRPgNNKmiWTD8fzuD+CQQV1ZZK65/KLEcrX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dairui Zhang <zhangdairui@gmail.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1402/1848] IB/mad: fix UAF and double-free in RMPP receive reassembly
Date: Wed, 18 Nov 2026 15:57:20 +0100
Message-ID: <20261118150018.220930483@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e0573e4d04040..d5eeeaf74ce87 100644
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



