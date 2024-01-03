Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2881C283;
	Wed,  3 Jan 2024 17:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vI49lt1J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31230C433C8;
	Wed,  3 Jan 2024 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704302138;
	bh=mk2Uy7do4g6sGnphQsxWzMkpBCdLAKoC8AwQIsgs42Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vI49lt1JiAlMiguJrX1zRnopckcfiUILnaseRKKk3YOh74Pqu91m/Qjoq9qTf8dhJ
	 mO6otU5GjLmoZfwwEtKPkVe7LmH9j+oxsZzVHsmZztp98avce2Ay8Arh/pTmP9OI8m
	 X+jSJ7bwnyiCyKPy5Q6xTVXOeyp+zD8nZkTissDs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Rich <kevinrich1337@gmail.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.6 49/49] netfilter: nf_tables: skip set commit for deleted/destroyed sets
Date: Wed,  3 Jan 2024 17:56:09 +0100
Message-ID: <20240103164842.593448811@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
References: <20240103164834.970234661@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -9849,7 +9849,7 @@ static void nft_set_commit_update(struct
 	list_for_each_entry_safe(set, next, set_update_list, pending_update) {
 		list_del_init(&set->pending_update);
 
-		if (!set->ops->commit)
+		if (!set->ops->commit || set->dead)
 			continue;
 
 		set->ops->commit(set);


