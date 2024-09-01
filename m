Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E5F17C;
	Sun,  1 Sep 2024 17:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210284; cv=none; b=mUnhNtHc0ZWr/510KO9ebNpZYNZQAH6wMf8M2th4WpdlQkHiGWiqN5wOyRbpnyNo3vVo+Rooki8gZjUozi74NyWwKg9h0BcyS+R7Ezohp3U/UfLjaBEz7XPVz2I6+9nNi9PIPeBi49bYivUV2SnMIbOznCEtL/HCNmksGrlgm/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210284; c=relaxed/simple;
	bh=Af2sexPmeGHoBZwe3fvuwYgsPEse6kxJFivMbfh53T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cF1e+L64hlrCQxUKuqLKx2x8BFLygNu+vGGUOjb7M21bQfl96syCOipkerwj6v7WYXPauwKtbpA78dWdyTAt/gREV1lSczte3+YrCqbLr82gwyb3aDF6IqD7UCDoxj2OmaTpwn7BIXGWU95ZaYlJ9Zjc5PXUOG/Z32sjPfPQ1D8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dv2ii8TD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dv2ii8TD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A64C4CEC3;
	Sun,  1 Sep 2024 17:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210284;
	bh=Af2sexPmeGHoBZwe3fvuwYgsPEse6kxJFivMbfh53T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dv2ii8TDShvZUv5q+wJCtS/MeXtx/ieAnAuBsiThM87AOLyeFqaWo4D4z/z8OH3i2
	 WvmeHRvtChd19/YeWSRPvBmgi6FPjuctg9IiQlOVpkX6Tn7LphSuuctpbNRNEwkSkh
	 eZTdjgiDC32LaU1tMBz48NggQDE58dbRDHpbC9Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/215] netfilter: nft_counter: Disable BH in nft_counter_offload_stats().
Date: Sun,  1 Sep 2024 18:17:28 +0200
Message-ID: <20240901160828.506890956@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 1eacdd71b3436b54d5fc8218c4bb0187d92a6892 ]

The sequence counter nft_counter_seq is a per-CPU counter. There is no
lock associated with it. nft_counter_do_eval() is using the same counter
and disables BH which suggest that it can be invoked from a softirq.
This in turn means that nft_counter_offload_stats(), which disables only
preemption, can be interrupted by nft_counter_do_eval() leading to two
writer for one seqcount_t.
This can lead to loosing stats or reading statistics while they are
updated.

Disable BH during stats update in nft_counter_offload_stats() to ensure
one writer at a time.

Fixes: b72920f6e4a9d ("netfilter: nftables: counter hardware offload support")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_counter.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 1b468a16b5237..f10d36c693b13 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -264,7 +264,7 @@ static void nft_counter_offload_stats(struct nft_expr *expr,
 	struct nft_counter *this_cpu;
 	seqcount_t *myseq;
 
-	preempt_disable();
+	local_bh_disable();
 	this_cpu = this_cpu_ptr(priv->counter);
 	myseq = this_cpu_ptr(&nft_counter_seq);
 
@@ -272,7 +272,7 @@ static void nft_counter_offload_stats(struct nft_expr *expr,
 	this_cpu->packets += stats->pkts;
 	this_cpu->bytes += stats->bytes;
 	write_seqcount_end(myseq);
-	preempt_enable();
+	local_bh_enable();
 }
 
 static struct nft_expr_type nft_counter_type;
-- 
2.43.0



