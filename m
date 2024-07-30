Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3278E1A76B1;
	Tue, 30 Jul 2024 17:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359896; cv=none; b=DYbrLIHO2wqaM+ZzQz+tSx5NX2K/VIbSW+edLhL3UWjzWrtsefDPFjf4gvgk5zYw4GCWJemCSiWKdTaoFAIkShvLIR34aS4e/CTgdc9W23OcS3PsrqcqJ6nz6/ULwHHASMeeF/fKHIMHMKSfnezKa3LFp7jGUklHKyapr2xHH3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359896; c=relaxed/simple;
	bh=MEBruco5mttoN0wX8N4f1CR6VG0kh91CtMH7uXy8gl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GQEdv28b+PBauMCbxF4Y0u5hBLT+AB0gvfuqSxcoP9MQKRUAwPPX/yTVnOQA+iDy4b0t5UAcPtMnGuG5wByIlajVkr7Bftii9S/oEjkClm39q14hLywK48WV3m3PsrwDVz1f1RsdxhDC3Uvf/i6/gmrN0YstSeYl5kLLR6CXQnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opICFZjj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opICFZjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABC6EC32782;
	Tue, 30 Jul 2024 17:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359896;
	bh=MEBruco5mttoN0wX8N4f1CR6VG0kh91CtMH7uXy8gl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=opICFZjj9N2lmzfVKhKJVGYm3kynoQQF6RpL1LEsMov2tNR0oSaykR9/YQM6oM3OP
	 9pcLfwJoLdKNKdX3028eJYinLKZx8S464jMnwi466Ke0oqpfSU+49RwP5snGGNiZmZ
	 5PQinxA0SKq6N4ZKSrSk2U8x5pg6023TuApfRrOw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Brivio <sbrivio@redhat.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 539/568] netfilter: nft_set_pipapo_avx2: disable softinterrupts
Date: Tue, 30 Jul 2024 17:50:46 +0200
Message-ID: <20240730151701.225497892@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8910a5ac7ed12..b8d3c3213efee 100644
--- a/net/netfilter/nft_set_pipapo_avx2.c
+++ b/net/netfilter/nft_set_pipapo_avx2.c
@@ -1139,8 +1139,14 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
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
 
@@ -1155,6 +1161,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	scratch = *raw_cpu_ptr(m->scratch);
 	if (unlikely(!scratch)) {
 		kernel_fpu_end();
+		local_bh_enable();
 		return false;
 	}
 
@@ -1235,6 +1242,7 @@ bool nft_pipapo_avx2_lookup(const struct net *net, const struct nft_set *set,
 	if (i % 2)
 		scratch->map_index = !map_index;
 	kernel_fpu_end();
+	local_bh_enable();
 
 	return ret >= 0;
 }
-- 
2.43.0



