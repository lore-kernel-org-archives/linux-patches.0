Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6E941D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:02:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D3FC433C7;
	Wed,  4 Oct 2023 18:02:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442551;
	bh=G5XcXIjSY9p49gkEq18qignOOUX8M+LmrrXFT0YEsEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EU1tV/ZcGteVKN92VmreFcN2yvVCCz7F7oaoAZTBmRUTYINcoK75JWr75bLImJ0VE
	 6KouPM0S7pIRu/dSZGinUThkzbQMhc1NoqpdiqNy0VZpn4XYJHn1DcJrEYe+/ve7Tn
	 IbSGOe8anktZ5xpHzyhuwAs6UplbwOzdrfI9VYVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/183] netfilter: nf_tables: GC transaction race with abort path
Date: Wed,  4 Oct 2023 19:54:16 +0200
Message-ID: <20231004175205.010968378@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
References: <20231004175203.943277832@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 720344340fb9be2765bbaab7b292ece0a4570eae upstream.

Abort path is missing a synchronization point with GC transactions. Add
GC sequence number hence any GC transaction losing race will be
discarded.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a2543db74cf65..c9a3a692879a8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9763,7 +9763,12 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 			   enum nfnl_abort_action action)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
-	int ret = __nf_tables_abort(net, action);
+	unsigned int gc_seq;
+	int ret;
+
+	gc_seq = nft_gc_seq_begin(nft_net);
+	ret = __nf_tables_abort(net, action);
+	nft_gc_seq_end(nft_net, gc_seq);
 
 	mutex_unlock(&nft_net->commit_mutex);
 
-- 
2.40.1



