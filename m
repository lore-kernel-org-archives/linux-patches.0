Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEDF131A78
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66F9AC433C7;
	Wed, 20 Sep 2023 12:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695214106;
	bh=PBH2+t77/J6fFOpcLTlJuSBxscv72kNgX6et6mJ8spU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L++DDIOZvPf6WWZdOJx+78z6z/vJsIzUzXTf6CCVbvnE2RORidMmS474RadLb+b2r
	 xJWGwLSqsCL6s1O+o7XTu4dp4px147ogR5/7RROX605/zvPlEbS4/FSv0zYPNCfLNX
	 vsGB+0DfjBXnSokJojR6Z/Y51jtLqrk8ZRDncPsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/110] netfilter: nf_tables: GC transaction race with netns dismantle
Date: Wed, 20 Sep 2023 13:32:27 +0200
Message-ID: <20230920112833.748584828@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
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

[ Upstream commit 02c6c24402bf1c1e986899c14ba22a10b510916b ]

Use maybe_get_net() since GC workqueue might race with netns exit path.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3e17d2403d899..33023b42698bb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8944,9 +8944,14 @@ struct nft_trans_gc *nft_trans_gc_alloc(struct nft_set *set,
 	if (!trans)
 		return NULL;
 
+	trans->net = maybe_get_net(net);
+	if (!trans->net) {
+		kfree(trans);
+		return NULL;
+	}
+
 	refcount_inc(&set->refs);
 	trans->set = set;
-	trans->net = get_net(net);
 	trans->seq = gc_seq;
 
 	return trans;
-- 
2.40.1



