Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041983;
	b=w9BZT77mqJ8WswpOYHtrHhW7uvliDseI4O04E+PLwmV9CGJlCP+FNLPcPlNaYmyTHLvI
	 lx9OT0zqRVrgCxCWZM6kR/WosrRTsm5OWCH5JzKemkcuDyZyOPTKlSpBFDqLjRq+2z2r8
	 5Mkpq1rrFM72vhVMmLSRZaD1qhh3HPd81TVFfHsfjVeD2Us4ndWYxVHyohmiuocBaMJZX
	 KmSWmrwuVezwFldD1jLSdsbYDUDyckm74nz9mKD4z4uv2G6ucuHaAbPYbm2IGo6QRht+M
	 q6e9/rzXc0WAywcnXhhpHi/aQvbls+Ncd2NX9Ax/0FZyo9pZUcDh/JNgSWCDpqAwXxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JGmaLjOJ8LLjNWyNZZrX3Rsv0EKqXSPhD2CaIRXlBmQ=;
	b=PNnw/6hmydB6KkaWLrUd0WxrJzYRCDVUiIcBlkDq9cnVaS0vZ0CSqOBDui9IzSCIk2Of
	 blyw99ZGGJymUXQc/0Durwn8dIBfNm2LwPCR2e9sEe2D5V40H0ZxvEkylLsEPr1tnm97a
	 S6TL1kwhPH7HPW7UrIUMrAit60JuKl5/L6tOjZCsYyeTH6FE9hoVWQFVMi2d41+/fJe2O
	 1vXnczrw87c0Xx2G/pj81S09Y832w3XC49iVMHA0pzP2hdbphy9098pGc95/QX/HFfnlP
	 TPmfiEN8sjkVRSH3unSNdtwnLw++mES14zttm7ZWzWl72Bn7vDmyY+riyWnyGwHJgqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I9YCHsRo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8020B606A32A;
	Wed, 18 Nov 2026 22:46:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I9YCHsRo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9060C1F000C4;
	Wed, 18 Nov 2026 22:46:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041983;
	bh=JGmaLjOJ8LLjNWyNZZrX3Rsv0EKqXSPhD2CaIRXlBmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9YCHsRoOw79HcgLcDrkIhSju+bCfdygdSOXhTgG6nkAg9RaCOWsKaAhjv6lA33iE
	 Ni8KrsPkOqmDqLVQGjBwsIVpchJdDXUqb7MCEf+fJmrGq8NwnAneH60GOUAr9VllY0
	 d/2Ndh/YTg791m44q3VefGpp74sps9aowPGNhYa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3008/3318] netfilter: conntrack: fix unlikely UaF in gc worker
Date: Wed, 18 Nov 2026 16:00:30 +0100
Message-ID: <20261118150450.483109643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8969d8abe4cbf..51cd56e31135e 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2554,6 +2554,11 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
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



