Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2F514EB862;
	Tue, 13 Oct 2026 12:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895562; cv=none; b=RxQFtVh26qf4rTYiu/+RH9i0y+FDKFBjN0IMrmPJJTBEUR7TLO0OtWEUSy6hweNQNyO4tJT3tqUM3jxyx2ASu2SLDg3ovZdO/bMNOXuJdBLnEhS15oX1PHIjXbMQ37UnNP3D7Xybz7MFAhDMKWl/1DturXdhlanRUamJFrpK//s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895562; c=relaxed/simple;
	bh=xLfaHO/X9klxiqqZh49DN158UXgieaZvypI+HjaIrko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aQYViS7FGpYXe3RF5goxZkdsFyq09s8LsBpIw/zHd6NyOrYBv4TgvKpqXG5PrEwRdAQZMQShcVbGEOiodDlfIDK/zICskBNygGcmwUINKd9bmaJlf8xExjZ/wG2g0t7yEwieSu6vioB8gnQezdZr9YPG0GeRpR5z19O0myPSHO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHZpMQUT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHZpMQUT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C906C1F000FF;
	Tue, 13 Oct 2026 12:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895561;
	bh=z9OZ6OBVPS0y7RUdveXh1WN1jIDNbxgDQOJF1o3nKAM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EHZpMQUTHxxeFtwd1btDYHl8C0DaOW61vJ4MhJBXqy6ieVBBvAHQW/dXxEJk3vaN4
	 Zj1ikyhn9QzHfMFbXkM+02oQbQgZVCIVD7qeEICM6wtO76yzjLIYz5KUgoPZ0APcPD
	 nVlBbLUGR1pMyuhjp+at6VRXdj5iAnlj5YVcHHYE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xinyang Ge <xinyang@anthropic.com>,
	Eric Dumazet <edumazet@kernel.org>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 314/497] ipv4: free inet_opt and ireq_opt after an RCU grace period
Date: Tue, 13 Oct 2026 13:38:01 +0200
Message-ID: <20261013112915.355144294@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Eric Dumazet <edumazet@kernel.org>

commit e3f33b0a1d89d738e2b913dab519226eaf76e15b upstream.

tcp_v4_syn_recv_sock() transfers ownership of ireq->ireq_opt to the
child socket (newinet->inet_opt) without copying it.

Another cpu can concurrently process a retransmitted SYN for the same
request socket, and send a SYNACK from tcp_check_req().
tcp_v4_send_synack() and inet_csk_route_req() read ireq->ireq_opt
under rcu_read_lock() only, and ip_build_and_send_pkt() and
ip_options_build() then read opt->optlen twice.

Note that the SYNACK timer itself is not an issue: it holds a
reference on its request socket, and inet_csk_reqsk_queue_drop()
calls timer_delete_sync() before the child can be freed.

Since commit 079096f103fa ("tcp/dccp: install syn_recv requests
into ehash table"), request sockets are processed without holding
the listener lock, so nothing prevents the child socket from being
freed while the SYNACK is still being built. TCP child sockets do
not have SOCK_RCU_FREE, and inet_sock_destruct() frees inet_opt
with a plain kfree(), leading to a use-after-free in
ip_options_build().

A similar issue exists with request socket migration
(net.ipv4.tcp_migrate_req=1, or a BPF_SK_REUSEPORT_SELECT_OR_MIGRATE
program). reqsk_timer_handler() clones the request socket with
inet_reqsk_clone(), so that the old request socket and its clone
share the same ireq_opt, then reqsk_migrate_reset() clears the
pointer in the old one. Another cpu holding a reference on the old
request socket can still be using these options (sending a SYNACK,
or creating a child in tcp_v4_syn_recv_sock()) when the clone is
freed, and tcp_v4_reqsk_destructor() also uses a plain kfree().

Readers already use RCU, and other paths replacing inet_opt
(do_ip_setsockopt(), cipso_v4_sock_setattr()...) already use
kfree_rcu(). Use kfree_rcu() in inet_sock_destruct() and
tcp_v4_reqsk_destructor() as well.

IPv6 is not affected by the first issue, because tcp_v6_syn_recv_sock()
duplicates the options. tcp_v6_reqsk_destructor() has the same
migration issue with ipv6_opt, which is only set by CALIPSO. This
will be addressed in a separate patch.

Fixes: 079096f103fa ("tcp/dccp: install syn_recv requests into ehash table")
Fixes: c905dee62232 ("tcp: Migrate TCP_NEW_SYN_RECV requests at retransmitting SYN+ACKs.")
Reported-by: Xinyang Ge <xinyang@anthropic.com>
Signed-off-by: Eric Dumazet <edumazet@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20261001221253.2964024-1-edumazet@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/af_inet.c  |    2 +-
 net/ipv4/tcp_ipv4.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -155,7 +155,7 @@ void inet_sock_destruct(struct sock *sk)
 	WARN_ON_ONCE(sk->sk_wmem_queued);
 	WARN_ON_ONCE(sk_forward_alloc_get(sk));
 
-	kfree(rcu_dereference_protected(inet->inet_opt, 1));
+	kfree_rcu(rcu_dereference_protected(inet->inet_opt, 1), rcu);
 	dst_release(rcu_dereference_protected(sk->sk_dst_cache, 1));
 	dst_release(rcu_dereference_protected(sk->sk_rx_dst, 1));
 }
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -1219,7 +1219,7 @@ static int tcp_v4_send_synack(const stru
  */
 static void tcp_v4_reqsk_destructor(struct request_sock *req)
 {
-	kfree(rcu_dereference_protected(inet_rsk(req)->ireq_opt, 1));
+	kfree_rcu(rcu_dereference_protected(inet_rsk(req)->ireq_opt, 1), rcu);
 }
 
 #ifdef CONFIG_TCP_MD5SIG


