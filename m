Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D41D47604A;
	Tue, 13 Oct 2026 12:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893808; cv=none; b=bsh2QPpPKRvKAbFiDNY7YKn9LBdXdkz3U29MjgiQAnXPQkkDl7a++Ue0OomPxmuMspIok+85diclq+9s40X7PQtvBRCVqO3uWC9C8I9cnRwP0z67JnoX2fY7FhKu4+fe/PIx7ZljUhciWUFNW2roTdPAL4xdn/46fdznp0wM08I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893808; c=relaxed/simple;
	bh=a3TszLWRwTZkhmkzIwIx75yLn5PpD4dedMkbgDSZipI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atRbSZ9yYr04O1076wkLSnq9YLR0Zn2kzzjl+bOpwRvGuMcHyUOCCnSs2oziTOAyWwYVBV7lmTKJ4CgK4saphUiHNYKEEWF0ZUAp0l6x0duU6d1eiT8v0SYz28ImtUkQByNWquvyzBrlbWEwgS219RUV+E/2nR1RHb3Wuz9fSdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=StTexL1T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="StTexL1T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EB8E1F000FF;
	Tue, 13 Oct 2026 12:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893807;
	bh=OHZID920uGVIBK/UebZrAnBRHT7o2ceT8jCVt72uD3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=StTexL1Tgs0/uuDhXcZ+I5SVaMY14DI5KCsFsczqMqMuRL7nxR/eU3gALsD9rS4Uw
	 3RBRQOPLUBbe5nV4g8XGWuNi8o04P42tS97lIDKfAu/inQx+0DNLuk/RXux9ulXuZQ
	 QdtiidiLuu49cEAeReoEvgNc+v7drpEiO52Q9zRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 295/621] net: fully inline backlog_unlock_irq_restore()
Date: Tue, 13 Oct 2026 13:34:50 +0200
Message-ID: <20261013112927.858680093@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 27a01c1969a5d5ed4739e45777957445af96322d ]

Some arches (like x86) do not inline spin_unlock_irqrestore().

backlog_unlock_irq_restore() is in RPS/RFS critical path,
we prefer using spin_unlock() + local_irq_restore() for
optimal performance.

Also change backlog_unlock_irq_restore() second argument
to avoid a pointless dereference.

No difference in net/core/dev.o code size.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260105163054.13698-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 46762cefe7f4 ("net: serialize netif_running() check in enqueue_to_backlog()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 327b4798837d8..922c4794b8403 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -246,12 +246,11 @@ static inline void backlog_lock_irq_disable(struct softnet_data *sd)
 }
 
 static inline void backlog_unlock_irq_restore(struct softnet_data *sd,
-					      unsigned long *flags)
+					      unsigned long flags)
 {
 	if (IS_ENABLED(CONFIG_RPS) || use_backlog_threads())
-		spin_unlock_irqrestore(&sd->input_pkt_queue.lock, *flags);
-	else
-		local_irq_restore(*flags);
+		spin_unlock(&sd->input_pkt_queue.lock);
+	local_irq_restore(flags);
 }
 
 static inline void backlog_unlock_irq_enable(struct softnet_data *sd)
@@ -5271,7 +5270,7 @@ void kick_defer_list_purge(unsigned int cpu)
 		if (!__test_and_set_bit(NAPI_STATE_SCHED, &sd->backlog.state))
 			__napi_schedule_irqoff(&sd->backlog);
 
-		backlog_unlock_irq_restore(sd, &flags);
+		backlog_unlock_irq_restore(sd, flags);
 
 	} else if (!cmpxchg(&sd->defer_ipi_scheduled, 0, 1)) {
 		smp_call_function_single_async(cpu, &sd->defer_csd);
@@ -5358,14 +5357,14 @@ static int enqueue_to_backlog(struct sk_buff *skb, int cpu,
 		}
 		__skb_queue_tail(&sd->input_pkt_queue, skb);
 		tail = rps_input_queue_tail_incr(sd);
-		backlog_unlock_irq_restore(sd, &flags);
+		backlog_unlock_irq_restore(sd, flags);
 
 		/* save the tail outside of the critical section */
 		rps_input_queue_tail_save(qtail, tail);
 		return NET_RX_SUCCESS;
 	}
 
-	backlog_unlock_irq_restore(sd, &flags);
+	backlog_unlock_irq_restore(sd, flags);
 
 cpu_backlog_drop:
 	reason = SKB_DROP_REASON_CPU_BACKLOG;
-- 
2.53.0



