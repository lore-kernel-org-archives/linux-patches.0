Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E7EE30BB96;
	Wed, 28 Jan 2026 15:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614972; cv=none; b=A//5b7tZn/x+mI1/dgloySCj5vuBBlV+yDBcJaE3CN03cPypdduJ3oEa0M1BBje+5I9dEk1Dk3BOosjpL5QMSgzvniR+jNQ28ADn9yFfcnt1dJ7YdsWeupTbQHaMgntlVjYX3+/K/1smHExbLF8AwU9LqrdvjOHM/WORp7ef1ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614972; c=relaxed/simple;
	bh=Dn7yo9uqPrJyWbiHOdXfKrTyyBDpNW8EkRyE3YW5Ik4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=csruqJnFCeSaBJ1G5uhD5IlhHutCdAgClDWz3JoSsks/+zFINigKLKHu4Hrb8hmr1u8LSu3LNKmikdYn9HTo2ByHcPwoX4jnXxhkSdPeQvUa8scgbPgBbKffD8GT+n/7yytS8F7A5/eVAeXbG5hCpGAcTxVZ0IHI18f5g90KkFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CJinz5CL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CJinz5CL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB4DC4CEF1;
	Wed, 28 Jan 2026 15:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614972;
	bh=Dn7yo9uqPrJyWbiHOdXfKrTyyBDpNW8EkRyE3YW5Ik4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CJinz5CLALvJzIm13KzYzIjnFb+qe36D7RabsOcxRkFuKTZ/ldnjV8Zl7Dv6Xdk8v
	 L/VNJSz7md2QAh14ltK57+z8dBMbeYzNMQMpugP9KwTIhaSwkRkOppRa1zLxbE2a2f
	 IAWte3Z23idQ3R6Q6mchRNypAfYcKp6OvBeIDGhk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GangMin Kim <km.kim1503@gmail.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/169] net/sched: Enforce that teql can only be used as root qdisc
Date: Wed, 28 Jan 2026 16:22:02 +0100
Message-ID: <20260128145335.428624971@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit 50da4b9d07a7a463e2cfb738f3ad4cff6b2c9c3b ]

Design intent of teql is that it is only supposed to be used as root qdisc.
We need to check for that constraint.

Although not important, I will describe the scenario that unearthed this
issue for the curious.

GangMin Kim <km.kim1503@gmail.com> managed to concot a scenario as follows:

ROOT qdisc 1:0 (QFQ)
  ├── class 1:1 (weight=15, lmax=16384) netem with delay 6.4s
  └── class 1:2 (weight=1, lmax=1514) teql

GangMin sends a packet which is enqueued to 1:1 (netem).
Any invocation of dequeue by QFQ from this class will not return a packet
until after 6.4s. In the meantime, a second packet is sent and it lands on
1:2. teql's enqueue will return success and this will activate class 1:2.
Main issue is that teql only updates the parent visible qlen (sch->q.qlen)
at dequeue. Since QFQ will only call dequeue if peek succeeds (and teql's
peek always returns NULL), dequeue will never be called and thus the qlen
will remain as 0. With that in mind, when GangMin updates 1:2's lmax value,
the qfq_change_class calls qfq_deact_rm_from_agg. Since the child qdisc's
qlen was not incremented, qfq fails to deactivate the class, but still
frees its pointers from the aggregate. So when the first packet is
rescheduled after 6.4 seconds (netem's delay), a dangling pointer is
accessed causing GangMin's causing a UAF.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: GangMin Kim <km.kim1503@gmail.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260114160243.913069-2-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_teql.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/sched/sch_teql.c b/net/sched/sch_teql.c
index 8badec6d82a24..6e4bdaa876ed6 100644
--- a/net/sched/sch_teql.c
+++ b/net/sched/sch_teql.c
@@ -178,6 +178,11 @@ static int teql_qdisc_init(struct Qdisc *sch, struct nlattr *opt,
 	if (m->dev == dev)
 		return -ELOOP;
 
+	if (sch->parent != TC_H_ROOT) {
+		NL_SET_ERR_MSG_MOD(extack, "teql can only be used as root");
+		return -EOPNOTSUPP;
+	}
+
 	q->m = m;
 
 	skb_queue_head_init(&q->q);
-- 
2.51.0



