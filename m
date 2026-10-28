Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208576;
	b=Vz21KIv4C6thmzzhnBo6lQW/pLxHPjDs98d93JcR3O0hrtRjCVu695t4KA9vZJVLpkSO
	 +3dTP1GTT/9Oblq2zZqexyRCasuymIR1i9MkGyAFX8r7BEforaofpKFkP4andPIbefzqK
	 tpdcd+w3OuQS9FDyahCZId+cMpYFb+IC4jeNuD8HS5XiZrZS86/v6W/68bcpEACJTuA80
	 VbewF4cqpUK9VecwMqqKx3Fjvz1T5/iZjdE4zj3ler+qS+OJ3/ieVlJc6GRs+qebm7xeH
	 z2W9v3QanQol4bmo0khNFfwgcPn0AU5wJ57YwAc1V1YE43H1aYtsLBH9M1xdr1bAewA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ovXbXO8xf0uJnja2kRGAr62ZSFatvaKludujVnDXCrU=;
	b=Hdnt9uASkN/NXMqOOpeIr+ezLIPFoTigNM3TvWfXAi0kDw2z3HFW8BSuWllR6iw/RTQI
	 Ab7q2Io8eGEqb0sjH115Oc6ej6fRdEIw/4LPEqqcRk94LFJ+TkEvjTEF1ByvLHlUolm5P
	 ASoNLKC3MVDYGXxTJjBf3e/RyETC+My/Flsv/qqylYi6M8QI76bHwDYlqEcTtoJFSQe9E
	 /FfrHV8b2+AYp9udRLdPGXf0EMB4mGrQJPdDXeGLebM611Wwt76H5oEJ4T0S8Zm35IQ/C
	 kOB8WlJowQrGORY8E/ZWay5iR68Ly9D3voDwz7A+Z8J0dVZ2dKd7VVvs5AeJtQfeVgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cgkvn1fp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FF8B606A31A;
	Wed, 28 Oct 2026 17:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Cgkvn1fp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C23881F01825;
	Wed, 28 Oct 2026 17:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208576;
	bh=ovXbXO8xf0uJnja2kRGAr62ZSFatvaKludujVnDXCrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cgkvn1fp9AWsshkUHTiWVN/+Oa+9ZNOZQEMWUE+8+FBnONmG2nWYLSkfhUS+/cG0W
	 RbGg21hpbGOUGuB+40DkGRb5iM9Z2P9i6TkDvMk7Lw0w50ytrx3UEf5kQURaKdDeeh
	 meefJwc0DmNEm66TWlMUcSXoL/Cyr4QdV5M/A/PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 168/516] tipc: prevent GCM nonce reuse on peer key changes
Date: Wed, 28 Oct 2026 17:55:20 +0100
Message-ID: <20261028170007.486519328@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 512ccd3d0e91e791fb37442aa0a2599aca19783d ]

TIPC can encrypt traffic between nodes using a different transmit key
for each node. In this mode, the AES-GCM nonce for a packet sent to a
known peer consists of a 32-bit prefix (a per-key salt XOR the peer's
address) followed by a 64-bit counter. That counter is stored in the
peer's RX crypto object. When the peer reports a change in which key
it uses to receive packets, TIPC resets this counter. The sender can
still be using the same TX key and salt, so subsequent packets reuse
earlier nonces. This nonce reuse breaks confidentiality and exposes
GCM's authentication key. This makes forgeries trivial: an attacker
can exploit CTR malleability to alter captured ciphertexts and use the
recovered authentication key to compute a valid tag for the modified
ciphertext, under the same key and nonce.

Use the TX key's existing aead->seqno counter instead. All encryptions
using that key object share the same atomic counter, so concurrent
encryptions get distinct nonce counter values. The counter survives
key activation and peer reconnection, and peer key-status reports
cannot reset it. This prevents those transitions from causing nonce
reuse while the same TX key remains installed.

The nonce format is unchanged, and receivers do not require consecutive
counter values, so sharing the counter across peers remains compatible
with existing receivers. A pre-existing check still invokes key
revocation in the unlikely event that the counter wraps to zero.

Fixes: fc1b6d6de220 ("tipc: introduce TIPC encryption & authentication")
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Reviewed-by: Tung Nguyen <tung.quang.nguyen@est.tech>
Link: https://patch.msgid.link/20260924202105.3722778-1-Jeremy.Jean@oss.cyber.gouv.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/crypto.c | 20 +++++---------------
 1 file changed, 5 insertions(+), 15 deletions(-)

diff --git a/net/tipc/crypto.c b/net/tipc/crypto.c
index 95ed278b9fb87..9031bb067ae00 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -142,7 +142,7 @@ struct tipc_tfm {
  * @rcu: struct rcu_head
  * @key: the aead key
  * @gen: the key's generation
- * @seqno: the key seqno (cluster scope)
+ * @seqno: the per-key TX nonce counter
  * @refcnt: the key reference counter
  */
 struct tipc_aead {
@@ -187,7 +187,6 @@ struct tipc_crypto_stats {
  * @rekeying_intv: rekeying interval (in minutes)
  * @stats: the crypto statistics
  * @name: the crypto name
- * @sndnxt: the per-peer sndnxt (TX)
  * @timer1: general timer 1 (jiffies)
  * @timer2: general timer 2 (jiffies)
  * @working: the crypto is working or not
@@ -215,7 +214,6 @@ struct tipc_crypto {
 	struct tipc_crypto_stats __percpu *stats;
 	char name[48];
 
-	atomic64_t sndnxt ____cacheline_aligned;
 	unsigned long timer1;
 	unsigned long timer2;
 	union {
@@ -1064,14 +1062,11 @@ static int tipc_ehdr_build(struct net *net, struct tipc_aead *aead,
 	WARN_ON(skb_headroom(skb) < ehsz);
 	ehdr = (struct tipc_ehdr *)skb_push(skb, ehsz);
 
-	/* Obtain a seqno first:
-	 * Use the key seqno (= cluster wise) if dest is unknown or we're in
-	 * cluster key mode, otherwise it's better for a per-peer seqno!
+	/*
+	 * Keep the nonce unique for the lifetime of the TX key,
+	 * including key state changes and peer reconnection.
 	 */
-	if (!__rx || aead->mode == CLUSTER_KEY)
-		seqno = atomic64_inc_return(&aead->seqno);
-	else
-		seqno = atomic64_inc_return(&__rx->sndnxt);
+	seqno = atomic64_inc_return(&aead->seqno);
 
 	/* Revoke the key if seqno is wrapped around */
 	if (unlikely(!seqno))
@@ -1250,7 +1245,6 @@ void tipc_crypto_key_flush(struct tipc_crypto *c)
 	tipc_crypto_key_set_state(c, 0, 0, 0);
 	for (k = KEY_MIN; k <= KEY_MAX; k++)
 		tipc_crypto_key_detach(c->aead[k], &c->lock);
-	atomic64_set(&c->sndnxt, 0);
 	spin_unlock_bh(&c->lock);
 }
 
@@ -1397,8 +1391,6 @@ static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
  * It also considers if peer has no key, then we need to make own master key
  * (if any) taking over i.e. starting grace period and also trigger key
  * distributing process.
- *
- * The "per-peer" sndnxt is also reset when the peer key has switched.
  */
 static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb)
 {
@@ -1449,7 +1441,6 @@ static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb)
 		if (cur)
 			tipc_aead_users_dec(tx->aead[cur], 0);
 
-		atomic64_set(&rx->sndnxt, 0);
 		/* Mark the point TX key users changed */
 		tx->timer1 = jiffies;
 
@@ -1514,7 +1505,6 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	tipc_crypto_key_set_state(c, 0, 0, 0);
 	atomic_set(&c->key_distr, 0);
 	atomic_set(&c->peer_rx_active, 0);
-	atomic64_set(&c->sndnxt, 0);
 	c->timer1 = jiffies;
 	c->timer2 = jiffies;
 	c->rekeying_intv = TIPC_REKEYING_INTV_DEF;
-- 
2.53.0



