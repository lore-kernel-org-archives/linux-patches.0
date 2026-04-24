Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C235C33E347;
	Fri, 24 Apr 2026 13:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037885; cv=none; b=h1KRuqK9nfxmfzHF7Jyj1ubLKLijp+utJ4ZeOm0yiv6NyoMujJ5XiCHy6ZHkGAZsxnKE80HbAzMtQFfjiO3sUhf6jl+l9FzNvTtpei89xLOZ+UEc9tlMwKypwxBSPMyiuleKoi0xqVXcRJOxaXLQ9LRi2bcw4KFJJo6/obO1bSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037885; c=relaxed/simple;
	bh=bW9tibOBtJOWREt66qjeHKIrvVhiL2gSWR8AsimHE5M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRkv1NxwKFX/hro+KPRlYvj2kN/eleogXzK4AbKzxhhZqggM1iLOy74M7QSMz9U0uMjVK/bqb7NtYlKdyyFgZqN1wP+3b71ivK43zlMyloJceOPP9v7xGQRrUOm2MY7rJTtB1o7s5MoMsC7pJzvw/tJgr8QaDU9j4aCErkwet80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxTH3ZKd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxTH3ZKd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59920C19425;
	Fri, 24 Apr 2026 13:38:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037885;
	bh=bW9tibOBtJOWREt66qjeHKIrvVhiL2gSWR8AsimHE5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxTH3ZKdl4la/4loHFdIlsP14vY1y0Ca2eqq15U5Mkf9K3awtfrO3lRlh/ElxwP2N
	 K0n5EazNRogNZ2jDbuCV1qeRzKD+rJSfG6hbSCKBVsC1DNMMoaZYbMdFw/jH3F4FAt
	 yJBnD7iZtf/m3bb+tPt0IS415Q+T3/LyrUsUTcoU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f3a497f02c389d86ef16@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Chelsy Ratnawat <chelsyratnawat2001@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 107/166] net: sched: fix TCF_LAYER_TRANSPORT handling in tcf_get_base_ptr()
Date: Fri, 24 Apr 2026 15:30:21 +0200
Message-ID: <20260424132555.138297504@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[Upstream commit 4fe5a00ec70717a7f1002d8913ec6143582b3c8e]

syzbot reported that tcf_get_base_ptr() can be called while transport
header is not set [1].

Instead of returning a dangling pointer, return NULL.

Fix tcf_get_base_ptr() callers to handle this NULL value.

[1]
 WARNING: CPU: 1 PID: 6019 at ./include/linux/skbuff.h:3071 skb_transport_header include/linux/skbuff.h:3071 [inline]
 WARNING: CPU: 1 PID: 6019 at ./include/linux/skbuff.h:3071 tcf_get_base_ptr include/net/pkt_cls.h:539 [inline]
 WARNING: CPU: 1 PID: 6019 at ./include/linux/skbuff.h:3071 em_nbyte_match+0x2d8/0x3f0 net/sched/em_nbyte.c:43
Modules linked in:
CPU: 1 UID: 0 PID: 6019 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
Call Trace:
 <TASK>
  tcf_em_match net/sched/ematch.c:494 [inline]
  __tcf_em_tree_match+0x1ac/0x770 net/sched/ematch.c:520
  tcf_em_tree_match include/net/pkt_cls.h:512 [inline]
  basic_classify+0x115/0x2d0 net/sched/cls_basic.c:50
  tc_classify include/net/tc_wrapper.h:197 [inline]
  __tcf_classify net/sched/cls_api.c:1764 [inline]
  tcf_classify+0x4cf/0x1140 net/sched/cls_api.c:1860
  multiq_classify net/sched/sch_multiq.c:39 [inline]
  multiq_enqueue+0xfd/0x4c0 net/sched/sch_multiq.c:66
  dev_qdisc_enqueue+0x4e/0x260 net/core/dev.c:4118
  __dev_xmit_skb net/core/dev.c:4214 [inline]
  __dev_queue_xmit+0xe83/0x3b50 net/core/dev.c:4729
  packet_snd net/packet/af_packet.c:3076 [inline]
  packet_sendmsg+0x3e33/0x5080 net/packet/af_packet.c:3108
  sock_sendmsg_nosec net/socket.c:727 [inline]
  __sock_sendmsg+0x21c/0x270 net/socket.c:742
  ____sys_sendmsg+0x505/0x830 net/socket.c:2630

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Reported-by: syzbot+f3a497f02c389d86ef16@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6920855a.a70a0220.2ea503.0058.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20251121154100.1616228-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_cls.h |  2 ++
 net/sched/em_cmp.c    |  5 ++++-
 net/sched/em_nbyte.c  |  2 ++
 net/sched/em_text.c   | 11 +++++++++--
 4 files changed, 17 insertions(+), 3 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index f308e8268651e..ccc1c698ed007 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -525,6 +525,8 @@ static inline unsigned char * tcf_get_base_ptr(struct sk_buff *skb, int layer)
 		case TCF_LAYER_NETWORK:
 			return skb_network_header(skb);
 		case TCF_LAYER_TRANSPORT:
+			if (!skb_transport_header_was_set(skb))
+				break;
 			return skb_transport_header(skb);
 	}
 
diff --git a/net/sched/em_cmp.c b/net/sched/em_cmp.c
index f17b049ea5309..71ce113f2d08e 100644
--- a/net/sched/em_cmp.c
+++ b/net/sched/em_cmp.c
@@ -22,9 +22,12 @@ static int em_cmp_match(struct sk_buff *skb, struct tcf_ematch *em,
 			struct tcf_pkt_info *info)
 {
 	struct tcf_em_cmp *cmp = (struct tcf_em_cmp *) em->data;
-	unsigned char *ptr = tcf_get_base_ptr(skb, cmp->layer) + cmp->off;
+	unsigned char *ptr = tcf_get_base_ptr(skb, cmp->layer);
 	u32 val = 0;
 
+	if (!ptr)
+		return 0;
+	ptr += cmp->off;
 	if (!tcf_valid_offset(skb, ptr, cmp->align))
 		return 0;
 
diff --git a/net/sched/em_nbyte.c b/net/sched/em_nbyte.c
index a83b237cbeb06..2e3c1d58d4563 100644
--- a/net/sched/em_nbyte.c
+++ b/net/sched/em_nbyte.c
@@ -42,6 +42,8 @@ static int em_nbyte_match(struct sk_buff *skb, struct tcf_ematch *em,
 	struct nbyte_data *nbyte = (struct nbyte_data *) em->data;
 	unsigned char *ptr = tcf_get_base_ptr(skb, nbyte->hdr.layer);
 
+	if (!ptr)
+		return 0;
 	ptr += nbyte->hdr.off;
 
 	if (!tcf_valid_offset(skb, ptr, nbyte->hdr.len))
diff --git a/net/sched/em_text.c b/net/sched/em_text.c
index f176afb70559e..32aae8a9dedaa 100644
--- a/net/sched/em_text.c
+++ b/net/sched/em_text.c
@@ -29,12 +29,19 @@ static int em_text_match(struct sk_buff *skb, struct tcf_ematch *m,
 			 struct tcf_pkt_info *info)
 {
 	struct text_match *tm = EM_TEXT_PRIV(m);
+	unsigned char *ptr;
 	int from, to;
 
-	from = tcf_get_base_ptr(skb, tm->from_layer) - skb->data;
+	ptr = tcf_get_base_ptr(skb, tm->from_layer);
+	if (!ptr)
+		return 0;
+	from = ptr - skb->data;
 	from += tm->from_offset;
 
-	to = tcf_get_base_ptr(skb, tm->to_layer) - skb->data;
+	ptr = tcf_get_base_ptr(skb, tm->to_layer);
+	if (!ptr)
+		return 0;
+	to = ptr - skb->data;
 	to += tm->to_offset;
 
 	return skb_find_text(skb, from, to, tm->config) != UINT_MAX;
-- 
2.53.0



