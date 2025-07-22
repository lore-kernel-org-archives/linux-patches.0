Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17BAA32;
	Tue, 22 Jul 2025 14:04:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193045; cv=none; b=TEQN/1lQ/sEVuU/s8wFMLbFDIIAjWpYrheJRpZoAy5RlGESlN5lv9VWPLEvBUkdcjvv5yya0qcDOAOvErDwsboCTXyNH1PWz/5RJOor/AwSPLkkLpi1J8ZuJsoaesC4nz9eHQtOa0RxgxavBBk85OZr6vm1btR6UDfk6jeWMbJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193045; c=relaxed/simple;
	bh=7zWefpgzwnsoagNjojLoRLVwGmd2RaxDEGt4UvWhphw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iKpmN9ZtYaRnDT9QsXzSxrHZCTVXNd9VTww8n6LvJ62piL1dblTRsYv+v5wFV28XCti1T0idTLApH0FLcS1P+nY7aMaosAugGaEj3B8X14f84zp7tRTgB8n59VGDEZ0FHd9AyGMXpbtGOma33kUnH5jeqYmCJscokfnFFGwJnkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGriRL/g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGriRL/g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5D3C4CEEB;
	Tue, 22 Jul 2025 14:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193044;
	bh=7zWefpgzwnsoagNjojLoRLVwGmd2RaxDEGt4UvWhphw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGriRL/g0gV5sYlSMp0i9+7TaJ9GSqkpgveNrfcqxVcVmXYmcGJ8p76gZWRdVafmc
	 ook4uQDAiYsNWhzsF7EzpPzjCBVaaQGv9Zo8dAgzV/81U63fpmlQx8LhPgJOKUakEL
	 HdeWK/u9vlTWI63NDuWFwVVHCo9c8T7D6sIuqK7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Liu <will@willsroot.io>,
	Savino Dicanosa <savy@syst3mfailure.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 132/158] net/sched: Return NULL when htb_lookup_leaf encounters an empty rbtree
Date: Tue, 22 Jul 2025 15:45:16 +0200
Message-ID: <20250722134345.656047559@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b2494d24a5425..1021681a57182 100644
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



