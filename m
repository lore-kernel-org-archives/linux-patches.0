Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78D028BE5
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 10:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2620C433C8;
	Mon, 19 Jun 2023 10:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687171746;
	bh=zMCFc6cFdBfDLQ1g6nz6+4imKudIewl73e2c3Z5gM1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=INJK13CSlQAp+yDk13bl/CxTFZ7lIjNcNVXTPnplVPL1zPIm5i6dBMl8reifFk3Ie
	 6RBcaA7p1LvQFsv+sclMZ3xjmarAKYuQyjKZdFPYAE/JAXfpOZidnIvNfsVRnzLxJ6
	 wsWJ10SXTTjXVbjTqnK2BrtNrNbkIINyY0i0MiGI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Lee Jones <lee@kernel.org>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 107/166] net/sched: cls_u32: Fix reference counter leak leading to overflow
Date: Mon, 19 Jun 2023 12:29:44 +0200
Message-ID: <20230619102159.999479340@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230619102154.568541872@linuxfoundation.org>
References: <20230619102154.568541872@linuxfoundation.org>
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

[ Upstream commit 04c55383fa5689357bcdd2c8036725a55ed632bc ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index 34d25f7a0687a..a3477537c102b 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -716,13 +716,19 @@ static int u32_set_parms(struct net *net, struct tcf_proto *tp,
 			 struct nlattr *est, u32 flags, u32 fl_flags,
 			 struct netlink_ext_ack *extack)
 {
-	int err;
+	int err, ifindex = -1;
 
 	err = tcf_exts_validate_ex(net, tp, tb, est, &n->exts, flags,
 				   fl_flags, extack);
 	if (err < 0)
 		return err;
 
+	if (tb[TCA_U32_INDEV]) {
+		ifindex = tcf_change_indev(net, tb[TCA_U32_INDEV], extack);
+		if (ifindex < 0)
+			return -EINVAL;
+	}
+
 	if (tb[TCA_U32_LINK]) {
 		u32 handle = nla_get_u32(tb[TCA_U32_LINK]);
 		struct tc_u_hnode *ht_down = NULL, *ht_old;
@@ -757,13 +763,9 @@ static int u32_set_parms(struct net *net, struct tcf_proto *tp,
 		tcf_bind_filter(tp, &n->res, base);
 	}
 
-	if (tb[TCA_U32_INDEV]) {
-		int ret;
-		ret = tcf_change_indev(net, tb[TCA_U32_INDEV], extack);
-		if (ret < 0)
-			return -EINVAL;
-		n->ifindex = ret;
-	}
+	if (ifindex >= 0)
+		n->ifindex = ifindex;
+
 	return 0;
 }
 
-- 
2.39.2



