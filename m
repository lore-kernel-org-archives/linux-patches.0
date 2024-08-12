Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE404186E38;
	Mon, 12 Aug 2024 16:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480561; cv=none; b=s+uXzfU4H+rfvFQ1ag11BV7q3z+Rnf7j4fgciCfgKpVrCBdETAQRZTf9isc5h7zf7NjIjcJW2Hy0J3i/JNIpq+/r+TF/qrQXeXmmmRH5cwywcex1r8CsoJ2EWAHjNjKsP80D1kzqlEjRvfRJn/yW7/3ImvlhvVkWEdz/5toTiB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480561; c=relaxed/simple;
	bh=NW7N2qfbdrFKBPHnmhwXrHGer8mVALiRT7an4d427m4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V5+vK0CVqBEyDq4deEnuug7iudC1kgt5ZLWOHa2T36yhq3is6qEqe+DnF5taFpGGx1y4b6ggFGclEwfvlGP6Tm8s+wJD25xvWPknrYs0Y5bhKo8O4fphQd2gCm2ksIPD00+jQZFAGdb6Rd07RIcHi0ZaiqFXgfLS0TpuaM7Ul08=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XGHNrDWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XGHNrDWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBA3C4AF0F;
	Mon, 12 Aug 2024 16:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480561;
	bh=NW7N2qfbdrFKBPHnmhwXrHGer8mVALiRT7an4d427m4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XGHNrDWF3ESMgbe2r5oqn5g8PZF6zulr7mSpC6ReKki2D1KgqZRl8sf4Ws7q3LnX/
	 Hm2E65njKHvCOvvOpKkqNisfLexOMXyUqlv78qIf6OwZIX8eHxo/H0UeZCXqtIZd0L
	 2jr2lVSBfvIgwvpj43GBsU446A3EXu8XN2avubpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.10 234/263] net/tcp: Disable TCP-AO static key after RCU grace period
Date: Mon, 12 Aug 2024 18:03:55 +0200
Message-ID: <20240812160155.492860103@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Safonov <0x7f454c46@gmail.com>

commit 14ab4792ee120c022f276a7e4768f4dcb08f0cdd upstream.

The lifetime of TCP-AO static_key is the same as the last
tcp_ao_info. On the socket destruction tcp_ao_info ceases to be
with RCU grace period, while tcp-ao static branch is currently deferred
destructed. The static key definition is
: DEFINE_STATIC_KEY_DEFERRED_FALSE(tcp_ao_needed, HZ);

which means that if RCU grace period is delayed by more than a second
and tcp_ao_needed is in the process of disablement, other CPUs may
yet see tcp_ao_info which atent dead, but soon-to-be.
And that breaks the assumption of static_key_fast_inc_not_disabled().

See the comment near the definition:
> * The caller must make sure that the static key can't get disabled while
> * in this function. It doesn't patch jump labels, only adds a user to
> * an already enabled static key.

Originally it was introduced in commit eb8c507296f6 ("jump_label:
Prevent key->enabled int overflow"), which is needed for the atomic
contexts, one of which would be the creation of a full socket from a
request socket. In that atomic context, it's known by the presence
of the key (md5/ao) that the static branch is already enabled.
So, the ref counter for that static branch is just incremented
instead of holding the proper mutex.
static_key_fast_inc_not_disabled() is just a helper for such usage
case. But it must not be used if the static branch could get disabled
in parallel as it's not protected by jump_label_mutex and as a result,
races with jump_label_update() implementation details.

Happened on netdev test-bot[1], so not a theoretical issue:

[] jump_label: Fatal kernel bug, unexpected op at tcp_inbound_hash+0x1a7/0x870 [ffffffffa8c4e9b7] (eb 50 0f 1f 44 != 66 90 0f 1f 00)) size:2 type:1
[] ------------[ cut here ]------------
[] kernel BUG at arch/x86/kernel/jump_label.c:73!
[] Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN NOPTI
[] CPU: 3 PID: 243 Comm: kworker/3:3 Not tainted 6.10.0-virtme #1
[] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[] Workqueue: events jump_label_update_timeout
[] RIP: 0010:__jump_label_patch+0x2f6/0x350
...
[] Call Trace:
[]  <TASK>
[]  arch_jump_label_transform_queue+0x6c/0x110
[]  __jump_label_update+0xef/0x350
[]  __static_key_slow_dec_cpuslocked.part.0+0x3c/0x60
[]  jump_label_update_timeout+0x2c/0x40
[]  process_one_work+0xe3b/0x1670
[]  worker_thread+0x587/0xce0
[]  kthread+0x28a/0x350
[]  ret_from_fork+0x31/0x70
[]  ret_from_fork_asm+0x1a/0x30
[]  </TASK>
[] Modules linked in: veth
[] ---[ end trace 0000000000000000 ]---
[] RIP: 0010:__jump_label_patch+0x2f6/0x350

[1]: https://netdev-3.bots.linux.dev/vmksft-tcp-ao-dbg/results/696681/5-connect-deny-ipv6/stderr

Cc: stable@kernel.org
Fixes: 67fa83f7c86a ("net/tcp: Add static_key for TCP-AO")
Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ao.c |   43 ++++++++++++++++++++++++++++++-------------
 1 file changed, 30 insertions(+), 13 deletions(-)

--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -266,32 +266,49 @@ static void tcp_ao_key_free_rcu(struct r
 	kfree_sensitive(key);
 }
 
-void tcp_ao_destroy_sock(struct sock *sk, bool twsk)
+static void tcp_ao_info_free_rcu(struct rcu_head *head)
 {
-	struct tcp_ao_info *ao;
+	struct tcp_ao_info *ao = container_of(head, struct tcp_ao_info, rcu);
 	struct tcp_ao_key *key;
 	struct hlist_node *n;
 
+	hlist_for_each_entry_safe(key, n, &ao->head, node) {
+		hlist_del(&key->node);
+		tcp_sigpool_release(key->tcp_sigpool_id);
+		kfree_sensitive(key);
+	}
+	kfree(ao);
+	static_branch_slow_dec_deferred(&tcp_ao_needed);
+}
+
+static void tcp_ao_sk_omem_free(struct sock *sk, struct tcp_ao_info *ao)
+{
+	size_t total_ao_sk_mem = 0;
+	struct tcp_ao_key *key;
+
+	hlist_for_each_entry(key,  &ao->head, node)
+		total_ao_sk_mem += tcp_ao_sizeof_key(key);
+	atomic_sub(total_ao_sk_mem, &sk->sk_omem_alloc);
+}
+
+void tcp_ao_destroy_sock(struct sock *sk, bool twsk)
+{
+	struct tcp_ao_info *ao;
+
 	if (twsk) {
 		ao = rcu_dereference_protected(tcp_twsk(sk)->ao_info, 1);
-		tcp_twsk(sk)->ao_info = NULL;
+		rcu_assign_pointer(tcp_twsk(sk)->ao_info, NULL);
 	} else {
 		ao = rcu_dereference_protected(tcp_sk(sk)->ao_info, 1);
-		tcp_sk(sk)->ao_info = NULL;
+		rcu_assign_pointer(tcp_sk(sk)->ao_info, NULL);
 	}
 
 	if (!ao || !refcount_dec_and_test(&ao->refcnt))
 		return;
 
-	hlist_for_each_entry_safe(key, n, &ao->head, node) {
-		hlist_del_rcu(&key->node);
-		if (!twsk)
-			atomic_sub(tcp_ao_sizeof_key(key), &sk->sk_omem_alloc);
-		call_rcu(&key->rcu, tcp_ao_key_free_rcu);
-	}
-
-	kfree_rcu(ao, rcu);
-	static_branch_slow_dec_deferred(&tcp_ao_needed);
+	if (!twsk)
+		tcp_ao_sk_omem_free(sk, ao);
+	call_rcu(&ao->rcu, tcp_ao_info_free_rcu);
 }
 
 void tcp_ao_time_wait(struct tcp_timewait_sock *tcptw, struct tcp_sock *tp)


