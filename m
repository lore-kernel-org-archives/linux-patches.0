Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209062;
	b=X/sg88plkptwjn0hZQBIPOUy1EB1i22BnH/8dsVr/aAyOPxmeWGRjDApMjnKDeouDLBv
	 PjznRHSytrbNfdzUfVNrZK6nvUotBhXtUXbhcOt6EJ800RfgFAPMfJF4cwmO+doUOhRl8
	 dRitU/OEXdhZwVOX4xtvzZ1VqRA/AzMB7T/EGRpHPhi6cyHQ35lFGOuJFnCpzXxDbtEAo
	 cJYaATffkhkb4rdaX4EkKuac+AL7sQr9dZ5ynwrtvoCfCdaHTjscIvrcl6SP6VgkrKzW9
	 fSVTauiXZzYu/GZDbNigtwueGQiewrwG+JsW7oRUevKspIppi4NaqCYiC0ZnOnZGv1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209062;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y7uY0LPJSPJzhwQ+sNZvzb6vRAulunegIIJTS5bAQZU=;
	b=T4WsG08jDrSrBwObAPBgk5NQxzq06oHZ3n3ccMX47aZIgU6F4dP8SUR0vHsGefFeYTwu
	 B8PDfTo9vmtq3z5wlid9srVN6wjgyCEdt1hENGRkkzQvO7FVVgXDVEzXWVtlZFFBWC2dL
	 rxyBnaxx+fzOihMQAeguXM25eWgPtoy5FaJpWO3hbVdUG2agxfLYRZs3tCx6Ig7UPaujq
	 HtMBZcU9+15DTyg0Oe2I/ogMipbVt6nQ1CEwvqjWOGWevSgn6N2YTQew5XtXgoM3UOscW
	 1F8MY2QTBrrnA+KFxFrpGWncBT5HvwXVN+eiEZU2schz0vhPXQTPsQM9Xu58PT9c4ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cd7KTlg7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C52760A5BCD;
	Wed, 28 Oct 2026 17:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cd7KTlg7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC21C1F031EB;
	Wed, 28 Oct 2026 17:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209062;
	bh=y7uY0LPJSPJzhwQ+sNZvzb6vRAulunegIIJTS5bAQZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cd7KTlg7upvm8tyVI6uaURoCgEnz6LJ4FFoLpTwlJ5gCuNtp8mtRbvQT/hcTcBA7c
	 lQ/DiIhPv0hKGRh7G5LWUxidQuBA9L3FXRn8TcRrNO4N3naP77mnH/0iRBZ+PgPuvV
	 Pp0FOlHHyMOydrJ30t0xZCKgB6NcSEqWSE0BVrCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis V. Lunev" <den@openvz.org>,
	Ilya Maximets <i.maximets@ovn.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 340/516] openvswitch: fix soft lockup in the netlink flow dump
Date: Wed, 28 Oct 2026 17:58:12 +0100
Message-ID: <20261028170011.541398771@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

From: Denis V. Lunev <den@openvz.org>

commit aaaaf87ea99b8766c9a8aa0e71aa42e6bc8a5320 upstream.

A production compute node carrying a few thousand datapath flows hit a
soft lockup inside a single netlink flow dump and panicked.

ovs_flow_cmd_dump() calls ovs_flow_stats_get() for every flow it
emits, and that releases stats->lock with spin_unlock_bh() once per
CPU that has touched the flow. Every release is a local_bh_enable(),
and each one runs the pending softirq backlog in the dumping thread's
own context.

The skb bounds the flows one callback emits, but not the softirq work
it absorbs. On a CPU that carries the box's packet load the backlog
refills as fast as it drains, so the dumping thread becomes that CPU's
softirq engine. It never sleeps and it has no reschedule point, so
under voluntary preemption nothing can take the CPU away from it:
neither the ksoftirqd the kernel woke to take the work over, nor the
stopper thread the softlockup detector dispatches to refresh its
timestamp.

Hold BH off across the whole callback instead, the way
ctnetlink_dump_table() does, so the nested spin_unlock_bh() stop
draining softirqs. The loop already runs under rcu_read_lock() and
cannot sleep. What it gives up is preemption under CONFIG_PREEMPT,
since a BH-off region is not preemptible outside PREEMPT_RT. The
region stays short: the skb caps the flows one callback emits, and
empty buckets cost no skb space but are each visited once per dump, as
the cursor only moves forward. The table grows on insert and shrinks
only on flush, so the walk is bounded by the largest flow count the
datapath has held. The softirq backlog the callback used to absorb has
no bound at all.

Fixes: 63e7959c4b9b ("openvswitch: Per NUMA node flow stats.")
Cc: stable@vger.kernel.org
Signed-off-by: Denis V. Lunev <den@openvz.org>
Reviewed-by: Ilya Maximets <i.maximets@ovn.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/openvswitch/datapath.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/openvswitch/datapath.c
+++ b/net/openvswitch/datapath.c
@@ -1461,6 +1461,12 @@ static int ovs_flow_cmd_dump(struct sk_b
 		return -ENODEV;
 	}
 
+	/*
+	 * Not needed for safety. Stops every spin_unlock_bh() in
+	 * ovs_flow_stats_get() from running the softirq backlog.
+	 */
+	local_bh_disable();
+
 	ti = rcu_dereference(dp->table.ti);
 	for (;;) {
 		struct sw_flow *flow;
@@ -1481,6 +1487,8 @@ static int ovs_flow_cmd_dump(struct sk_b
 		cb->args[0] = bucket;
 		cb->args[1] = obj;
 	}
+
+	local_bh_enable();
 	rcu_read_unlock();
 	return skb->len;
 }


