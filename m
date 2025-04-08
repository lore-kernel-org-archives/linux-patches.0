Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B10127BF90;
	Tue,  8 Apr 2025 12:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116945; cv=none; b=FAhvzxkhx81qERq33gxf9xs+0vgAIrCjhO/xIzGYdoIvET3Pl8XFYBZgBaLVoSdZp/g+RVzHZLF/KE57lrKSGNxCsBwlLZDP7ti6nAYMLNBmO3515w8y3fhfuX5Ol8zj3bu/0daRspr8wSEMm40G4C0B/zpmF2x1GFz2kOCJkBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116945; c=relaxed/simple;
	bh=6NRIF0bqW2Xwly1+JkbDb/l0MXSAqqwt9omBJ1IJGRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIaZ3E6X6LAjpb89YjM15vWejyPcpnj9uGAZjrM+fCiAnFd/wVN6kwJ8mKrpEBPGQ5Frv04Y7bPrJKm7NVXrSueFsgMS9HJk6q7smUeSBO0WzRwsdO1DrUwFOXU7yyO0LDe/n+Vxz2uaErEIwXtoS9YwR0ju1Ayl0EJw7eWNcZk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glJdQzYS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glJdQzYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0F6C4CEEB;
	Tue,  8 Apr 2025 12:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116945;
	bh=6NRIF0bqW2Xwly1+JkbDb/l0MXSAqqwt9omBJ1IJGRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=glJdQzYSiEWOEf9JEmyzbY2JHma0mBUw/wxohYgC3FSKK/TOb61Q5pbZos0oV2S5Y
	 0SQBDYfst77cAxgKeR0j3xNP95qXoOQSuV8xB2pgnPUZCqlXM3TEyOaISj1gHajH5n
	 J/ILaq4jG7LXdoUNn/JZ4oenIKO4eJOl7AJN9ZBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+53ed3a6440173ddbf499@syzkaller.appspotmail.com,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 327/423] netfilter: nf_tables: dont unregister hook when table is dormant
Date: Tue,  8 Apr 2025 12:50:53 +0200
Message-ID: <20250408104853.437804532@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index eb3a6f96b094d..bdee187bc5dd4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2732,11 +2732,11 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
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



