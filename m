Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623025;
	b=tkyS8BVoTAwEh0VGG1Hkds8onakB45DY3g3+ltRIlI0WeIWIWr9N/rYi/W9QqYFoqbvH
	 32Rjl9vJ953k+g27wZpUcFoLmY5tqgNmnwt/stwd50Ajs/NmLQqtiVkWYr0i/9/rKHhmq
	 QnJ7cjcpKv57a/PcornWSFi4HXtWQ9eRco+0TLkHDZbLzrBq4jePqHBsBLDsp85Ppxb+k
	 LvjOD3gVo4ZTjTPveHdZ/YfsLQyoALBf3fTLV32zgbaRREW6Pj/1nDEi/p2zMWyuYMlWN
	 G3OzgR9ychj+r/zzSDDYIdt251OqP5ZpTX6/7U5CZHhabEMxklU/rOKrC/bf/0DkdVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623025;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8CmpYa93ZijKu0CISptfGay8NQ2eH6YkjOQZ1hZl3Ro=;
	b=YIflKhoLdL6+Nwp/zimbvLoL1pHfoFu9sblxzvHsmcK5XefWB7Mw8JNi4Xcs2Wynlt2D
	 Ohg6BWVRs615RhJ3zYKfvYKSkjpxgZW2rY91XzKJBwZHqkeoCpa2wf5CB4QXp3oKloUY1
	 HFvIHyKXj1k4kx/H/CNmhcWVlWzxVoIKPNbUaYDUa2bwAygqQeNxBJQMuPOsHuUMjpPsU
	 AaH+zhgIy/q7+V9r3r8RbHL3PXTGnOSoLFgaTO9E87n9xnum6hykO3Ze50yFiKRniVjlz
	 DjJRfMp1iO+grWc5MIYj+jbeiu5mpOc7r4QFXXSVijcDQLsdpH0hI2tBbIDXaRnQgVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aYePUVJm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85112606A326;
	Wed, 25 Nov 2026 16:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aYePUVJm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529081F000CF;
	Wed, 25 Nov 2026 16:10:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623024;
	bh=8CmpYa93ZijKu0CISptfGay8NQ2eH6YkjOQZ1hZl3Ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aYePUVJmH6u1jFMPabF+vJoNFLZcKW3xXkCAjPcEZONZuWqIYVL4W+oBYHjaLmvYT
	 v62XfHH0xT5BcWXbGb4XvbDrl45w+9rt1INR6TB2OOOSeqEsUhGNQdAFZZKAE5Nlo5
	 iLjHWBqmR7tTUD1tpUgJV99rVYwqPddvS0RT468c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 724/990] netfilter: nf_dup: preserve guard across NFQUEUE reinjection
Date: Wed, 25 Nov 2026 15:34:51 +0100
Message-ID: <20261125143839.034078153@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

commit 82052e5b5ec36504fe1b9c3c28a711a78fcacf37 upstream.

NFQUEUE can suspend traversal of a duplicated packet while the task-local
duplication guard is set. The output call then returns and clears the guard
before a later verdict resumes hook traversal.

Save the guard in the queue entry and restore it while reinjection
continues hook traversal. Preserve and restore the verdict task's prior
state, including nested synchronous reinjection.

Fixes: cd58bcd9787e ("netfilter: xt_TEE: have cloned packet travel through Xtables too")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_queue.h |    1 +
 net/netfilter/nf_queue.c         |    1 +
 net/netfilter/nfnetlink_queue.c  |   17 ++++++++++++++---
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -23,6 +23,7 @@ struct nf_queue_entry {
 	struct net_device	*physout;
 #endif
 	struct nf_hook_state	state;
+	bool			in_nf_duplicate;
 	bool			nf_ct_is_unconfirmed;
 	u16			size; /* sizeof(entry) + saved route keys */
 
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -218,6 +218,7 @@ static int __nf_queue(struct sk_buff *sk
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
 		.skb_dev = skb->dev,
+		.in_nf_duplicate = current->in_nf_duplicate,
 		.state	= *state,
 		.hook_index = index,
 		.size	= sizeof(*entry) + route_key_size,
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -44,6 +44,7 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/netfilter/nf_queue.h>
+#include <net/net_debug.h>
 #include <net/netns/generic.h>
 
 #include <linux/atomic.h>
@@ -351,21 +352,30 @@ static void nf_reinject(struct nf_queue_
 	const struct nf_hook_entry *hook_entry;
 	const struct nf_hook_entries *hooks;
 	struct sk_buff *skb = entry->skb;
+	bool old_in_nf_duplicate;
 	const struct net *net;
 	unsigned int i;
 	int err;
 	u8 pf;
 
+	DEBUG_NET_WARN_ONCE(current->in_nf_duplicate &&
+			    !entry->in_nf_duplicate,
+			    "%s called with unexpected duplication guard",
+			    __func__);
+	local_bh_disable();
+	old_in_nf_duplicate = current->in_nf_duplicate;
+
 	net = entry->state.net;
 	pf = entry->state.pf;
 
+	current->in_nf_duplicate = entry->in_nf_duplicate;
 	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
 
 	i = entry->hook_index;
 	if (!hooks || i >= hooks->num_hook_entries) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
 		nf_queue_entry_free(entry);
-		return;
+		goto out;
 	}
 
 	hook_entry = &hooks->hooks[i];
@@ -388,9 +398,7 @@ next_hook:
 	switch (verdict & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
 	case NF_STOP:
-		local_bh_disable();
 		entry->state.okfn(entry->state.net, entry->state.sk, skb);
-		local_bh_enable();
 		break;
 	case NF_QUEUE:
 		err = nf_queue(skb, &entry->state, i, verdict);
@@ -404,6 +412,9 @@ next_hook:
 	}
 
 	nf_queue_entry_free(entry);
+out:
+	current->in_nf_duplicate = old_in_nf_duplicate;
+	local_bh_enable();
 }
 
 /* return true if the entry has an unconfirmed conntrack attached that isn't owned by us


