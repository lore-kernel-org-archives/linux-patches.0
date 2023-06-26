Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3816612B9C
	for <patches@lists.linux.dev>; Mon, 26 Jun 2023 18:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A97BAC433C9;
	Mon, 26 Jun 2023 18:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1687803839;
	bh=wNkBY1az243WiHCcVzdWlQDF8CSoO1SrrEccfHheBdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SrPY1+VBELGgzPqEkP3hgtIxVZHE17HjYecSOH+5bxozbfMvKBR3QZPRHDLHJhqWl
	 iPhPHH224oX8btvGtjaZrCjAV4gEOQo3dYkdQL48oOM60OkxbeaOp5c0yHQaGhcxZU
	 OujFvNxQwGpSoDIza7wd77oAdcnLDHYVefreH5Gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.3 195/199] netfilter: nf_tables: drop module reference after updating chain
Date: Mon, 26 Jun 2023 20:11:41 +0200
Message-ID: <20230626180814.298714943@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230626180805.643662628@linuxfoundation.org>
References: <20230626180805.643662628@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 043d2acf57227db1fdaaa620b2a420acfaa56d6e upstream.

Otherwise the module reference counter is leaked.

Fixes b9703ed44ffb ("netfilter: nf_tables: support for adding new devices to an existing netdev chain")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2664,6 +2664,8 @@ static int nf_tables_updchain(struct nft
 	nft_trans_basechain(trans) = basechain;
 	INIT_LIST_HEAD(&nft_trans_chain_hooks(trans));
 	list_splice(&hook.list, &nft_trans_chain_hooks(trans));
+	if (nla[NFTA_CHAIN_HOOK])
+		module_put(hook.type->owner);
 
 	nft_trans_commit_list_add_tail(ctx->net, trans);
 


