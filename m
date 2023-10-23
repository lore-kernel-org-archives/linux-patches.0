Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA9BD134C3
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeXkgShl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47029C433C9;
	Mon, 23 Oct 2023 11:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059162;
	bh=xkz0JAJKgN82kBTAhWwUYoYcTI19NLJ4X5uaC4D6BpU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeXkgShlCzeHYLWR9QA/fZTmhWyY3tc746WqOYcDRXzBIVBaZa4w9ptj4PNODuwra
	 GQW+RqmcEInJZhMe9k10yuz5ic0kxab6uKBgKAa8Tj8btsEE+MzAqZ/bZjlwGwgeCM
	 iRKSofdXFEQS0a1HfeAk9pmvFeejOczxLe0IC2Es=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingyuan Mo <hdthky0@gmail.com>,
	Florian Westphal <fw@strlen.de>
Subject: [PATCH 6.5 084/241] nf_tables: fix NULL pointer dereference in nft_expr_inner_parse()
Date: Mon, 23 Oct 2023 12:54:30 +0200
Message-ID: <20231023104835.935772713@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

From: Xingyuan Mo <hdthky0@gmail.com>

commit 505ce0630ad5d31185695f8a29dde8d29f28faa7 upstream.

We should check whether the NFTA_EXPR_NAME netlink attribute is present
before accessing it, otherwise a null pointer deference error will occur.

Call Trace:
 <TASK>
 dump_stack_lvl+0x4f/0x90
 print_report+0x3f0/0x620
 kasan_report+0xcd/0x110
 __asan_load2+0x7d/0xa0
 nla_strcmp+0x2f/0x90
 __nft_expr_type_get+0x41/0xb0
 nft_expr_inner_parse+0xe3/0x200
 nft_inner_init+0x1be/0x2e0
 nf_tables_newrule+0x813/0x1230
 nfnetlink_rcv_batch+0xec3/0x1170
 nfnetlink_rcv+0x1e4/0x220
 netlink_unicast+0x34e/0x4b0
 netlink_sendmsg+0x45c/0x7e0
 __sys_sendto+0x355/0x370
 __x64_sys_sendto+0x84/0xa0
 do_syscall_64+0x3f/0x90
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Signed-off-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index aae6ffebb413..a623d31b6518 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3166,7 +3166,7 @@ int nft_expr_inner_parse(const struct nft_ctx *ctx, const struct nlattr *nla,
 	if (err < 0)
 		return err;
 
-	if (!tb[NFTA_EXPR_DATA])
+	if (!tb[NFTA_EXPR_DATA] || !tb[NFTA_EXPR_NAME])
 		return -EINVAL;
 
 	type = __nft_expr_type_get(ctx->family, tb[NFTA_EXPR_NAME]);
-- 
2.42.0



