Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CC63B9D96;
	Sat, 17 Oct 2026 17:14:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257278; cv=none; b=QdgNdbPaPV4QOSJOmuAHx8HoPGSkR7F+5Hm/2pVKlSVJsPCrUj8JYSNJqvQ71VsDste68ysrxCwaMneNaCadjK07ItvFjQ1MHDCOqVl4xgda7+MWtXwXny1ou8jFOL8uOvwjGMEWbUr2livsMA/qpBZFB4oxXBxz9pGLwTud69E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257278; c=relaxed/simple;
	bh=/4dIG7HbsvBK6kOC+xsSVBoQpE3h2sBwlhogj9MgOzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PqwD/qxAjIhJuuI+R4g8CWWGsSL8ylKP3Em6T9EaqsrJWDdEvdjjx2cL6q6Zz/opl6TfjQOe9aUYcB0xc2GMlqDNArTyCtkotjoYdRCVXZP1ra2KKBge1y7f4ox6L9gt0sAloPevp7a7RTYMm0DAim/pO1VDE5P/cwLBPeXsKU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xm0tjAFq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xm0tjAFq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1EB1F000C4;
	Sat, 17 Oct 2026 17:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257276;
	bh=c0TqrozAP3GeKFcj/WP7D3saeeMtccBFt3NN2mbEbS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xm0tjAFqh0yV2C0h5tcitg72lpOQSaa1peVpTpyGsQmltEWF38x+kPieDTAhIgMyg
	 RzBCLA3uy5kvzafey4blq4a6nigqG/D13us9BnqC/I8YgBIGIGNITIm+R9tbLkgrrX
	 gKWoa1OLZOpH0gETp40WKgEpPtPDgr0nFlqtPMZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis V. Lunev" <den@openvz.org>,
	Ilya Maximets <i.maximets@ovn.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.6 0507/1674] openvswitch: fix soft lockup in the netlink flow dump
Date: Sat, 17 Oct 2026 17:46:19 +0200
Message-ID: <20261017160444.121447800@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1500,6 +1500,12 @@ static int ovs_flow_cmd_dump(struct sk_b
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
@@ -1520,6 +1526,8 @@ static int ovs_flow_cmd_dump(struct sk_b
 		cb->args[0] = bucket;
 		cb->args[1] = obj;
 	}
+
+	local_bh_enable();
 	rcu_read_unlock();
 	return skb->len;
 }


