Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD441BDF0;
	Wed,  3 Jan 2024 17:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cQ2WGPBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C98DC433C7;
	Wed,  3 Jan 2024 17:01:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301299;
	bh=anUIZahRW955cASBOCk3xjCctJz5uEUrcLcu6JsAYTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cQ2WGPBru/MD0IikISYNUL7lbECFF+oNrLLbZNjaUhfg5KNsQQKTTv9hX5uhK5s5w
	 lhzVhxarfeFhcjXmm/a/vxd39W0NJPF1e2EMcOXJB+qQvRkGYYIX08g4EO07odgZy8
	 orLz8IZFBngBSm4ph/d5Rx3DwbydvOMXgYG3nLnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Rich <kevinrich1337@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 094/100] netfilter: nf_tables: skip set commit for deleted/destroyed sets
Date: Wed,  3 Jan 2024 17:55:23 +0100
Message-ID: <20240103164910.247031578@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164856.169912722@linuxfoundation.org>
References: <20240103164856.169912722@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 7315dc1e122c85ffdfc8defffbb8f8b616c2eb1a upstream.

NFT_MSG_DELSET deactivates all elements in the set, skip
set->ops->commit() to avoid the unnecessary clone (for the pipapo case)
as well as the sync GC cycle, which could deactivate again expired
elements in such set.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Reported-by: Kevin Rich <kevinrich1337@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9480,7 +9480,7 @@ static void nft_set_commit_update(struct
 	list_for_each_entry_safe(set, next, set_update_list, pending_update) {
 		list_del_init(&set->pending_update);
 
-		if (!set->ops->commit)
+		if (!set->ops->commit || set->dead)
 			continue;
 
 		set->ops->commit(set);


