Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E45349D590;
	Thu, 17 Sep 2026 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668593; cv=none; b=h6ps5CrV1tgI2Vlz7WBWPRMS+iO8gfW61UN4Jls2V7WeTpPSO8nwZBfcow/IPSpWEAn3ipUwfrOz/Xs6BnXhRWe14gMsSyTNuu0SVzF9y6IhRXRdQOI6U2sHJ9wn54YQWkoN2IUPeDfEqZg5ywnL679oqAD0xljXv1LN9XCIiUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668593; c=relaxed/simple;
	bh=LghK0GZu5Jb1E6AuT3CWWTnYQkLj5I8hzMxz3LF5/20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AuEai8XX5NaGxVTtPn4hV0cq5XnH+jCrLF51b/8o0t920kB81g4O7+J9nqsj/3Nx3dprhrBAHLOm0dTldJlcmE6gbglVLlCsUgg0opHHiMG0BkBaQD1A2EwhEFdidyx/5/uQwRrXqeap6Q3tDMCnUYA1BezqWYG2Cs0Q/Tw+M4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tYGKX8l0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tYGKX8l0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36491F000FF;
	Thu, 17 Sep 2026 18:09:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668591;
	bh=0m55JxuMnVvBlw2IzOlmpQbSd/+ut0Av4I0FZMK8qFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tYGKX8l0/RoRg9PeLUxfUi3MioPmCkeI3hS+hpTBjnFgRcA3V2VoyWrXr/7pE1zIO
	 XpV0BgHEhN1YSZx1hCaog7Z9NfOGS8G4NKeDvHskd7C2bvaxs6GsZsiw9ymhlsMYaa
	 uhu8WlEU3av/dBkd6W2cfICT78XWfbNuJMg/tyi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0477/1102] drop_monitor: perform u64_stats updates under IRQ-disabled section
Date: Thu, 17 Sep 2026 16:07:00 +0100
Message-ID: <20260917151551.670293079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit fd098a23bf8fda7eae48db9b06e7c34fc4d228fa ]

In net_dm_packet_trace_kfree_skb_hit() and net_dm_hw_trap_packet_probe(),
u64_stats_update_begin() / u64_stats_inc() / u64_stats_update_end() were
called after spin_unlock_irqrestore(&...drop_queue.lock, flags), when local
IRQs had already been re-enabled.

Tracepoint probes can execute in IRQ or softirq context. On 32-bit
architectures, u64_stats_update_begin() disables preemption but not interrupts,
relying on seqcount writes. If a nested interrupt occurs on the same CPU during
the 64-bit stats update, the reentrant seqcount update can corrupt the
seqcount state or stats value.

Fix this by performing the 64-bit per-CPU stats update before releasing
drop_queue.lock via spin_unlock_irqrestore(), ensuring local interrupts remain
disabled during the u64_stats update.

Fixes: e9feb58020f9 ("drop_monitor: Expose tail drop counter")
Fixes: 5e58109b1ea4 ("drop_monitor: Add support for packet alert mode for hardware drops")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260722141743.3266924-3-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/drop_monitor.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 212f0a048cab6..c880caa158a9f 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -531,10 +531,10 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	return;
 
 unlock_free:
-	spin_unlock_irqrestore(&data->drop_queue.lock, flags);
 	u64_stats_update_begin(&data->stats.syncp);
 	u64_stats_inc(&data->stats.dropped);
 	u64_stats_update_end(&data->stats.syncp);
+	spin_unlock_irqrestore(&data->drop_queue.lock, flags);
 	consume_skb(nskb);
 }
 
@@ -1002,10 +1002,10 @@ net_dm_hw_trap_packet_probe(void *ignore, const struct devlink *devlink,
 	return;
 
 unlock_free:
-	spin_unlock_irqrestore(&hw_data->drop_queue.lock, flags);
 	u64_stats_update_begin(&hw_data->stats.syncp);
 	u64_stats_inc(&hw_data->stats.dropped);
 	u64_stats_update_end(&hw_data->stats.syncp);
+	spin_unlock_irqrestore(&hw_data->drop_queue.lock, flags);
 	net_dm_hw_metadata_free(n_hw_metadata);
 free:
 	consume_skb(nskb);
-- 
2.53.0



