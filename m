Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107B02BE037;
	Mon, 27 Oct 2025 19:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593216; cv=none; b=S9X2ewwe5um3NCF4Fl9tamppU/Q1BDjknhHF9kx34E1L7IFRM4mdzeh82YYygBW0Xl6R7sYysuim5jlctVslaxLrjgM1NL774r4HONad7xtLA0iWGgVbdmW8pscL41VAEUTsZ5MEjpsNMDoRJTEfF1ieCjVzdFMWTPpzyLsbPG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593216; c=relaxed/simple;
	bh=4mW79P0JqVxhGfGpf4Pq/moKTBVTPGWexmw5C0vB+u4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zf5X7b2lKihydEs/m1d7lgY/KG+4fN22ZxyN0ht7gcGaptTwyGFLrHIdOBt5lVDAbFBvNHAyZ5FiLvcYcsA70i+6Bf+mDS1UU0OqA1Om06hlW53nPZ9EY9AqJm9zQ2fJ4ULqLnaOF2fbg97HW0laFDjfUQk52C6dGlNdvpDsAkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ILhUSzHJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ILhUSzHJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96B16C4CEF1;
	Mon, 27 Oct 2025 19:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593215;
	bh=4mW79P0JqVxhGfGpf4Pq/moKTBVTPGWexmw5C0vB+u4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ILhUSzHJmCRUoTS/tY+iuBnv6sMTFCRDM5Ri1qFOWZX94N7aDoTucCsN7sOAhiScH
	 MtBWkuq3+ttT1DfCi/mnLtDY8n9+232aJLmYqvElMisobDxyktBd/LloqRkNoLOG2A
	 mqgIUL5qQaYP8Sa5x4BfSyqKP4p6h41huNJx8YFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Antonio Quartulli <antonio@openvpn.net>,
	Ralf Lici <ralf@mandelbit.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 057/184] net: datagram: introduce datagram_poll_queue for custom receive queues
Date: Mon, 27 Oct 2025 19:35:39 +0100
Message-ID: <20251027183516.434301844@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ralf Lici <ralf@mandelbit.com>

[ Upstream commit f6ceec6434b5efff62cecbaa2ff74fc29b96c0c6 ]

Some protocols using TCP encapsulation (e.g., espintcp, openvpn) deliver
userspace-bound packets through a custom skb queue rather than the
standard sk_receive_queue.

Introduce datagram_poll_queue that accepts an explicit receive queue,
and convert datagram_poll into a wrapper around datagram_poll_queue.
This allows protocols with custom skb queues to reuse the core polling
logic without relying on sk_receive_queue.

Cc: Sabrina Dubroca <sd@queasysnail.net>
Cc: Antonio Quartulli <antonio@openvpn.net>
Signed-off-by: Ralf Lici <ralf@mandelbit.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Antonio Quartulli <antonio@openvpn.net>
Link: https://patch.msgid.link/20251021100942.195010-2-ralf@mandelbit.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: efd729408bc7 ("ovpn: use datagram_poll_queue for socket readiness in TCP")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h |  3 +++
 net/core/datagram.c    | 44 ++++++++++++++++++++++++++++++++----------
 2 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index fa633657e4c06..ad66110b43cca 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -4157,6 +4157,9 @@ struct sk_buff *__skb_recv_datagram(struct sock *sk,
 				    struct sk_buff_head *sk_queue,
 				    unsigned int flags, int *off, int *err);
 struct sk_buff *skb_recv_datagram(struct sock *sk, unsigned int flags, int *err);
+__poll_t datagram_poll_queue(struct file *file, struct socket *sock,
+			     struct poll_table_struct *wait,
+			     struct sk_buff_head *rcv_queue);
 __poll_t datagram_poll(struct file *file, struct socket *sock,
 			   struct poll_table_struct *wait);
 int skb_copy_datagram_iter(const struct sk_buff *from, int offset,
diff --git a/net/core/datagram.c b/net/core/datagram.c
index f474b9b120f98..8b328879f8d25 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -920,21 +920,22 @@ int skb_copy_and_csum_datagram_msg(struct sk_buff *skb,
 EXPORT_SYMBOL(skb_copy_and_csum_datagram_msg);
 
 /**
- * 	datagram_poll - generic datagram poll
+ *	datagram_poll_queue - same as datagram_poll, but on a specific receive
+ *		queue
  *	@file: file struct
  *	@sock: socket
  *	@wait: poll table
+ *	@rcv_queue: receive queue to poll
  *
- *	Datagram poll: Again totally generic. This also handles
- *	sequenced packet sockets providing the socket receive queue
- *	is only ever holding data ready to receive.
+ *	Performs polling on the given receive queue, handling shutdown, error,
+ *	and connection state. This is useful for protocols that deliver
+ *	userspace-bound packets through a custom queue instead of
+ *	sk->sk_receive_queue.
  *
- *	Note: when you *don't* use this routine for this protocol,
- *	and you use a different write policy from sock_writeable()
- *	then please supply your own write_space callback.
+ *	Return: poll bitmask indicating the socket's current state
  */
-__poll_t datagram_poll(struct file *file, struct socket *sock,
-			   poll_table *wait)
+__poll_t datagram_poll_queue(struct file *file, struct socket *sock,
+			     poll_table *wait, struct sk_buff_head *rcv_queue)
 {
 	struct sock *sk = sock->sk;
 	__poll_t mask;
@@ -956,7 +957,7 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
 		mask |= EPOLLHUP;
 
 	/* readable? */
-	if (!skb_queue_empty_lockless(&sk->sk_receive_queue))
+	if (!skb_queue_empty_lockless(rcv_queue))
 		mask |= EPOLLIN | EPOLLRDNORM;
 
 	/* Connection-based need to check for termination and startup */
@@ -978,4 +979,27 @@ __poll_t datagram_poll(struct file *file, struct socket *sock,
 
 	return mask;
 }
+EXPORT_SYMBOL(datagram_poll_queue);
+
+/**
+ *	datagram_poll - generic datagram poll
+ *	@file: file struct
+ *	@sock: socket
+ *	@wait: poll table
+ *
+ *	Datagram poll: Again totally generic. This also handles
+ *	sequenced packet sockets providing the socket receive queue
+ *	is only ever holding data ready to receive.
+ *
+ *	Note: when you *don't* use this routine for this protocol,
+ *	and you use a different write policy from sock_writeable()
+ *	then please supply your own write_space callback.
+ *
+ *	Return: poll bitmask indicating the socket's current state
+ */
+__poll_t datagram_poll(struct file *file, struct socket *sock, poll_table *wait)
+{
+	return datagram_poll_queue(file, sock, wait,
+				   &sock->sk->sk_receive_queue);
+}
 EXPORT_SYMBOL(datagram_poll);
-- 
2.51.0



