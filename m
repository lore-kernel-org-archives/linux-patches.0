Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F2E93A6F1C;
	Wed, 23 Sep 2026 14:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790173330; cv=none; b=fFYfg8mn56vNA1qGYAqlqFrl5aNByPFnDmm9wtyrNY3CB/dwMl6c+bpi1OL0CM9YBfkhFBbWSuyfJboJj4tiD2MNxr6SIteWIl1ClmkDr9dT5tsI0mx+FZVI+3Gm2lJM7TS6+I9Y9scX1A+0ulbMKcpNxQpRL3ShZ5qOpXmAVZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790173330; c=relaxed/simple;
	bh=W6SHaedIs/WQlZquifl7+Glwoj23qtLkLz7PsjO8Ukg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rLPOlC3T7qQkPiApZCKU9dQRxP2gRjpus7Yf/TE0gdH6Zp645TaHQmg/OnahgE4M+HQ0N9jzLgZrV9c4t6uD1iIUgCAaRBBZKXET/BHJdCjqWKMv7XbyIOZ/59eIwigzDVd0DuuqV54InOUPsFOTLVoWcxvvAsSLobzHkolA/Ks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=adZ00dYL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="adZ00dYL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B481F000FF;
	Wed, 23 Sep 2026 14:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790173329;
	bh=ao0uM18tSNsUxjzIcpU219G504vJyztXfzObFjFYWHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=adZ00dYLoWgryYLc02HFiw7GiQXM+m57QhGEPpUYinMjuhOyEuZ8m1ZMeCTuLXBH5
	 OCcDnweNfp5jFzT3+rcCzjwebpqJzyzkyVCAkjBQYy3nFrAtJGNFMnFQe6V2HOirKY
	 ewpb3LkOpv5XICn6aOGbyuxwNRMrGX0ElGhrWBlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+dc57fd6722deb17e92af@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 185/438] drop_monitor: use raw_cpu_ptr() in tracepoint probes
Date: Wed, 23 Sep 2026 16:03:26 +0200
Message-ID: <20260923140649.560336171@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit c19b7d35086b7d240f1ca3088b0079d2bd39ffb9 ]

syzbot reported a preemption warning in sk_skb_reason_drop():

 BUG: using smp_processor_id() in preemptible [00000000] code: syz.0.17/5917
 caller is net_dm_packet_trace_kfree_skb_hit+0x119/0x350 net/core/drop_monitor.c:519

In net_dm_packet_trace_kfree_skb_hit(), data = this_cpu_ptr(&dm_cpu_data)
is evaluated before spin_lock_irqsave(&data->drop_queue.lock, flags).
When kfree_skb() is called from preemptible context (e.g. process context
during close() on /dev/net/tun), preemption is enabled, triggering the
CONFIG_DEBUG_PREEMPT warning in smp_processor_id().

The same pattern exists in net_dm_hw_trap_summary_probe() and
net_dm_hw_trap_packet_probe() for dm_hw_cpu_data.

This is a false positive because each per-cpu structure is protected
by its own spinlock. If the task migrates to another CPU right after
reading the per-cpu pointer, the lock still safely synchronizes
access to that queue.

Use raw_cpu_ptr() instead of this_cpu_ptr() to silence
CONFIG_DEBUG_PREEMPT without disturbing interrupt state or breaking
PREEMPT_RT locking semantics.

Fixes: ca30707dee2b ("drop_monitor: Add packet alert mode")
Fixes: 5855357cd40e ("drop_monitor: Prepare probe functions for devlink tracepoint")
Reported-by: syzbot+dc57fd6722deb17e92af@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6aa316b2.f81106d8.2ab401.0014.GAE@google.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260910204612.3762015-4-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/drop_monitor.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 873155ca72432..795c15dd1771a 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -448,7 +448,7 @@ net_dm_hw_trap_summary_probe(void *ignore, const struct devlink *devlink,
 	if (metadata->trap_type == DEVLINK_TRAP_TYPE_CONTROL)
 		return;
 
-	hw_data = this_cpu_ptr(&dm_hw_cpu_data);
+	hw_data = raw_cpu_ptr(&dm_hw_cpu_data);
 	raw_spin_lock_irqsave(&hw_data->lock, flags);
 	hw_entries = hw_data->hw_entries;
 
@@ -516,7 +516,7 @@ static void net_dm_packet_trace_kfree_skb_hit(void *ignore,
 	 */
 	nskb->tstamp = tstamp;
 
-	data = this_cpu_ptr(&dm_cpu_data);
+	data = raw_cpu_ptr(&dm_cpu_data);
 
 	spin_lock_irqsave(&data->drop_queue.lock, flags);
 	if (skb_queue_len(&data->drop_queue) < net_dm_queue_len)
@@ -983,7 +983,7 @@ net_dm_hw_trap_packet_probe(void *ignore, const struct devlink *devlink,
 	NET_DM_SKB_CB(nskb)->hw_metadata = n_hw_metadata;
 	nskb->tstamp = tstamp;
 
-	hw_data = this_cpu_ptr(&dm_hw_cpu_data);
+	hw_data = raw_cpu_ptr(&dm_hw_cpu_data);
 
 	spin_lock_irqsave(&hw_data->drop_queue.lock, flags);
 	if (skb_queue_len(&hw_data->drop_queue) < net_dm_queue_len)
-- 
2.53.0



