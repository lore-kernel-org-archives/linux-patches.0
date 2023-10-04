Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E86531D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:02:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A449C433CA;
	Wed,  4 Oct 2023 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442548;
	bh=QK8Z6jHgI/QOMSZy8hv7DNSi73yxidy3MXIiieybFMw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2o1kXbYCmpgOmCM3apr0ic4mlA6RJGB7D8XyBjKPF/tchQ1jjQ6TyNSW3S3X7AwFN
	 LCCkEXWMAtjU8saZKlyHoplawxaw6MDSq4T6BK/1E3h6XCYC1bcit7lPkv8YKsZX9c
	 H/zj1QPHQ0jF6KB5FxIZXgUU4TEFW+D96Ef8W7eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 024/183] netfilter: nf_tables: GC transaction race with netns dismantle
Date: Wed,  4 Oct 2023 19:54:15 +0200
Message-ID: <20231004175204.961206646@linuxfoundation.org>
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

commit 02c6c24402bf1c1e986899c14ba22a10b510916b upstream.

Use maybe_get_net() since GC workqueue might race with netns exit path.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index aadcb2a5dc816..a2543db74cf65 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8949,9 +8949,14 @@ struct nft_trans_gc *nft_trans_gc_alloc(struct nft_set *set,
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



