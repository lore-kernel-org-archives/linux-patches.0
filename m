Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FEB353346;
	Tue, 26 Aug 2025 14:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217174; cv=none; b=OwBo7LN/AdMuHw8fll8jP1FRK7fILt+xpxPYAI42ZpPSwhpxnrJPPMT+b2U1zqn+a+RTr60QgYMK834V/a5uwDtlzx6euhDkFJo5ygxhEw3elsm0bsaE6wp25bRlD7Ai1KVcPAmKCegWVnW4QGClU9yX2jk3UYMYJB3t7lFG0ms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217174; c=relaxed/simple;
	bh=TJ29bMBTvNWPCRBmIxiRTbvi7D1SKSTgkot7NwQ208k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GO8XuBIrmAoDbWWveaUPe6AmSiRtlFMxV8f+yxDUPbgOFx6Za0a610IHsxmJ6JyyqOxpYVWUL8+LiOXJarzn/e6csKAn+Oe1NcDB53I5ldbCnn0Esogjz651mnJuz7GR2tWWwaCV+7Bqth2aYHf0u47ns8ueutrdJFkCsBhOPC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UtlSOUVR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UtlSOUVR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D613AC113D0;
	Tue, 26 Aug 2025 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217174;
	bh=TJ29bMBTvNWPCRBmIxiRTbvi7D1SKSTgkot7NwQ208k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UtlSOUVR4e7yQgqf3SlVef3dkDBslma3SjLqUQC4XmK6olZXlC9hEdaB1HVWwVXSs
	 2OuUdHVyOixRI22HLn58uHjld3g/iiDx22P5OXbIjYdl1c6WdC/3Ivf85sE688sCx8
	 OorlW1Yrk16yHZkMww5y4JvWh3FF1qDhEBW0D+7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Liu <will@willsroot.io>,
	Savino Dicanosa <savy@syst3mfailure.io>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/523] net/sched: Return NULL when htb_lookup_leaf encounters an empty rbtree
Date: Tue, 26 Aug 2025 13:04:14 +0200
Message-ID: <20250826110925.691331395@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 net/sched/sch_htb.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/sched/sch_htb.c
+++ b/net/sched/sch_htb.c
@@ -775,7 +775,9 @@ static struct htb_class *htb_lookup_leaf
 		u32 *pid;
 	} stk[TC_HTB_MAXDEPTH], *sp = stk;
 
-	BUG_ON(!hprio->row.rb_node);
+	if (unlikely(!hprio->row.rb_node))
+		return NULL;
+
 	sp->root = hprio->row.rb_node;
 	sp->pptr = &hprio->ptr;
 	sp->pid = &hprio->last_ptr_id;


