Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4D155C330;
	Mon, 31 Aug 2026 13:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184030; cv=none; b=OO564oPKotEFvdvfyJCcCm5U/QA+KBlXuf8MSUWmoiKrMl0v1wGKd99iplb370rHcIaHGwKHGL1EZTRf5XgqQC0Myrt1HoYnxIMV6xSQ56myWelPUqBgUwc0nhl2a1biDQqu/14XPs06Lm0xK53c7A3eyglDs473dNodoWFnGGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184030; c=relaxed/simple;
	bh=wQhRp6y57M7HMp45upApe4YBrQm6toxAhCb3B2+Ehgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lpN2p75jFIoe5Z5nxJIogEILJVTS0E2D8OS09lWwcZrehMrRPIrj7+dXb62xWb42iikTYxWvweWsxGMhT/eQDKnj/jcaLGCAPzPtMcAD3XkDVPx4vskvQjiLASSD499/OyJskaba9uqldS9o4Qsn6qW5Odo4niUQ0kS2cG9Kg1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N86M+nOF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N86M+nOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813161F00A3E;
	Mon, 31 Aug 2026 13:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184028;
	bh=HREz0YbvPy5qjJDgH+H6fbN0w6Y1y3Yq6PCqz47ShyM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N86M+nOFTpVYIa/tRbKvIiyf8L98Ll3/ODrpxXz8MYna//jSJpoox7MkAJ8OXJQ4N
	 cVwDq/uWy7ng38ioOcy7lXL6ovxBY19Jma6dgx7nXCEh6g81yMiYC543f34vF5qQEh
	 R2uXmsNRRfZlMNLQnbkuhZELvMX4LyACBy71+H9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 49/83] tcp: fix AO info use-after-free in tcp_ao_connect_init()
Date: Mon, 31 Aug 2026 15:34:25 +0200
Message-ID: <20260831133402.006920342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.207714926@linuxfoundation.org>
References: <20260831133359.207714926@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qing Ming <a0yami@mailbox.org>

commit ea30dc5267e367b8a5e1e06cc074f813bcbf18b2 upstream.

tcp_v4_connect() adds a SYN-SENT socket to the ehash before calling
tcp_connect().  If TCP-AO is configured, tcp_connect() first verifies that
a key matches the peer and the bound device's current L3 master.
tcp_ao_connect_init() later resolves the L3 master again and removes keys
which do not match it.

The socket lock does not stabilize the bound device's VRF membership.
Detaching the device from its VRF between the initial validation and the
L3-master calculation in tcp_ao_connect_init() can therefore make the
validation succeed while initialization observes the default L3 domain and
removes the only key.  The subsequent AO lookup then fails, so the no-key
path clears tp->ao_info and frees it directly.

The receive path can find the socket in the ehash and load tp->ao_info
under RCU before acquiring the socket lock.  A reader which loaded the old
pointer can thus continue into tcp_inbound_ao_hash() after the direct free.

The issue was found during a static audit of TCP-AO object lifetime.  An
unprivileged reproducer in self-created user and network namespaces raced
connect() with detaching a veth from its VRF while sending TCP-AO segments.
It triggered the same KASAN report on two fresh boots:

  BUG: KASAN: slab-use-after-free in tcp_inbound_ao_hash+0x585/0x19f0
  Write of size 8 at addr ffff88800bf88128 by task tcp_ao_vrf_race/232

  Call Trace:
   tcp_inbound_ao_hash+0x585/0x19f0
   tcp_inbound_hash+0x677/0xa80
   tcp_v4_rcv+0x1c3e/0x3ab0

  Allocated by task 235:
   tcp_ao_alloc_info+0x43/0xf0
   tcp_ao_add_cmd+0xdf7/0x13b0
   do_tcp_setsockopt+0x168c/0x2640

  Freed by task 235:
   kfree+0x1b8/0x550
   tcp_connect+0x252/0x4f00
   tcp_v4_connect+0x1114/0x1720

The bad address is 40 bytes inside the freed 128-byte object, matching the
tcp_ao_info counters.key_not_found field.  The two runs used 1000 attempts
each, reached the no-key path 366 and 411 times, and produced one and two
KASAN reports respectively.  With this change, the same reproducer reached
the no-key path 366 times in 1000 attempts without a KASAN report or oops.

Use tcp_ao_destroy_sock() for the no-key path.  It unpublishes the AO info,
updates the socket memory and static-key accounting, and defers the free
until after an RCU grace period.

Also drop the WARN_ON_ONCE() and its stale comment.  The VRF detach race
makes the no-key state reachable during normal operation, so it is a
handled condition rather than an impossible assertion.  On panic_on_warn
kernels the WARN would turn this handled race into a kernel panic.

Fixes: 248411b8cb89 ("net/tcp: Wire up l3index to TCP-AO")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5
Signed-off-by: Qing Ming <a0yami@mailbox.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20260825072033.6921-1-a0yami@mailbox.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ao.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

--- a/net/ipv4/tcp_ao.c
+++ b/net/ipv4/tcp_ao.c
@@ -1147,12 +1147,7 @@ void tcp_ao_connect_init(struct sock *sk
 		ao_info->lisn = htonl(tp->write_seq);
 		ao_info->snd_sne = 0;
 	} else {
-		/* Can't happen: tcp_connect() verifies that there's
-		 * at least one tcp-ao key that matches the remote peer.
-		 */
-		WARN_ON_ONCE(1);
-		rcu_assign_pointer(tp->ao_info, NULL);
-		kfree(ao_info);
+		tcp_ao_destroy_sock(sk, false);
 	}
 }
 


