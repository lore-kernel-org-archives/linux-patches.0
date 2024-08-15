Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3642163D5;
	Thu, 15 Aug 2024 14:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732498; cv=none; b=RVoA3sAUbVBTDKkqSivTVeEP1QxxG0Pol8K4JkUVuTSfFoZAaFNT4dkVvkKcKaisvkwHiGgmEhMxEETmpw45MTRM5MFUTAl/zJT2Im3G7yoOE1G257daOQeBwxuNpQPSZ3t6CdeAbnKo16h389F48Pdj5ir2LAk2L7hGo16ORdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732498; c=relaxed/simple;
	bh=84wnEsHRCVU3P/FLoWT5ML1L/b3AmyVwZB+1jkSiJCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qp7GKNopjvwsbYflYsSu6PMPmlubGBVGIiel0vm0cXu72SUbfTn5OnKf/WFwRgxbDwLyU8V/FdJp7UHO3c8F0MiyaW+c9fC+UneNLx5wN5Tl3p0+76nQDLmdiNFEV1MRTY7oBKMHbbF/k60FkKnSYej9GnI3554EdTimhL0kMcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N24+5vON; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N24+5vON"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46027C4AF0C;
	Thu, 15 Aug 2024 14:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732497;
	bh=84wnEsHRCVU3P/FLoWT5ML1L/b3AmyVwZB+1jkSiJCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N24+5vONbG/eM5S/ohJVWGxvMhWspIqCQ8trMq6Fo6+EglCdc/FEkpVnXxTj5bzGH
	 gkNkW2AZg1gaGFG259zc1QLe/g+ZUwvHvISQNHx2X9x8xQVOwHCKga6YqlzTCZPhbE
	 5ppGoFI69i3QkxvHPdsW5KuLeFZG66oE1DkwfPUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 198/352] netfilter: nft_set_pipapo_avx2: disable softinterrupts
Date: Thu, 15 Aug 2024 15:24:24 +0200
Message-ID: <20240815131926.930855920@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 60fb8bc0fdcc9..13c7e22c93842 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1129,8 +1129,14 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
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
 
@@ -1140,6 +1146,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	scratch = *raw_cpu_ptr(m->scratch);
 	if (unlikely(!scratch)) {
 		kernel_fpu_end();
+		local_bh_enable();
 		return false;
 	}
 
@@ -1220,6 +1227,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	if (i % 2)
 		scratch->map_index = !map_index;
 	kernel_fpu_end();
+	local_bh_enable();
 
 	return ret >= 0;
 }
-- 
2.43.0



