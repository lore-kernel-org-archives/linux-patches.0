Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AE6741B34E;
	Wed,  4 Feb 2026 15:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217766; cv=none; b=Y4EV+5Ubz2Ox7HK+MD6Z6LwF6LXa4oMSyhEOCl5Y3na5bcn+A7VTvipBTw6/PK1NqHdAG7iN43dDsv8oGdh/a39TZbhDsByUA+7svX87Sj57U2QeNsm9yH9nc+2Z8pr2QhZDVnO7x30Gt2x4kglbKVSVgItYTIemTLpjgGpY8Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217766; c=relaxed/simple;
	bh=SzSB6DFSzJXisTnr4tU7dh+jg7SbkktjzqS6RQf9KLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XSuDe5FxIVl/HZNO5cejAICc7FX1Z2heL5KDrWhVkTlxirqDfQn6uB0jSs4f9Le9CbtT2E9B2Xlg3gx9IzAzQR21Du5P70SuRPL34Coa6h+lCwRVecGSEe57/GXd1HwdgmNPjkv3aVDOBpKGxFmLUMcMioKE9xf0MwUjAh0ITIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DDUH5P2q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DDUH5P2q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 830D1C4CEF7;
	Wed,  4 Feb 2026 15:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217766;
	bh=SzSB6DFSzJXisTnr4tU7dh+jg7SbkktjzqS6RQf9KLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DDUH5P2qd3+5tsBQmhSDTfM87atQcfdn9gmhxoVUdIibSZLuNMG8vftJKncVhlHRG
	 U4LMw8vvU4pnnft3M68xB604d7WPOJNY365C+gLS9kWx/7nN6dzPduuT4vbXXO04ra
	 pdz0KXUWbuMJxbeyo1V/6Whu6ZR2PgRGhs/kUSVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GangMin Kim <km.kim1503@gmail.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/280] net/sched: Enforce that teql can only be used as root qdisc
Date: Wed,  4 Feb 2026 15:38:06 +0100
Message-ID: <20260204143913.674757815@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7721239c185fb..0a7856e14a975 100644
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



