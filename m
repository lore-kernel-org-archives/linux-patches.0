Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774193;
	b=hniLDT1f/4IvYG76f9QySPkFT7n4HJ6ZTGmvNY8SZv0ldd2NFsUUPYQHvanUHri6aOfn
	 Y3TTxhViXOewgHdW62zyzTMmWwTK2f/d6fU+ecJdOPaIKp0pwvrKygLM7j4hDf38XO93P
	 7B5gFfgwndi9e4UQw2gxk6cUQE3E/0RfWNeP4jt+KMsL70DI8oMaUr0/VtQd8su8SkM+a
	 zbQMFpOX+p2m2tq5a9AvhewXZLdyTte1Qu0SyBcAh5atIZUPL4cTpDH5JoVKDpT/KAWwO
	 2fCit4e/U5N/Xitq5qs63Lrtw9goQEcQQXvWiLEzQm050kb841HyVENcjv4CJnutmqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774193;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ghqUK07MpGnt6bhDAnCrM/qT2yKQa+7n0pvHZmO+Lmc=;
	b=Aqm7J3V5RN93CWPFVnZHIs0FJ/rt8fcahGv2IXw3QFfiYEGdRBLI/YVkWwO0hd83996/
	 RZB1nrTidLS9H8S+IkCI87KKZqsUAhvUJJBau62Px+3gisNIV5TvfiUT+3a1dpXr7SwiG
	 I31L0z3gTlvhtE8hY8YKq9xsFoPsidXZHCXXYi5al59GhGI1ty8UO+uuzreK6d2PPTo2h
	 14FeFJyV4qGEhWPo/qJe8ZR2TSoaB3Ta3VLmpwFjSmFgwkXfBBArx/CilQYmxWoqWZVbS
	 CsvMpZuZQRF7kBK735LBMKaqo1XdTeoJQ9qZ7iilUIYRvMo2FRoQyNcmP3TS+no/Z0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="z+htw/6J";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0034560A260E;
	Fri, 23 Oct 2026 16:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+htw/6J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CD641F01825;
	Fri, 23 Oct 2026 16:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774192;
	bh=ghqUK07MpGnt6bhDAnCrM/qT2yKQa+7n0pvHZmO+Lmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+htw/6JmDCP630+b8Sb+QIsxmqMdFqE5YscgWD8dS5PS1FpmOiHFUSiWD2OSmRMV
	 IH5lmzATwsbIynZZi9ZQV7dkZpE+eKjM1KFEabSD3wxvocDgkZxmMQhJBm2z+w4SCd
	 IJibgPjAdTi6ID/KxDrewRpVeXA0LMIBEDKBJGqg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Norbert Szetei <norbert@doyensec.com>,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 153/193] net: psp: do not inherit the Rx association on clone
Date: Fri, 23 Oct 2026 18:37:10 +0200
Message-ID: <20261023163717.831024022@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

From: Norbert Szetei <norbert@doyensec.com>

commit 1d2929d0850fff683b8aff051275945e65f082c8 upstream.

sk->psp_assoc sits past sk_dontcopy_end, so sock_copy() copies it into
every socket accepted from a listener without taking a reference, while
inet_sock_destruct() puts for every inet socket. psp_twsk_init() does
refcount_inc() for the timewait socket, so a child closing through
TIME_WAIT cancels its own put and leaves the association with one
reference and N timewait sockets holding the same pointer. Closing the
listener frees it, and the timewait timers then put freed memory.

Rejecting the association on a listening socket is not sufficient: a socket
can acquire one while established and then be turned back into a listener,
because tcp_disconnect() leaves sk->psp_assoc in place.

  BUG: KASAN: slab-use-after-free in psp_twsk_assoc_free+0x6f/0xf0
  Write of size 4 at addr ffff888110f9255c by task swapper/7/0
   psp_twsk_assoc_free+0x6f/0xf0
   inet_twsk_put+0xda/0x1b0
   call_timer_fn+0x53/0x2e0
   __run_timers+0x764/0xa80
  Freed by task 99:
   kfree+0x1a7/0x500
   process_one_work+0x7ec/0x1100

An association carries a per-connection SPI and key, so a child must not
inherit the parent's. Clear it on clone.

Fixes: 6b46ca260e22 ("net: psp: add socket security association code")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: Norbert Szetei <norbert@doyensec.com>
Reviewed-by: Daniel Zahka <daniel.zahka@gmail.com>
Link: https://patch.msgid.link/BC10EB92-ABB3-41B2-AB16-266BEEBE18C0@doyensec.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/sock.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -2471,6 +2471,9 @@ struct sock *sk_clone_lock(const struct
 #ifdef CONFIG_BPF_SYSCALL
 	RCU_INIT_POINTER(newsk->sk_bpf_storage, NULL);
 #endif
+#if IS_ENABLED(CONFIG_INET_PSP)
+	RCU_INIT_POINTER(newsk->psp_assoc, NULL);
+#endif
 
 	/* SANITY */
 	if (likely(newsk->sk_net_refcnt)) {


