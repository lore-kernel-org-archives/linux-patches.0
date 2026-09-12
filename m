Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1FA426ED46;
	Sat, 12 Sep 2026 19:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240792; cv=none; b=O1eKg9hy9zBjZRL+jpdYGUg21G/Lfvy1kEA6PfDs8YgN+jiAQ9jUZdmpYl9O1h9EyARspj7kKiiXjfWdPEhv+KZ7pBjGUUs0AbBQLR3hnYaX4/tP1rGRWvL3SFYyiS3oA/TFce67KKe4M1IUEqGFv1dpfyF34KIonpOxqZWSVa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240792; c=relaxed/simple;
	bh=cqaNpnih0c2glCiL5iNpXGI0jZEb2i4rHjv9i/XCYGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D130CDY785ia2jSrcahfqZ7W5BTbAPepqUEKj6AYXghkTJdlaTN3TeionKz3Qw6HWY/WjkV1RFTOwkkiDSWzsaM8DS1ptFEdihtQmTH1WS7iShoi2IiyhlsCPgedaHhS+hTPrKC7tugM7+S3Xy0tlgNVxioaxYQdrNKtmCWHXkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wYELh0sc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wYELh0sc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51C741F000FF;
	Sat, 12 Sep 2026 19:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240791;
	bh=4xrP7CAk7noWbovYLvfZzk3K78E18PupYNSRT8sQ3cw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wYELh0scwROS4AVVtTmhlPID85ugd/Y/mqLxKfNDuA4OcUsUh+Dy07yVTKmQexNQ+
	 5nhcRq9oIlLJDAleR0gPwomHWenHK8xiBJAhpZlMYwtXzWN78vZp/t1vCh6I9bkqHJ
	 9rufYa4ddv3PR6sa1nbkgwhBkuucGIf+0xm44TEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 909/935] netfilter: nf_tables: move hardware offload step after building the chain blob
Date: Sat, 12 Sep 2026 09:05:39 +0200
Message-ID: <20260912065547.666880577@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 021a2a34b8a12..c1b5b579ccd72 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9505,10 +9505,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	if (nf_tables_validate(net) < 0)
 		return -EAGAIN;
 
-	err = nft_flow_rule_offload_commit(net);
-	if (err < 0)
-		return err;
-
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		int ret;
@@ -9532,6 +9528,16 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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



