Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1E1D4DC557;
	Thu, 17 Sep 2026 15:52:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660353; cv=none; b=bQzg+ziK5MnYjNSbNTyd5X69JpQRZbVvjFlNoMALVJWe6zp25pQikiYk1FecSelDCuIBrbwXhK8lRRsIa38eI3lYzXSgKWNn9C0la+IwEYi6NFbOL1iMRNh7mxeiee6V54b6nFezw44P2vUwtH3ufKb/ZCk08qrxJUlhCSm7W3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660353; c=relaxed/simple;
	bh=gokXANcuOz9qJHUCX+anXonXv+o64yBw47pG0Cx5Jjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PO5Zn++8fWN6hSfdkLsfgIWGeAXJiS3PfLOt1NxOzbi3OE8DMnvuesurq2kDsfFhgpwwOP02AgN86rEpJMqeV1eU+Q8mfLHHNjpxQOyoVtrUJwWnKgzGRSLNDF00wM/OB8Dkn6FRS6vmRgHBfMHlpk3O5nggyZH08ISdIHJ0LsA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yev4xxzo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yev4xxzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD2261F000FF;
	Thu, 17 Sep 2026 15:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660351;
	bh=KgmULTd+lQxyuCSREIgQS3jtL0O1r8Y4k5Vwwt+21uQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Yev4xxzoP1Dy+MwQoxv37CdYYkpA0qjBWyC/c1dkPIMaA/EBpz2wRCxWReSD5cIC5
	 yAulphTZG74RF1BBs8CZgBzhd+yFikAiP+rk7h5kzCvA0JQeG8q152O0VPwaaXqTFZ
	 UwrVK0iJqnnv7GpGqs8U8FvRQRrChG9psdouFrSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kimi Security Team <bug-report@moonshot.ai>,
	Weiming Shi <shiweiming@moonshot.ai>,
	Eric Dumazet <edumazet@google.com>,
	Yilin Zhang <yilinzhang@moonshot.ai>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 563/733] inet: frags: invalidate queues before flushing them
Date: Thu, 17 Sep 2026 16:14:31 +0100
Message-ID: <20260917151406.349939819@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -235,6 +235,8 @@ void fqdir_pre_exit(struct fqdir *fqdir)
 	rhashtable_walk_start(&hti);
 
 	while ((fq = rhashtable_walk_next(&hti))) {
+		int refs = 0;
+
 		if (IS_ERR(fq)) {
 			if (PTR_ERR(fq) != -EAGAIN)
 				break;
@@ -242,8 +244,12 @@ void fqdir_pre_exit(struct fqdir *fqdir)
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


