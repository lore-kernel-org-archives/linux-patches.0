Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD6221A71F
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tQnwpktt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2886CC433C9;
	Mon,  9 Oct 2023 13:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858576;
	bh=Gd22lmOPcMffvT+ZOZpOSbo5timP7IMd15JAXrQWfrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tQnwpkttgMn20SsLPkD4IOO8zd9FwXcitxhluNiOSKvOyBN/s0d7eMaQ7GD4GC4PV
	 BoHwzgg/P72tcCiu5xbAFKsNO5SKwTaPKgnCZB1X55Zk2jaYg0ZHPFK0w+hUCPtDAq
	 tFwZjN4skMX1tRGWEHSVZ7rkSfCwDuCPAedNfUxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 026/226] netfilter: nf_tables: use correct lock to protect gc_list
Date: Mon,  9 Oct 2023 14:59:47 +0200
Message-ID: <20231009130127.439319313@linuxfoundation.org>
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

commit 8357bc946a2abc2a10ca40e5a2105d2b4c57515e upstream.

Use nf_tables_gc_list_lock spinlock, not nf_tables_destroy_list_lock to
protect the gc_list.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 1f67931b86d8e..9fc302a6836ba 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8065,9 +8065,9 @@ static void nft_trans_gc_work(struct work_struct *work)
 	struct nft_trans_gc *trans, *next;
 	LIST_HEAD(trans_gc_list);
 
-	spin_lock(&nf_tables_destroy_list_lock);
+	spin_lock(&nf_tables_gc_list_lock);
 	list_splice_init(&nf_tables_gc_list, &trans_gc_list);
-	spin_unlock(&nf_tables_destroy_list_lock);
+	spin_unlock(&nf_tables_gc_list_lock);
 
 	list_for_each_entry_safe(trans, next, &trans_gc_list, list) {
 		list_del(&trans->list);
-- 
2.40.1



