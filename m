Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624249;
	b=cv+FIWTSOP4r3m5Nwb0pFjj7w9AGmBrek8FODg5LgvmyWITDLR0y3NqtYGpaSHUu/6fk
	 fqH3D+owQy+/SGMOO0ALdr2XYzXb3xZcCYbdZMbW+y5xzmYbiE/nSviyGfocNHvhUEuu9
	 1LS0T9NEfieW9LmB1EEOIkgViQl8dx0dJB7rayZSsgZ9mn0ZenYO68UD2h7sGtbDDkl81
	 hgguxpUVeaIsqQegjO6ceEg4QqogjSukYicUycz5ytRnjIk4EOjpAFTB4sFfgBkkY7jPE
	 T+1/aoM2tpZwr3SKGZhqE1j2CTClE+jt4/qwmlkRketcnSv0YLrV7qogKv4/B/Vg5RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624249;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MKATjWojvxHdfmlh2nL+Oj50jhV9gRjjstZtxos+qu0=;
	b=gOK0U4t+b6dE2ZnD7mVQFMdnOGwtVuwk6fXytMn9iCggtz+qhATszsST1MqRwtPzbNdY
	 IbP+jxPAGGsBfBOgo+6htiuX7xoUOweSNBovpRMYn6KFe41BSGyidXmRpIGgdSJvQ6udU
	 Q3Se525KH42bB1chCabzZaUTapQUVcm/iwGDAx3wWa2cI5MHFICDukfynlrcpKde0I3uz
	 KOvFoVuAkdGoO/OwixTCE1Fpu0UpcHOAFFxEJcV/Bax3pn0XA7YrfpIOjWiRzA5jUvC/T
	 sw2cw511PbSW+F63E1zv5/3WPfeq1HTXlpIticeUY/PeJs2SBLeMkRA6k/cKOsvAOCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bRaUabOv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECACD606A686;
	Wed, 25 Nov 2026 16:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bRaUabOv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC6FE1F000C4;
	Wed, 25 Nov 2026 16:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624248;
	bh=MKATjWojvxHdfmlh2nL+Oj50jhV9gRjjstZtxos+qu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bRaUabOvs/SbVQVl57H7ZdrSfDjtVdQl5qVWLqZ4y7kcNLECQZFJsKl6a1Sw67JYq
	 iN6wVBYk/BzoGVFp8HIwRQyyu66nSD1wkxOqUGGEdF0sQAObFQQN0akH0PreDV3Fje
	 PH2nSK0OnF/IpIiWyM5LvLs8E9qSheym1wgG/DRo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 086/816] netfilter: nf_dup_netdev: Move the recursion counter struct netdev_xmit
Date: Wed, 25 Nov 2026 15:27:14 +0100
Message-ID: <20261125143851.211620495@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit f37ad91270397a6d053e8623bdb3cf79859691d2 ]

nf_dup_skb_recursion is a per-CPU variable and relies on disabled BH for its
locking. Without per-CPU locking in local_bh_disable() on PREEMPT_RT
this data structure requires explicit locking.

Move nf_dup_skb_recursion to struct netdev_xmit, provide wrappers.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: d6c18cadfc6c ("netfilter: nft_reject: prevent unbounded recursion in output hooks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice_xmit.h |  3 +++
 net/netfilter/nf_dup_netdev.c  | 22 ++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/linux/netdevice_xmit.h b/include/linux/netdevice_xmit.h
index 59726e6cd2cc6..cc232508e695e 100644
--- a/include/linux/netdevice_xmit.h
+++ b/include/linux/netdevice_xmit.h
@@ -18,6 +18,9 @@ struct netdev_xmit {
 	u8			sched_mirred_nest;
 	struct net_device	*sched_mirred_dev[MIRRED_NEST_LIMIT];
 #endif
+#if IS_ENABLED(CONFIG_NF_DUP_NETDEV)
+	u8 nf_dup_skb_recursion;
+#endif
 };
 
 #endif
diff --git a/net/netfilter/nf_dup_netdev.c b/net/netfilter/nf_dup_netdev.c
index a8e2425e43b0d..fab8b9011098f 100644
--- a/net/netfilter/nf_dup_netdev.c
+++ b/net/netfilter/nf_dup_netdev.c
@@ -15,12 +15,26 @@
 
 #define NF_RECURSION_LIMIT	2
 
-static DEFINE_PER_CPU(u8, nf_dup_skb_recursion);
+#ifndef CONFIG_PREEMPT_RT
+static u8 *nf_get_nf_dup_skb_recursion(void)
+{
+	return this_cpu_ptr(&softnet_data.xmit.nf_dup_skb_recursion);
+}
+#else
+
+static u8 *nf_get_nf_dup_skb_recursion(void)
+{
+	return &current->net_xmit.nf_dup_skb_recursion;
+}
+
+#endif
 
 static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 				enum nf_dev_hooks hook)
 {
-	if (__this_cpu_read(nf_dup_skb_recursion) > NF_RECURSION_LIMIT)
+	u8 *nf_dup_skb_recursion = nf_get_nf_dup_skb_recursion();
+
+	if (*nf_dup_skb_recursion > NF_RECURSION_LIMIT)
 		goto err;
 
 	if (hook == NF_NETDEV_INGRESS && skb_mac_header_was_set(skb)) {
@@ -32,9 +46,9 @@ static void nf_do_netdev_egress(struct sk_buff *skb, struct net_device *dev,
 
 	skb->dev = dev;
 	skb_clear_tstamp(skb);
-	__this_cpu_inc(nf_dup_skb_recursion);
+	(*nf_dup_skb_recursion)++;
 	dev_queue_xmit(skb);
-	__this_cpu_dec(nf_dup_skb_recursion);
+	(*nf_dup_skb_recursion)--;
 	return;
 err:
 	kfree_skb(skb);
-- 
2.53.0



