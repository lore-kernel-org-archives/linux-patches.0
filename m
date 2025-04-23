Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13E1175BF;
	Wed, 23 Apr 2025 14:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420069; cv=none; b=FWve/WnYdZm/4cu24/g4r8b2jf0fuY78/5G7VncDNu++H9fekTovQPoBopzEDfFMkCHwHs4BkeTtmGCr/1q9t4kZ4ADoVwAYd4ibZVvrhw/9ZThwUmjAWBP/OJGXSybd9AQwwzFMOEdw19Gf5KNEF4jqH03psjg5KpEvLeiSEPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420069; c=relaxed/simple;
	bh=QS1HXhA9So4UgQHdlfnw828MoeFzNqXlI4WUQG1q9EE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRZDWE54qjEBsqWYs7JcGbh/GmqqjJL+4k+X9I/KCtoAKJDqy3SjUPS9TkN9IMptvV74aCI5RD4z5pqJ90nwTDciqjc20urFoszsvYFpN8aYPZUL30Z3p03owN9mnjmP7vgKNwkOeEdfRkloSnAOFt8+HTHTL0w9Qi1+fI3SWaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vj9iLQcf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vj9iLQcf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12F5AC4CEE2;
	Wed, 23 Apr 2025 14:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420068;
	bh=QS1HXhA9So4UgQHdlfnw828MoeFzNqXlI4WUQG1q9EE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vj9iLQcf3ESpjJ1nyX74gxj4DMcIx89oIsJ8sq9UbQHjOtO2shTSKMq3YX1pp/8HB
	 +PrA5AbUIn3ZVLKUEj5WlO16BB3/eD71d9jqCKX07MO6nMVIo8SN/wDDHKxJzPee/K
	 h1EHQ4LKrlco6QT7QMoSkIULbluLn2SFV93cjsi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzkaller@googlegroups.com>,
	Octavian Purdila <tavip@google.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 014/291] net_sched: sch_sfq: move the limit validation
Date: Wed, 23 Apr 2025 16:40:03 +0200
Message-ID: <20250423142624.989277295@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Octavian Purdila <tavip@google.com>

[ Upstream commit b3bf8f63e6179076b57c9de660c9f80b5abefe70 ]

It is not sufficient to directly validate the limit on the data that
the user passes as it can be updated based on how the other parameters
are changed.

Move the check at the end of the configuration update process to also
catch scenarios where the limit is indirectly updated, for example
with the following configurations:

tc qdisc add dev dummy0 handle 1: root sfq limit 2 flows 1 depth 1
tc qdisc add dev dummy0 handle 1: root sfq limit 2 flows 1 divisor 1

This fixes the following syzkaller reported crash:

------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in net/sched/sch_sfq.c:203:6
index 65535 is out of range for type 'struct sfq_head[128]'
CPU: 1 UID: 0 PID: 3037 Comm: syz.2.16 Not tainted 6.14.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 12/27/2024
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:94 [inline]
 dump_stack_lvl+0x201/0x300 lib/dump_stack.c:120
 ubsan_epilogue lib/ubsan.c:231 [inline]
 __ubsan_handle_out_of_bounds+0xf5/0x120 lib/ubsan.c:429
 sfq_link net/sched/sch_sfq.c:203 [inline]
 sfq_dec+0x53c/0x610 net/sched/sch_sfq.c:231
 sfq_dequeue+0x34e/0x8c0 net/sched/sch_sfq.c:493
 sfq_reset+0x17/0x60 net/sched/sch_sfq.c:518
 qdisc_reset+0x12e/0x600 net/sched/sch_generic.c:1035
 tbf_reset+0x41/0x110 net/sched/sch_tbf.c:339
 qdisc_reset+0x12e/0x600 net/sched/sch_generic.c:1035
 dev_reset_queue+0x100/0x1b0 net/sched/sch_generic.c:1311
 netdev_for_each_tx_queue include/linux/netdevice.h:2590 [inline]
 dev_deactivate_many+0x7e5/0xe70 net/sched/sch_generic.c:1375

Reported-by: syzbot <syzkaller@googlegroups.com>
Fixes: 10685681bafc ("net_sched: sch_sfq: don't allow 1 packet limit")
Signed-off-by: Octavian Purdila <tavip@google.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_sfq.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/sched/sch_sfq.c b/net/sched/sch_sfq.c
index 68e909e8fabd9..002941d35b643 100644
--- a/net/sched/sch_sfq.c
+++ b/net/sched/sch_sfq.c
@@ -661,10 +661,6 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt,
 		if (!p)
 			return -ENOMEM;
 	}
-	if (ctl->limit == 1) {
-		NL_SET_ERR_MSG_MOD(extack, "invalid limit");
-		return -EINVAL;
-	}
 
 	sch_tree_lock(sch);
 
@@ -705,6 +701,12 @@ static int sfq_change(struct Qdisc *sch, struct nlattr *opt,
 		limit = min_t(u32, ctl->limit, maxdepth * maxflows);
 		maxflows = min_t(u32, maxflows, limit);
 	}
+	if (limit == 1) {
+		sch_tree_unlock(sch);
+		kfree(p);
+		NL_SET_ERR_MSG_MOD(extack, "invalid limit");
+		return -EINVAL;
+	}
 
 	/* commit configuration */
 	q->limit = limit;
-- 
2.39.5



