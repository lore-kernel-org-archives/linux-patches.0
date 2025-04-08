Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB8022690D0;
	Tue,  8 Apr 2025 11:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113561; cv=none; b=JLzFm74z8fjSLfVfCDcf/Ab+dJ1/zuziF6QX1BMWKUZXZGVix4VQwJ3ugsRyGmfJhElmQUrgmpqd46y17AJFFDlN2R0j/CNcvaOZi3KWL0i7q27qu4nlVImmTFa4kt/wTAZLg9vKt1Xd9UkRhqrENd1cKHuUY7a38bKXxbneW2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113561; c=relaxed/simple;
	bh=2LFnuOOdln4FH2FMBimodxWhnfFTICCVgaL/3V54qm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YU8IJitOnA9URTFitHwmyn6LacIau3UabBy4+7atN6DQGfjR+YjPBQoryRa8tmZrLWeByPihHFWesv6SZspZuIk/IDv17AG/XXUEIkoNP2bwekOw773vPIzx2msUUivFgaTATfxyk1tc8vZGWxUiBdbOnrSS3feuPYVvTZ/t5mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0a/R4UJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0a/R4UJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27626C4CEE7;
	Tue,  8 Apr 2025 11:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113561;
	bh=2LFnuOOdln4FH2FMBimodxWhnfFTICCVgaL/3V54qm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0a/R4UJ4QG9Q7aej3RoT1Yq+K3gsemS5Y4wGnB16MtNBcrxLPqED8vrTD1xAeqPi
	 o9r3xRVKQzyNXaVVLWu61/9SkRRPxA68bFXGbP7wYgZ8nV1vwRwAQitTeIyEVyWDIl
	 +9YOyTXrOTGPmKfXYdkHqi9MVyXW1nGTfTbWXAA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 206/268] netfilter: nf_tables: dont unregister hook when table is dormant
Date: Tue,  8 Apr 2025 12:50:17 +0200
Message-ID: <20250408104834.127436101@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9e9544f819421..18ae39cf41887 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2669,11 +2669,11 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
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



