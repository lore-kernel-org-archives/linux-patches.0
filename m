Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A49A53BC4D7;
	Thu, 15 Jan 2026 17:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496878; cv=none; b=oIrCKfY91o9qQLS3clkBkGlr5lzt58PGChQ/bD50t2c1QptdN4tTpvybhI8PzOQQkIjMGj4tyeyGJqtdyXhRbg+isvtpwE0yc22DwMFWUn7Jic0g2vtV7UrSxrLYQvCglFZEIlH87j7uvP36gVWfBotHoAfjCltzo7dcehBf4Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496878; c=relaxed/simple;
	bh=kpXjEIbC4AggIgCLmBmdlm+EbDMG8gw0KqvhbO0ABGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mEf67jzeMMEd8XnjO8O5x8isy88OXF3wMVJpvUTXtqeiYq93nprVna+UzdNs4yMqoou1QLD6bMeA7yUJwhdmR8422p9cKNIMZz/QMfBKgiIVHJ9MazJhmIDlivMkf+fPA1BfHCDPRIJzbiHuhOkHBBCysx8A7IadcNHrzVFMN0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yoEZTlTX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yoEZTlTX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17668C116D0;
	Thu, 15 Jan 2026 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496878;
	bh=kpXjEIbC4AggIgCLmBmdlm+EbDMG8gw0KqvhbO0ABGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yoEZTlTXHzMkFKGJTIKg7IVlIpMOG9LOkC0GZLWEXfw1osW48SdEZswKQXYu5MatI
	 aL1IDbIyR2iZAvw84NXGNzdKLFpOz/Uinqb/EtbLrZKMgrYOQoOSfO4fi7I6il+MUD
	 iNCqOPCQwFJUM3Goqzj/gG8Dnvr5vTcvZ6W50Ns0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zilin Guan <zilin@seu.edu.cn>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 48/88] netfilter: nf_tables: fix memory leak in nf_tables_newrule()
Date: Thu, 15 Jan 2026 17:48:31 +0100
Message-ID: <20260115164148.049445530@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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
index 394ee65e1d35f..43ebe3b4f886a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4098,7 +4098,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 	if (!nft_use_inc(&chain->use)) {
 		err = -EMFILE;
-		goto err_release_rule;
+		goto err_destroy_flow;
 	}
 
 	if (info->nlh->nlmsg_flags & NLM_F_REPLACE) {
@@ -4148,6 +4148,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 
 err_destroy_flow_rule:
 	nft_use_dec_restore(&chain->use);
+err_destroy_flow:
 	if (flow)
 		nft_flow_rule_destroy(flow);
 err_release_rule:
-- 
2.51.0



