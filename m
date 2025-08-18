Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B8D427B344;
	Mon, 18 Aug 2025 13:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523601; cv=none; b=XYjIPz/SHnzz07gmJjomPwjJ17tVtnNjTGW3/IdMSt7y2MMctkgMtTwj1QYhCujJSMDG3YFPllfcdlPVqK1Nts/diUEqDGpjMhEEMbn2mMQ/YZASD1y/iW4RXdMI1zzm+VVXFsj8xsXyWICu+nQnlBqTZAHn8/SQ6uMZ5pys6+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523601; c=relaxed/simple;
	bh=8Vvt4qFcK2kxrI81rSuXKiaxwm/A3yf+d9ENCmgLxkU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c5Rk57ATx58Z8XjweNKGPcC+AEGYN3Emq0AU0hQNDVH3Hegtofgx/aLHtS/XsYltbfZObcF4zHivNhkAnyzzyDPSWNZdAwh1Fue+4zpOtUXetV8wJX9ph788sO0GvZ8b1Ichsf+TsOzTL1/BWH7n+XA5HZf3qjpSIL1XxFfrGgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JdD6PMBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JdD6PMBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904EEC4CEEB;
	Mon, 18 Aug 2025 13:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523601;
	bh=8Vvt4qFcK2kxrI81rSuXKiaxwm/A3yf+d9ENCmgLxkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JdD6PMBSLY0d69vIQIyLLUl8bs9NKnD+fY/q9FiEU4edZG2y/+9xqF0euW0ZtxUFT
	 qTSOGFx2NCJCmA7uvOJHdyCHkGGFmJm2B6DPk4UeRUjrfTMB90UEdmCW3kOtA0WYLc
	 AscaGSnRBbc0CzpgEDltfbEAcMEFu2aBFpQbncCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Stefano Brivio <sbrivio@redhat.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 189/515] netfilter: nft_set_pipapo: prefer kvmalloc for scratch maps
Date: Mon, 18 Aug 2025 14:42:55 +0200
Message-ID: <20250818124505.649888727@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 897eefee2eb73ec6c119a0ca357d7b4a3e92c5ef ]

The scratchmap size depends on the number of elements in the set.
For huge sets, each scratch map can easily require very large
allocations, e.g. for 100k entries each scratch map will require
close to 64kbyte of memory.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nft_set_pipapo.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index c5855069bdab..9e4e25f2458f 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -1219,7 +1219,7 @@ static void pipapo_free_scratch(const struct nft_pipapo_match *m, unsigned int c
 
 	mem = s;
 	mem -= s->align_off;
-	kfree(mem);
+	kvfree(mem);
 }
 
 /**
@@ -1240,10 +1240,9 @@ static int pipapo_realloc_scratch(struct nft_pipapo_match *clone,
 		void *scratch_aligned;
 		u32 align_off;
 #endif
-		scratch = kzalloc_node(struct_size(scratch, map,
-						   bsize_max * 2) +
-				       NFT_PIPAPO_ALIGN_HEADROOM,
-				       GFP_KERNEL_ACCOUNT, cpu_to_node(i));
+		scratch = kvzalloc_node(struct_size(scratch, map, bsize_max * 2) +
+					NFT_PIPAPO_ALIGN_HEADROOM,
+					GFP_KERNEL_ACCOUNT, cpu_to_node(i));
 		if (!scratch) {
 			/* On failure, there's no need to undo previous
 			 * allocations: this means that some scratch maps have
-- 
2.39.5



