Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F165D1E480;
	Tue, 26 Aug 2025 13:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215742; cv=none; b=fVa1Fdu9l3zv4VRPs62BDniBZLlqB5Hf1OAAswaX0TrIW1G3n9zyzVWEmLnoSRKdZMMGMpEl+PYKyyo691pMwqzKDu931hHN0HxdgUw4CTs7D5m7d/MmIGqcI3BFbEx2S9b0G69elC82dbRzHyczIQTR0hA38aVp5W0kPw/H4JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215742; c=relaxed/simple;
	bh=n+OGKPyRX84VxHVyItmUCXUoFZ9FoqgCBjpSi0VbX04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VqPImFnRVy9toW6p89pSDbmV9+Pft9MFrQuLyJE3ExYzkvW/ZRlPSCO5OnKGRalHA7v+QrLqU3RtOKNwrBN3Kxyh2Tc7lWjWlgiNHjwVc+GobhU7G+OenJC1vmh9o+R7/zoY/TtNUsydxRK9Iafvcf61BmkEN10my+IZ6NXFY58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2IBtuiO+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2IBtuiO+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ABB3C113CF;
	Tue, 26 Aug 2025 13:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215741;
	bh=n+OGKPyRX84VxHVyItmUCXUoFZ9FoqgCBjpSi0VbX04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2IBtuiO+WEwIwuhhzzIk5IfcpuA4NfpYWuL2n8Te2W9CC9r5ZAFYVHaU1DJdhzbzS
	 81bJTlDugxN7H3+N5fRjrr2Jv4ayrk15Zxd2B2jDIqpUnw05jWS88e48MQ0ch2niLJ
	 LGVoo8eYN4TYzlHZt6rldnd7X7AgIvaA+osRY13M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Khoroshilov <khoroshilov@ispras.ru>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 148/644] netfilter: nf_tables: adjust lockdep assertions handling
Date: Tue, 26 Aug 2025 13:03:59 +0200
Message-ID: <20250826110950.152950822@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a1f60f275814..33d03340d9fc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3443,7 +3443,7 @@ void nf_tables_rule_destroy(const struct nft_ctx *ctx, struct nft_rule *rule)
 /* can only be used if rule is no longer visible to dumps */
 static void nf_tables_rule_release(const struct nft_ctx *ctx, struct nft_rule *rule)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	nft_rule_expr_deactivate(ctx, rule, NFT_TRANS_RELEASE);
 	nf_tables_rule_destroy(ctx, rule);
@@ -5180,7 +5180,7 @@ void nf_tables_deactivate_set(const struct nft_ctx *ctx, struct nft_set *set,
 			      struct nft_set_binding *binding,
 			      enum nft_trans_phase phase)
 {
-	lockdep_commit_lock_is_held(ctx->net);
+	WARN_ON_ONCE(!lockdep_commit_lock_is_held(ctx->net));
 
 	switch (phase) {
 	case NFT_TRANS_PREPARE_ERROR:
-- 
2.39.5



