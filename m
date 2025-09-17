Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 182B51E489;
	Wed, 17 Sep 2025 12:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113092; cv=none; b=cxoufEym3Dyw38AEpuCUFBaGtr2uL4YNRsoafqm7uQtXW1TDN3rVckp/9c7YngRNOkoLCUjoBqgRvl/DrrNCrlcK/p9ZKylTEMnFz8zd6F+7AxsdNfoUqjCMi8jjYQOprwzKJ/y7eexxm0N/sBHXM+0TID9Jw/AnTHUhSjnr3F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113092; c=relaxed/simple;
	bh=CrRAy6a2JOpMBwH7yOBXkZ+V9q/czkIlZmhvPwaSBG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDbOzb5V3BfaFlUbERjBqClYf4B3KPXzXWZDvPipoph4d0r6uXGlHavmSgOfCxz4FThfWqBU3bbmIAsQIuRzkWuSI87i/NL3IAWeWZ8087jlel+or8HjU+NI/5nieeqv7NTPO5DeqSJUh2/G91QAxYEbV99IwtcZfBZmecI7gic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UU8+Z5/N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UU8+Z5/N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 897A1C4CEF0;
	Wed, 17 Sep 2025 12:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113092;
	bh=CrRAy6a2JOpMBwH7yOBXkZ+V9q/czkIlZmhvPwaSBG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UU8+Z5/N0whWXKmDPPYmKLlQcf35kBLdIoO7bWVgSOJW9DVNtfG5KWUFMvQU5KyEB
	 a4pEVGWZ4iWjFCtjnoyZ6hmG+q9vaVRVfPL3LC2EZURh7aHX0jLAKc4UrRspUot1VK
	 bTIHXJbN9KP2tKHN6j9BiFifTejamTNED6aQl2u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 152/189] netfilter: nft_set_bitmap: fix lockdep splat due to missing annotation
Date: Wed, 17 Sep 2025 14:34:22 +0200
Message-ID: <20250917123355.582996966@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
References: <20250917123351.839989757@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 5e13f2c491a4100d208e77e92fe577fe3dbad6c2 ]

Running new 'set_flush_add_atomic_bitmap' test case for nftables.git
with CONFIG_PROVE_RCU_LIST=y yields:

net/netfilter/nft_set_bitmap.c:231 RCU-list traversed in non-reader section!!
rcu_scheduler_active = 2, debug_locks = 1
1 lock held by nft/4008:
 #0: ffff888147f79cd8 (&nft_net->commit_mutex){+.+.}-{4:4}, at: nf_tables_valid_genid+0x2f/0xd0

 lockdep_rcu_suspicious+0x116/0x160
 nft_bitmap_walk+0x22d/0x240
 nf_tables_delsetelem+0x1010/0x1a00
 ..

This is a false positive, the list cannot be altered while the
transaction mutex is held, so pass the relevant argument to the iterator.

Fixes tag intentionally wrong; no point in picking this up if earlier
false-positive-fixups were not applied.

Fixes: 28b7a6b84c0a ("netfilter: nf_tables: avoid false-positive lockdep splats in set walker")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_bitmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_set_bitmap.c b/net/netfilter/nft_set_bitmap.c
index 12390d2e994fc..8a435cc0e98c4 100644
--- a/net/netfilter/nft_set_bitmap.c
+++ b/net/netfilter/nft_set_bitmap.c
@@ -221,7 +221,8 @@ static void nft_bitmap_walk(const struct nft_ctx *ctx,
 	const struct nft_bitmap *priv = nft_set_priv(set);
 	struct nft_bitmap_elem *be;
 
-	list_for_each_entry_rcu(be, &priv->list, head) {
+	list_for_each_entry_rcu(be, &priv->list, head,
+				lockdep_is_held(&nft_pernet(ctx->net)->commit_mutex)) {
 		if (iter->count < iter->skip)
 			goto cont;
 
-- 
2.51.0



