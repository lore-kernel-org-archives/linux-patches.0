Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021704;
	b=3LHftCBhZqA8K4/iRMHzSIctgfiBGWzx9V1U3/1VLccCu9TMsX7kXD2yXN7+2mn6pVOt
	 n772DrP63B85wZyDGjwtJyjaK45S3goN6ZBAQ41GvXhDbh8UJ3JLV+1yVxZ9SL6eHvBT9
	 2wfEhdLGiDURHXC4T3c2CoqxziVur2EbXWfnuFkxoE/GxX+gIK/EWD+JwKdVMEvVoCvGE
	 IIEwuch6595jjiTjgbJljIWslJdiOReJMpdECpzr8gVTphXyeS4lfN0Pchp8a8Wt/DDIU
	 o61Pl85XcvvGbPjU20u+O/Cx4yXlHYiEKftWuPLN3bnIV7yxSdP6lqvWPbsh+Z2lGjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=INWPiVcf4GWx7MjCTzeAHBdRCQLxN+8SEkW8YFMkoA8=;
	b=2y08A3WrhemWI3vm07BV6dZ2rbZLBAukFsSAT0s6A6+/ZKMvWahOByAbQ6f1xJKLgiy7
	 CJHx1JEBR9LHRwTfMQg+VutFHPRWJUFeMM11/IVfEL5w69OktSenjPee47ZGnlDwdkj1H
	 EBWHTdTn80C/2oBFRLYM6lXBvRHAlHVssN7LF7SXCL09vQIG4ZiMVxqvtlj33PTde+L1F
	 reFDGfPHBwJJwSq39wNINn5tf4HgC5Ax6pwNvCIigT81tWrPg8iqxzkHjlE8OyL4+rMmX
	 KJGbEjhWbxVCeDeIcpHvHnXz1KbukrG5oh6zLjg6Tv76yIj38jwq2CBuim1Mx2OdV6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWhPyrfl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACAC0606A320;
	Wed, 18 Nov 2026 17:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xWhPyrfl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E87A1F000C4;
	Wed, 18 Nov 2026 17:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021704;
	bh=INWPiVcf4GWx7MjCTzeAHBdRCQLxN+8SEkW8YFMkoA8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xWhPyrflPf3mBSRaA6HxQZ5VkoPD2bJTY/aRBqw2kBow/+Qt/ZgwHlYKEiM3iUqGG
	 kdVwoebTM5VZxMWHp2pZSKzVKX3WAovp9JwMMlP1flRtzGwbNsuZNkJv+8BS/HfYlM
	 I9jEC9seoxM57TTjYLKaaVIPVC71H5XJBFb/dqNE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ren Tamura <ren.tamura.oss@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2400/2651] tools/cgroup: sum shrinker object counts across NUMA nodes
Date: Wed, 18 Nov 2026 16:00:40 +0100
Message-ID: <20261118150411.759536240@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ren Tamura <ren.tamura.oss@gmail.com>

[ Upstream commit ae2514c95518b39b36fa463d855c74f29c91d064 ]

Each row of a memcg-aware shrinker's debugfs count file contains the
cgroup ID followed by one object count per NUMA node.  memcg_shrinker.py
uses only the first count when sorting and displaying entries.

This undercounts objects on NUMA systems.  An entry with counts of 0 and
23 is treated as zero and omitted from the output, even though its total
is 23.

Sum all count fields after the cgroup ID so that the displayed totals and
sort order account for every node.  Single-node input retains the same
result.

Link: https://lore.kernel.org/179074810112.139422.9274126921568167859@gmail.com
Fixes: d261ea23533b ("tools: add memcg_shrinker.py")
Signed-off-by: Ren Tamura <ren.tamura.oss@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/cgroup/memcg_shrinker.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/cgroup/memcg_shrinker.py b/tools/cgroup/memcg_shrinker.py
index e81c3017ada96..714772449c6ba 100644
--- a/tools/cgroup/memcg_shrinker.py
+++ b/tools/cgroup/memcg_shrinker.py
@@ -31,7 +31,7 @@ def scan_shrinkers(shrinker_debugfs):
                     items = line.split(' ')
                     ino = int(items[0])
                     # (count, shrinker, memcg ino)
-                    shrinkers.append((int(items[1]), shrinker, ino))
+                    shrinkers.append((sum(map(int, items[1:])), shrinker, ino))
     return shrinkers
 
 
-- 
2.53.0



