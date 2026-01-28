Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C013242D7F;
	Wed, 28 Jan 2026 15:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615898; cv=none; b=XetzC7bD8Kc2nIvBcbSX+kk66BW9v5eUAuZpfKbeTcckyYQd5qSirufdKh4vMma4/+2jMBNZIpeyJr2szJOwNWHYnmlW02dOsCl83gTqtoAHDQTEKJ0h2tei3+sqBPKaLiFhnmN5jhJo9x9nzDMtFIZ7phJCPpalziM1YJuosqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615898; c=relaxed/simple;
	bh=9DLQc1Dc56CBkzMmqoeRnfM7BflVyq6uIBeL9lcWaCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G2PG5mrcaSmENLxtUzeloJiTjaUaEGDP6L9JSHzDxlRlGKrAbs4CIhVTvwjK3HAyDc2BQ7bN9HxeBreozhuKgHZC3RPHmNfnJHdfavKSKbjge2N4OIBrb3GWJxWCuuz8PZm1z+uqOjcRLntE5qCKlcD+T4pGD83LPRfaALujPNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bl+t7Mr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bl+t7Mr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B55C4CEF1;
	Wed, 28 Jan 2026 15:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615898;
	bh=9DLQc1Dc56CBkzMmqoeRnfM7BflVyq6uIBeL9lcWaCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bl+t7Mr2Gtea132UIat+WTCznsJwyN9Zc/7ZgTl/gEdgddAR2K+kVdIAvmmfyzMUu
	 aVkiIC9/HrWFxA4Ps94hURyO/5wQcLrx7iU6rioc5dZSuD24Nk67Seh06ow91h8sbl
	 7IQ8BxpVu3hdSbScAosD4ORvopyzq/7R7N0JqbS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+5cf914f193dffde3bd3c@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Yotam Gigi <yotam.gi@gmail.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 147/227] net/sched: act_ife: avoid possible NULL deref
Date: Wed, 28 Jan 2026 16:23:12 +0100
Message-ID: <20260128145349.747283956@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

[ Upstream commit 27880b0b0d35ad1c98863d09788254e36f874968 ]

tcf_ife_encode() must make sure ife_encode() does not return NULL.

syzbot reported:

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
 RIP: 0010:ife_tlv_meta_encode+0x41/0xa0 net/ife/ife.c:166
CPU: 3 UID: 0 PID: 8990 Comm: syz.0.696 Not tainted syzkaller #0 PREEMPT(full)
Call Trace:
 <TASK>
  ife_encode_meta_u32+0x153/0x180 net/sched/act_ife.c:101
  tcf_ife_encode net/sched/act_ife.c:841 [inline]
  tcf_ife_act+0x1022/0x1de0 net/sched/act_ife.c:877
  tc_act include/net/tc_wrapper.h:130 [inline]
  tcf_action_exec+0x1c0/0xa20 net/sched/act_api.c:1152
  tcf_exts_exec include/net/pkt_cls.h:349 [inline]
  mall_classify+0x1a0/0x2a0 net/sched/cls_matchall.c:42
  tc_classify include/net/tc_wrapper.h:197 [inline]
  __tcf_classify net/sched/cls_api.c:1764 [inline]
  tcf_classify+0x7f2/0x1380 net/sched/cls_api.c:1860
  multiq_classify net/sched/sch_multiq.c:39 [inline]
  multiq_enqueue+0xe0/0x510 net/sched/sch_multiq.c:66
  dev_qdisc_enqueue+0x45/0x250 net/core/dev.c:4147
  __dev_xmit_skb net/core/dev.c:4262 [inline]
  __dev_queue_xmit+0x2998/0x46c0 net/core/dev.c:4798

Fixes: 295a6e06d21e ("net/sched: act_ife: Change to use ife module")
Reported-by: syzbot+5cf914f193dffde3bd3c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6970d61d.050a0220.706b.0010.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Yotam Gigi <yotam.gi@gmail.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260121133724.3400020-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ife.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/sched/act_ife.c b/net/sched/act_ife.c
index 7c6975632fc2e..c7ab25642d997 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -821,6 +821,7 @@ static int tcf_ife_encode(struct sk_buff *skb, const struct tc_action *a,
 	/* could be stupid policy setup or mtu config
 	 * so lets be conservative.. */
 	if ((action == TC_ACT_SHOT) || exceed_mtu) {
+drop:
 		qstats_drop_inc(this_cpu_ptr(ife->common.cpu_qstats));
 		return TC_ACT_SHOT;
 	}
@@ -829,6 +830,8 @@ static int tcf_ife_encode(struct sk_buff *skb, const struct tc_action *a,
 		skb_push(skb, skb->dev->hard_header_len);
 
 	ife_meta = ife_encode(skb, metalen);
+	if (!ife_meta)
+		goto drop;
 
 	spin_lock(&ife->tcf_lock);
 
@@ -844,8 +847,7 @@ static int tcf_ife_encode(struct sk_buff *skb, const struct tc_action *a,
 		if (err < 0) {
 			/* too corrupt to keep around if overwritten */
 			spin_unlock(&ife->tcf_lock);
-			qstats_drop_inc(this_cpu_ptr(ife->common.cpu_qstats));
-			return TC_ACT_SHOT;
+			goto drop;
 		}
 		skboff += err;
 	}
-- 
2.51.0



