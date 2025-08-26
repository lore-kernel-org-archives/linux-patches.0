Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E276A341651;
	Tue, 26 Aug 2025 14:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217420; cv=none; b=PWPhFFM8mjiZsJC16124d3qhCCDax6BSJlc98E/F0ih4FkpBew+Jg5biMSJkj12MdvF7U+sjbfJOFubWbMFBuyy7mk8Gutv0vtNrb7AI5RwKP23hWlrhmD6lYONfDZUM7J9Taai+PFZolVeHpMtcXqvYG3BFSv2lCYdtfWw1l8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217420; c=relaxed/simple;
	bh=YNL1OrU8/l+ncfuzCuRp5vgYt5YRheF49vds671WHPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nimAMN9oGg99fui8CViSm6Gdl/nK05lX7CbSRXHQSIVB2lM1aZerKIJQs49SipN3rmNLAAHaBFMv7+oAVytIhgD9i6YHLaS3/37TP73ZGP+U3UJv1gnhJZjnJGhrmJIJT9ZbtUlwaLmhdCsUJppqnCOwS7rcuBHGV14VCXO6XAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MCqEvdym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MCqEvdym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 748ECC4CEF1;
	Tue, 26 Aug 2025 14:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217419;
	bh=YNL1OrU8/l+ncfuzCuRp5vgYt5YRheF49vds671WHPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MCqEvdymXh0O+xs6faLlzB5ylePp6YEQfTljFsB59rV/nBQeMG0jhOFefWy8hf7BF
	 CpAcD+RkS8uDdADck9QAKfnu8WJzX44n2DI/7rXkx2xaeTzfWMQjImb0zuXFNzh+Nx
	 AnH4XADuMT4DIQGAaNrCYA4vAdC01gj0WWfEWKSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 105/523] netfilter: nf_tables: adjust lockdep assertions handling
Date: Tue, 26 Aug 2025 13:05:15 +0200
Message-ID: <20250826110927.127006469@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

[ Upstream commit 8df1b40de76979bb8e975201d07b71103d5de820 ]

It's needed to check the return value of lockdep_commit_lock_is_held(),
otherwise there's no point in this assertion as it doesn't print any
debug information on itself.

Found by Linux Verification Center (linuxtesting.org) with Svace static
analysis tool.

Fixes: b04df3da1b5c ("netfilter: nf_tables: do not defer rule destruction via call_rcu")
Reported-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Acked-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_tables_api.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ff419ecb268a..8e799848cbcc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3347,7 +3347,7 @@ void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
 /* can only be used if rule is no longer visible to dumps */
 static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *rule)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
 	nf_tables_rule_destroy(ctx, rule);
@@ -4860,7 +4860,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	switch (phase) {
 	case NFT_TRANS_PREPARE_ERROR:
-- 
2.39.5



