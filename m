Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26206221F17;
	Wed,  4 Feb 2026 14:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216433; cv=none; b=DMeltVghkEGxGnegL1DiXEJIot8/KBjpFSVBAMp/D0U/OjXi2I7sMmtTol2xatgl05QItbM0l0jhWqQmamDzQzu7h3um2ReB6AiquWMaUMgk77ZX1YpRXxS4gTRYWqfI1G0PAbGAupl3LEOYuOADP1Kkm9hBv3cgAJKRMUtP0xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216433; c=relaxed/simple;
	bh=vkkytA5sH0ENL6wZJDCIXZiU1Fv5vM3Cujg3+sB2mew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCxnjSa7QFqyx4iw8RqvkETODU7P8sumTSt+RuPTxew/nWApMq1KnUVoF2U+6R5n1s+Zlx+fjR8l4NNtcSoUe0sjMfeg8pTCLnDSJhW4QOPsT7nHI/ohJr6qFvgA2Rs5elpKLFaLhgv1toLTsJxipxAcpAi8HeMDZXmR2x/ytuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UBKBDYJO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UBKBDYJO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2317C4CEF7;
	Wed,  4 Feb 2026 14:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216433;
	bh=vkkytA5sH0ENL6wZJDCIXZiU1Fv5vM3Cujg3+sB2mew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UBKBDYJOck0MHEKbSdCKuRRJGfEyz62nlv189mc21MbPiXXArc7L9DFV1gW+RdCwb
	 YYx+GAQ2xcIxTGd+EDzjZXX+YBUhGVwhlK1X7kJBtcUIAYE4uZn8p5DxCtPQulWtVa
	 lZrQozlrHQMwyetv3YcRbELWlvjx+YTtv3/UdhNY=
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
Subject: [PATCH 5.10 086/161] net/sched: act_ife: avoid possible NULL deref
Date: Wed,  4 Feb 2026 15:39:09 +0100
Message-ID: <20260204143854.842733342@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 892d4824d81d5..a953d29c1892e 100644
--- a/net/sched/act_ife.c
+++ b/net/sched/act_ife.c
@@ -820,6 +820,7 @@ static int tcf_ife_encode(struct sk_buff *skb, const struct tc_action *a,
 	/* could be stupid policy setup or mtu config
 	 * so lets be conservative.. */
 	if ((action == TC_ACT_SHOT) || exceed_mtu) {
+drop:
 		qstats_drop_inc(this_cpu_ptr(ife->common.cpu_qstats));
 		return TC_ACT_SHOT;
 	}
@@ -828,6 +829,8 @@ static int tcf_ife_encode(struct sk_buff *skb, const struct tc_action *a,
 		skb_push(skb, skb->dev->hard_header_len);
 
 	ife_meta = ife_encode(skb, metalen);
+	if (!ife_meta)
+		goto drop;
 
 	spin_lock(&ife->tcf_lock);
 
@@ -843,8 +846,7 @@ static int tcf_ife_encode(struct sk_buff *skb, const struct tc_action *a,
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



