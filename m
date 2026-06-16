Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7257B43E490;
	Tue, 16 Jun 2026 17:08:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629726; cv=none; b=CipSad6IL2IKEHVuqMXEZvUMwytLllTBuWHwY/ElCol85JAuPJAlpWqzweElaC1swKaccYImnzHuMrlYw9rbgaC/PHTZWU6zrDjiZiYGV9lqdFPC6QbIshAiQvmDOa9ZRAHMQgEnfj0NDM8OxDB5sdG8wrA/WSJeiHJ4p61pvgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629726; c=relaxed/simple;
	bh=XuP2QmOAK6+BDbLSUFwvlOns4N2T3pfXfFYH+rS4plU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nU0DWgQFy0tuQMfN090MsHjzDqQPbqYhyuDrUU1Yr+YkjkjxH9/N93gY1n/JKp0TLLSPvKDc1gIS6+nYcMQFg1VrubR/10ZWkxSGNgvNU3ktGuJf2b/8WHZHOL8RSboia+Vx+SWhbyuri56l0duAAMI9W/OaH8DbRCcBfwW0Rz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x/sldnO1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x/sldnO1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D431F000E9;
	Tue, 16 Jun 2026 17:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629725;
	bh=5d2at4bTXw26NZJ+wrEHJzljFyPLDsWeVjuLz+wsHns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x/sldnO1i0nWgYBJWn1SYkGQDZaqeXFVp6eIgAMQoHh27OCs6FVVjbMsGAJl/irkO
	 pwg4DGKgwWlr5g2VnO6IBMvV3UZbziHjIKwi5uMOAszbmaEm2kbauloGBJTzvCl2Wm
	 Vrr5QSgxfgXxW8ZzXTnOrLmQEBk2EJJOXCMOzEvI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 310/452] udp: clear skb->dev before running a sockmap verdict
Date: Tue, 16 Jun 2026 20:28:57 +0530
Message-ID: <20260616145133.806772841@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sechang Lim <rhkrqnwk98@gmail.com>

commit 3c94f241f776562c489876ff506f366224565c21 upstream.

On the UDP receive path skb->dev is repurposed as dev_scratch (the
truesize/state cache set by udp_set_dev_scratch()), through the
union { struct net_device *dev; unsigned long dev_scratch; } in sk_buff.

When a UDP socket is in a sockmap, sk_data_ready is
sk_psock_verdict_data_ready(), which calls udp_read_skb() -> recv_actor()
(sk_psock_verdict_recv) to run the attached SK_SKB verdict program in softirq.
If that program calls a socket-lookup helper (bpf_sk_lookup_tcp/udp,
bpf_skc_lookup_tcp), bpf_skc_lookup() does:

	if (skb->dev)
		caller_net = dev_net(skb->dev);

skb->dev still holds the dev_scratch value (a non-NULL integer), so dev_net()
dereferences it as a struct net_device * and the kernel takes a general
protection fault on a non-canonical address in softirq:

  Oops: general protection fault, probably for non-canonical address 0x1010000800004a0
  CPU: 1 UID: 0 PID: 1406 Comm: syz.2.19 Not tainted 7.1.0-rc6 #1 PREEMPT(full)
  RIP: 0010:bpf_skc_lookup net/core/filter.c:7033 [inline]
  RIP: 0010:bpf_sk_lookup+0x45/0x160 net/core/filter.c:7047
  Call Trace:
   <IRQ>
   bpf_prog_4675cb904b7071f8+0x12e/0x14e
   bpf_prog_run_pin_on_cpu+0xc6/0x1f0
   sk_psock_verdict_recv+0x1ba/0x350
   udp_read_skb+0x31a/0x370
   sk_psock_verdict_data_ready+0x2e3/0x600
   __udp_enqueue_schedule_skb+0x4c8/0x650
   udpv6_queue_rcv_one_skb+0x3ec/0x740
   udp6_unicast_rcv_skb+0x11d/0x140
   ip6_protocol_deliver_rcu+0x61e/0x950
   ip6_input_finish+0xa9/0x150
   NF_HOOK+0x286/0x2f0
   ip6_input+0x117/0x220
   NF_HOOK+0x286/0x2f0
   __netif_receive_skb+0x85/0x200
   process_backlog+0x374/0x9a0
   __napi_poll+0x4f/0x1c0
   net_rx_action+0x3b0/0x770
   handle_softirqs+0x15a/0x460
   do_softirq+0x57/0x80
   </IRQ>

The rmem charge that dev_scratch accounted for is released by skb_recv_udp() on
dequeue, just above, so the scratch is dead by the time recv_actor() runs. Clear
skb->dev so bpf_skc_lookup() falls back to sock_net(skb->sk), which
skb_set_owner_sk_safe() set just above.

Fixes: 965b57b469a5 ("net: Introduce a new proto_ops ->read_skb()")
Cc: stable@vger.kernel.org
Signed-off-by: Sechang Lim <rhkrqnwk98@gmail.com>
Reviewed-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260603162737.697215-1-rhkrqnwk98@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/udp.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/ipv4/udp.c
+++ b/net/ipv4/udp.c
@@ -1801,6 +1801,14 @@ try_again:
 	}
 
 	WARN_ON_ONCE(!skb_set_owner_sk_safe(skb, sk));
+
+	/*
+	 * skb->dev still aliases the UDP rx dev_scratch (its charge was freed
+	 * on dequeue above); a sockmap verdict program may deref it via
+	 * bpf_sk_lookup_*(), so clear it -> bpf_skc_lookup() uses skb->sk
+	 */
+	skb->dev = NULL;
+
 	return recv_actor(sk, skb);
 }
 EXPORT_SYMBOL(udp_read_skb);


