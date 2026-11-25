Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624428;
	b=Jje5SGSVrpiDkH+WcX0DFhf6z1/FejEtW38r01Jts6+lOBjmXvREZEn4S8DRczbsafvj
	 ux4wWBT4WKvUHSnbuh+Zl179r7iZ8UQlyL4O5nKxG4slfQ+NAu4GqJ9pIyCJ+uUaCDrHv
	 Ws8c4h5C+Z6D/I/2Eyz08g2xKNuBj87qvY/k9qwRd3owuyPDhGYQ0C0f1oqYoz6Esk5KH
	 88u6jynNt9OcIUBO35sZz3R3ntXqkHL+D1P4wMTcx1y2YafdhAgGH4+fVKIgOBH7F75xL
	 6xscgXOBFwwE2pyZ14YoCXjMwrlEsZy07vmclsEyum27jSfj/mSKFAu5QN3byaO06vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5HySbtZp+rXIqvXR6rELySxeOfvGQVfDSodmgLQDZng=;
	b=1CO2bfdRYyxQu9viZM2Gp3qoBgSvN5CNO0VxjgXkqPYFRzSCuCq3BLufaP/Jt2FwfUrb
	 2IkzuK17jlz7ymTpLBVWh6pk8piiSCJUEQsR6YiSqkTBtA8KnDlaMfkjuhzXu3xU8HKkz
	 /HktsogFUr20fKV55HZwjQC81SQt2kSb/6gS0sclGTB+3HXLv/jbetH2quloO6AkAm3WN
	 E0PmWrYhhdC/KumygkDJ8Z+ksZ0SNTUMG7WGxSBoHxO6MoJnwKI7bATU7Rp97VyXPyWEV
	 xtCo0GRMXH8pItkqCLI/3dqtPPS+v+VBD5UxveGqy7fJe1sUhAWEltgEfrkgBCeFKEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PpEL4uhx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B5E5606A33A;
	Wed, 25 Nov 2026 16:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PpEL4uhx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D03A81F000C0;
	Wed, 25 Nov 2026 16:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624428;
	bh=5HySbtZp+rXIqvXR6rELySxeOfvGQVfDSodmgLQDZng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PpEL4uhxvSgB4GYECK4A0Wgk9y2/c5i8VwrEaeMaF4FQGfLAEyu+2Z5KeAVpIFim3
	 h8WUWbNOfltN2ZIPPXv/ONn0JQYSZam6TWogb5uZky6jYgA1WNjO1Fj59ffXmiby8B
	 wI5cOOJc91RgQeiS6Knkn/WxVtArDpl2YKEqHHmg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 190/816] tcp: wait for TIME_WAIT teardown before freeing per-netns ehash
Date: Wed, 25 Nov 2026 15:28:58 +0100
Message-ID: <20261125143853.592614185@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 647b81ddefc6364290e67bf33c89d54971f8995e ]

inet_twsk_kill() removes a TIME_WAIT socket from the established hash
before it finishes using the ehash lock, hashinfo and bind tables, and
before it drops the death-row reference. A running timer can therefore
unhash its socket before inet_twsk_purge() reaches it. The purge cannot
synchronize with that timer, and tcp_sk_exit_batch() can free the
private ehash and hashinfo while inet_twsk_kill() is still using them.

An unprivileged reproducer using user and network namespaces, a private
TCP ehash and a FIN_WAIT2 timer triggers a KASAN slab-use-after-free in
inet_twsk_kill(). The allocation and free stacks point to
inet_pernet_hashinfo_alloc() and inet_pernet_hashinfo_free().

Wait for an RCU grace period after purging the whole batch, if one
netns in the batch uses a private ehash. TIME_WAIT removal runs with
bottom halves disabled, so this also waits for removers that were
already invisible to the purge. Keep the wait under
tcp_exit_batch_mutex, before freeing any private hashinfo.

The same window exists with the shared tcp_hashinfo. There, the
hashinfo memory stays valid, but tcp_sk_exit_batch() can decrement
tcp_death_row.tw_refcount from 2 to 1 before inet_twsk_kill() drops its
own reference. This triggers the WARN_ON_ONCE() in tcp_sk_exit_batch(),
then a refcount_t "decrement hit 0" warning from inet_twsk_kill().

Adding a grace period for the shared case would be costly on busy
hosts. It is not needed: struct net is freed by a later cleanup_net(),
after the synchronize_rcu() in ops_undo_list(), so inet_twsk_kill()
can safely drop the last tw_refcount reference itself.
Use refcount_dec_if_one() and only warn if tw_refcount is not 1
after a grace period.

Fixes: d1e5e6408b30 ("tcp: Introduce optional per-netns ehash.")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
[edumazet: only call synchronize_net() if one netns in the batch uses a private ehash,
 use refcount_dec_if_one() to avoid a false WARN with the shared ehash]
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261030075843.2567707-1-edumazet@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index b42630611afc7..b92f040a3eaab 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3681,6 +3681,7 @@ static int __net_init tcp_sk_init(struct net *net)
 
 static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 {
+	bool synced = false;
 	struct net *net;
 
 	/* make sure concurrent calls to tcp_sk_exit_batch from net_cleanup_work
@@ -3695,9 +3696,27 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 
 	tcp_twsk_purge(net_exit_list);
 
+	/* inet_twsk_kill() unhashes a twsk before it is done with ehash
+	 * and bhash, and before it drops its tw_refcount reference,
+	 * so tcp_twsk_purge() can miss it. Such callers run with BH
+	 * disabled: wait for them before freeing a private ehash.
+	 */
+	list_for_each_entry(net, net_exit_list, exit_list) {
+		if (net->ipv4.tcp_death_row.hashinfo->pernet) {
+			synchronize_net();
+			synced = true;
+			break;
+		}
+	}
+
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		inet_pernet_hashinfo_free(net->ipv4.tcp_death_row.hashinfo);
-		WARN_ON_ONCE(!refcount_dec_and_test(&net->ipv4.tcp_death_row.tw_refcount));
+		/* Without a grace period, a concurrent inet_twsk_kill() might
+		 * still hold a tw_refcount reference. Let it drop it: struct net
+		 * is freed by a later cleanup_net(), after an RCU grace period.
+		 */
+		if (!refcount_dec_if_one(&net->ipv4.tcp_death_row.tw_refcount))
+			WARN_ON_ONCE(synced);
 		tcp_fastopen_ctx_destroy(net);
 	}
 
-- 
2.53.0



