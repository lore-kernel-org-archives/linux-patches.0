Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056549;
	b=f4BVxrxLehL1qflCxmEfx6IzpxYvLbj37oH5YNKuRlzN4jv/2Zz1aiig7qM5v60ErqBG
	 nDSaX3/k+l3Dmd2HWGeC2DX/MySvG1+UtX4m1PLJGw7JYqTsKe4R4r/ZbwfmMGpIUUIkk
	 wHiLykWQhCsqgj9PWjDssmpFSBoz1qytY6z+ZchmKfsPCyImm1JB4x2ymqNFdJFa5NgIP
	 mCABgQhIm21RwVL46VhiPlU18LAfyr+qtPMtwFC8cDygN1jtLPLopmcHW26A0yzXEhPbe
	 //SF+NQrKc0Bmssb3dJVqwQJJzf++XHgSKgF2wc77Q+ABDB2d0nIbrxhYzmNAVaeloA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YYxd0jJtbieMoq9/LH/0v5HYcW2rTFb5o11TNesTrGY=;
	b=UbmgfOz1u/SptWk7h66CHaUL6Zl6iMxwQuX+SVfAetZfANwaBSVZLWzOCx2Dp2kT3YHi
	 wd2Di6xLlDCwp8OkOuXSpakCKX8fuczfhiQ9lerxZ/3Cu2MksYRygk9zjqhjwOMscchEq
	 H1lIm4xXtcLf+ZdAD81d+kFg6OyZsFuNXlvoA/ZfLwFx1XF1StXQU64GtYRr6qjt0UHl8
	 uj2zUesOGqAlFJyBtqnFHcVh7wuGiLHMmv0zKtARPY04Zt+REtUZAsowqcM0FP8XM/4xL
	 doTC8SuD9f7d/sQ3onTv0P8XC42L6UZmHLkjslMS+hQ7SoAFVADoaAshZMJ9JnmjJAw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrV3praz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82919606A32F;
	Thu, 19 Nov 2026 02:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zrV3praz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED391F000C4;
	Thu, 19 Nov 2026 02:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056549;
	bh=YYxd0jJtbieMoq9/LH/0v5HYcW2rTFb5o11TNesTrGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zrV3prazCcsZOj2r9v914/Z2Oudoj0bL1X1L+K48KwqtJOigANiwyoJePj+pZmVMZ
	 EeazWjEspQ0PZVOqg7/8xE4MP3nFfnGkZqbg4a2eCZ6MCK9lWBNC9KPw0QOwDxtzLL
	 84DnKfCWYdiCMQhUDZaErjyXIVVNSRhzYdgNDdeY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 2026/2214] netfilter: conntrack: fix unlikely UaF in gc worker
Date: Wed, 18 Nov 2026 16:01:42 +0100
Message-ID: <20261118150131.806338187@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index ea9aba75b38af..978cb810a4a0c 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2590,6 +2590,11 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
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



