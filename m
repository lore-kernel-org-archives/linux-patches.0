Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D438939B974
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:17:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302639; cv=none; b=bDgE3pajwbUluDRg6RbIfBQYAt2X0k3SV5wRNce+sejD2IuAE8YxComQfx7tT4XU9RTApGn+GMrNN7qVfM/l1GMEw3D2VkjaSZAD5+nxQa6E/MZL/nTBn2nnVL+o1VVKbnPXdacTWSw2HSBjg+0e8+5eeHbTP6+QHqmEUN+IZHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302639; c=relaxed/simple;
	bh=nystGe1yVUUM/j2rbGNIkv8mPybE0O/ohdiygyxb+4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ieSKOZ/igIaE4udWwGVQlUDQ92afbj68y+HoKjMbXUv2G1aR5QPj5YE3aRAqrwrF2m7+uJkCK+MQ5GQnYFR18ci250k2eH4k2XOlmJBrC+Dn038htTtZwrp+xsJIP/1DbvyYXtMb5rkXBUG5t/oshxcR1aoJaHuuJ3iI55i0tgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MWGWf/DB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MWGWf/DB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F6BC19423;
	Sat, 28 Feb 2026 18:17:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302639;
	bh=nystGe1yVUUM/j2rbGNIkv8mPybE0O/ohdiygyxb+4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MWGWf/DBvijrOxdEAnuUtLwKnT5L5ClWWwhTltIBpEW+lIDVMd6itR3vlmHPDYYCF
	 k52Q5B9Y4z1wIy5qNumzBDU/FP7P3Cq3TjnrOsT9gZUeOrDDq6bOg0bVHzYmxA1bsO
	 MJie70yytqA6gywuTM9q9AWaWsJDKc0nBh62V/jEtuEAwabGX2+bCgHQXzCLqMXbzV
	 r90NhKIxlDX1NFobfAxueES+On+jdNjYc9Qsr8eMMqlpBlQX4+OLLpNXx7JPeq2kbz
	 mU6t9QbomX6ihBnLX9cIg5ZhphMFtn6a0pI9uwjDsYVQmjhq9nTGXTAjST6N3Zn2Nr
	 nseOi4Z3DbrQA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 161/164] net: remove WARN_ON_ONCE when accessing forward path array
Date: Sat, 28 Feb 2026 13:15:00 -0500
Message-ID: <20260228181505.1600663-161-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit 008e7a7c293b30bc43e4368dac6ea3808b75a572 ]

Although unlikely, recent support for IPIP tunnels increases chances of
reaching this WARN_ON_ONCE if userspace manages to build a sufficiently
long forward path.

Remove it.

Fixes: ddb94eafab8b ("net: resolve forwarding path from virtual netdevice and HW destination address")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 977146a70b8c1..48abe997e6f3b 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -750,7 +750,7 @@ static struct net_device_path *dev_fwd_path(struct net_device_path_stack *stack)
 {
 	int k = stack->num_paths++;
 
-	if (WARN_ON_ONCE(k >= NET_DEVICE_PATH_STACK_MAX))
+	if (k >= NET_DEVICE_PATH_STACK_MAX)
 		return NULL;
 
 	return &stack->path[k];
-- 
2.51.0

