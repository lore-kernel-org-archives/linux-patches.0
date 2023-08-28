Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A7B08BE0
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DAA7C433C9;
	Mon, 28 Aug 2023 10:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218046;
	bh=YeYbUHnJ9DiiDPgwvusWIoswMMDpGkH982eva3I6pkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0gbhXK9HoDhgDW/VSmQB1Za2SBZ1monbJv/K37oPolrtap7Z4ETxNogmQvyrZ9huP
	 QDjrHvkKaxlVsoeZ3y94FEyVR9s4mJOGEx2XoOaN/Ntf+gMN3VYu4oVBrtgTg8/3eJ
	 PhmxIlkBTRFDVcPHQ27MvEn1lw6vyLGM3Ba6Eqhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 046/129] netfilter: nf_tables: use correct lock to protect gc_list
Date: Mon, 28 Aug 2023 12:12:05 +0200
Message-ID: <20230828101158.900401865@linuxfoundation.org>
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

[ Upstream commit 8357bc946a2abc2a10ca40e5a2105d2b4c57515e ]

Use nf_tables_gc_list_lock spinlock, not nf_tables_destroy_list_lock to
protect the gc list.

Fixes: 5f68718b34a5 ("netfilter: nf_tables: GC transaction API to avoid race with control plane")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 9cd8c14a0faf4..ad38f84a8f11a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9470,9 +9470,9 @@ static void nft_trans_gc_work(struct work_struct *work)
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



