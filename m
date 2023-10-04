Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B5A91D523
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00F6C433C9;
	Wed,  4 Oct 2023 18:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696442554;
	bh=Cm6L9Onu2fhkg9aLVEQlXSWgiIitT8ku9LJAJHFygF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TGktT7lKmxzAEzWuyXXLzilHhZFTEHr8ko+zegSgvPKHqOfelkj58836aX1aVTtnW
	 RcrqURqfLTHldOedZrn8mhZ1jXdH+46NvJtD6KAI4ixuWdyicPn7+mF8fGIN5dFfKI
	 EaBZYV6lRtQr1ZS0cgpP4JrSElUSfXUSJ6Gpboxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 026/183] netfilter: nf_tables: use correct lock to protect gc_list
Date: Wed,  4 Oct 2023 19:54:17 +0200
Message-ID: <20231004175205.049462196@linuxfoundation.org>
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
index c9a3a692879a8..ac266dc2c31b7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -8925,9 +8925,9 @@ static void nft_trans_gc_work(struct work_struct *work)
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



