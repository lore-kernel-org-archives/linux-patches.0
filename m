Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F36347512;
	Wed, 20 May 2026 17:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296549; cv=none; b=qZgxDSX5sUweOkS1PcJkhN4DfBtka/eGIyckRA5tNirLstHsYTb2cG5RfCAGi6YkTQJHAhsVjm5BdBx6kDckUkXoTp5Q0UhOacvdHqKsUAK+4qpFKP9HuT7d/2a9DOmqxCI1usiUtLa5UZfwYgG/F2VqmYOcmXIv2TD8W6BWcdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296549; c=relaxed/simple;
	bh=1yPGTGxUPT0RYNtPWc17t49n7BF96LDLqlC72++/LCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rfiguQlvjSTnhkq/mRASp/QDXG+E3vViFAZ8HeDaNi/CMr0bAxdDQ4OYe1IXPguBn7APZ9Ov97A+zeg3KNINQP0Lhb63OIuOfE5Cobi8IBu9dtqLlAT52PmooS3DDh9j2MIL1wkQkqEWrYGF3PASaId6UbMv3X68tG9lNkQyneE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n/8ZHCZD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n/8ZHCZD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB2421F000E9;
	Wed, 20 May 2026 17:02:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296548;
	bh=pi1wwmrwxVhqUsa7tB3ZFI+X1uqbl4XN9B/pzyE8SQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/8ZHCZDtZJtemFWUwQ4lgyymO9e7mxLg1jycnUW8nJPGrieTMoOf1VdYoW8hgz5j
	 dyLnM2X0RLAsTWff6HBueJgOSyXmhLmEG3uZooHgZqZ4ALFVICjbKHoP4GvNejjQYy
	 EqRwSYO/IE3URAnwjMfcf/G6tP37hdOn/N5qw0Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0841/1146] net/sched: sch_fq_codel: remove data-races from fq_codel_dump_stats()
Date: Wed, 20 May 2026 18:18:11 +0200
Message-ID: <20260520162207.267454018@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit bbfaa73ea6871db03dc05d7f05f00557a8981f25 ]

fq_codel_dump_stats() acquires the qdisc spinlock a bit too late.

Move this acquisition before we fill st.qdisc_stats with live data.

Fixes: edb09eb17ed8 ("net: sched: do not acquire qdisc spinlock in qdisc/class stats dump")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260421142509.3967231-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_fq_codel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 8181b52dd9a8a..84b84e3ad80d6 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -585,6 +585,8 @@ static int fq_codel_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	};
 	struct list_head *pos;
 
+	sch_tree_lock(sch);
+
 	st.qdisc_stats.maxpacket = q->cstats.maxpacket;
 	st.qdisc_stats.drop_overlimit = q->drop_overlimit;
 	st.qdisc_stats.ecn_mark = q->cstats.ecn_mark;
@@ -593,7 +595,6 @@ static int fq_codel_dump_stats(struct Qdisc *sch, struct gnet_dump *d)
 	st.qdisc_stats.memory_usage  = q->memory_usage;
 	st.qdisc_stats.drop_overmemory = q->drop_overmemory;
 
-	sch_tree_lock(sch);
 	list_for_each(pos, &q->new_flows)
 		st.qdisc_stats.new_flows_len++;
 
-- 
2.53.0



