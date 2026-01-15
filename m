Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCA6033993;
	Thu, 15 Jan 2026 17:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497091; cv=none; b=N/t1uo3x09iWmLfDLCxGcejyhhnlWXVbmgnoed9ZlOonp5F8VnI0OzjX37AbpSOizbnbvWHOSxvMdtYSTEQJyAmyQXJoPJalBY5IZQBtL7TcB7otci9TqioEVdyUhBhegdHFJuL1wVvbZZzqeEHeaSLDvAem33jeFp26ZeNrBxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497091; c=relaxed/simple;
	bh=DidZO0CFzpjzkfbQRSb5hEVHEPeT0UKwJRL4aMViAa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jO2tlepCm8Mkb6hiHbiYBsgTc9DeWmhJCwoEAbSPYqIXH5mVR/rdjC41cIDyKGvqdy+intOwFUcJ5FF7ifGp72wgvqlMVtjo7TNaN7K8g/rsJNMeVdbnXUi0/EB2fiVPfMZfA9sMh5HQ8p7C9LROG70vyUWq+TMBpn7ow1u+dzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zEH6SPue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zEH6SPue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AE3AC116D0;
	Thu, 15 Jan 2026 17:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497091;
	bh=DidZO0CFzpjzkfbQRSb5hEVHEPeT0UKwJRL4aMViAa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zEH6SPueMWrOw75jX/qHPlYXnK9V7Du4Us1Eznox+Ni5tiohtjzj4PT2MDmMqKCgT
	 xj5oEvcfWRSM2sgLMjFhOEQsrAAAOwb2McPEkF5AcwffldfkLOhL9LwCWVL7IQm9Me
	 Ba/0MWhCQeE42+wyNIt+9O19qAOPFrH3MZnOdy3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 34/72] netfilter: nf_tables: fix memory leak in nf_tables_newrule()
Date: Thu, 15 Jan 2026 17:48:44 +0100
Message-ID: <20260115164144.731704255@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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
index b278f493cc93c..d154e3e0c9803 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3811,7 +3811,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (!nft_use_inc(&chain->use)) {
 		err = -EMFILE;
-		goto err_release_rule;
+		goto err_destroy_flow;
 	}
 
 	if (info->nlh->nlmsg_flags & NLM_F_REPLACE) {
@@ -3861,6 +3861,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 err_destroy_flow_rule:
 	nft_use_dec_restore(&chain->use);
+err_destroy_flow:
 	if (flow)
 		nft_flow_rule_destroy(flow);
 err_release_rule:
-- 
2.51.0



