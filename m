Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6F726156E;
	Tue,  8 Apr 2025 12:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115306; cv=none; b=kgLQdT0DiYC+NojbZAaw4e9vi73/0rg+BJXRFCW5IqqgkXh8AkMmkH5jiX3n+wlzByRpszk1h41U8zUPs9Cr64f38BCzcVovBMi/WMHu4PF9dDGEZgHq0QWeJXL63qyWAq76uvBslcQDkTkqc8gC4ozETDpKATq1JS/1BcjFBLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115306; c=relaxed/simple;
	bh=IWEHiPa7NEbs/SFUBGU2/9acyA9CyQtTdfJXmXeB8Jw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owcu9qBHkjanH7onCucZHk7cba+DNZ4HTVa5bZbsOPF3XuyF4cf03Kkoa3rcGw5epUcxSk+E8Y4zoG9vR4A2YV/2tXYG5IhfxHwlnTRDixNZ0nWoY0n5fYIllQtg3XjrvrlZNUYaMSvWu+o8Bo5Atdh0z4UkDKDJNraehZCM8Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WSQh4dkM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WSQh4dkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4B9C4CEE5;
	Tue,  8 Apr 2025 12:28:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115305;
	bh=IWEHiPa7NEbs/SFUBGU2/9acyA9CyQtTdfJXmXeB8Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WSQh4dkMEw4S4B7PT6L+p8iD/gJ7rbIEx3miMSkBsxslCFvaiDmeC/CD6+uCfe2bj
	 kcBuwDdXkfyqXqrEqY9Y99BZOzF6iLqiEqP4f4n/G4Kcts2zDvBvLj8HkwYlw5opPW
	 bMHv4mMZVbxApcFV4mcbs6ZXJM+LFU5NDpnXPMS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 386/499] netfilter: nf_tables: dont unregister hook when table is dormant
Date: Tue,  8 Apr 2025 12:49:58 +0200
Message-ID: <20250408104900.858506634@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 688c15017d5cd5aac882400782e7213d40dc3556 ]

When nf_tables_updchain encounters an error, hook registration needs to
be rolled back.

This should only be done if the hook has been registered, which won't
happen when the table is flagged as dormant (inactive).

Just move the assignment into the registration block.

Reported-by: syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=53ed3a6440173ddbf499
Fixes: b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 99f6b2530b96e..712adede565c8 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2835,11 +2835,11 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 			err = nft_netdev_register_hooks(ctx->net, &hook.list);
 			if (err < 0)
 				goto err_hooks;
+
+			unregister = true;
 		}
 	}
 
-	unregister = true;
-
 	if (nla[NFTA_CHAIN_COUNTERS]) {
 		if (!nft_is_base_chain(chain)) {
 			err = -EOPNOTSUPP;
-- 
2.39.5



