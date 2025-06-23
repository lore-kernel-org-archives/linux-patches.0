Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7678D223DEE;
	Mon, 23 Jun 2025 22:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716615; cv=none; b=Mjl78kRbDXkM3Tl+On4tYeYQngJvrdyLz6q7g/3vMf3E0jwC2jAbEfR9CZOWJ0KQ9AmNGSheBGIxyzJePPeTiE8tPOBp2/g+pD3zMVAiTuSxCgy0KpOwtACbC5w+6h6TUPGNL2ZUXu55CBWGeyo8W0QegLDrk8zN2cYdzqEqxAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716615; c=relaxed/simple;
	bh=Jpn1IvxA10dqvZmKkRkG3bk9x1TtK8qmJbDJA+5LNOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lK3MWS2MWRASbjrOBurZJ7+E+SnGT1zUFvaIwL/edUnko7Sk8txBYymDwL7cqba1hCfZhYaFY9BNwVGtqOq3LWvOHIIYDLSt+kSgYYWL3q89YuQ85hlHtTHwYGEjptuMsdCE/8gWuI1E95KcCOAfDdwkfPSpTxYJnPgqbc4DIrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wpkVgfEM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wpkVgfEM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10805C4CEEA;
	Mon, 23 Jun 2025 22:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716615;
	bh=Jpn1IvxA10dqvZmKkRkG3bk9x1TtK8qmJbDJA+5LNOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wpkVgfEMkCcMqFCvaqUnXhkqX2expHABeJoIrvQy0GlUxErDc22kwJCSd6l819mZJ
	 wJ0Jk9pOKTFjBMJDIzOcCkDBwjYhgK7zczNSA9Y9DJDZOhRpCsavQbB7+7g58XS/0k
	 JTdWLTc6BUutVAfOX0rkIyXxEvIJDWFXAfr+fHAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Kim <jonathan.kim@amd.com>,
	Jesse Zhang <Jesse.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 542/592] drm/amdkfd: move SDMA queue reset capability check to node_show
Date: Mon, 23 Jun 2025 15:08:20 +0200
Message-ID: <20250623130713.332739354@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

From: Jesse.Zhang <Jesse.Zhang@amd.com>

[ Upstream commit a55737dab6ba63eb4241e9c6547629058af31e12 ]

Relocate the per-SDMA queue reset capability check from
kfd_topology_set_capabilities() to node_show() to ensure we read the
latest value of sdma.supported_reset after all IP blocks are initialized.

Fixes: ceb7114c961b ("drm/amdkfd: flag per-sdma queue reset supported to user space")
Reviewed-by: Jonathan Kim <jonathan.kim@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit e17df7b086cf908cedd919f448da9e00028419bb)
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_topology.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
index 9bbee484d57cc..d6653e39e1477 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_topology.c
@@ -510,6 +510,10 @@ static ssize_t node_show(struct kobject *kobj, struct attribute *attr,
 			dev->node_props.capability |=
 					HSA_CAP_AQL_QUEUE_DOUBLE_MAP;
 
+		if (KFD_GC_VERSION(dev->gpu) < IP_VERSION(10, 0, 0) &&
+			(dev->gpu->adev->sdma.supported_reset & AMDGPU_RESET_TYPE_PER_QUEUE))
+				dev->node_props.capability2 |= HSA_CAP2_PER_SDMA_QUEUE_RESET_SUPPORTED;
+
 		sysfs_show_32bit_prop(buffer, offs, "max_engine_clk_fcompute",
 			dev->node_props.max_engine_clk_fcompute);
 
@@ -2001,8 +2005,6 @@ static void kfd_topology_set_capabilities(struct kfd_topology_device *dev)
 		if (!amdgpu_sriov_vf(dev->gpu->adev))
 			dev->node_props.capability |= HSA_CAP_PER_QUEUE_RESET_SUPPORTED;
 
-		if (dev->gpu->adev->sdma.supported_reset & AMDGPU_RESET_TYPE_PER_QUEUE)
-			dev->node_props.capability2 |= HSA_CAP2_PER_SDMA_QUEUE_RESET_SUPPORTED;
 	} else {
 		dev->node_props.debug_prop |= HSA_DBG_WATCH_ADDR_MASK_LO_BIT_GFX10 |
 					HSA_DBG_WATCH_ADDR_MASK_HI_BIT;
-- 
2.39.5



