Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4A0C1A4F12;
	Wed, 20 Nov 2024 12:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107499; cv=none; b=iD7Da4EV7rkYOnGDA0DheAtZA60u8TOufhd2G1hB/RAERQbGM5Y/iepI74ZP2QMOG8G3dvD3z7qbS7Pktg3xoosAWeTX3qo1YeI2NRdedQjQd+a3dQj0Tf+H+SDkJZJe5tYFp18R+5iaTq692/q6+RqBrlnGTPtl6Wiy4h6e0LA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107499; c=relaxed/simple;
	bh=yZ69wy6yq79pLSqNOVwcyUuk8HXfVrfNvtYa2H4w4EI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlpX9fkE5xP0s7PWsfwjHqy7Rzzomh7qMY1P3LqpSY5o/eYizyFssyzyWJcwz7T9tjpYT/mXHbddmsHhOtnqVvd8nVVPDzLtSNAQVyr/Tgf/5HEyFKBj7EtsIeyiL8TMEl74JBF/K50XYvn2bcik4WUnL/LOWNJptQR1MIaYERo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QQ5vz+7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QQ5vz+7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0AEC4CECD;
	Wed, 20 Nov 2024 12:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107499;
	bh=yZ69wy6yq79pLSqNOVwcyUuk8HXfVrfNvtYa2H4w4EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QQ5vz+7QGvDBzQ7Nh9PdOx04J5XcFshsts0OCeUbuPlyHgpp+e4neKfe+u/cLzqDb
	 DvoRkanx5dsQnHykyqGcDvnrmVcfZPF+B7XhpdkZwEa7UrzfwIwhFqeg8kMbO8JWMG
	 saKbd13uD1TghfhwTwFhjud5hrj+n52mgGNeSMus=
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
Subject: [PATCH 6.11 023/107] net: sched: cls_u32: Fix u32s systematic failure to free IDR entries for hnodes.
Date: Wed, 20 Nov 2024 13:55:58 +0100
Message-ID: <20241120125630.200897392@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 9412d88a99bc1..d3a03c57545bc 100644
--- a/net/sched/cls_u32.c
+++ b/net/sched/cls_u32.c
@@ -92,6 +92,16 @@ struct tc_u_common {
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
@@ -310,7 +320,7 @@ static u32 gen_new_htid(struct tc_u_common *tp_c, struct tc_u_hnode *ptr)
 	int id = idr_alloc_cyclic(&tp_c->handle_idr, ptr, 1, 0x7FF, GFP_KERNEL);
 	if (id < 0)
 		return 0;
-	return (id | 0x800U) << 20;
+	return id2handle(id);
 }
 
 static struct hlist_head *tc_u_common_hash;
@@ -360,7 +370,7 @@ static int u32_init(struct tcf_proto *tp)
 		return -ENOBUFS;
 
 	refcount_set(&root_ht->refcnt, 1);
-	root_ht->handle = tp_c ? gen_new_htid(tp_c, root_ht) : 0x80000000;
+	root_ht->handle = tp_c ? gen_new_htid(tp_c, root_ht) : id2handle(0);
 	root_ht->prio = tp->prio;
 	root_ht->is_root = true;
 	idr_init(&root_ht->handle_idr);
@@ -612,7 +622,7 @@ static int u32_destroy_hnode(struct tcf_proto *tp, struct tc_u_hnode *ht,
 		if (phn == ht) {
 			u32_clear_hw_hnode(tp, ht, extack);
 			idr_destroy(&ht->handle_idr);
-			idr_remove(&tp_c->handle_idr, ht->handle);
+			idr_remove(&tp_c->handle_idr, handle2id(ht->handle));
 			RCU_INIT_POINTER(*hn, ht->next);
 			kfree_rcu(ht, rcu);
 			return 0;
@@ -989,7 +999,7 @@ static int u32_change(struct net *net, struct sk_buff *in_skb,
 
 		err = u32_replace_hw_hnode(tp, ht, userflags, extack);
 		if (err) {
-			idr_remove(&tp_c->handle_idr, handle);
+			idr_remove(&tp_c->handle_idr, handle2id(handle));
 			kfree(ht);
 			return err;
 		}
-- 
2.43.0



