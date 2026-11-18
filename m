Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061849;
	b=zg9rz+fJwehmsP1avIe119fUaeUHLELN/lq0gVgn8NtIf34jXMgWGBIR3f8YRZFn7AH2
	 Q8w9JoaNxBjLhXSggMauhm7OZLrVJ2EHHHGGUHtZAgZ8AF1QgXEDbUHegmYjXr37uuuf4
	 erI+DiBGzfhquhewLpAa01Dnfn2jdb1bP4G8iCOyZLKtV1IAfMp3UMHWbusvG+OaZhGpI
	 OXNNh7G/ymo45O9om65CM7zD5xZwNh4YeiYs7ZO2lHWzxQbzMC3kfHw+MEbs+oAPudIKE
	 061p02x3XfO9eMCvp+RkWsqR2UAdQAG+8IvAOAG/uBbTgcUsoVCE6ZahnZ3UYe6UcbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ca1ZQCpat86vjGBhccYSa9EC/MdOY7wpurQwkc16pPg=;
	b=xTjamMnFhv4Oe+g0lPibXM8ZgAv5XQ/3tu89KbzoTH1t4bHwayKd05bJeuqUXZVVZg8z
	 XO0U022UB75/KvEudgpBCXSXZ4XyeIiKOIMJAr2qGSjzCY1Fkdd75zT18ml+MfSv2asIN
	 u1CHmtEVwQqHsZcpby5215HtYTdCHruy5lpW264/bLUdwYTONLaoUYsARl8Z0mq9DEd/u
	 wfPM+tYfNgLZMNIIXxM/rOyjsRW5CyXfdP4xDUf/H2MPwiG2fbhcyPcgCneGL6meYeLvG
	 nh4TgFUEtXWJ8GtSdS7tb3K6jmnWDYGx5rfYFgoEbcPVuUdmSJ9pOdLMTmDCLjmjlSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IHa+D7Eq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDBA606A32A;
	Thu, 19 Nov 2026 04:17:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IHa+D7Eq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4421F000C4;
	Thu, 19 Nov 2026 04:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061849;
	bh=ca1ZQCpat86vjGBhccYSa9EC/MdOY7wpurQwkc16pPg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IHa+D7EqJts9q1EnD0aC926t899o5eY4oOLKW4boYapMpQsUK9kEYWZ1bCbIj6UWz
	 iSkignssyu8xbxvaWXIrA9esjxBpxAqw0VEFCXCGNTrC1Tc3xdSOyeBNJi4iZwRm8+
	 dYCr5dAXJY7HYiAApDSkJvXUO730aYIwrfQ44e1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1701/1848] netfilter: conntrack: fix unlikely UaF in gc worker
Date: Wed, 18 Nov 2026 16:02:19 +0100
Message-ID: <20261118150030.950852209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e2330c3456b03..5c5112b5bc3a7 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2457,6 +2457,11 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
 		goto i_see_dead_people;
 	}
 
+	/* must wait for current scan loop, worker also looks at
+	 * struct nf_conntrack_net, which is about to be free'd.
+	 */
+	flush_work(&conntrack_gc_work.dwork.work);
+
 	list_for_each_entry(net, net_exit_list, exit_list) {
 		nf_conntrack_proto_pernet_fini(net);
 		nf_conntrack_ecache_pernet_fini(net);
-- 
2.53.0



