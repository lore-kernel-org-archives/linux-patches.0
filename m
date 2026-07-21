Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DD6747042E;
	Tue, 21 Jul 2026 19:29:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662141; cv=none; b=D1aa093uZi0S6ftK/fH6FkjFvMLnLFLpeAv8pL+jghenSVF1Rut7ZMqTyTpwobPpMsHymalYOQ8u700eNqypgK2Kvfqw9G2pu7doEo52th+IuXIMym+tRIYyYg2CWIlm3xSsxL9SVbCS1XUog1E+qNfibLjVeBHZDa7hlj5951E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662141; c=relaxed/simple;
	bh=BdZqri5HCzsjdoQgC4E1nNeZgKK5vv9I35lrZyXabXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J53UJ7Ygvkx9O2/NLY1k1IoEsEF3gkGYq2mE7KYzQEogYUoNt/ywBxlsbl4VY/KGqIZCE8aMZYH6YxmscKa2LYm2fRzYp7KI1nfpT7JnPh/yUtcj3pjsF3//UqKq13ev2Q0RShKHAsSBZuPf2fgYXYsaskASU69Yit2ZybGbJKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZHlUmDK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZHlUmDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B3E1F000E9;
	Tue, 21 Jul 2026 19:28:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662140;
	bh=xsqUy253Qg8ugJDwsx7Qw875tSVr34trhUD7ABMeLcw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZHlUmDKOoy210oyXMaexaGZMUIdXeGKKMlUK1Tvz23jHUetLpy7iY4OjrN10irWF
	 W1gWarux5Gyw9ATFMqvzwKIzt/PhjwoUwN2QvITqFRQ/oeOeA4y6TRjr2jWlPHuKM0
	 yCg7u8sx40mCyYuc/i5HXANkxRAMhPjaslkw+WDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0333/1276] net/sched: cls_flow: Dont expose folded kernel pointers
Date: Tue, 21 Jul 2026 17:12:56 +0200
Message-ID: <20260721152453.556301386@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit f294fc71c4a0fa4964f6428a1b4e7929c1d83125 ]

The flow classifier falls back to addr_fold() for fields that are missing
from packet headers. In map mode, userspace controls mask, xor, rshift,
addend and divisor, and can observe the resulting classid through class
statistics. This allows a tc classifier in a user/network namespace to
recover the 32-bit folded value of skb->sk, skb_dst() or skb_nfct().

Align with standard kernel practices for pointer hashing and replace the
XOR folding with a keyed siphash (which is cryptographically secure)

Fixes: e5dfb815181f ("[NET_SCHED]: Add flow classifier")
Reported-by: Kyle Zeng <kylebot@openai.com>
Tested-by: Kyle Zeng <kylebot@openai.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260610101839.14135-1-jhs@mojatatu.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_flow.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/sched/cls_flow.c b/net/sched/cls_flow.c
index 7eeead60ec23b2..a8b900a27d2f03 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -21,6 +21,7 @@
 #include <net/inet_sock.h>
 
 #include <net/pkt_cls.h>
+#include <linux/siphash.h>
 #include <net/ip.h>
 #include <net/route.h>
 #include <net/flow_dissector.h>
@@ -57,11 +58,15 @@ struct flow_filter {
 	struct rcu_work		rwork;
 };
 
+static siphash_aligned_key_t flow_keys_secret __read_mostly;
+
 static inline u32 addr_fold(void *addr)
 {
-	unsigned long a = (unsigned long)addr;
-
-	return (a & 0xFFFFFFFF) ^ (BITS_PER_LONG > 32 ? a >> 32 : 0);
+#ifdef CONFIG_64BIT
+	return (u32)siphash_1u64((u64)addr, &flow_keys_secret);
+#else
+	return (u32)siphash_1u32((u32)addr, &flow_keys_secret);
+#endif
 }
 
 static u32 flow_get_src(const struct sk_buff *skb, const struct flow_keys *flow)
@@ -596,6 +601,7 @@ static int flow_init(struct tcf_proto *tp)
 		return -ENOBUFS;
 	INIT_LIST_HEAD(&head->filters);
 	rcu_assign_pointer(tp->root, head);
+	net_get_random_once(&flow_keys_secret, sizeof(flow_keys_secret));
 	return 0;
 }
 
-- 
2.53.0



