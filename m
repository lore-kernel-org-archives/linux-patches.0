Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027299;
	b=2FCmBKBBLEoRsdp0+F0FINlBINx5VFr6SGviBiRzumignWzukJUxZ6Cn1wmPdppvocXl
	 x9xE9HYUeoMga41mlfjWeKaxCRtK1KS37ooHNXiGkQTkQTiDdKYAFTIjVIPawTE4ZG2++
	 p3iX6JvCrrmC187VT/EWbNH0NgJZ9bW5N+Uo51a8BFcn9ydKUT9eaPk8k3ZpdISoK1MSU
	 Syllz4j8jUHnUMGZreH3V846FaLLe/G1SoIFhjPmwfwJ7QY7pNoLC4Y648/9EfwIo/wCy
	 3+mZR2hK/xKX/eI/0t2aC8zV1wsWBSRbYb6qOCeZsylXOj7a5CPGRZIChdslmnNjdXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027299;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=k9VC/h2mXd00UXZg6ioqTr4hyBY4ACRzp9ww00jw+p0=;
	b=cnq6+sNnS/qqfuRYKhbd/eYDpY2aSZ6/1Q47hCXULTJiWo0Iq+ryoHPr+Wk4Hruh/mxL
	 nZiErTW/cwyw8BegbQD2WxBoT/Z1ISTK3O0YWi81lgY8T24GCle745vN4Eiu9m8U4zVO9
	 xzPbg85oDGQd3QbXSKJRvW+wfMdzMu1fBLBR4QjaGvvtYzYivskKVxxVagu4ByyqYk1RP
	 sR+H+sJ1iUrbW/odHaU34nYtzS8MqlpoB+9cFY3cSzfLGMbk5pksIcveKg0YGdIQ7TXhs
	 7GEahFsODlXbi7Xw3pUmDlcmwu15SoRvqV3sieGQVzkNJInn4enGS/17418+DhA3kSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ttmgom8A;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51C07606A320;
	Wed, 18 Nov 2026 18:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ttmgom8A
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A26C91F000C4;
	Wed, 18 Nov 2026 18:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027299;
	bh=k9VC/h2mXd00UXZg6ioqTr4hyBY4ACRzp9ww00jw+p0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ttmgom8AzwjSIyaiir6TVkG8KtDdE0ShjOkLUQ5pt2HYfjVs4Hjebov1a770XXprX
	 tyIOhc2xVBT8vqdSBIPtmkwrCmQnWwzd8uZgrprCUOyOc6P7aftPQoJy5gXPI54sv+
	 XErafPBSjcRXx6aPudlsooBYomDmLn2xaJfXIRWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1733/2151] netfilter: conntrack: fix unlikely UaF in gc worker
Date: Wed, 18 Nov 2026 15:57:48 +0100
Message-ID: <20261118150224.995088450@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
index 73315d53d2879..a102fe5386171 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2504,6 +2504,11 @@ void nf_conntrack_cleanup_net_list(struct list_head *net_exit_list)
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



