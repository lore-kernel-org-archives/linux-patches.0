Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 764B6371449;
	Sat, 28 Feb 2026 17:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301461; cv=none; b=uCCfmO0t132BPFNNVCpzKI4BjTwtLNTOTRsbuUqh77WRVz2yuBZn+j/sbaL0JqrRKTpnGPaD4Y4apPcAsnR5vEtH7WigwvGbCbSq/OwhsrpM8smMYro/hq9ipfZVM+PZ9zWGlVKMDiMubZSHQUrFFzr58476zy/rsYf/8Yjx8aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301461; c=relaxed/simple;
	bh=nM1XEveaFIjfXnZVXj/hWPrDdHpdlkASv+bJh7unDdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFhyfJTYLqfdV6LGd8bpbeYtKiWsZLJH1x9YMjdXcc/vmqig3HYd6LuTafT/a9Ilm5hl8bmLlJUStrm6RrRYCAHJPgUAILB9d4bdDjrfpPcFPYOIxM1FmFb3X5J35WCxcxotG6GuNGF+wTmm/BsOgfNIIwuvaDexz62GFvNf9HM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iy1KbcH5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iy1KbcH5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D972C116D0;
	Sat, 28 Feb 2026 17:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301461;
	bh=nM1XEveaFIjfXnZVXj/hWPrDdHpdlkASv+bJh7unDdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iy1KbcH5q5QZu1leLZ4k7Sf6u/tK4iBTuUp3K9YHXLtDUsMroPAlsNkam0wp2Rjqh
	 x8rpXz0FDQ3GiGN/RFb360YZNuYHCJTvJkUDzunTNoRa/OrihNg2RF1OpCwvDYBvNY
	 IQz4gjAxIZvs44kWblXLlAs0ZlRWLL1jovEpGVcqO+3MCT4kV+h21OI2YHAxiSFnNb
	 ujDFm4cEFNrdT8svLxaN33+BuRliIwric+OOI1RPAxZd4idITsX/uT5IZRXNTSLKSJ
	 nHAm9eqGph5tGcavmgsAWrf4h0NUphIP41d2E95zQIFQuWUd4d6KSXSnzhF4lbHCsr
	 lmEDqLuRRggDw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pratyush Yadav <pratyush@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 646/752] kho: skip memoryless NUMA nodes when reserving scratch areas
Date: Sat, 28 Feb 2026 12:45:57 -0500
Message-ID: <20260228174750.1542406-646-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Evangelos Petrongonas <epetron@amazon.de>

[ Upstream commit 427b2535f51342de3156babc6bdc3f3b7dd2c707 ]

kho_reserve_scratch() iterates over all online NUMA nodes to allocate
per-node scratch memory.  On systems with memoryless NUMA nodes (nodes
that have CPUs but no memory), memblock_alloc_range_nid() fails because
there is no memory available on that node.  This causes KHO initialization
to fail and kho_enable to be set to false.

Some ARM64 systems have NUMA topologies where certain nodes contain only
CPUs without any associated memory.  These configurations are valid and
should not prevent KHO from functioning.

Fix this by only counting nodes that have memory (N_MEMORY state) and skip
memoryless nodes in the per-node scratch allocation loop.

Link: https://lkml.kernel.org/r/20260120175913.34368-1-epetron@amazon.de
Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers").
Signed-off-by: Evangelos Petrongonas <epetron@amazon.de>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Alexander Graf <graf@amazon.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kexec_handover.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/kexec_handover.c b/kernel/kexec_handover.c
index 03d12e27189fc..2da4bd994322f 100644
--- a/kernel/kexec_handover.c
+++ b/kernel/kexec_handover.c
@@ -619,7 +619,7 @@ static void __init kho_reserve_scratch(void)
 	scratch_size_update();
 
 	/* FIXME: deal with node hot-plug/remove */
-	kho_scratch_cnt = num_online_nodes() + 2;
+	kho_scratch_cnt = nodes_weight(node_states[N_MEMORY]) + 2;
 	size = kho_scratch_cnt * sizeof(*kho_scratch);
 	kho_scratch = memblock_alloc(size, PAGE_SIZE);
 	if (!kho_scratch)
@@ -649,7 +649,11 @@ static void __init kho_reserve_scratch(void)
 	kho_scratch[i].size = size;
 	i++;
 
-	for_each_online_node(nid) {
+	/*
+	 * Loop over nodes that have both memory and are online. Skip
+	 * memoryless nodes, as we can not allocate scratch areas there.
+	 */
+	for_each_node_state(nid, N_MEMORY) {
 		size = scratch_size_node(nid);
 		addr = memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
 						0, MEMBLOCK_ALLOC_ACCESSIBLE,
-- 
2.51.0

