Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 397AE1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctQu3tIk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4B5EC433C8;
	Wed,  4 Oct 2023 18:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443846;
	bh=EuX+YYff5gTgeI9L4hVd5OEqcMjFHB8dZ6VqsK600TY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctQu3tIkhLC8mh3eK3HZEBz73JUfBIvdO7t0ISFPZjbL/kvYYE4h3hvwBSOaHDU7T
	 9uKqT7HXQue7ApYNId6vpeB//MS4WHzH0SFWYMkDxXx3ub93O79FgjE7iu6LNLHsuy
	 g10gYjKkYhrcfmusTQurtu51EGpHhyrvUlMPViLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Phil Sutter <phil@nwl.cc>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 041/321] netfilter: nf_tables: Fix entries val in rule reset audit log
Date: Wed,  4 Oct 2023 19:53:06 +0200
Message-ID: <20231004175231.068831891@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit 7fb818f248cff996180b7cdcdcb86b6b4f6e44e2 ]

The value in idx and the number of rules handled in that particular
__nf_tables_dump_rules() call is not identical. The former is a cursor
to pick up from if multiple netlink messages are needed, so its value is
ever increasing. Fixing this is not just a matter of subtracting s_idx
from it, though: When resetting rules in multiple chains,
__nf_tables_dump_rules() is called for each and cb->args[0] is not
adjusted in between. Introduce a dedicated counter to record the number
of rules reset in this call in a less confusing way.

While being at it, prevent the direct return upon buffer exhaustion: Any
rules previously dumped into that skb would evade audit logging
otherwise.

Fixes: 9b5ba5c9c5109 ("netfilter: nf_tables: Unbreak audit log reset")
Signed-off-by: Phil Sutter <phil@nwl.cc>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 018cf368f6a5f..3e6839c03bccc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3451,6 +3451,8 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 	struct net *net = sock_net(skb->sk);
 	const struct nft_rule *rule, *prule;
 	unsigned int s_idx = cb->args[0];
+	unsigned int entries = 0;
+	int ret = 0;
 	u64 handle;
 
 	prule = NULL;
@@ -3473,9 +3475,11 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 					NFT_MSG_NEWRULE,
 					NLM_F_MULTI | NLM_F_APPEND,
 					table->family,
-					table, chain, rule, handle, reset) < 0)
-			return 1;
-
+					table, chain, rule, handle, reset) < 0) {
+			ret = 1;
+			break;
+		}
+		entries++;
 		nl_dump_check_consistent(cb, nlmsg_hdr(skb));
 cont:
 		prule = rule;
@@ -3483,10 +3487,10 @@ static int __nf_tables_dump_rules(struct sk_buff *skb,
 		(*idx)++;
 	}
 
-	if (reset && *idx)
-		audit_log_rule_reset(table, cb->seq, *idx);
+	if (reset && entries)
+		audit_log_rule_reset(table, cb->seq, entries);
 
-	return 0;
+	return ret;
 }
 
 static int nf_tables_dump_rules(struct sk_buff *skb,
-- 
2.40.1



