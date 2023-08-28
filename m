Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C266ADE
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421F8C433C8;
	Mon, 28 Aug 2023 10:20:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218043;
	bh=nZbwt/aOincUZqNFixGr3zdZRZFBvUEGPXcbKw/Sq9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TfSo6g631TpybFqO4XxGh3Yqz+ktpZJQHAq5lRrjQef0G1nVlDDIbovQvCjTJQs4C
	 noty1+hU1BOa8WMc4CmBn9aPqg/cmyC5QyPtj53PBAYXXwW5PE5jThMObcFlKTAgUM
	 Lp89k0K2/ohXqI1csDGjnsoCeD1+na20fvlxBLWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 045/129] netfilter: nf_tables: GC transaction race with abort path
Date: Mon, 28 Aug 2023 12:12:04 +0200
Message-ID: <20230828101158.866860095@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 720344340fb9be2765bbaab7b292ece0a4570eae ]

Abort path is missing a synchronization point with GC transactions. Add
GC sequence number hence any GC transaction losing race will be
discarded.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 539bc5d5c12fd..9cd8c14a0faf4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10348,8 +10348,12 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 			   enum nfnl_abort_action action)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
-	int ret = __nf_tables_abort(net, action);
+	unsigned int gc_seq;
+	int ret;
 
+	gc_seq = nft_gc_seq_begin(nft_net);
+	ret = __nf_tables_abort(net, action);
+	nft_gc_seq_end(nft_net, gc_seq);
 	mutex_unlock(&nft_net->commit_mutex);
 
 	return ret;
-- 
2.40.1



