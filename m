Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 268591D174F;
	Tue, 27 Aug 2024 15:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724772530; cv=none; b=r8iTB3J3O8fzKyiHueKt3F78U4KzT2Hn0GLJa9D6SXu5ahx0Dc/5C4j2ydXfwLnA8lzZ4lj/7WXr4ONitvpNgrQjLE+lttZTAhxAECxqmPmYpr6p0Dy83PrRWhGbRXWamGWpCgf9SRK1Cz4+Dgmp0z9NdhXHSrGL6JNjR7ZZxa4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724772530; c=relaxed/simple;
	bh=3tacsCwSmjYxUWHEK3OC51OjppYtl7Trjc5sPmSGynI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9TCUDClJ10DvBtAjXCJhUVmcdoPlGll5XvDGbniLoiCBABUQO3/AnlcUR+y9SfRSaY+uX9vEWmnm0HfJk/XjsVGinWzZHdshu+aPS5UWNz751BTuO/h3pyyZQ9KmTdOB4RmNLqGewZWnh7H44QfYnqvh79Jzkbi7JYuybOBoUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdN6liC2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdN6liC2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97439C6107E;
	Tue, 27 Aug 2024 15:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724772530;
	bh=3tacsCwSmjYxUWHEK3OC51OjppYtl7Trjc5sPmSGynI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdN6liC2gZBCTTyuB30c0MdoHUJyVtq1RiMR9ckNjJyE9wFxlZT6xz4JqIB+Oy9V3
	 2j59xjmZ8TkJu59M8/B1G5W+GPsdo2QXHGV8eFPttZoCrcV1FFGLjvlTf7UJegAp0i
	 HUfsHfoxQRmDnNmAkzIX1/jl/oR9ZoFA8sEJBk6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 235/321] netfilter: nft_counter: Disable BH in nft_counter_offload_stats().
Date: Tue, 27 Aug 2024 16:39:03 +0200
Message-ID: <20240827143847.182030879@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index b5fe7fe4b60db..73e4d278d6c13 100644
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
 
 void nft_counter_init_seqcount(void)
-- 
2.43.0



