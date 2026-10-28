Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211277;
	b=PncYM/PCOR2bO1AO96JMhRsIJIfgYn7PpulRTunO7G7XUpVEVtC90FsLv3BolXKAUVDX
	 uzlL+Eno/n7al6vIjLuKvK+vTW5YbF+F0pSK26LiL1PoBA+9IyXpLhiZ3Q5Bx9TEDTp+n
	 b6mXpDN1PRnQFKa6FlbzQ9AmkWEed2IwxoaV8w+RyvfcItVBlgUjgYeP6+blR1szot28R
	 7SYeC+OR5yFwhKfKgqnHfpHoWxemBJm8sKykKtm+dPImTHngzlZ9+pPjalAd9k5JWGyNx
	 ZstFLOKpixVbpSv1aAx/q6s2QDja25Y0maJjwpkLVKA7MKK7qvbk5v43h6N8m7NAY8w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211277;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GEYQ+SFgG8OqA+d0OygusuYrZ13mlcQxiJv+Tel0kkY=;
	b=nd99notMe0V57SwRwfQAEbouFHiFAIwJDDiV0WY6wiSktdmdrWYKlDNVdTa9sJbUuzys
	 OgyJKsZT8GvfW/DyygxNQVo48kgEVBBfsCcWhDdcbzFTJu8wERomif1rp4KRLdTPh6BFM
	 ttDM9jNgmzVgCRi4Oc9FChC/bKHnuvQD619k9Msea313jLCvD6bzeYmyM74AaLBiZ5QvV
	 Ar0E67POi93EMDQWMJDHNvOOVIreTQJf/+cDX8IA2KgzloMfO8IFRkk8xq4GSn0qds73m
	 g1hqefGF6ZNhbDz3rbZqHyTSnsdcdepC/97bV95AeYlRHuC6rx5SEZfaiJJYK4FMvOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kD+59mTk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 747EA60A2616;
	Wed, 28 Oct 2026 18:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kD+59mTk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B127A1F01828;
	Wed, 28 Oct 2026 18:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211277;
	bh=GEYQ+SFgG8OqA+d0OygusuYrZ13mlcQxiJv+Tel0kkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kD+59mTkAtU9lLmmPH03EZI1qx4CQnwc/6PKqkjP82OPZfFPIUVHy+N1kx1Sl9uM1
	 VaFasJteY7ZmLPq3bnFqQ9EKSmDbUUE6sqlMC2KGN24KJKSK1FSfaVEtW1Cd5Y/UKk
	 kx7Rh/5eRMQRYRJa1VElyv1sGzdLqsYtVRsrGkn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Artem Novikov <naa@amicon.ru>,
	Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.15 277/571] vxlan: Fix potential null-ptr-deref in vxlan_gro_prepare_receive().
Date: Wed, 28 Oct 2026 17:57:04 +0100
Message-ID: <20261028170014.576164118@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

commit 30a45c0bffdd62350261e2f2689fdba426a33578 upstream.

udp_tunnel_sock_release() could set sk->sk_user_data to NULL
while vxlan_gro_prepare_receive() is running.

Let's check if rcu_dereference_sk_user_data() is NULL after
skb_gro_remcsum_init().

Fixes: 5602c48cf875 ("vxlan: change vxlan to use UDP socket GRO")
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260502031401.3557229-7-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ Artem Novikov: Apply the check to the older vxlan_gro_receive()
  implementation. Initialize the remcsum state first and use the
  existing out path for cleanup when sk_user_data has been cleared. ]
Signed-off-by: Artem Novikov <naa@amicon.ru>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_core.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/net/vxlan/vxlan_core.c
+++ b/drivers/net/vxlan/vxlan_core.c
@@ -791,12 +791,16 @@ static struct sk_buff *vxlan_gro_receive
 	struct vxlanhdr *vh, *vh2;
 	unsigned int hlen, off_vx;
 	int flush = 1;
-	struct vxlan_sock *vs = rcu_dereference_sk_user_data(sk);
+	struct vxlan_sock *vs;
 	__be32 flags;
 	struct gro_remcsum grc;
 
 	skb_gro_remcsum_init(&grc);
 
+	vs = rcu_dereference_sk_user_data(sk);
+	if (!vs)
+		goto out;
+
 	off_vx = skb_gro_offset(skb);
 	hlen = off_vx + sizeof(*vh);
 	vh   = skb_gro_header_fast(skb, off_vx);


