Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A10C2BDC0E;
	Sat, 12 Sep 2026 11:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212465; cv=none; b=gXluxAOITO9ZoeI1NZLOrhsIvGffn2WVOAiyjhHNd1Fx86n7HVC+raTaYZKCzuuN8HUW8Wh6n6ZsEDqkWNiKsD5dQl/IPpn1IaOTKaWmhq7Z89DJl/umCKGERWhGhqpcVZtIWzVrpe+DtZOj4AI1JPEIqTfNUObEFAmBK+0v598=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212465; c=relaxed/simple;
	bh=wbuKDSgN1fGgOBs703c2pN9I+I4i6JZcvDsDUNisHNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aybD3EccvRDsO9x2Y6PlM/01LlbWqwCo3T4iGzAk/OswNstWz19FcTqwlN6/OevT+knruy7j8RlR8kuwFkVZupiZotMK5fLQqGDGzY44JG205JGYVPK1N8MmUo+gUb2E0hIzt8Rp+TiKBVb2FmHRFUb3IzwJkPq066QpSEzZGDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8AKdaUS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8AKdaUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6F3A1F000FF;
	Sat, 12 Sep 2026 11:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212463;
	bh=I8zoYQSFmd4QVJrWy+4jRjRmZMKGi3D5cygC3n1LSsg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d8AKdaUSjoXgALZJV0qI9HhMmu2tYpUCpt2L92gFKlYBM+WcGRHJqvUaVDqpmrdbE
	 3KVQzOIwrxG+F8Sk7Ar3K5Ao7ql8pnh0sO7l0Stlq/lfxsnlZ9FpvTTUqjq5xtf3V1
	 OHAvZt77Wc8KXY+pt2ELANqmCxR9e+b7SHW9VFxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1442/1518] netfilter: nf_tables: move hardware offload step after building the chain blob
Date: Sat, 12 Sep 2026 09:00:11 +0200
Message-ID: <20260912065656.176746983@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d01f96d32f282..a3a66b6268cd6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10774,10 +10774,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		return -EAGAIN;
 	}
 
-	err = nft_flow_rule_offload_commit(net);
-	if (err < 0)
-		return err;
-
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		struct nft_table *table = trans->table;
@@ -10802,6 +10798,16 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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



