Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5E13563FB;
	Sat, 17 Oct 2026 16:59:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256368; cv=none; b=gnK6Kzt3DanodHiHAClRYYU/AtYaWB8y664nZuyATuF17zPPYeGOrQT7XDWMAaBcZf24kBrDl8KrOw4M0SQp+AU3LFHBFhd4cXxZrlORiJNt+c89o9nDj9WhLWx3Myj6KEVf+lUSuTMhpWxlKDXjFx7bKyFQvPUfSfz9S/ziX6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256368; c=relaxed/simple;
	bh=t+pa1B7DT1zF9Cr0ggGBpZsz8DtQnDTcu75VK/gjnfg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ak86UaTdcoISWXQQJjm81ukYQQCm3SmCI1Yiw+Ma6tZCNmogTjNcO+CRkOEeu8U7MxM1sDM3gYKG6jC7H+2KdiMvDMBlLk5+wnj0U+5c+wJwYCukr2/KXmFNJkLhcAq1xMXobWuXTizInQoTIJivKDsg4CilFsB9nVFsNTCNkBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vK4KXYUH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vK4KXYUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF6611F000C4;
	Sat, 17 Oct 2026 16:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256367;
	bh=lcRzTUj1c26LqfYzeatiSciC/oRVQSKqAh7aMaiS0BU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vK4KXYUHnpjU8mz82/oe/Lr9Vv4ft/GrhnpnaeBhXkySI8Q99E1QANJrguLGHc1Zv
	 aEhj/BinfxhJk8h5tRPUJswaU3/ZdRpx/H7CWDyCt1MZjeA/SPt1+dxxHywD/bozen
	 VQLm22/gUE90aipk785akfvZLWN3X3bkBMFUWZfU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Tung Nguyen <tung.quang.nguyen@est.tech>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0214/1674] tipc: prevent GCM nonce reuse on peer key changes
Date: Sat, 17 Oct 2026 17:41:26 +0200
Message-ID: <20261017160436.642064580@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index d58db40d6c036..9c3ef67eb5f41 100644
--- a/net/tipc/crypto.c
+++ b/net/tipc/crypto.c
@@ -144,7 +144,7 @@ struct tipc_tfm {
  * @rcu: struct rcu_head
  * @key: the aead key
  * @gen: the key's generation
- * @seqno: the key seqno (cluster scope)
+ * @seqno: the per-key TX nonce counter
  * @refcnt: the key reference counter
  */
 struct tipc_aead {
@@ -190,7 +190,6 @@ struct tipc_crypto_stats {
  * @rekeying_intv: rekeying interval (in minutes)
  * @stats: the crypto statistics
  * @name: the crypto name
- * @sndnxt: the per-peer sndnxt (TX)
  * @timer1: general timer 1 (jiffies)
  * @timer2: general timer 2 (jiffies)
  * @working: the crypto is working or not
@@ -219,7 +218,6 @@ struct tipc_crypto {
 	struct tipc_crypto_stats __percpu *stats;
 	char name[48];
 
-	atomic64_t sndnxt ____cacheline_aligned;
 	unsigned long timer1;
 	unsigned long timer2;
 	union {
@@ -1060,14 +1058,11 @@ static int tipc_ehdr_build(struct net *net, struct tipc_aead *aead,
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
@@ -1246,7 +1241,6 @@ void tipc_crypto_key_flush(struct tipc_crypto *c)
 	tipc_crypto_key_set_state(c, 0, 0, 0);
 	for (k = KEY_MIN; k <= KEY_MAX; k++)
 		tipc_crypto_key_detach(c->aead[k], &c->lock);
-	atomic64_set(&c->sndnxt, 0);
 	spin_unlock_bh(&c->lock);
 }
 
@@ -1393,8 +1387,6 @@ static struct tipc_aead *tipc_crypto_key_pick_tx(struct tipc_crypto *tx,
  * It also considers if peer has no key, then we need to make own master key
  * (if any) taking over i.e. starting grace period and also trigger key
  * distributing process.
- *
- * The "per-peer" sndnxt is also reset when the peer key has switched.
  */
 static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb)
 {
@@ -1445,7 +1437,6 @@ static void tipc_crypto_key_synch(struct tipc_crypto *rx, struct sk_buff *skb)
 		if (cur)
 			tipc_aead_users_dec(tx->aead[cur], 0);
 
-		atomic64_set(&rx->sndnxt, 0);
 		/* Mark the point TX key users changed */
 		tx->timer1 = jiffies;
 
@@ -1510,7 +1501,6 @@ int tipc_crypto_start(struct tipc_crypto **crypto, struct net *net,
 	tipc_crypto_key_set_state(c, 0, 0, 0);
 	atomic_set(&c->key_distr, 0);
 	atomic_set(&c->peer_rx_active, 0);
-	atomic64_set(&c->sndnxt, 0);
 	c->timer1 = jiffies;
 	c->timer2 = jiffies;
 	c->rekeying_intv = TIPC_REKEYING_INTV_DEF;
-- 
2.53.0



