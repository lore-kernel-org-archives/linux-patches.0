Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8499E28001E;
	Tue, 27 May 2025 17:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367810; cv=none; b=NLs/KanGB9tAhD27GdRLmaGLSRofwsck9PC0vlA9JnrU1h/BBbI+m0N8SmDCZgn2yUY+NHuj4iSaEoRlBAFmxb1DzCeG2N21liSooqOFRFzGPpQhIhSgP1tL49DsU/r4nV/I6TShO6JdfxkkghpcGrwALfW3NIciAhStMj2P360=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367810; c=relaxed/simple;
	bh=UqdSHXiaTwlxXck3JWpKGaUokZ0luSCTY53o84O6AKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lkJpvhsHcoC6foWUAC9T8g6RN7zwEZ/Hf+jZO11rAXd+ENCTFpKyNGd4z305aK+6eu9PQfp0xV2tR7HPJYbHLICRwVqgiezKCvK7SqvDKCTS1XPhVB0M4RmNXLF1Y48gbMrrpL1YRfnBHn18jpiN9wiDa7XX58KPj3CzDCXDE3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L8l2uq15; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L8l2uq15"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97059C4CEEA;
	Tue, 27 May 2025 17:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367810;
	bh=UqdSHXiaTwlxXck3JWpKGaUokZ0luSCTY53o84O6AKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L8l2uq15N12mkf6onGp1CBK77TeMiMww47Rjzl8BYSldqT2Ql2WcnwLLnvHLdlWBa
	 DgtJb15nkqf56KstNreKi4CpIJQwq2cnoNE06YeXP1f71451n0q7HxgNR74qJ5oFiD
	 LREJ+yeSJyU0aO/3N8ht5tvEs7lZ9qjk3wgDsya4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Huang <jinhuieric.huang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 479/783] drm/amdkfd: fix missing L2 cache info in topology
Date: Tue, 27 May 2025 18:24:36 +0200
Message-ID: <20250527162532.638981827@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 334c576a75b14..98317eda2cdb4 100644
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



