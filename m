Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621429;
	b=DyyZOkTN0J7Pip5SV5F3iSmcV645vBFAuen51hqjBbNM7OFOrIgLpde1U+5Ai2CynRTD
	 IulE4PhsnRZoL+7oVApuJGYYK6vM5AI6+l5rRf+KInHecifgCsEPUl1rxTuWB7yBcmYf7
	 BQvYQsd+xhkRnlQVNOWp2zKD3QaiC44SbwA/BL3akvNquAmu9BlSO9Vv8UzP7G8/bNHMO
	 nyPSvRRO2pQrLVweAecMG+NeAiJQr12eNfmWb9yTnHjNMGH3mInLz+kSKduIdpYQGIswV
	 GWYT30QrWlqvI3GPnCLU7nOsfdsdCoEXjM1eATJYvTu839GsgtsWtSohr0ZIdpVJKPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621429;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HsbKtP8CEwKvlaSNE0+BQTW6DcIoxHr2MaPtvCyMnCs=;
	b=UTrbCR9ROYQmONGNfd5JiqmH8HKLRy5Fe9AxOtNeOoP/8bb+nVLj5KQS5veAPcRIr/XI
	 DP6H0HGMXRRt/P8qw9O1K20hUIlaX/peyu0LIody27/IV05HyAO+gFVFqkCuHbd1fSh36
	 F4uq13rSreFgW+PKz1Z15ibp+VebBpIBAWLBdsypadDmcG3G0wdAtm0pZn2hu44dYEd/S
	 OA8pnClXNLY1yJNE5JzwCVuoBgGbm2TPZpArcFtr397aEWUiW1Zz4Mm+8LWm3SenTdWbs
	 fVhH7DWl7QH8d4NK7ujwW1Ztdr5tsmwx4+62Z/psvY/OprEFSM1hHmqzZplM17KviXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecZx0D+c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9723606A682;
	Wed, 25 Nov 2026 15:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ecZx0D+c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE721F000D0;
	Wed, 25 Nov 2026 15:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621428;
	bh=HsbKtP8CEwKvlaSNE0+BQTW6DcIoxHr2MaPtvCyMnCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ecZx0D+cHmwPe2US3CyKoxZhLCoETLiT6RO8jy6lKQZF0sF4JkkJPuhwvO0vl4TIj
	 mvJczCRXC+aeBSm+hHM384oUnn2CusoMni+rFzTEu4HH0Tsn17guVavoSBGEPRg6PB
	 t5yDQNp1BIl5Ddbn0H2scS68xpjqYAca6gKXytUE=
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
Subject: [PATCH 6.18 223/990] tcp: wait for TIME_WAIT teardown before freeing per-netns ehash
Date: Wed, 25 Nov 2026 15:26:30 +0100
Message-ID: <20261125143827.313079514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b5517f9af5465..fa5437b405207 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3700,6 +3700,7 @@ static int __net_init tcp_sk_init(struct net *net)
 
 static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 {
+	bool synced = false;
 	struct net *net;
 
 	/* make sure concurrent calls to tcp_sk_exit_batch from net_cleanup_work
@@ -3714,9 +3715,27 @@ static void __net_exit tcp_sk_exit_batch(struct list_head *net_exit_list)
 
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



