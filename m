Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D004C3C07A;
	Sat, 12 Sep 2026 16:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232031; cv=none; b=lK3WBVyaAEsLEth0UTjJYpteHIFmgFVDMZZgN4QUqY0vCTmHJcqHTVw3tGOFXDv+b6zBfOIB8+NwXIrjn2ZtmEACblr3UzCCeU+IWJM7bPbhxSzSmZtkbr8CqzaKEYzGKCnPc1YWr15PgXnk6fjYLnC+z/0u8z2ArCPOaHUJ+LI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232031; c=relaxed/simple;
	bh=7yjhA/J2wd7A+NZf7ehnoxyQWhIhJMcFWDECBFH+6Ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MM6wHQEjDMDTA5vuK+ncNObLtagGVDRfArk9E+O9VOQzjLOpLwb64c09KMg4liSIMgf9+cRPMZAOAjvS1OU9v0WgqkzIYynmzbGqM2yIuWHyUm+lZuOhVhfNdMYrTCjLALkgk2A7VNSolEertlzfxZsoi5P1vw7OcFEixEvy5/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xvVs5Wxk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xvVs5Wxk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E2421F000FF;
	Sat, 12 Sep 2026 16:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232029;
	bh=NNxOI/W3a/0TEGPxWLCGvdnbaAJrn1SJ02H/InzG1EI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvVs5WxkDPD/KhNtZm6Vv9aHWgqaPqrP9wxvDdXYeBoYDJAUGXjUO+zpQcVsa7B6N
	 aOYf24olVQpbP1z0c/UTWtbCgg1L5jGyPNgzlO5gx237FG5kDgXandwAV0qSUcUkb8
	 pFowp5Kw3mNYiDlgQ42abS7uEUSnRhMSxy96erfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1120/1191] netfilter: nf_tables: move hardware offload step after building the chain blob
Date: Sat, 12 Sep 2026 09:04:08 +0200
Message-ID: <20260912065613.309359320@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 1baf5253d635a..96b0638c220a7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9793,10 +9793,6 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	if (nf_tables_validate(net) < 0)
 		return -EAGAIN;
 
-	err = nft_flow_rule_offload_commit(net);
-	if (err < 0)
-		return err;
-
 	/* 1.  Allocate space for next generation rules_gen_X[] */
 	list_for_each_entry_safe(trans, next, &nft_net->commit_list, list) {
 		int ret;
@@ -9820,6 +9816,16 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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



