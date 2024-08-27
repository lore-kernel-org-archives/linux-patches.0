Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 112171A01C8;
	Tue, 27 Aug 2024 14:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770514; cv=none; b=aJiPDmP7nQ5DPy0V/eJDdGVhJvCakTgAg9+L2CQVrqcf/c3xoCoXJwFvSRkxsPp/ITlyfXh+58BVwEKoliDH7bok3k7vcM1Pnu8Ais1TwqTmCvhSe/OBbdjH49UgOSXU6AS4BsKFSM42AsaC/hyX4gLJdntrXxHSS66ExLCumA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770514; c=relaxed/simple;
	bh=j7qE9ioYxamWLDm9JeGhAS5gNg1UFYAOpDIa7rRTeYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fPdh560UOkL5YcAGlwO0j+QfdvstW7JU1Ulha5ATG/efXxzxYs1zrOyHZs6ee/BR5lvJnGQB2M8rGz9aucHbC0B/1mFIfxg9EXp+74QypLE/9Nt8K9pw3gYTxbPD1IJ2ORWko8sqBr+jny9x4vHPelzF9Ml36djxveP9QAjTXbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b78yFPs5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b78yFPs5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB41C4E690;
	Tue, 27 Aug 2024 14:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770513;
	bh=j7qE9ioYxamWLDm9JeGhAS5gNg1UFYAOpDIa7rRTeYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b78yFPs5wWqI5xYwrJTfvgYpgJ0dyyBfZK5913GjT49M7Xua4NubLHhB5H7VkNKg8
	 hbAU0+GHKLJc6PhPLeS8QmZcQs4RiVx5gL17SCSdDbCqJzQfTT1tsqgM9vX79XKGeS
	 gqW6TkBlvE9dOrmHJpmSN04VN0AJSKBIQRg7Ekvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8ea26396ff85d23a8929@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jason Xing <kerneljasonxing@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 250/341] tcp: prevent concurrent execution of tcp_sk_exit_batch
Date: Tue, 27 Aug 2024 16:38:01 +0200
Message-ID: <20240827143852.920624522@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 565d121b69980637f040eb4d84289869cdaabedf ]

Its possible that two threads call tcp_sk_exit_batch() concurrently,
once from the cleanup_net workqueue, once from a task that failed to clone
a new netns.  In the latter case, error unwinding calls the exit handlers
in reverse order for the 'failed' netns.

tcp_sk_exit_batch() calls tcp_twsk_purge().
Problem is that since commit b099ce2602d8 ("net: Batch inet_twsk_purge"),
this function picks up twsk in any dying netns, not just the one passed
in via exit_batch list.

This means that the error unwind of setup_net() can "steal" and destroy
timewait sockets belonging to the exiting netns.

This allows the netns exit worker to proceed to call

WARN_ON_ONCE(!refcount_dec_and_test(&net->ipv4.tcp_death_row.tw_refcount));

without the expected 1 -> 0 transition, which then splats.

At same time, error unwind path that is also running inet_twsk_purge()
will splat as well:

WARNING: .. at lib/refcount.c:31 refcount_warn_saturate+0x1ed/0x210
...
 refcount_dec include/linux/refcount.h:351 [inline]
 inet_twsk_kill+0x758/0x9c0 net/ipv4/inet_timewait_sock.c:70
 inet_twsk_deschedule_put net/ipv4/inet_timewait_sock.c:221
 inet_twsk_purge+0x725/0x890 net/ipv4/inet_timewait_sock.c:304
 tcp_sk_exit_batch+0x1c/0x170 net/ipv4/tcp_ipv4.c:3522
 ops_exit_list+0x128/0x180 net/core/net_namespace.c:178
 setup_net+0x714/0xb40 net/core/net_namespace.c:375
 copy_net_ns+0x2f0/0x670 net/core/net_namespace.c:508
 create_new_namespaces+0x3ea/0xb10 kernel/nsproxy.c:110

... because refcount_dec() of tw_refcount unexpectedly dropped to 0.

This doesn't seem like an actual bug (no tw sockets got lost and I don't
see a use-after-free) but as erroneous trigger of debug check.

Add a mutex to force strict ordering: the task that calls tcp_twsk_purge()
blocks other task from doing final _dec_and_test before mutex-owner has
removed all tw sockets of dying netns.

Fixes: e9bd0cca09d1 ("tcp: Don't allocate tcp_death_row outside of struct netns_ipv4.")
Reported-by: syzbot+8ea26396ff85d23a8929@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/0000000000003a5292061f5e4e19@google.com/
Link: https://lore.kernel.org/netdev/20240812140104.GA21559@breakpoint.cc/
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Jason Xing <kerneljasonxing@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20240812222857.29837-1-fw@strlen.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index 6ef51d253abb7..96d235bcf5cb2 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -94,6 +94,8 @@ EXPORT_SYMBOL(tcp_hashinfo);
 
 static DEFINE_PER_CPU(struct sock *, ipv4_tcp_sk);
 
+static DEFINE_MUTEX(tcp_exit_batch_mutex);
+
 static u32 tcp_v4_init_seq(const struct sk_buff *skb)
 {
 	return secure_tcp_seq(ip_hdr(skb)->daddr,
@@ -3304,6 +3306,16 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 {
 	struct net *net;
 
+	/* make sure concurrent calls to tcp_sk_exit_batch from net_cleanup_work
+	 * and failed setup_net error unwinding path are serialized.
+	 *
+	 * tcp_twsk_purge() handles twsk in any dead netns, not just those in
+	 * net_exit_list, the thread that dismantles a particular twsk must
+	 * do so without other thread progressing to refcount_dec_and_test() of
+	 * tcp_death_row.tw_refcount.
+	 */
+	mutex_lock(&tcp_exit_batch_mutex);
+
 	tcp_twsk_purge(net_exit_list);
 
 	list_for_each_entry(net, net_exit_list, exit_list) {
@@ -3311,6 +3323,8 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 		WARN_ON_ONCE(!refcount_dec_and_test(&net->ipv4.tcp_death_row.tw_refcount));
 		tcp_fastopen_ctx_destroy(net);
 	}
+
+	mutex_unlock(&tcp_exit_batch_mutex);
 }
 
 static struct pernet_operations __net_initdata tcp_sk_ops = {
-- 
2.43.0



