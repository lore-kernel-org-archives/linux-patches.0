Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8911929C338;
	Thu, 15 Jan 2026 17:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496583; cv=none; b=PvxWbWRYt5iBVEQoLRLWXdNHjr/tXyMxz45xnE6x9CxND8iC25kg2XeKtyTuR/G+rDSCPIK/nCg0qO1JYKu3rQUE5roq8ONmvrIb4MhmQQMZnRR7zeN1ZHnEqcjr8LqyWQ8TZGmObDFHL97Pu4AmbM74A/F/rdCxCI45643QEl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496583; c=relaxed/simple;
	bh=RdSI4UZCTxfYlkKZp/BEIPU7q2VugBIqCa5GvKdBeic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jPMTXo+mvUQi0WUy+MvXQ5XZzg6bnHwqcwPjGSHfV/CYZ9v/t30lQpJ6Vn/zeru38RylhB0hbaR65dqsXgFDP5OLGPtT8FrvigFNZgcAXSoQLQMeRIVrX4bFoAmJ3sc4IGW9ci8/ujrBtxMyUIs1b1MYMfeGJ4FDRHdTZDqbjrE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1vlb2pG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1vlb2pG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16790C116D0;
	Thu, 15 Jan 2026 17:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496583;
	bh=RdSI4UZCTxfYlkKZp/BEIPU7q2VugBIqCa5GvKdBeic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y1vlb2pGc14Rv58HWaSNOOi4VosI9gEBbJIV4pPh6BNCzpuVU5iLXAyErM6jiAL2z
	 rjSuzgtcVstk2vpqwMs0GQSonjzQV5VEqGR3KmzV6KsCawzH1YK4kasOj83ElpXdrP
	 4TbpAZb/gTsAKACZmoYnsP3VYlR/zweV8Ve0xyxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 062/119] netfilter: nf_tables: fix memory leak in nf_tables_newrule()
Date: Thu, 15 Jan 2026 17:47:57 +0100
Message-ID: <20260115164154.194459533@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

From: Zilin Guan <zilin@seu.edu.cn>

[ Upstream commit d077e8119ddbb4fca67540f1a52453631a47f221 ]

In nf_tables_newrule(), if nft_use_inc() fails, the function jumps to
the err_release_rule label without freeing the allocated flow, leading
to a memory leak.

Fix this by adding a new label err_destroy_flow and jumping to it when
nft_use_inc() fails. This ensures that the flow is properly released
in this error case.

Fixes: 1689f25924ada ("netfilter: nf_tables: report use refcount overflow")
Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index b4741fb337988..6a2b7ce67e7f3 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4196,7 +4196,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (!nft_use_inc(&chain->use)) {
 		err = -EMFILE;
-		goto err_release_rule;
+		goto err_destroy_flow;
 	}
 
 	if (info->nlh->nlmsg_flags & NLM_F_REPLACE) {
@@ -4246,6 +4246,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 err_destroy_flow_rule:
 	nft_use_dec_restore(&chain->use);
+err_destroy_flow:
 	if (flow)
 		nft_flow_rule_destroy(flow);
 err_release_rule:
-- 
2.51.0



