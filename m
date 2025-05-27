Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5A72110E;
	Tue, 27 May 2025 17:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365474; cv=none; b=Woo6R3rug+3u4Jj8WxDJiVl6Bhxzi4duCiuSjlMYardKvrWQ8gCFNHO7kswjbdOdwAPQam/lpXBMf09OQxQb7JF3mHacquS2BaHoBLwva8j9XvqoELMVTYCErfnDMC5T7Hezo4vtbe+l8mdNvz2xxxz7nrRNxXv8LW30XmLasJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365474; c=relaxed/simple;
	bh=k2V0WKOtKwSVG0D2GbBBEtrtCk+GkDIOw7whRPQAlHA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZZXzuWbEEImlb8/Gn9b8h5IUZJmzvVFGiyN7i9bGbJnBtrG3qk+5bk5A2iFJ4pygRtHIjT3HAnpSyeJXRf4s22iVvPfwomm8cFFfFgvaANAOgizxGXySL4pBjwuDQ0L43jPIwSPbrWP3gox3W2Ks65P+CX07wRLkiFCqveTzxn0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qXhzjwGW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qXhzjwGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF08AC4CEE9;
	Tue, 27 May 2025 17:04:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365474;
	bh=k2V0WKOtKwSVG0D2GbBBEtrtCk+GkDIOw7whRPQAlHA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qXhzjwGWNyR0VNhdhsT4lDMBrtXbil2F/l9vULT6WDtxsmgz0JgTSpmTqxYcYQKa3
	 Feuo3KOGBTxKuXTrJ4dLX8V4NS4iI1FtJ2Psgd+y5WGI11PLvqUP3v04vpYtBKKa1l
	 6GJCEzDAi1izOxuPoUVKe6lCJrV08Ujy3+7PzyI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 388/626] drm/amdkfd: fix missing L2 cache info in topology
Date: Tue, 27 May 2025 18:24:41 +0200
Message-ID: <20250527162500.785188493@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Huang <jinhuieric.huang@amd.com>

[ Upstream commit 5ffd56822a7159917306d99f18fd15dfd7288f20 ]

In some ASICs L2 cache info may miss in kfd topology,
because the first bitmap may be empty, that means
the first cu may be inactive, so to find the first
active cu will solve the issue.

v2: Only find the first active cu in the first xcc

Signed-off-by: Eric Huang <jinhuieric.huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
index bcb5cdc4a9d81..82da568604b6e 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -1683,17 +1683,32 @@ static int fill_in_l2_l3_pcache(struct kfd_cache_properties **props_ext,
 				int cache_type, unsigned int cu_processor_id,
 				struct kfd_node *knode)
 {
-	unsigned int cu_sibling_map_mask;
+	unsigned int cu_sibling_map_mask = 0;
 	int first_active_cu;
 	int i, j, k, xcc, start, end;
 	int num_xcc = NUM_XCC(knode->xcc_mask);
 	struct kfd_cache_properties *pcache = NULL;
 	enum amdgpu_memory_partition mode;
 	struct amdgpu_device *adev = knode->adev;
+	bool found = false;
 
 	start = ffs(knode->xcc_mask) - 1;
 	end = start + num_xcc;
-	cu_sibling_map_mask = cu_info->bitmap[start][0][0];
+
+	/* To find the bitmap in the first active cu in the first
+	 * xcc, it is based on the assumption that evrey xcc must
+	 * have at least one active cu.
+	 */
+	for (i = 0; i < gfx_info->max_shader_engines && !found; i++) {
+		for (j = 0; j < gfx_info->max_sh_per_se && !found; j++) {
+			if (cu_info->bitmap[start][i % 4][j % 4]) {
+				cu_sibling_map_mask =
+					cu_info->bitmap[start][i % 4][j % 4];
+				found = true;
+			}
+		}
+	}
+
 	cu_sibling_map_mask &=
 		((1 << pcache_info[cache_type].num_cu_shared) - 1);
 	first_active_cu = ffs(cu_sibling_map_mask);
-- 
2.39.5



