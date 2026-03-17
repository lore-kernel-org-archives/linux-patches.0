Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26083F54DE;
	Tue, 17 Mar 2026 17:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767348; cv=none; b=pL3CxbbkOl3rS7XVyLQ5BhdlMSWfwN4tshrYHM53yAQsiqjmrZI19szJsq05CmsoUzOuL6qMzpyob4KNFXI2p83Lrlu3juVlSW8eFPA8GEa/myrrgjGhDDFViC9VkP2R0dTMjST/T4dcGLPRNGebGryyM7niNw6yu9OZBSHc4sQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767348; c=relaxed/simple;
	bh=rctog8/12so7nUHboPwJhvC5kWXPW6WFOETRIQ40RX4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRf5dUlXVbE03SJmqWrTmP1J0CJHxj55kx0+jI7olEtpmTEKXWTHH35k7gnEK/aMiOc3qiNNztzxAKMRNhYrKb5IOz8IAHUrrCI5scZo3TU5cJrpdza8yD1gvwG8RP1Q7YcnvW1kOxoLfs9SvKQe5tHoBpQ93JzhJfVxUs73oko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EQ4mhFx/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EQ4mhFx/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C24C4CEF7;
	Tue, 17 Mar 2026 17:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767348;
	bh=rctog8/12so7nUHboPwJhvC5kWXPW6WFOETRIQ40RX4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EQ4mhFx/GtQLbdwnuBRCcuBf5bPPWIOX+mL/ayfhceUQ0roeDt1BlkxK2zq0IXqnh
	 k0JdTF4G+si9AxGxFD0qiNnGnu1eahnQBYTMmBTIacNATPDW1mMO1P4+MMCYfZe0Kc
	 7HNkeILBETiOq1e31YRqN9BAPmGbzUESXD3Tz+G4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com,
	Helen Koike <koike@igalia.com>,
	Phil Sutter <phil@nwl.cc>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 066/333] netfilter: nf_tables: Fix for duplicate device in netdev hooks
Date: Tue, 17 Mar 2026 17:31:35 +0100
Message-ID: <20260317163001.820166866@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Phil Sutter <phil@nwl.cc>

[ Upstream commit b7cdc5a97d02c943f4bdde4d5767ad0c13cad92b ]

When handling NETDEV_REGISTER notification, duplicate device
registration must be avoided since the device may have been added by
nft_netdev_hook_alloc() already when creating the hook.

Suggested-by: Florian Westphal <fw@strlen.de>
Reported-by: syzbot+bb9127e278fa198e110c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bb9127e278fa198e110c
Fixes: a331b78a5525 ("netfilter: nf_tables: Respect NETDEV_REGISTER events")
Tested-by: Helen Koike <koike@igalia.com>
Signed-off-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c    | 2 +-
 net/netfilter/nft_chain_filter.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 598a9fe03fb0b..ed1d639fe34d7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -9841,7 +9841,7 @@ static int nft_flowtable_event(unsigned long event, struct net_device *dev,
 			break;
 		case NETDEV_REGISTER:
 			/* NOP if not matching or already registered */
-			if (!match || (changename && ops))
+			if (!match || ops)
 				continue;
 
 			ops = kzalloc(sizeof(struct nf_hook_ops),
diff --git a/net/netfilter/nft_chain_filter.c b/net/netfilter/nft_chain_filter.c
index b16185e9a6dd7..041426e3bdbf1 100644
--- a/net/netfilter/nft_chain_filter.c
+++ b/net/netfilter/nft_chain_filter.c
@@ -344,7 +344,7 @@ static int nft_netdev_event(unsigned long event, struct net_device *dev,
 			break;
 		case NETDEV_REGISTER:
 			/* NOP if not matching or already registered */
-			if (!match || (changename && ops))
+			if (!match || ops)
 				continue;
 
 			ops = kmemdup(&basechain->ops,
-- 
2.51.0



