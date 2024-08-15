Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67A821714A1;
	Thu, 15 Aug 2024 13:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730098; cv=none; b=UVDpzwvTWTSfFyBaJOn0f9NU+ffCS5UZLQ+BnMftHZOXj0Lh+paINIKfLfbFLuAgFx7kiRg93Ps8xtMh3BUOUdAa2ywcEWgKP1shEofYb1u8eApZpojWLToYCE97tOpdSz5Ay8WMz88HWhOx0TwqK29R5GDVpjGbWzd3B4kw1kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730098; c=relaxed/simple;
	bh=Z1zHJnzleCfK0aHFkrF/IqOTtqvfv2oma25sK+UDGfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBdTAtfTm7uaM5l7DL2xX4tT6CMInwHZt2w8wLOJE0tLq22HzcdHXmJpdyKwwVsQa8GZgbHTBvkoVhcX/UCIwSbsLXSKDAptvJUyfjzG6GzMlGu1uN1gyeL7+/12BXlO8y6jIB9nVPqj0/RJk8u0AlNxFALi8gUxpRkdqkE++Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0uV5lAf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0uV5lAf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF593C4AF0A;
	Thu, 15 Aug 2024 13:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730098;
	bh=Z1zHJnzleCfK0aHFkrF/IqOTtqvfv2oma25sK+UDGfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0uV5lAfMMsuBRcOnR1cPwuGUV+7tZCTb/NBbs6955PkXLhPOBzJZd/ZLS1rApekf
	 xBI9+JKwd1TZ98dH3tnnNi3H0LoJm3gb14sl90z3TKkjMnqf57jticKmbADFmBCds2
	 L/8L/bWjwiX6F2kDOlDnnnwgJiVkBBKS0m2bRwr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/484] netfilter: nft_set_pipapo_avx2: disable softinterrupts
Date: Thu, 15 Aug 2024 15:22:11 +0200
Message-ID: <20240815131951.951074727@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit a16909ae9982e931841c456061cb57fbaec9c59e ]

We need to disable softinterrupts, else we get following problem:

1. pipapo_avx2 called from process context; fpu usable
2. preempt_disable() called, pcpu scratchmap in use
3. softirq handles rx or tx, we re-enter pipapo_avx2
4. fpu busy, fallback to generic non-avx version
5. fallback reuses scratch map and index, which are in use
   by the preempted process

Handle this same way as generic version by first disabling
softinterrupts while the scratchmap is in use.

Fixes: f0b3d338064e ("netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() check, fallback to non-AVX2 version")
Cc: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo_avx2.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo_avx2.c b/net/netfilter/nft_set_pipapo_avx2.c
index 295406cf63672..dfae90cd34939 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1141,8 +1141,14 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	bool map_index;
 	int i, ret = 0;
 
-	if (unlikely(!irq_fpu_usable()))
-		return nft_pipapo_lookup(net, set, key, ext);
+	local_bh_disable();
+
+	if (unlikely(!irq_fpu_usable())) {
+		bool fallback_res = nft_pipapo_lookup(net, set, key, ext);
+
+		local_bh_enable();
+		return fallback_res;
+	}
 
 	m = rcu_dereference(priv->match);
 
@@ -1157,6 +1163,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	scratch = *raw_cpu_ptr(m->scratch);
 	if (unlikely(!scratch)) {
 		kernel_fpu_end();
+		local_bh_enable();
 		return false;
 	}
 
@@ -1237,6 +1244,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	if (i % 2)
 		scratch->map_index = !map_index;
 	kernel_fpu_end();
+	local_bh_enable();
 
 	return ret >= 0;
 }
-- 
2.43.0



