Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE18439359;
	Thu, 30 Jul 2026 15:52:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785426771; cv=none; b=cVLTMeuQ14vQfSOFFEEvQepkjjkEy1RTTXuQgZl046ygp89I2V0rncL/JZJExOuOyKT58RhnYiDgF8T+7iF0ivoJhcqbtEbAc1G+4Jv5uIGKBxjPgP+dmQudIswh+oPyzjOHyRRFeyBba9apNkMGkr63IADauXCJNjNwGrKXg/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785426771; c=relaxed/simple;
	bh=z6AZs6363zg0+Ht5xT5YDIGYfaf4ZhoBv0FaDYg/xxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHF2MUGASi6oZxIZOGt9jZzbvnVoKlBWOh2F74qRqX86UYw8NZeH3bWzBr24a6KQ6gtiiUJO7Wo54XUU2itKnw6ntwWcovm6pYbb7hijEAbpE3BhRM++ptA8urIVZ384B6lRehqvF0rC3hTWHEM3ZucvCQiQqE0Eir4eKTpSnCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URKBXs6S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URKBXs6S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D7731F000E9;
	Thu, 30 Jul 2026 15:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785426770;
	bh=UF8yKzC6AdyWIwy2wxCv6xvbNE1CufoGwZ7Otb337nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=URKBXs6S4oCgoAPlq1of9iyFa0vkPSnzE4uvytPyf+hR1fXIUdY3G2Tv4xY9CD5qG
	 HTZKd9CYWmSWN1wHj54LIgSjFf6kqUmR/4HpbmKVN8MetUD6U3offF+GOpuxPPJCE6
	 p33Cs/PKwVXwgt26LZCI62XzVreE68ZusGtOO32A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Michael Bommarito <michael.bommarito@gmail.com>,
	Dmitry Safonov <dima@arista.com>,
	Qihang <q.h.hack.winter@gmail.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 536/602] tcp: defer md5sig_info kfree past RCU grace period in tcp_connect
Date: Thu, 30 Jul 2026 16:15:28 +0200
Message-ID: <20260730141447.284647443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Michael Bommarito <michael.bommarito@gmail.com>

[ Upstream commit b74cd55038905d5e74c1de109ab78a30b2ea0e1f ]

The md5+ao reconciliation in tcp_connect() (net/ipv4/tcp_output.c)
has two symmetric branches:

	if (needs_md5) {
		tcp_ao_destroy_sock(sk, false);
	} else if (needs_ao) {
		tcp_clear_md5_list(sk);
		kfree(rcu_replace_pointer(tp->md5sig_info, NULL, ...));
	}

Both branches free a per-socket auth-info object while the socket is
in TCP_SYN_SENT and is already on the inet ehash (inserted by
inet_hash_connect() in tcp_v4_connect()). Both branches are reachable
by softirq RX-path readers that load the corresponding info pointer
via implicit RCU before bh_lock_sock_nested() is taken.

The needs_md5 branch is fixed in the prior patch by re-introducing
the call_rcu() free in tcp_ao_destroy_sock(): the equivalent per-key
loop runs inside tcp_ao_info_free_rcu(), the RCU callback, so by the
time it frees each tcp_ao_key all softirq readers that captured the
container have already completed rcu_read_unlock().

The needs_ao branch is not symmetric in the same way. The container
free can be deferred via kfree_rcu(md5sig, rcu) -- struct
tcp_md5sig_info already has the required rcu member
(include/net/tcp.h:1999-2002), and the rest of the tree already does
this in the tcp_md5sig_info_add() rollback paths
(net/ipv4/tcp_ipv4.c:1410, 1436). But the per-key teardown is done
by tcp_clear_md5_list() in process context BEFORE the container's
RCU grace period: it walks &md5sig->head and frees each
tcp_md5sig_key with bare hlist_del + kfree. A concurrent softirq
reader in __tcp_md5_do_lookup() / __tcp_md5_do_lookup_exact()
(tcp_ipv4.c:1253, 1298) walks the same list via
hlist_for_each_entry_rcu() and races with that bare kfree on the
keys themselves -- a per-key slab use-after-free of the same class
as the TCP-AO bug, on the same race window.

Fix this in two halves:

  1. Convert the bare kfree() in tcp_connect() to kfree_rcu() so the
     md5sig_info container joins the rest of the md5sig lifecycle.
     The local-variable lift is mechanical and required because
     kfree_rcu() is a macro that expects an lvalue.

  2. Make tcp_clear_md5_list() RCU-safe by replacing hlist_del +
     kfree(key) with hlist_del_rcu + kfree_rcu(key, rcu). struct
     tcp_md5sig_key already carries the rcu member
     (include/net/tcp.h:1995) and tcp_md5_do_del()
     (net/ipv4/tcp_ipv4.c:1456) already uses kfree_rcu, so this
     restores the lifecycle invariant the rest of the file follows
     rather than introducing a one-off.

The other caller of tcp_clear_md5_list() is tcp_md5_destruct_sock()
(net/ipv4/tcp.c:412), which runs from the sock destructor when the
socket is already unhashed and unreachable; the extra grace period
there is unnecessary but harmless. Making the helper unconditionally
RCU-safe is the cleaner contract.

The needs_ao branch is not reachable by the userns reproducer used
to demonstrate the AO-side splat (the repro installs both keys but
ends up in the needs_md5 branch because the connect peer matches
the MD5 key, not the AO key); however the symmetric race exists
and a maintainer touching this code should not have to think about
which branch escapes RCU and which one does not.

Fixes: 51e547e8c89c ("tcp: Free TCP-AO/TCP-MD5 info/keys without RCU")
Cc: stable@vger.kernel.org # v6.18+
Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Michael Bommarito <michael.bommarito@gmail.com>
Reviewed-by: Dmitry Safonov <dima@arista.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
[also credits to Qihang, who found that this races with tcp-diag]
Reported-by: Qihang <q.h.hack.winter@gmail.com>
Signed-off-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://patch.msgid.link/20260625-tcp-md5-connect-v3-2-1fd313d6c1e0@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 6f6e860e370c ("tcp: Decrement tcp_md5_needed static branch")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -4119,9 +4119,13 @@ int tcp_connect(struct sock *sk)
 		if (needs_md5) {
 			tcp_ao_destroy_sock(sk, false);
 		} else if (needs_ao) {
+			struct tcp_md5sig_info *md5sig;
+
 			tcp_clear_md5_list(sk);
-			kfree(rcu_replace_pointer(tp->md5sig_info, NULL,
-						  lockdep_sock_is_held(sk)));
+			md5sig = rcu_replace_pointer(tp->md5sig_info, NULL,
+						     lockdep_sock_is_held(sk));
+			if (md5sig)
+				kfree_rcu(md5sig, rcu);
 		}
 	}
 #endif


