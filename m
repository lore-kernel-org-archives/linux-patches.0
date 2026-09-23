Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3E1E5383FA;
	Wed, 23 Sep 2026 14:44:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174642; cv=none; b=gUP0rvIQPTkWDSG4Un8rHNLg5eiUEKQhus52Ts/oaYLqs9qW85Tueclv1ufperCvBqGuJMwWAtYfXndfXnWuPxn60UKNBlcZuSSSpenqernKcaUJ8Tz8i3y5BhBtFcTYA8NU8cU5YwuhS9UkGvA9MNE1qif/pEF0+I2v79ZAxOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174642; c=relaxed/simple;
	bh=7suGsd1dpQ2MQGcguBzd+iP1Gp2tmH+q0P2UnAZaXoU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGnBhGG+iU01qP1XHgCeKga6Fk3TLsOiL47UJeyQnBvE7a01TN3xX29uR1Lh7/PDWl0kRI2tmB1Q58LpCmW6aXJoWZSQi0+u7+6MAPsquLxs1RIhdF8JWJPmQPlBz++oJFc4JsL9AiJLP9LLxRSNzu70s/0SkGoKabCY3dMgKGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VGz0HvkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGz0HvkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A1221F000FF;
	Wed, 23 Sep 2026 14:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174640;
	bh=ld+h2zJC7bDna7omz72R0lGzPqmw/ahCVpmxW5kEKxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VGz0HvkDoJgdpb/1dvlV5/K/qz5iSNQdnayqhuodth8D00Xxn6Vx768txmobMS6M/
	 S2QAdvD4WdcCKe+WJ6Z/6ET/0lVmRkC7TrqNL+wHalcjPRZbq+oa6gpX8Kv2rNXerf
	 2mRYH8jtn92d6haj8KGDg7twwlPncY3294ktJeK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Zahka <daniel.zahka@gmail.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 180/398] net: psp: avoid conflicts with skb->decrypted and sk_validate_xmit_skb()
Date: Wed, 23 Sep 2026 16:04:14 +0200
Message-ID: <20260923140648.097214500@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Daniel Zahka <daniel.zahka@gmail.com>

[ Upstream commit a41f24c612c3f5139a3143307eb85bbcf1bd4d07 ]

PSP conflicts with TLS ULP in its usage of both skb->decrypted and
sk->sk_validate_xmit_skb().

Make PSP mutually exclusive with TLS ULP, the only other user of either
of these. As other users of skb->decrypted come along, they can be added
to sk_has_decrypt_user(). It would make sense to also assert that
sk->sk_validate_xmit_skb() is also NULL in both of these setup paths for
similar future proofing, but the PSP listener/sk_clone() path is still
broken and it could be seen as a regression to not allow rx assoc to run
on a child of a listener socket with PSP tx assoc state.

Include all TCP ULPs in the sk_has_decrypt_user() check, even though TLS
is the only one that conflicts with PSP via the decrypted bit. This is
intentional because PSP was not designed to be used with ULPs. It is
best to close off surface area that may make bugs reachable, until
someone wishes to design and test an actual user of PSP with ULPs.

Fixes: 6b46ca260e22 ("net: psp: add socket security association code")
Signed-off-by: Daniel Zahka <daniel.zahka@gmail.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20260915-psp-ktls-fix-v2-1-0eedc3b148ec@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/sock.h | 2 ++
 net/core/sock.c    | 7 +++++++
 net/ipv4/tcp_ulp.c | 4 ++++
 net/psp/psp_sock.c | 4 ++++
 4 files changed, 17 insertions(+)

diff --git a/include/net/sock.h b/include/net/sock.h
index 9e13e1233e417..fb91d72a955dd 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -2260,6 +2260,8 @@ static inline void sk_gso_disable(struct sock *sk)
 	sk->sk_route_caps &= ~NETIF_F_GSO_MASK;
 }
 
+bool sk_has_decrypt_user(const struct sock *sk);
+
 static inline int skb_do_copy_data_nocache(struct sock *sk, struct sk_buff *skb,
 					   struct iov_iter *from, char *to,
 					   int copy, int offset)
diff --git a/net/core/sock.c b/net/core/sock.c
index a0288a3618193..0d5f167e6ce69 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -142,6 +142,7 @@
 
 #include <trace/events/sock.h>
 
+#include <net/psp.h>
 #include <net/tcp.h>
 #include <net/busy_poll.h>
 #include <net/phonet/phonet.h>
@@ -2635,6 +2636,12 @@ void sk_setup_caps(struct sock *sk, struct dst_entry *dst)
 }
 EXPORT_SYMBOL_GPL(sk_setup_caps);
 
+bool sk_has_decrypt_user(const struct sock *sk)
+{
+	return psp_sk_assoc(sk) ||
+	       (sk_is_inet(sk) && inet_csk_has_ulp(sk)); /* for tls */
+}
+
 /*
  *	Simple resource managers for sockets.
  */
diff --git a/net/ipv4/tcp_ulp.c b/net/ipv4/tcp_ulp.c
index 2aa442128630e..b58045df101e5 100644
--- a/net/ipv4/tcp_ulp.c
+++ b/net/ipv4/tcp_ulp.c
@@ -136,6 +136,10 @@ static int __tcp_set_ulp(struct sock *sk, const struct tcp_ulp_ops *ulp_ops)
 	if (icsk->icsk_ulp_ops)
 		goto out_err;
 
+	err = -EINVAL;
+	if (sk_has_decrypt_user(sk))
+		goto out_err;
+
 	if (sk->sk_socket)
 		clear_bit(SOCK_SUPPORT_ZC, &sk->sk_socket->flags);
 
diff --git a/net/psp/psp_sock.c b/net/psp/psp_sock.c
index a931d825d1cc4..0fcc60c92c329 100644
--- a/net/psp/psp_sock.c
+++ b/net/psp/psp_sock.c
@@ -143,6 +143,10 @@ int psp_sock_assoc_set_rx(struct sock *sk, struct psp_assoc *pas,
 		NL_SET_ERR_MSG(extack, "Socket already has PSP state");
 		err = -EBUSY;
 		goto exit_unlock;
+	} else if (sk_has_decrypt_user(sk)) {
+		NL_SET_ERR_MSG(extack, "Socket has incompatible state");
+		err = -EINVAL;
+		goto exit_unlock;
 	}
 
 	refcount_inc(&pas->refcnt);
-- 
2.53.0



