Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F36305688;
	Tue, 16 Jun 2026 17:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630814; cv=none; b=FY4WKvX+gOOSFX/4rREtYJx7OoNOFwDn/qN88UA3spHHaO53h71ixZEcyeeJty0Lygx2533AtfZb2OWtm21HyvsQ1xMNXGUjG7Wqdbr6GRZyLyExVcSVFZVl27Nkq2gcbaPG/CHzl+aN+bOUfYHuffTWlbtOrtbwKojrj9PdfJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630814; c=relaxed/simple;
	bh=O4Q0tC+k0NPRvyLHiVBqFX3vXM7j/NaCwBVtjV40RIc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oflz0jRUJSrnQzR3DdV9GGe++G7i26q+aPUgOtowl0MegpXc2QfSDxyKxOgPLysAYsTRp1EFyp9mLos20dBfSAC+dN0g0jOajvgx9orJupDyIXjCaliJnfVgLSwVFZwCsHciLdYDxXo0lqKgoLnFz6jQ+TlS8sjiuwHkevjdFRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmA/45hk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmA/45hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FF71F00A3A;
	Tue, 16 Jun 2026 17:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630812;
	bh=mpQPbsxXKFCAwgtWoAQPj/tLOn130n8XDreZGRF/Prc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmA/45hki1ltT4gCf+/vwyNPFybTgVWKcnrRaAbwh2VVMOH7+jaHrUkHnE4p7boZe
	 BaHCKhVSUTgDlM21NX0Mhu/nZkqgX/r0a876U8ofOZMg+uPBOZh6qptrD/RiHuNgWA
	 HHcto5KDn1MHSmYQLuKa4BebErLyky27VCOw+eFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 068/522] net/packet: convert po->running to an atomic flag
Date: Tue, 16 Jun 2026 20:23:35 +0530
Message-ID: <20260616145129.002692365@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 61edf479818e63978cabd243b82ca80f8948a313 ]

Instead of consuming 32 bits for po->running, use
one available bit in po->flags.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 2c054e17d9d4 ("net/packet: fix TOCTOU race on mmap'd vnet_hdr in tpacket_snd()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 20 ++++++++++----------
 net/packet/diag.c      |  2 +-
 net/packet/internal.h  |  2 +-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 50d9618d85f3c7..36347814ec7ceb 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -340,14 +340,14 @@ static void __register_prot_hook(struct sock *sk)
 {
 	struct packet_sock *po = pkt_sk(sk);
 
-	if (!po->running) {
+	if (!packet_sock_flag(po, PACKET_SOCK_RUNNING)) {
 		if (po->fanout)
 			__fanout_link(sk, po);
 		else
 			dev_add_pack(&po->prot_hook);
 
 		sock_hold(sk);
-		po->running = 1;
+		packet_sock_flag_set(po, PACKET_SOCK_RUNNING, 1);
 	}
 }
 
@@ -369,7 +369,7 @@ static void __unregister_prot_hook(struct sock *sk, bool sync)
 
 	lockdep_assert_held_once(&po->bind_lock);
 
-	po->running = 0;
+	packet_sock_flag_set(po, PACKET_SOCK_RUNNING, 0);
 
 	if (po->fanout)
 		__fanout_unlink(sk, po);
@@ -389,7 +389,7 @@ static void unregister_prot_hook(struct sock *sk, bool sync)
 {
 	struct packet_sock *po = pkt_sk(sk);
 
-	if (po->running)
+	if (packet_sock_flag(po, PACKET_SOCK_RUNNING))
 		__unregister_prot_hook(sk, sync);
 }
 
@@ -1834,7 +1834,7 @@ static int fanout_add(struct sock *sk, struct fanout_args *args)
 	err = -EINVAL;
 
 	spin_lock(&po->bind_lock);
-	if (po->running &&
+	if (packet_sock_flag(po, PACKET_SOCK_RUNNING) &&
 	    match->type == type &&
 	    match->prot_hook.type == po->prot_hook.type &&
 	    match->prot_hook.dev == po->prot_hook.dev) {
@@ -3277,7 +3277,7 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 
 	if (need_rehook) {
 		dev_hold(dev);
-		if (po->running) {
+		if (packet_sock_flag(po, PACKET_SOCK_RUNNING)) {
 			rcu_read_unlock();
 			/* prevents packet_notifier() from calling
 			 * register_prot_hook()
@@ -3290,7 +3290,7 @@ static int packet_do_bind(struct sock *sk, const char *name, int ifindex,
 								 dev->ifindex);
 		}
 
-		BUG_ON(po->running);
+		BUG_ON(packet_sock_flag(po, PACKET_SOCK_RUNNING));
 		WRITE_ONCE(po->num, proto);
 		po->prot_hook.type = proto;
 
@@ -4230,7 +4230,7 @@ static int packet_notifier(struct notifier_block *this,
 		case NETDEV_DOWN:
 			if (dev->ifindex == po->ifindex) {
 				spin_lock(&po->bind_lock);
-				if (po->running) {
+				if (packet_sock_flag(po, PACKET_SOCK_RUNNING)) {
 					__unregister_prot_hook(sk, false);
 					sk->sk_err = ENETDOWN;
 					if (!sock_flag(sk, SOCK_DEAD))
@@ -4541,7 +4541,7 @@ static int packet_set_ring(struct sock *sk, union tpacket_req_u *req_u,
 
 	/* Detach socket from network */
 	spin_lock(&po->bind_lock);
-	was_running = po->running;
+	was_running = packet_sock_flag(po, PACKET_SOCK_RUNNING);
 	num = po->num;
 	WRITE_ONCE(po->num, 0);
 	if (was_running)
@@ -4752,7 +4752,7 @@ static int packet_seq_show(struct seq_file *seq, void *v)
 			   s->sk_type,
 			   ntohs(READ_ONCE(po->num)),
 			   READ_ONCE(po->ifindex),
-			   po->running,
+			   packet_sock_flag(po, PACKET_SOCK_RUNNING),
 			   atomic_read(&s->sk_rmem_alloc),
 			   from_kuid_munged(seq_user_ns(seq), sock_i_uid(s)),
 			   sock_i_ino(s));
diff --git a/net/packet/diag.c b/net/packet/diag.c
index a3bd91dba43945..cd30cc619c6b45 100644
--- a/net/packet/diag.c
+++ b/net/packet/diag.c
@@ -21,7 +21,7 @@ static int pdiag_put_info(const struct packet_sock *po, struct sk_buff *nlskb)
 	pinfo.pdi_tstamp = po->tp_tstamp;
 
 	pinfo.pdi_flags = 0;
-	if (po->running)
+	if (packet_sock_flag(po, PACKET_SOCK_RUNNING))
 		pinfo.pdi_flags |= PDI_RUNNING;
 	if (packet_sock_flag(po, PACKET_SOCK_AUXDATA))
 		pinfo.pdi_flags |= PDI_AUXDATA;
diff --git a/net/packet/internal.h b/net/packet/internal.h
index 0956e4a934492d..9e50bf06131f29 100644
--- a/net/packet/internal.h
+++ b/net/packet/internal.h
@@ -117,7 +117,6 @@ struct packet_sock {
 	spinlock_t		bind_lock;
 	struct mutex		pg_vec_lock;
 	unsigned long		flags;
-	unsigned int		running;	/* bind_lock must be held */
 	int			pressure;
 	int			ifindex;	/* bound device		*/
 	__be16			num;
@@ -146,6 +145,7 @@ enum packet_sock_flags {
 	PACKET_SOCK_TX_HAS_OFF,
 	PACKET_SOCK_TP_LOSS,
 	PACKET_SOCK_HAS_VNET_HDR,
+	PACKET_SOCK_RUNNING,
 };
 
 static inline void packet_sock_flag_set(struct packet_sock *po,
-- 
2.53.0



