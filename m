Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBC622DEA8E;
	Tue, 22 Jul 2025 14:14:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193644; cv=none; b=dmHEyQjtkNDQp5fEinApaBt+hS2Zl+H6VcXC1o2wnlj4hdbcRCxRWkOk+dJoqseCvDkV9avRk7ww1RhCOZbttzD12t36bRRlxuIEG/83ywV2V+dkPpwKTI4O+N9ZY7iQ12zHFMvFOgY4zcuLzoMIOKNU/nuVoBFrjSPXEAjbcaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193644; c=relaxed/simple;
	bh=SY6J4BX1aF6klvwI6Vxn559VDFbvUnUEZRqKZsNiqk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eF5+BGyoYYzKillzpQwdmdYevCfD0ZBNp+l20aMSCWodqa+BIlXBo3adgV5sbZpPYGdaqfxZ19S+7j8EAUm7NB4XyeAtzOw0xkWTTWgt0Rjys+0aMdndW4t8ssEL1ai4I0X3k9h9XAQm6MNLlYRSgtM6AAJVdxU/8/XIzEqJeR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UitP/cpO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UitP/cpO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C98CC4CEEB;
	Tue, 22 Jul 2025 14:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193644;
	bh=SY6J4BX1aF6klvwI6Vxn559VDFbvUnUEZRqKZsNiqk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UitP/cpO6vJDrINFRxTAKs+Xn7WirTAjCCaZCXvdLl10h6+BoGW3h40v6SNz4vTel
	 mEoHTFGTwbLdcXFJi2XPelgAZFLP8Et9E6fm1wT8Pn4zlXLPaf0EgbYsdy4gtxM35h
	 4n6A/K36sw8Ilv51/JmyjqcE99GCF6v1fD8piU3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Liu <will@willsroot.io>,
	Savino Dicanosa <savy@syst3mfailure.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 155/187] net/sched: Return NULL when htb_lookup_leaf encounters an empty rbtree
Date: Tue, 22 Jul 2025 15:45:25 +0200
Message-ID: <20250722134351.554298943@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Liu <will@willsroot.io>

[ Upstream commit 0e1d5d9b5c5966e2e42e298670808590db5ed628 ]

htb_lookup_leaf has a BUG_ON that can trigger with the following:

tc qdisc del dev lo root
tc qdisc add dev lo root handle 1: htb default 1
tc class add dev lo parent 1: classid 1:1 htb rate 64bit
tc qdisc add dev lo parent 1:1 handle 2: netem
tc qdisc add dev lo parent 2:1 handle 3: blackhole
ping -I lo -c1 -W0.001 127.0.0.1

The root cause is the following:

1. htb_dequeue calls htb_dequeue_tree which calls the dequeue handler on
   the selected leaf qdisc
2. netem_dequeue calls enqueue on the child qdisc
3. blackhole_enqueue drops the packet and returns a value that is not
   just NET_XMIT_SUCCESS
4. Because of this, netem_dequeue calls qdisc_tree_reduce_backlog, and
   since qlen is now 0, it calls htb_qlen_notify -> htb_deactivate ->
   htb_deactiviate_prios -> htb_remove_class_from_row -> htb_safe_rb_erase
5. As this is the only class in the selected hprio rbtree,
   __rb_change_child in __rb_erase_augmented sets the rb_root pointer to
   NULL
6. Because blackhole_dequeue returns NULL, netem_dequeue returns NULL,
   which causes htb_dequeue_tree to call htb_lookup_leaf with the same
   hprio rbtree, and fail the BUG_ON

The function graph for this scenario is shown here:
 0)               |  htb_enqueue() {
 0) + 13.635 us   |    netem_enqueue();
 0)   4.719 us    |    htb_activate_prios();
 0) # 2249.199 us |  }
 0)               |  htb_dequeue() {
 0)   2.355 us    |    htb_lookup_leaf();
 0)               |    netem_dequeue() {
 0) + 11.061 us   |      blackhole_enqueue();
 0)               |      qdisc_tree_reduce_backlog() {
 0)               |        qdisc_lookup_rcu() {
 0)   1.873 us    |          qdisc_match_from_root();
 0)   6.292 us    |        }
 0)   1.894 us    |        htb_search();
 0)               |        htb_qlen_notify() {
 0)   2.655 us    |          htb_deactivate_prios();
 0)   6.933 us    |        }
 0) + 25.227 us   |      }
 0)   1.983 us    |      blackhole_dequeue();
 0) + 86.553 us   |    }
 0) # 2932.761 us |    qdisc_warn_nonwc();
 0)               |    htb_lookup_leaf() {
 0)               |      BUG_ON();
 ------------------------------------------

The full original bug report can be seen here [1].

We can fix this just by returning NULL instead of the BUG_ON,
as htb_dequeue_tree returns NULL when htb_lookup_leaf returns
NULL.

[1] https://lore.kernel.org/netdev/pF5XOOIim0IuEfhI-SOxTgRvNoDwuux7UHKnE_Y5-zVd4wmGvNk2ceHjKb8ORnzw0cGwfmVu42g9dL7XyJLf1NEzaztboTWcm0Ogxuojoeo=@willsroot.io/

Fixes: 512bb43eb542 ("pkt_sched: sch_htb: Optimize WARN_ONs in htb_dequeue_tree() etc.")
Signed-off-by: William Liu <will@willsroot.io>
Signed-off-by: Savino Dicanosa <savy@syst3mfailure.io>
Link: https://patch.msgid.link/20250717022816.221364-1-will@willsroot.io
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_htb.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/sched/sch_htb.c b/net/sched/sch_htb.c
index 14bf71f570570..c968ea7637746 100644
--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -821,7 +821,9 @@ static struct htb_class *htb_lookup_leaf(struct htb_prio *hprio, const int prio)
 		u32 *pid;
 	} stk[TC_HTB_MAXDEPTH], *sp = stk;
 
-	BUG_ON(!hprio->row.rb_node);
+	if (unlikely(!hprio->row.rb_node))
+		return NULL;
+
 	sp->root = hprio->row.rb_node;
 	sp->pptr = &hprio->ptr;
 	sp->pid = &hprio->last_ptr_id;
-- 
2.39.5



