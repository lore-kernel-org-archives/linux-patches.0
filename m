Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972F5221DBD;
	Mon, 23 Jun 2025 21:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712898; cv=none; b=ZeVCONwgyYQykBTfgFjnETFBP92Scp5P4fvWZx0WVXWyWhz4vdoYhIqeLdN2um2pOygdxDsv0R3dP/l9IV9sdenYKIXTYc1HmwX0Fu87eTpW+8OhoA1zsiFIxtVyurg66vJkvvmEksmd2zfxCSkVDexI6gUzdHXCiCGMOp5GtNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712898; c=relaxed/simple;
	bh=/1ff1EVy0sv4rkVGRoMzZXKaas1x2bXZn7EDZr959ys=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b9TI8VE1ZFQrZ0nQuJlDMmTXOoNWImrayPu7ob8FZ+3mlFyg7r79kVFgicrJDXAPvlS4Xym9RmXqiLKI13fpTmZVE27zBmT9cIuH/36iI4T05x1U0Q1kJdaHNlDreCFlx0KfHwrKZ8Ik5q/EgIPvCHUc0vNs2snQWAoE+nypNSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTikezPr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTikezPr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 323AAC4CEEA;
	Mon, 23 Jun 2025 21:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712898;
	bh=/1ff1EVy0sv4rkVGRoMzZXKaas1x2bXZn7EDZr959ys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QTikezPrxfKaHzJsod7m+U5NjxH7wLWjPUyyGBelOBm1DqK26u30u+smgLvpizlUm
	 5x5FRCA2jkFhP+7WXtd81iRpbsnN8JV5/vy8uaBdr+pJ7v7kOXOJqGDl9XHXgW1nN8
	 voG2eSu84SjjZoJPQApC18EJK7ODVPDn+HYoMj4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amber Lin <Amber.Lin@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 154/222] drm/amdkfd: Set SDMA_RLCx_IB_CNTL/SWITCH_INSIDE_IB
Date: Mon, 23 Jun 2025 15:08:09 +0200
Message-ID: <20250623130616.715009259@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amber Lin <Amber.Lin@amd.com>

[ Upstream commit ab9fcc6362e0699fc1150aa1d8503c40fce2c1e1 ]

When submitting MQD to CP, set SDMA_RLCx_IB_CNTL/SWITCH_INSIDE_IB bit so
it'll allow SDMA preemption if there is a massive command buffer of
long-running SDMA commands.

Signed-off-by: Amber Lin <Amber.Lin@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
index d978fcac26651..4110cdc71f045 100644
--- a/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_mqd_manager_v9.c
@@ -387,6 +387,10 @@ static void update_mqd_sdma(struct mqd_manager *mm, void *mqd,
 	m->sdma_engine_id = q->sdma_engine_id;
 	m->sdma_queue_id = q->sdma_queue_id;
 	m->sdmax_rlcx_dummy_reg = SDMA_RLC_DUMMY_DEFAULT;
+	/* Allow context switch so we don't cross-process starve with a massive
+	 * command buffer of long-running SDMA commands
+	 */
+	m->sdmax_rlcx_ib_cntl |= SDMA0_GFX_IB_CNTL__SWITCH_INSIDE_IB_MASK;
 
 	q->is_active = QUEUE_IS_ACTIVE(*q);
 }
-- 
2.39.5



