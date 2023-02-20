Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91EB463B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:52:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AB73C433D2;
	Mon, 20 Feb 2023 13:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901129;
	bh=MwXDZzxAASX98Dz6VPm5my0X8jztwAeHzKpv4LQ+prY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H1znUPKCH/NjsCsI5IP4FJ7MykS4lnCgUCSPjh/4BjmpoGMdDHYX0Dnn/G3Q6GKBt
	 AXxFFzwN+AGoqW70s5ayqRntMLbGm3O/uohGpZY8DWW+9Lhpba++bpSfNHsMi4TtKC
	 cYqzrqiSHGW2U/ghObLp59vHuVuIxACfBdaHxQE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shell Chen <xierch@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Qingfang DENG <dqfext@gmail.com>
Subject: [PATCH 5.15 41/83] netfilter: nft_tproxy: restrict to prerouting hook
Date: Mon, 20 Feb 2023 14:36:14 +0100
Message-Id: <20230220133555.100693724@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
References: <20230220133553.669025851@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Florian Westphal <fw@strlen.de>

commit 18bbc3213383a82b05383827f4b1b882e3f0a5a5 upstream.

TPROXY is only allowed from prerouting, but nft_tproxy doesn't check this.
This fixes a crash (null dereference) when using tproxy from e.g. output.

Fixes: 4ed8eb6570a4 ("netfilter: nf_tables: Add native tproxy support")
Reported-by: Shell Chen <xierch@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Qingfang DENG <dqfext@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_tproxy.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/netfilter/nft_tproxy.c
+++ b/net/netfilter/nft_tproxy.c
@@ -312,6 +312,13 @@ static int nft_tproxy_dump(struct sk_buf
 	return 0;
 }
 
+static int nft_tproxy_validate(const struct nft_ctx *ctx,
+			       const struct nft_expr *expr,
+			       const struct nft_data **data)
+{
+	return nft_chain_validate_hooks(ctx->chain, 1 << NF_INET_PRE_ROUTING);
+}
+
 static struct nft_expr_type nft_tproxy_type;
 static const struct nft_expr_ops nft_tproxy_ops = {
 	.type		= &nft_tproxy_type,
@@ -320,6 +327,7 @@ static const struct nft_expr_ops nft_tpr
 	.init		= nft_tproxy_init,
 	.destroy	= nft_tproxy_destroy,
 	.dump		= nft_tproxy_dump,
+	.validate	= nft_tproxy_validate,
 };
 
 static struct nft_expr_type nft_tproxy_type __read_mostly = {


