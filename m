Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C2951AFEF;
	Thu, 17 Sep 2026 17:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665051; cv=none; b=QWD2Kaj33LFzBBxBvnGlJ+ARsO8whclvRgDkdLjwRyLN6cI1oPLfXkT8dee+wFi0NseavQPb9CQ1NEZT+S9eXdbcweclXX1p64nTFLfV0THqYV4qlrWVMDgBIsqh/iG4TIuy75WPUb7OFgc0r0W7WNZKo2fMr6vrX4+8qrk+3Dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665051; c=relaxed/simple;
	bh=CdyriODPxjjcUX1qAQgLMzZPPhLV9a56uF6sqRCwS4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ggOJQeUki5T3iWALNpCftcl8P3rM/cIWglcFX2ON5M0+1tL/PNPxd+MemwMJUi26pinmovxH0oh/U2G1mlEglvy6nS6ayqqD7hKAVtpEk05OKgAtbYg9bcSukM0KZgINPiE1s3Qj5YAoBm+/eh/JKdOiVEZt3yFsaSVBRFa8Hc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dX3o728g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dX3o728g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 969C91F000FF;
	Thu, 17 Sep 2026 17:10:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665047;
	bh=mrppfB5N+5t9ZFpsRvJDmR59t0pFpdc4MbvXJhcro0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dX3o728giOMOKzwG85yKkiNBOvHfWRWfoMjvk+h9vIKFMAfcd78X5eVZ+pE2fYnl+
	 pqeuBoLZ4qA6ofigwmKCAjuCTx3XupJG2n2mGZ6rOkJvJqmXnbqeKP4gS3TfhtbROu
	 y8LEuCCUzwl3k5SY+891I/yYUnVyns2uoHMVA/fA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0575/1250] drop_monitor: perform u64_stats updates under IRQ-disabled section
Date: Thu, 17 Sep 2026 16:06:10 +0100
Message-ID: <20260917151607.486764978@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 60d31c2feed3e..54bf1f60829e8 100644
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



