Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032453;
	b=ZSBWWr3LP34r/vuZluiRaGI0R1D20u727+fHFhHLFL+0INqOCveFgAAYG8CLnKnx9Oq2
	 voPsp2tGG/NvwlJSGXK6NLjaNjkGGWQaI7tZmZocdfivJ4AtOIcOdSvg3Fc2XrHU5VlOO
	 VMg0ERobbMI2mMYXB35yetYTUUA9BDe0t6wucSQWxgtVAM1c3K8VZFMX02PnPI2ICOHKk
	 4w42FtfwzTWZrRN4O5dvbBu5p6CwPcgBz3BOy3kOSiErg3KsoiWjrH3NXexiospIoPFVE
	 y41gnfXfqP0kziJHmYW6LNoH075sI/j/f+BDmDBiyji9reoROh/ocZHdKaO8jDGBLJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032453;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7XzgDA8PGykpgQkkGduROGiTtwWXrp2mZAsUO/xY+2A=;
	b=r+yhS7bWsdI1boyxGyGCbL1NzKN4yNYqXz/xqGZjeQFSSP1Kl6hg+xI8TBt4dCDdXIQ9
	 cIeSzmi/IgNjHVaI+RR6XnLALJFzDuJZ09J4XGk7vPdrE7jRjwZn36sTq93JUSZ5fO6Xc
	 VGS1kGh/2g6vrRDwNMBRJFpPK2TPMwggo0J6npO4Dwv722RwOQgY5W0PTTpjMZQfeM/eh
	 IjvPfQOwReZ3P7Tv9NuzYWgwHLIJPvsoVutHvu1hgrxC8jjxazr45uONFXK1XyhoAFi8I
	 m7R7bJ4U2cbIATRDs6kg7Y3KjjjCs2myQdHZBZC7JRhnUqH3GuO3wi8AS0sg6raQvhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYIsu6gt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A38606A33A;
	Wed, 18 Nov 2026 20:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYIsu6gt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8421F000C4;
	Wed, 18 Nov 2026 20:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032452;
	bh=7XzgDA8PGykpgQkkGduROGiTtwWXrp2mZAsUO/xY+2A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYIsu6gtetzCQ2Lyx1n5JRkhrbx9C3LQaQUi7EEWzatboPQi/x+GuKzhai7KRrMQo
	 qQZDssJ9bH6z7Yn2dQawfS4s7QflAgSZgjK9oN/Ua3yZslWnYdX+Dd7fAR6O0OraVm
	 f1gFzH/vYb+B2wPsPh0mzkxgxqAgSK9Ank2DFctU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1375/1756] netfilter: conntrack: fix unlikely UaF in gc worker
Date: Wed, 18 Nov 2026 15:58:22 +0100
Message-ID: <20261118150103.951551197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 9836164821a46af07428bb2a5e14137bf0c7bd6e ]

When early-drop scan is enabled, gc_worker() reads tmp->ct_net, resolves
cnet with nf_ct_pernet(), and reads cnet->count with RCU read lock held but
before acquiring a reference to tmp.

Its unlikely but possible that the worker gets preempted before reading
cnet->count while nf_conntrack_cleanup_net_list manages to unlink all
conntracks and returns in the mean time.
This allows for the pernet memory to get free'd.

On resume, use after free would occur when the worker reads cnet->count.

This can be solved either via another synchronize_rcu() in
nf_conntrack_cleanup_net_list or via cheaper flush_work().  If work
wasn't running no race can happen as next call cannot observe
already-unlinked conntrack objects.

This is an LLM finding with no reproducer, but it appears to be correct.

Fixes: c6dd940b1f74 ("netfilter: allow early drop of assured conntracks")
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_core.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 22b4ef2e0d60d..c828975026777 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2505,6 +2505,11 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 		goto i_see_dead_people;
 	}
 
+	/* must wait for current scan loop, worker also looks at
+	 * struct nf_conntrack_net, which is about to be free'd.
+	 */
+	flush_work(&conntrack_gc_work.dwork.work);
+
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		nf_conntrack_ecache_pernet_fini(net);
 		nf_conntrack_expect_pernet_fini(net);
-- 
2.53.0



