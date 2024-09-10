Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC3618EFCD;
	Tue, 10 Sep 2024 10:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962404; cv=none; b=fclUkQOn0aJULUmFaRdZE6T4A1Ai8vkSQbb3tLKVgc2SlCJ+lrg/u+A97PLNrGhRPHcB3tuVyFxfupG6Yk2+z6lQsrtiDhLI0sniE3dKapruu3WRtbWYWo8A8sfFCgiqAoKrAvl2ywgjd71YHY61dDbzqK5wcokeZvaR2D44khM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962404; c=relaxed/simple;
	bh=PZuGwrRPZ0x8Pmdi+2k9iI/zk/mVxpOH+8UM72Tqpfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U79rWOnAroYnmNHw+t4CjSHkYbIU6wMe3ZrD9ZuQsWaGc6N7aJ5WaGTgxKcUz5W89wTSIdklp1ObJAatZfX8JLGo2efdN/NVdcJVFl5a3FGKPqCFeZDzj2MV5bpZHgNfHjIaIKvhvVr+W6sZHr3KYmYQl7FeX0m+PxbOOrdRa0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tEwRA7jV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tEwRA7jV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 081B6C4CEC3;
	Tue, 10 Sep 2024 10:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962404;
	bh=PZuGwrRPZ0x8Pmdi+2k9iI/zk/mVxpOH+8UM72Tqpfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tEwRA7jVjFKLWIK4Z2dstg9PflKs28zhgZJVyzeoHrGMYGAeyMKdEXCeSUY93WG7D
	 sFJv0n0CbQigoAGSprPBIkh/yeDMonyZ/ed9k3p1C70GxR24u5uYlZpHSxko4KKFyB
	 mlEHwdLwIJJb5PBTrQiDR3eo0mNZ4i6YeX2ROL5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Stanislav Fomichev <sdf@google.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	"David S. Miller" <davem@davemloft.net>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: [PATCH 5.4 022/121] net: set SOCK_RCU_FREE before inserting socket into hashtable
Date: Tue, 10 Sep 2024 11:31:37 +0200
Message-ID: <20240910092546.769444440@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092545.737864202@linuxfoundation.org>
References: <20240910092545.737864202@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf@google.com>

commit 871019b22d1bcc9fab2d1feba1b9a564acbb6e99 upstream.

We've started to see the following kernel traces:

 WARNING: CPU: 83 PID: 0 at net/core/filter.c:6641 sk_lookup+0x1bd/0x1d0

 Call Trace:
  <IRQ>
  __bpf_skc_lookup+0x10d/0x120
  bpf_sk_lookup+0x48/0xd0
  bpf_sk_lookup_tcp+0x19/0x20
  bpf_prog_<redacted>+0x37c/0x16a3
  cls_bpf_classify+0x205/0x2e0
  tcf_classify+0x92/0x160
  __netif_receive_skb_core+0xe52/0xf10
  __netif_receive_skb_list_core+0x96/0x2b0
  napi_complete_done+0x7b5/0xb70
  <redacted>_poll+0x94/0xb0
  net_rx_action+0x163/0x1d70
  __do_softirq+0xdc/0x32e
  asm_call_irq_on_stack+0x12/0x20
  </IRQ>
  do_softirq_own_stack+0x36/0x50
  do_softirq+0x44/0x70

__inet_hash can race with lockless (rcu) readers on the other cpus:

  __inet_hash
    __sk_nulls_add_node_rcu
    <- (bpf triggers here)
    sock_set_flag(SOCK_RCU_FREE)

Let's move the SOCK_RCU_FREE part up a bit, before we are inserting
the socket into hashtables. Note, that the race is really harmless;
the bpf callers are handling this situation (where listener socket
doesn't have SOCK_RCU_FREE set) correctly, so the only
annoyance is a WARN_ONCE.

More details from Eric regarding SOCK_RCU_FREE timeline:

Commit 3b24d854cb35 ("tcp/dccp: do not touch listener sk_refcnt under
synflood") added SOCK_RCU_FREE. At that time, the precise location of
sock_set_flag(sk, SOCK_RCU_FREE) did not matter, because the thread calling
__inet_hash() owns a reference on sk. SOCK_RCU_FREE was only tested
at dismantle time.

Commit 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
started checking SOCK_RCU_FREE _after_ the lookup to infer whether
the refcount has been taken care of.

Fixes: 6acc9b432e67 ("bpf: Add helper to retrieve socket in BPF")
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
[Resolved conflict for 5.10 and below.]
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_hashtables.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/inet_hashtables.c
+++ b/net/ipv4/inet_hashtables.c
@@ -609,6 +609,7 @@ int __inet_hash(struct sock *sk, struct
 		if (err)
 			goto unlock;
 	}
+	sock_set_flag(sk, SOCK_RCU_FREE);
 	if (IS_ENABLED(CONFIG_IPV6) && sk->sk_reuseport &&
 		sk->sk_family == AF_INET6)
 		__sk_nulls_add_node_tail_rcu(sk, &ilb->nulls_head);
@@ -616,7 +617,6 @@ int __inet_hash(struct sock *sk, struct
 		__sk_nulls_add_node_rcu(sk, &ilb->nulls_head);
 	inet_hash2(hashinfo, sk);
 	ilb->count++;
-	sock_set_flag(sk, SOCK_RCU_FREE);
 	sock_prot_inuse_add(sock_net(sk), sk->sk_prot, 1);
 unlock:
 	spin_unlock(&ilb->lock);


