Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27B8A1C6AB;
	Mon,  4 Mar 2024 21:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589226; cv=none; b=JyNgdGNcUc5KxZJxiv+c2utWQdxlg8PskixBfd1qET/XazDswbk5ImO6NR14SBT0ocaLZWLxELCgS08+20MkddMkYEv0DaVXOFALdP4fere0JMnitHNuyHd2h6k+BNtL0cupLMKTQZX/O5pqAer876ZobYf3muC5HgwXPgFyuv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589226; c=relaxed/simple;
	bh=vgBREZutk7yHb4jCBMzEBHOqjOttRikT0gGnrsMoxO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbQPUGBugL5yzIYn0YvnNJzK1rsMkqa3ucMqQCWwHaOR7iFs2pKNZpohX8yHzEYhWMgsUk60P+CTAQIvpc2ClHSkj4rtGgQE498kHKPCNqR9EYK8yjQN99Qyi8MRHD6z2fwHcjyBFBXu4yOnCPLbfmK+Hu/fPhMgr2e5Ih8LPN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l7tYTPoL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l7tYTPoL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CE58C433F1;
	Mon,  4 Mar 2024 21:53:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589225;
	bh=vgBREZutk7yHb4jCBMzEBHOqjOttRikT0gGnrsMoxO4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l7tYTPoLPkUvIDEmCQmRlPtwFjosGtGT62DqXifX4QxmMWvZrWoGjSGJQrUD2JA6i
	 0e/D5VAG39IagQAE9fdIcvj45QpBR4iqPEkuP/fFYyQQrtn/r6EmqygKCGOznCVOaB
	 q+VvZRmNFFX1X7WIxmBX34h9aSVSWphjlyKBYr8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/84] tls: rx: dont store the decryption status in socket context
Date: Mon,  4 Mar 2024 21:24:01 +0000
Message-ID: <20240304211543.269918919@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7dc59c33d62c4520a119051d4486c214ef5caa23 ]

Similar justification to previous change, the information
about decryption status belongs in the skb.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: f7fa16d49837 ("tls: decrement decrypt_pending if no async completion will be called")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/strparser.h |  1 +
 include/net/tls.h       |  1 -
 net/tls/tls_device.c    |  3 ++-
 net/tls/tls_sw.c        | 10 ++++++----
 4 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/include/net/strparser.h b/include/net/strparser.h
index c271543076cf8..a191486eb1e4c 100644
--- a/include/net/strparser.h
+++ b/include/net/strparser.h
@@ -72,6 +72,7 @@ struct sk_skb_cb {
 	u64 temp_reg;
 	struct tls_msg {
 		u8 control;
+		u8 decrypted;
 	} tls;
 };
 
diff --git a/include/net/tls.h b/include/net/tls.h
index 24c1b718ceacc..ea0aeae26cf76 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -147,7 +147,6 @@ struct tls_sw_context_rx {
 
 	struct sk_buff *recv_pkt;
 	u8 async_capable:1;
-	u8 decrypted:1;
 	atomic_t decrypt_pending;
 	/* protect crypto_wait with decrypt_pending*/
 	spinlock_t decrypt_compl_lock;
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 88785196a8966..f23d18e666284 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -936,6 +936,7 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 			 struct sk_buff *skb, struct strp_msg *rxm)
 {
 	struct tls_offload_context_rx *ctx = tls_offload_ctx_rx(tls_ctx);
+	struct tls_msg *tlm = tls_msg(skb);
 	int is_decrypted = skb->decrypted;
 	int is_encrypted = !is_decrypted;
 	struct sk_buff *skb_iter;
@@ -950,7 +951,7 @@ int tls_device_decrypted(struct sock *sk, struct tls_context *tls_ctx,
 				   tls_ctx->rx.rec_seq, rxm->full_len,
 				   is_encrypted, is_decrypted);
 
-	ctx->sw.decrypted |= is_decrypted;
+	tlm->decrypted |= is_decrypted;
 
 	if (unlikely(test_bit(TLS_RX_DEV_DEGRADED, &tls_ctx->flags))) {
 		if (likely(is_encrypted || is_decrypted))
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index 82d7c9b036bc7..0a6630bbef53e 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -1560,9 +1560,10 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
 	struct tls_prot_info *prot = &tls_ctx->prot_info;
 	struct strp_msg *rxm = strp_msg(skb);
+	struct tls_msg *tlm = tls_msg(skb);
 	int pad, err = 0;
 
-	if (!ctx->decrypted) {
+	if (!tlm->decrypted) {
 		if (tls_ctx->rx_conf == TLS_HW) {
 			err = tls_device_decrypted(sk, tls_ctx, skb, rxm);
 			if (err < 0)
@@ -1570,7 +1571,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		}
 
 		/* Still not decrypted after tls_device */
-		if (!ctx->decrypted) {
+		if (!tlm->decrypted) {
 			err = decrypt_internal(sk, skb, dest, NULL, chunk, zc,
 					       async);
 			if (err < 0) {
@@ -1594,7 +1595,7 @@ static int decrypt_skb_update(struct sock *sk, struct sk_buff *skb,
 		rxm->offset += prot->prepend_size;
 		rxm->full_len -= prot->overhead_size;
 		tls_advance_record_sn(sk, prot, &tls_ctx->rx);
-		ctx->decrypted = 1;
+		tlm->decrypted = 1;
 		ctx->saved_data_ready(sk);
 	} else {
 		*zc = false;
@@ -2137,8 +2138,9 @@ static void tls_queue(struct strparser *strp, struct sk_buff *skb)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(strp->sk);
 	struct tls_sw_context_rx *ctx = tls_sw_ctx_rx(tls_ctx);
+	struct tls_msg *tlm = tls_msg(skb);
 
-	ctx->decrypted = 0;
+	tlm->decrypted = 0;
 
 	ctx->recv_pkt = skb;
 	strp_pause(strp);
-- 
2.43.0



