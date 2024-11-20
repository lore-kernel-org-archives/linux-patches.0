Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4610E1DFEF;
	Wed, 20 Nov 2024 13:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107660; cv=none; b=dBcHFoRIx/nONQwFPvibCOePIeJwCkUUOrNv2O9OabWJIKOY+qtfvGsxoRjLx5Qmg6YFAWz2/4ERWJchrl3E3wywtRWtHfCJNDIe2/8RU7FveNPfHBDH9Ohofuwd7sFap7MM1hfSOHSCIv/+BeKDbZH2O+GVcHqg8T5gxUMEDaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107660; c=relaxed/simple;
	bh=HW/j5A8Vm/WGmX/JJDVADkhNCQU6Iz5UtCOQWh5rD+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oQNaPjtujDCHYgqXM6vUYX0+wvePOlzUAZDm91JhbbBP2zW3+bixhgvadkxl2xUbwcMWxTT2iTTR259Th07spcFJ/vrFpYs6uIHKtWMOniJCkLPEGXmV5+8vGoK8BoOpvSUO/z02SEgACXqq+ZjaTG39PG0KuObfObzj9rknW9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pZc+F4us; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pZc+F4us"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1859CC4CECD;
	Wed, 20 Nov 2024 13:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107660;
	bh=HW/j5A8Vm/WGmX/JJDVADkhNCQU6Iz5UtCOQWh5rD+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pZc+F4usMzAdlLZy6lIUTWMUxXHAdAbAdIChHKLwISjrIYJbQmP/ibW695ALpzIOr
	 Y3vfNl+u94jqrh78vONS4INwS8RLJncpiNhKZQHERrCtQeg6ij4+aPCLbBCKoLSgdo
	 3KPXwUaX7rBLJtY41XNjxZCVOIBYOLYtHQTHQcYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Alexandre Ferrieux <alexandre.ferrieux@orange.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 12/73] net: sched: cls_u32: Fix u32s systematic failure to free IDR entries for hnodes.
Date: Wed, 20 Nov 2024 13:57:58 +0100
Message-ID: <20241120125809.920134238@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125809.623237564@linuxfoundation.org>
References: <20241120125809.623237564@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexandre Ferrieux <alexandre.ferrieux@gmail.com>

[ Upstream commit 73af53d82076bbe184d9ece9e14b0dc8599e6055 ]

To generate hnode handles (in gen_new_htid()), u32 uses IDR and
encodes the returned small integer into a structured 32-bit
word. Unfortunately, at disposal time, the needed decoding
is not done. As a result, idr_remove() fails, and the IDR
fills up. Since its size is 2048, the following script ends up
with "Filter already exists":

  tc filter add dev myve $FILTER1
  tc filter add dev myve $FILTER2
  for i in {1..2048}
  do
    echo $i
    tc filter del dev myve $FILTER2
    tc filter add dev myve $FILTER2
  done

This patch adds the missing decoding logic for handles that
deserve it.

Fixes: e7614370d6f0 ("net_sched: use idr to allocate u32 filter handles")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Alexandre Ferrieux <alexandre.ferrieux@orange.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/20241110172836.331319-1-alexandre.ferrieux@orange.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_u32.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/net/sched/cls_u32.c b/net/sched/cls_u32.c
index adcc8de1d01be..e87d79d043d54 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -91,6 +91,16 @@ struct tc_u_common {
 	long			knodes;
 };
 
+static u32 handle2id(u32 h)
+{
+	return ((h & 0x80000000) ? ((h >> 20) & 0x7FF) : h);
+}
+
+static u32 id2handle(u32 id)
+{
+	return (id | 0x800U) << 20;
+}
+
 static inline unsigned int u32_hash_fold(__be32 key,
 					 const struct tc_u32_sel *sel,
 					 u8 fshift)
@@ -308,7 +318,7 @@ static u32 gen_new_htid(struct tc_u_common *tp_c, struct tc_u_hnode *ptr)
 	int id = idr_alloc_cyclic(&tp_c->handle_idr, ptr, 1, 0x7FF, GFP_KERNEL);
 	if (id < 0)
 		return 0;
-	return (id | 0x800U) << 20;
+	return id2handle(id);
 }
 
 static struct hlist_head *tc_u_common_hash;
@@ -358,7 +368,7 @@ static int u32_init(struct tcf_proto *tp)
 		return -ENOBUFS;
 
 	refcount_set(&root_ht->refcnt, 1);
-	root_ht->handle = tp_c ? gen_new_htid(tp_c, root_ht) : 0x80000000;
+	root_ht->handle = tp_c ? gen_new_htid(tp_c, root_ht) : id2handle(0);
 	root_ht->prio = tp->prio;
 	root_ht->is_root = true;
 	idr_init(&root_ht->handle_idr);
@@ -610,7 +620,7 @@ static int u32_destroy_hnode(struct tcf_proto *tp, struct tc_u_hnode *ht,
 		if (phn == ht) {
 			u32_clear_hw_hnode(tp, ht, extack);
 			idr_destroy(&ht->handle_idr);
-			idr_remove(&tp_c->handle_idr, ht->handle);
+			idr_remove(&tp_c->handle_idr, handle2id(ht->handle));
 			RCU_INIT_POINTER(*hn, ht->next);
 			kfree_rcu(ht, rcu);
 			return 0;
@@ -987,7 +997,7 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 
 		err = u32_replace_hw_hnode(tp, ht, userflags, extack);
 		if (err) {
-			idr_remove(&tp_c->handle_idr, handle);
+			idr_remove(&tp_c->handle_idr, handle2id(handle));
 			kfree(ht);
 			return err;
 		}
-- 
2.43.0



