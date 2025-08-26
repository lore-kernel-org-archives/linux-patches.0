Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECDB635209B;
	Tue, 26 Aug 2025 14:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218682; cv=none; b=qwAcga2q3/txLOvAxcOwhS5NgImw2PM0Z8i45mYji5/Rl6erj+un0t3bDkSryudE9atULS+tfyAHeurZ/Buo5HWIxSD4nyKnToQaIhXZgAKHxpTeW0VWWjs2FL5XJ0E82JQ+KZOw3sAukzgahkC8+1mOfy9Tg/3hzaHXkxIwnLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218682; c=relaxed/simple;
	bh=BMxZkYlxfJ4+P0xeSBfiaVVPLjPsZh7T4hHIZ6ZCUkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9fyzHx0rEli/xBKkBmAAja/WYYCDo3NyWMlcN5veYYTH6D0Cm4sRb9S7PPLrwtY5w5RH0piZD57wHHe1B1yPasgZtusv0zF5TGwBOlsz5R6UmgO4COWNvKJTbs1QPeLl7celComjY8Txa9ecoHaUqEZYRznU3l2UCTNMrkxpg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ts0kMrC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ts0kMrC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E4B2C4CEF1;
	Tue, 26 Aug 2025 14:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218681;
	bh=BMxZkYlxfJ4+P0xeSBfiaVVPLjPsZh7T4hHIZ6ZCUkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ts0kMrC2z6X9S9fYyaQ8p/Zul+JdQSHgKixLzVNY1xun0iEmwQYIFvCpAeqxV8U09
	 h5RoiRkvutsHW1h2xA2FS3K1XbfTGi+1DPmwG6HpX9wmZNvsorOK8VDxt+DMZUspSm
	 sj01zdMdAWAdQM8ZvoLj74fIJNoA4WksQKwMgzAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 093/403] netfilter: nf_tables: adjust lockdep assertions handling
Date: Tue, 26 Aug 2025 13:06:59 +0200
Message-ID: <20250826110909.238496854@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 9e20fb759cb8..54c43f1cceac 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2823,7 +2823,7 @@ static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
 static void nf_tables_rule_release(const struct nft_ctx *ctx,
 				   struct nft_rule *rule)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
 	nf_tables_rule_destroy(ctx, rule);
@@ -4173,7 +4173,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	switch (phase) {
 	case NFT_TRANS_PREPARE_ERROR:
-- 
2.39.5



