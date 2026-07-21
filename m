Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEAE44AB68;
	Tue, 21 Jul 2026 21:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669112; cv=none; b=M+S/Te/LuwZT/wWhb2TN4TJYUfscl5SSM/TgPycCXbO3fCI2f8wtiqYlP7yUe1fOCJ2fMz5hq6Q6S2sqFnrv037wDSyEXjrBqeGKPCd+8Aqs54FxKYQ4hCqA2+kK/BU+BxUWMTj+L4JCbZ9cua4po7Rgt44UHa447tuIxEwxMio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669112; c=relaxed/simple;
	bh=zWNE1/L31Qwxzdaf1Uzoipqw0oi5/fG3r8LKTWQ+5tQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r061lhQdjE3sVmyJr03vFZm0HcURF3nuGVXZssWdPh/N4eWkXl1UOFEzgv2gRD1rk2B7eul2yueWPvkHljZh1+/tEZ0Kw+6KFDggHmjv+PBEUp62oGUWr/dflhj8+SyItP/9y/7MtzUrURYegx++r3oKMe/T/lZ5z55QiWn5aAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIpYZbNt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIpYZbNt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87FBF1F000E9;
	Tue, 21 Jul 2026 21:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669111;
	bh=npZ621GFJzC4ySni7ZDgo6koYEa5GZqjVjnvK0tnbQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pIpYZbNt7DW+4SM2f4GfAxs7en9xOIu+R3XkKNhJkAqlBjp3VpLzf+3DuBDRWfqmM
	 o673FmpC1qxH6Yf1fS2vuYskMlF6ROg5g1binHDGDbGWBs8345hA5YoabjcKCnL1hH
	 Dyn2cXAVjawS2EJnOg7qM9lXa8KbCvoxniQaxYnU=
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
Subject: [PATCH 6.1 0432/1067] net/sched: cls_flow: Dont expose folded kernel pointers
Date: Tue, 21 Jul 2026 17:17:13 +0200
Message-ID: <20260721152434.281561668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 64b281cca6ae73..315d689adf651f 100644
--- a/net/sched/cls_flow.c
+++ b/net/sched/cls_flow.c
@@ -21,6 +21,7 @@
 #include <net/inet_sock.h>
 
 #include <net/pkt_cls.h>
+#include <linux/siphash.h>
 #include <net/ip.h>
 #include <net/route.h>
 #include <net/flow_dissector.h>
@@ -56,11 +57,15 @@ struct flow_filter {
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
@@ -594,6 +599,7 @@ static int flow_init(struct tcf_proto *tp)
 		return -ENOBUFS;
 	INIT_LIST_HEAD(&head->filters);
 	rcu_assign_pointer(tp->root, head);
+	net_get_random_once(&flow_keys_secret, sizeof(flow_keys_secret));
 	return 0;
 }
 
-- 
2.53.0



