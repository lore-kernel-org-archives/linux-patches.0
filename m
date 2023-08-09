Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69F853B7
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:09:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C93C433C7;
	Wed,  9 Aug 2023 11:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579391;
	bh=sukjLJV8XilSbB00831/37O+s5n1iZ9AGOwIlOj6zq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tc1MY4JZlMKkDcaQci1xMi6A2LLRf8if/lhRp79jvX+CretSsiw/fIPLRWlVkg5cJ
	 5gwwMPbrIF7Bdhtw5+8+2KyIjAQxtj/P8J5Lku6Ome8hRRFLTA8e6NDvpaVV6pNq7m
	 UWCTFp6jRK3YD8ZuGAllpdUORLrEnOSA+pQzmNKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lee Jones <lee@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rishabh Bhatnagar <risbhat@amazon.com>
Subject: [PATCH 4.14 180/204] net/sched: cls_u32: Fix reference counter leak leading to overflow
Date: Wed,  9 Aug 2023 12:41:58 +0200
Message-ID: <20230809103648.521541059@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lee Jones <lee@kernel.org>

commit 04c55383fa5689357bcdd2c8036725a55ed632bc upstream.

In the event of a failure in tcf_change_indev(), u32_set_parms() will
immediately return without decrementing the recently incremented
reference counter.  If this happens enough times, the counter will
rollover and the reference freed, leading to a double free which can be
used to do 'bad things'.

In order to prevent this, move the point of possible failure above the
point where the reference counter is incremented.  Also save any
meaningful return values to be applied to the return data at the
appropriate point in time.

This issue was caught with KASAN.

Fixes: 705c7091262d ("net: sched: cls_u32: no need to call tcf_exts_change for newly allocated struct")
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Rishabh Bhatnagar <risbhat@amazon.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_u32.c |   21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -774,11 +774,22 @@ static int u32_set_parms(struct net *net
 			 struct nlattr *est, bool ovr)
 {
 	int err;
+#ifdef CONFIG_NET_CLS_IND
+	int ifindex = -1;
+#endif
 
 	err = tcf_exts_validate(net, tp, tb, est, &n->exts, ovr);
 	if (err < 0)
 		return err;
 
+#ifdef CONFIG_NET_CLS_IND
+	if (tb[TCA_U32_INDEV]) {
+		ifindex = tcf_change_indev(net, tb[TCA_U32_INDEV]);
+		if (ifindex < 0)
+			return -EINVAL;
+	}
+#endif
+
 	if (tb[TCA_U32_LINK]) {
 		u32 handle = nla_get_u32(tb[TCA_U32_LINK]);
 		struct tc_u_hnode *ht_down = NULL, *ht_old;
@@ -806,14 +817,10 @@ static int u32_set_parms(struct net *net
 	}
 
 #ifdef CONFIG_NET_CLS_IND
-	if (tb[TCA_U32_INDEV]) {
-		int ret;
-		ret = tcf_change_indev(net, tb[TCA_U32_INDEV]);
-		if (ret < 0)
-			return -EINVAL;
-		n->ifindex = ret;
-	}
+	if (ifindex >= 0)
+		n->ifindex = ifindex;
 #endif
+
 	return 0;
 }
 


