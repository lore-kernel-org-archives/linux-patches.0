Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3377D41B8CC;
	Sat, 12 Sep 2026 13:21:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219285; cv=none; b=Y72hXkgP6s8uVB1H1/VaFN0hjlqhQOaC+1plMbN3r08neoRWnGege4x1X8gK1WNXPwCS6wDqqQes/o8RljkqSPPLENYb3XSb5isMbyFGqQKHf0WR68GLXALVFRdmekDGJnQuXLcXZ2Gg0jCvH/FAgZgb8wnqK8/w2I66XO7/37s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219285; c=relaxed/simple;
	bh=7LdGWZbDvwD2vsVpjTrFk76ka23UCZ0kGVqsof1EYhk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVlucjFw0iAyL6UjkygiUZIRL/itEQFuzDUM69eYxGeMfuFyicApHukgcKjSHAj51SxmWKIwL5eha/EzaK4pxGJ7pSNiRB8lQaI0Ky76FdbEqM8I1bE5derUpw2s5iyiOagNcPtjUFwL40MkwwDHUTbnc1VGHpf8vuNTFmEdMvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6X3CEo7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6X3CEo7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 041AA1F000FF;
	Sat, 12 Sep 2026 13:21:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219282;
	bh=josTEEoQx1/SDdjyfsYDzy8gFKlyLJ98AjO5S8wVokQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O6X3CEo79GTF4BAG0dndqPKL1j9IN/0X0tJ0BQlX6n8kYk1zr/JRCmuj5tMmV7i40
	 EjlpKQCkDDE2I6YC+goZJLZrtFcEdJEDvgiM4c1oJZD9C3rOf9xkKf60jVEcvSpJbF
	 x02Zk5us969DqT2JXxs1OeI9DaLXffvxiaPN24xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1319/1376] netfilter: nf_tables: move hardware offload step after building the chain blob
Date: Sat, 12 Sep 2026 09:02:25 +0200
Message-ID: <20260912065636.928884079@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b1881d362e1924b66f6016c3efd28807032b41bf ]

Allocate the chain blob before the ruleset offload to reduce chances of
entering an inconsistent state where the offloaded ruleset in the nic
and the software ruleset differ.

Fixes: c9626a2cbdb2 ("netfilter: nf_tables: add hardware offload support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 12b9e1970883d..2613ebfdc854e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10271,10 +10271,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		return -EAGAIN;
 	}
 
-	err = nft_flow_rule_offload_commit(net);
-	if (err < 0)
-		return err;
-
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		struct nft_table *table = trans->table;
@@ -10299,6 +10295,16 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		}
 	}
 
+	/* must be last, so audit and chain blob set up does not leave hardware
+	 * in consistent state.
+	 */
+	err = nft_flow_rule_offload_commit(net);
+	if (err < 0) {
+		nf_tables_commit_chain_prepare_cancel(net);
+		nf_tables_commit_audit_free(&adl);
+		return err;
+	}
+
 	/* step 2.  Make rules_gen_X visible to packet path */
 	list_for_each_entry(table, &nft_net->tables, list) {
 		list_for_each_entry(chain, &table->chains, list)
-- 
2.53.0



