Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19EA4315A;
	Sun,  7 Sep 2025 20:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277764; cv=none; b=UKcr9WfUtsJp7tliBZoqn66XAMR1FmMDePlyo0jqbtmVB0yEN3iEMOPyX0sa2VVHfXHedGbOrwowP0WET+isyr7/uA6qbjrGZ/qeK8ei9bAExAtQBoMYy8goKh1/v6XOpCQ2fPtqltAAYsQbd2P7NAxvKWh4Y5Kbd9P1+/t7oAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277764; c=relaxed/simple;
	bh=bkJXxjf350oC+XtJiVpGNInDihFovxHtGywTjZMvwKU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hqzq9ai1Lyyl9wfRBzG1K5J3AMBWErg/45fiEjxY6a2zHuEpC4baKd4nZEgXFRzNfuTGxBnYOseKNiTefEibDmMBekcPTOpwZlRaGZkePXyJW+Vg+K9brtjf8MV/B74KjXj2XlyrTrjiD/2kRdxSjPNkTM9hOdjO7hEcRJcoMjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPp8x08O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPp8x08O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55175C4CEF0;
	Sun,  7 Sep 2025 20:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277764;
	bh=bkJXxjf350oC+XtJiVpGNInDihFovxHtGywTjZMvwKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DPp8x08O6Q5pJMItw/pRmW3p8T0wxYEp5H8tuRZNrjNeaqsMHHmjs48b0HZR3/lSZ
	 +DTcR87qZpE4VvlpbERB9Xjr3123RmfszaHbddNC3UyNAh0homzn3ONtwAYBOdmtUp
	 6LZHUJ1N/ztO9OV8YaENjbyl3ZyoByv6eQ78e3iQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Paasch <cpaasch@openai.com>,
	Dmitry Safonov <0x7f454c46@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 073/183] net/tcp: Fix socket memory leak in TCP-AO failure handling for IPv6
Date: Sun,  7 Sep 2025 21:58:20 +0200
Message-ID: <20250907195617.531781267@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Paasch <cpaasch@openai.com>

[ Upstream commit fa390321aba0a54d0f7ae95ee4ecde1358bb9234 ]

When tcp_ao_copy_all_matching() fails in tcp_v6_syn_recv_sock() it just
exits the function. This ends up causing a memory-leak:

unreferenced object 0xffff0000281a8200 (size 2496):
  comm "softirq", pid 0, jiffies 4295174684
  hex dump (first 32 bytes):
    7f 00 00 06 7f 00 00 06 00 00 00 00 cb a8 88 13  ................
    0a 00 03 61 00 00 00 00 00 00 00 00 00 00 00 00  ...a............
  backtrace (crc 5ebdbe15):
    kmemleak_alloc+0x44/0xe0
    kmem_cache_alloc_noprof+0x248/0x470
    sk_prot_alloc+0x48/0x120
    sk_clone_lock+0x38/0x3b0
    inet_csk_clone_lock+0x34/0x150
    tcp_create_openreq_child+0x3c/0x4a8
    tcp_v6_syn_recv_sock+0x1c0/0x620
    tcp_check_req+0x588/0x790
    tcp_v6_rcv+0x5d0/0xc18
    ip6_protocol_deliver_rcu+0x2d8/0x4c0
    ip6_input_finish+0x74/0x148
    ip6_input+0x50/0x118
    ip6_sublist_rcv+0x2fc/0x3b0
    ipv6_list_rcv+0x114/0x170
    __netif_receive_skb_list_core+0x16c/0x200
    netif_receive_skb_list_internal+0x1f0/0x2d0

This is because in tcp_v6_syn_recv_sock (and the IPv4 counterpart), when
exiting upon error, inet_csk_prepare_forced_close() and tcp_done() need
to be called. They make sure the newsk will end up being correctly
free'd.

tcp_v4_syn_recv_sock() makes this very clear by having the put_and_exit
label that takes care of things. So, this patch here makes sure
tcp_v4_syn_recv_sock and tcp_v6_syn_recv_sock have similar
error-handling and thus fixes the leak for TCP-AO.

Fixes: 06b22ef29591 ("net/tcp: Wire TCP-AO to request sockets")
Signed-off-by: Christoph Paasch <cpaasch@openai.com>
Reviewed-by: Dmitry Safonov <0x7f454c46@gmail.com>
Link: https://patch.msgid.link/20250830-tcpao_leak-v1-1-e5878c2c3173@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/tcp_ipv6.c | 32 +++++++++++++++-----------------
 1 file changed, 15 insertions(+), 17 deletions(-)

diff --git a/net/ipv6/tcp_ipv6.c b/net/ipv6/tcp_ipv6.c
index f61b0396ef6b1..3e83c7b5c14a7 100644
--- a/net/ipv6/tcp_ipv6.c
+++ b/net/ipv6/tcp_ipv6.c
@@ -1431,17 +1431,17 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 	ireq = inet_rsk(req);
 
 	if (sk_acceptq_is_full(sk))
-		goto out_overflow;
+		goto exit_overflow;
 
 	if (!dst) {
 		dst = inet6_csk_route_req(sk, &fl6, req, IPPROTO_TCP);
 		if (!dst)
-			goto out;
+			goto exit;
 	}
 
 	newsk = tcp_create_openreq_child(sk, req, skb);
 	if (!newsk)
-		goto out_nonewsk;
+		goto exit_nonewsk;
 
 	/*
 	 * No need to charge this sock to the relevant IPv6 refcnt debug socks
@@ -1525,25 +1525,19 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 			const union tcp_md5_addr *addr;
 
 			addr = (union tcp_md5_addr *)&newsk->sk_v6_daddr;
-			if (tcp_md5_key_copy(newsk, addr, AF_INET6, 128, l3index, key)) {
-				inet_csk_prepare_forced_close(newsk);
-				tcp_done(newsk);
-				goto out;
-			}
+			if (tcp_md5_key_copy(newsk, addr, AF_INET6, 128, l3index, key))
+				goto put_and_exit;
 		}
 	}
 #endif
 #ifdef CONFIG_TCP_AO
 	/* Copy over tcp_ao_info if any */
 	if (tcp_ao_copy_all_matching(sk, newsk, req, skb, AF_INET6))
-		goto out; /* OOM */
+		goto put_and_exit; /* OOM */
 #endif
 
-	if (__inet_inherit_port(sk, newsk) < 0) {
-		inet_csk_prepare_forced_close(newsk);
-		tcp_done(newsk);
-		goto out;
-	}
+	if (__inet_inherit_port(sk, newsk) < 0)
+		goto put_and_exit;
 	*own_req = inet_ehash_nolisten(newsk, req_to_sk(req_unhash),
 				       &found_dup_sk);
 	if (*own_req) {
@@ -1570,13 +1564,17 @@ static struct sock *tcp_v6_syn_recv_sock(const struct sock *sk, struct sk_buff *
 
 	return newsk;
 
-out_overflow:
+exit_overflow:
 	__NET_INC_STATS(sock_net(sk), LINUX_MIB_LISTENOVERFLOWS);
-out_nonewsk:
+exit_nonewsk:
 	dst_release(dst);
-out:
+exit:
 	tcp_listendrop(sk);
 	return NULL;
+put_and_exit:
+	inet_csk_prepare_forced_close(newsk);
+	tcp_done(newsk);
+	goto exit;
 }
 
 INDIRECT_CALLABLE_DECLARE(struct dst_entry *ipv4_dst_check(struct dst_entry *,
-- 
2.50.1



