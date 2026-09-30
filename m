Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C08CC3D3CF4;
	Wed, 30 Sep 2026 19:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795653; cv=none; b=SkeoJazoVDh0yq/ieZYzyWPtCjR/o8rl+lPm+cJ/DBbM0D392Y2yLVHa5PIQeWFx/N9KofcUaSpmB+kP4hg2a0MxWm0ctexj3VtHCRjZeQURnVkxSMD0FCHdGGoZFpzO9j9R9VkP5LkkgFLJeENZ6590jzUqHLwYsggMWltZ50k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795653; c=relaxed/simple;
	bh=DSYBiYhx4/bAt1b1oD1kzufQfyi6hqlNN/4WjjK0E+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YoO/ET2b9jCOson4JGb2dNouYUsLdb7Ogdl8wDF4RmvPsqWixD66dzpj26qEQzJpsz98ZiefbFE7+PF5WEBhl2CRodAdIMrXf7qRxdd5RFU9k+C+BgO4ZCC3WQeDVNb8UEWJU7XwtUp4t5PcfXOUDwkz0HHEZRSRgeZlfrjOEIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ccuyv6et; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ccuyv6et"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B7841F000FF;
	Wed, 30 Sep 2026 19:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795651;
	bh=WoMG7a3yHWlZRfUoPUwgKlkRaKiQk8zcEwT6VIWH9VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ccuyv6etPzQ0im71j1tQ+SCLoxUjdlh0PVj3gDTUkTi1KuOCZQ9rZWYTRbRxM9yi5
	 S5K0XwmN0N+W5JM4P6emqAQH/94ndFQ3xXhz9/XwrYxFCyP3yJJY1HNyk3ZsMlzcZb
	 PTcKPYlQvoOYzS3i1ur1RsJm6qYMTAT2kmU1K1Zc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kimi Security Team <bug-report@moonshot.ai>,
	Weiming Shi <shiweiming@moonshot.ai>,
	Eric Dumazet <edumazet@google.com>,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 0636/1193] inet: frags: invalidate queues before flushing them
Date: Wed, 30 Sep 2026 17:22:00 +0200
Message-ID: <20260930152448.374597919@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Yilin Zhang <yilinzhang@moonshot.ai>

commit b824476c56a153934c67c9e0f873e1fd967743d6 upstream.

fqdir_pre_exit() flushes the skbs from incomplete queues without
changing their completion state. A fragment which found a queue before
high_thresh was cleared can then acquire the queue lock and reuse stale
reassembly metadata. A queue concurrently killed after fqdir->dead is
set can instead become INET_FRAG_COMPLETE|INET_FRAG_HASH_DEAD while
still holding its old skbs; skipping it because it is complete leaves
those references behind until asynchronous fqdir teardown.

For IPv6, stale metadata can make ip6_frag_reasm() use the old
nhoffset with a new skb and access memory out of bounds. The resulting
heap corruption can be leveraged for local privilege escalation when
unprivileged network namespaces are available. Unflushed fragments can
also keep conntrack references alive after the conntrack per-net
cleanup point.

Kill each incomplete queue, then flush every queue still owned by the
dying rhashtable. HASH_DEAD identifies that ownership, while complete
queues without it are already owned by another destroy path and must be
left alone. Releasing a timer reference removed by inet_frag_kill() is
deferred to inet_frag_putn(), after the queue lock is dropped.

KASAN report:

  BUG: KASAN: slab-out-of-bounds in ipv6_frag_rcv (net/ipv6/reassembly.c:289 (discriminator 2) net/ipv6/reassembly.c:229 (discriminator 2) net/ipv6/reassembly.c:391 (discriminator 2))
  Write of size 1 at addr ff110001039c6e00 by task poc/771
  Call Trace:
  ? ipv6_frag_rcv (net/ipv6/reassembly.c:289 (discriminator 2) net/ipv6/reassembly.c:229 (discriminator 2) net/ipv6/reassembly.c:391 (discriminator 2))
  ipv6_frag_rcv (net/ipv6/reassembly.c:289 (discriminator 2) net/ipv6/reassembly.c:229 (discriminator 2) net/ipv6/reassembly.c:391 (discriminator 2))
  ip6_protocol_deliver_rcu (net/ipv6/ip6_input.c:479 (discriminator 5))
  ip6_input_finish (net/ipv6/ip6_input.c:534)
  ipv6_rcv (include/net/dst.h:480 (discriminator 3) net/ipv6/ip6_input.c:119 (discriminator 3) net/ipv6/ip6_input.c:109 (discriminator 3) include/linux/netfilter.h:325 (discriminator 3) include/linux/netfilter.h:319 (discriminator 3) net/ipv6/ip6_input.c:351 (discriminator 3))
  packet_sendmsg (net/packet/af_packet.c:3110 net/packet/af_packet.c:3142)
  __x64_sys_sendmmsg (net/socket.c:2883 net/socket.c:2880 net/socket.c:2880)
  The buggy address belongs to the object at ff110001039c6b40
  which belongs to the cache skbuff_small_head of size 704
  The buggy address is located 0 bytes to the right of
  allocated 704-byte region [ff110001039c6b40, ff110001039c6e00)

  BUG: KASAN: slab-out-of-bounds in ip6_protocol_deliver_rcu (net/ipv6/ip6_input.c:423 (discriminator 1))
  Read of size 1 at addr ff110001039c6e08 by task poc/771
  Call Trace:
  ? ip6_protocol_deliver_rcu (net/ipv6/ip6_input.c:423 (discriminator 1))
  ip6_protocol_deliver_rcu (net/ipv6/ip6_input.c:423 (discriminator 1))
  ip6_input_finish (net/ipv6/ip6_input.c:534)
  ipv6_rcv (include/net/dst.h:480 (discriminator 3) net/ipv6/ip6_input.c:119 (discriminator 3) net/ipv6/ip6_input.c:109 (discriminator 3) include/linux/netfilter.h:325 (discriminator 3) include/linux/netfilter.h:319 (discriminator 3) net/ipv6/ip6_input.c:351 (discriminator 3))
  packet_sendmsg (net/packet/af_packet.c:3110 net/packet/af_packet.c:3142)
  __x64_sys_sendmmsg (net/socket.c:2883 net/socket.c:2880 net/socket.c:2880)
  packet_sendmsg (net/packet/af_packet.c:2959 net/packet/af_packet.c:3053 net/packet/af_packet.c:3142)
  __x64_sys_sendmmsg (net/socket.c:2883 net/socket.c:2880 net/socket.c:2880)
  The buggy address belongs to the object at ff110001039c6b40
  which belongs to the cache skbuff_small_head of size 704
  The buggy address is located 8 bytes to the right of
  allocated 704-byte region [ff110001039c6b40, ff110001039c6e00)

Fixes: 006a5035b495 ("inet: frags: flush pending skbs in fqdir_pre_exit()")
Cc: stable@vger.kernel.org
Reported-by: Kimi Security Team <bug-report@moonshot.ai>
Tested-by: Weiming Shi <shiweiming@moonshot.ai>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Yilin Zhang <yilinzhang@moonshot.ai>
Link: https://patch.msgid.link/20260904162800.1095662-1-yilinzhang@moonshot.ai
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/inet_fragment.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/ipv4/inet_fragment.c
+++ b/net/ipv4/inet_fragment.c
@@ -237,6 +237,8 @@ void fqdir_pre_exit(struct fqdir *fqdir)
 	rhashtable_walk_start(&hti);
 
 	while ((fq = rhashtable_walk_next(&hti))) {
+		int refs = 0;
+
 		if (IS_ERR(fq)) {
 			if (PTR_ERR(fq) != -EAGAIN)
 				break;
@@ -244,8 +246,12 @@ void fqdir_pre_exit(struct fqdir *fqdir)
 		}
 		spin_lock_bh(&fq->lock);
 		if (!(fq->flags & INET_FRAG_COMPLETE))
+			inet_frag_kill(fq, &refs);
+
+		if (fq->flags & INET_FRAG_HASH_DEAD)
 			inet_frag_queue_flush(fq, 0);
 		spin_unlock_bh(&fq->lock);
+		inet_frag_putn(fq, refs);
 	}
 
 	rhashtable_walk_stop(&hti);


