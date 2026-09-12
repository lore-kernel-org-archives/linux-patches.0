Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99B72F7F17;
	Sat, 12 Sep 2026 15:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226324; cv=none; b=hCH2AZpH5Z8BF3q859dbohXQzjgtEkjY0xfbCahzphjqqO8KF0zs/GlB1c6FMr6uw0zCPSqVBlEmEDWLcjMcMzFxF7WQJ5rVfCOfxE6uA2JVK5n2ZzqBFBe8bpvdxK4SkLy5bRA4PGxjdMMbdYM2HaIxAPfsfunG0SygBYv6ObY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226324; c=relaxed/simple;
	bh=vO2G55pFiIv6afICODBGrM07ZU69jVkED/+gVYfUIuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+HxfgKaepsAOcxjakcpvxhdzK/I07XKZpDPbHOx05QLdwAARxpDV/ARc1iy9hZlVwEa0DyJFF111M+xepRBBN6CVAdtzhGmEklZtrjuKA9uKLF5zJtSi54QUXoxSNwejpPO5VRO6s2sjuf3GVLWf9v0lJ/LdHQVixTwfKVpb+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O4OrJcHi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O4OrJcHi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC91E1F00893;
	Sat, 12 Sep 2026 15:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226323;
	bh=GuWVwAVRx97uHVTEhvLGfRjfc2+qLkCRyGXpavCfXT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O4OrJcHi9uQrACdRdEwi/3XDEWtVv6exgC9xaFO97DY5x1UTkFsgiD+ofHjYaUTOR
	 qMSQmQ4jBAdPk+9etCm1rNeyWuuZ415DmPFZoEFSrwxwzB9GUJ3C2GDvvkBTnHD24p
	 gVTyljzWjv3Z4QMzNCKt72oUcUjRHwpNrbhVah+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1380/1424] netfilter: nf_tables: move hardware offload step after building the chain blob
Date: Sat, 12 Sep 2026 09:03:32 +0200
Message-ID: <20260912065638.161571852@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2c894a7d8a401..a9053667e3702 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -10214,10 +10214,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		return -EAGAIN;
 	}
 
-	err = nft_flow_rule_offload_commit(net);
-	if (err < 0)
-		return err;
-
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		int ret;
@@ -10241,6 +10237,16 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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



