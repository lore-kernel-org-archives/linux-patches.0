Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E454F3EAE;
	Tue, 13 Oct 2026 11:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892193; cv=none; b=jNu+MhoFhV/zHOOlOu1jRuGbCxcSGQgWJYAwx7Wt3PJXgi9RWn4G8hzSLqUr6/E6Dgh1TNAkVcRCeFU9SOham3mSVka0mFRVLtZplVpmpFFSysoOVZaYGZ9y92E7yQPAzoW6nfXPi8m9t1ME27WrL/1/TPsc/ZZkWPKC8JcbUi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892193; c=relaxed/simple;
	bh=fuzin2aObD/sWkPWGHpOmf6p9i2+V5D3rPktTJ7qc0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ES6EJPrDNVB25WRxEhlG6CqFHisbhO8qsHeFh3rxfiHI+h/TnLuQrYXNAMpcrm+o2/OyySSvePX8Cg6py70FfOFKbI22tIjZQdwhZJc4RM1FZwgyf23W0N3ziRX/7gMV6ZWWS+7G9zdOkjZr8pxuGeOYl/6BW5cwtN7Hol7J49E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ztM3xkCh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ztM3xkCh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5246B1F00893;
	Tue, 13 Oct 2026 11:49:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892191;
	bh=+YpYDrQ3v/2FjPQkUbqPTl8KZE0IfuxL35pByK5qNZk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ztM3xkChnULYZLYBHq6a63Iq9lMMgytmUKXL/FuW0YWA3ynFGZViNp3ex8v6xBIE8
	 IZeQrIg2ipAzA7H0zl70sQm3aMwGZSBdqd4NQcrm8kn22qB5ROdnwkdb98wkegxlrS
	 1e3+suFv1yydcOS7s8SoQtx5LFbrQ4fG7dVZZvds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Denis V. Lunev" <den@openvz.org>,
	Ilya Maximets <i.maximets@ovn.org>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 7.2 092/281] openvswitch: fix soft lockup in the netlink flow dump
Date: Tue, 13 Oct 2026 13:36:48 +0200
Message-ID: <20261013112857.368339407@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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
@@ -1529,6 +1529,12 @@ static int ovs_flow_cmd_dump(struct sk_b
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
@@ -1549,6 +1555,8 @@ static int ovs_flow_cmd_dump(struct sk_b
 		cb->args[0] = bucket;
 		cb->args[1] = obj;
 	}
+
+	local_bh_enable();
 	rcu_read_unlock();
 	return skb->len;
 }


