Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D000D171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 325C4C433EF;
	Mon, 22 May 2023 19:51:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785115;
	bh=Ywx6IFMbBrrFl9cOOrJYcsCm20fDCw8vmKZ2GGHJ51k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vxqBWQjDI+r6DLJ/PWi1LOKpRbE9RS+y12+DXxBYNcyxteTNxhsw8OdfAZNus0Pzd
	 18loNo3hT3UoOE6SPMz2wv+6FKfoLue0vN2xuqV/3iW9W8fGMWZ49hS/43X8RLALVz
	 uIP38sRVO40VXjcOD9Mh6sWxwWpU4ezdkpRVFPN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 286/364] netfilter: nf_tables: fix nft_trans type confusion
Date: Mon, 22 May 2023 20:09:51 +0100
Message-Id: <20230522190419.897956918@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

[ Upstream commit e3c361b8acd636f5fe80c02849ca175201edf10c ]

nft_trans_FOO objects all share a common nft_trans base structure, but
trailing fields depend on the real object size. Access is only safe after
trans->msg_type check.

Check for rule type first.  Found by code inspection.

Fixes: 1a94e38d254b ("netfilter: nf_tables: add NFTA_RULE_ID attribute")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 45f701fd86f06..ef80504c3ccd2 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3802,12 +3802,10 @@ static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 	struct nft_trans *trans;
 
 	list_for_each_entry(trans, &nft_net->commit_list, list) {
-		struct nft_rule *rule = nft_trans_rule(trans);
-
 		if (trans->msg_type == NFT_MSG_NEWRULE &&
 		    trans->ctx.chain == chain &&
 		    id == nft_trans_rule_id(trans))
-			return rule;
+			return nft_trans_rule(trans);
 	}
 	return ERR_PTR(-ENOENT);
 }
-- 
2.39.2



