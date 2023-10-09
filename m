Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEAD18E05
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:35:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGbwJOzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26555C433C8;
	Mon,  9 Oct 2023 13:35:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858544;
	bh=79mUaHlqhpjkyDddBXbWgT+phgCK6zHzZYxvpiCHKPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGbwJOzmyN4ynpZrCIhzdqMtjXDTerqXLrtUAQPWss9fAHtIn74EX7cospStYhHZr
	 88ZYUI36N94oAlTLHgwlv3U6IencWDRe1+twitBreavXX7+xxeiQDTBdcYzaP1ixat
	 m/jOXcv3BUTSRYS7s8z9jZcoaoL6N3YK7Rb75n5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 023/226] netfilter: nf_tables: fix GC transaction races with netns and netlink event exit path
Date: Mon,  9 Oct 2023 14:59:44 +0200
Message-ID: <20231009130127.352039452@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 6a33d8b73dfac0a41f3877894b38082bd0c9a5bc upstream.

Netlink event path is missing a synchronization point with GC
transactions. Add GC sequence number update to netns release path and
netlink event path, any GC transaction losing race will be discarded.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 206755eb35f3a..43da2f0a52623 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8320,6 +8320,22 @@ static void nft_set_commit_update(struct list_head *set_update_list)
 	}
 }
 
+static unsigned int nft_gc_seq_begin(struct nftables_pernet *nft_net)
+{
+	unsigned int gc_seq;
+
+	/* Bump gc counter, it becomes odd, this is the busy mark. */
+	gc_seq = READ_ONCE(nft_net->gc_seq);
+	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
+
+	return gc_seq;
+}
+
+static void nft_gc_seq_end(struct nftables_pernet *nft_net, unsigned int gc_seq)
+{
+	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
+}
+
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
@@ -8401,9 +8417,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	while (++nft_net->base_seq == 0)
 		;
 
-	/* Bump gc counter, it becomes odd, this is the busy mark. */
-	gc_seq = READ_ONCE(nft_net->gc_seq);
-	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
+	gc_seq = nft_gc_seq_begin(nft_net);
 
 	/* step 3. Start new generation, rules_gen_X now in use. */
 	net->nft.gencursor = nft_gencursor_next(net);
@@ -8583,7 +8597,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	nf_tables_gen_notify(net, skb, NFT_MSG_NEWGEN);
 	nf_tables_commit_audit_log(&adl, nft_net->base_seq);
 
-	WRITE_ONCE(nft_net->gc_seq, ++gc_seq);
+	nft_gc_seq_end(nft_net, gc_seq);
 	nf_tables_commit_release(net);
 
 	return 0;
@@ -9538,11 +9552,18 @@ static void __net_exit nf_tables_pre_exit_net(struct net *net)
 static void __net_exit nf_tables_exit_net(struct net *net)
 {
 	struct nftables_pernet *nft_net = net_generic(net, nf_tables_net_id);
+	unsigned int gc_seq;
 
 	mutex_lock(&nft_net->commit_mutex);
+
+	gc_seq = nft_gc_seq_begin(nft_net);
+
 	if (!list_empty(&nft_net->commit_list))
 		__nf_tables_abort(net, NFNL_ABORT_NONE);
 	__nft_release_tables(net);
+
+	nft_gc_seq_end(nft_net, gc_seq);
+
 	mutex_unlock(&nft_net->commit_mutex);
 	WARN_ON_ONCE(!list_empty(&nft_net->tables));
 	WARN_ON_ONCE(!list_empty(&nft_net->module_list));
-- 
2.40.1



