Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56844387368;
	Tue, 10 Mar 2026 11:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141638; cv=none; b=iAex6wlJpqXmIxF8xNktMxz2XqhrFsvOarBzMhFOCPifbsq6WMM4v3+Iv39nyzjWxmC3I7nW5J3+oXx19OMx6FtZOw/FjRZjMfSLCfZ7gwBsnf6JRcr0kHmal5C7UuV+isZm0lyT5xY0ZM2DpPRdQFPRU6b4329Bud8e4U8LwHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141638; c=relaxed/simple;
	bh=7Ub6PDtqOw1QpeiF7sT+qTep445WVEzaBOPEIg7qrUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5H6PIxmABNhVCy04fzNs7j9zSSWMTfQc9LaDadDqqJfkCi418WM3pGWYaWVNVt+84uOk29NXUIfNxpUVVc/7tzFpj3rFjDGAIzfxDVzJEhBocjtnRAjBqP0QoqSNbUy2Nk/pE0KCz6M7UiQS/kjyEV/D1/81V3NtRrcTxCSwvA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JSNy6Dqt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JSNy6Dqt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F57C2BCAF;
	Tue, 10 Mar 2026 11:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141638;
	bh=7Ub6PDtqOw1QpeiF7sT+qTep445WVEzaBOPEIg7qrUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JSNy6Dqt0YoRxlDHczvDg86lWraMaqg0F3NqqOAWbKkgpVnFllcnVk/zdGs+dmxAR
	 FkAQswM6kLw9i4RVN/ddqkm7Jzz/mNz8hdnZWG7EElYrWiqSwCNy478GwXBoE2UmTJ
	 JjILLwI3WP3euUkmNGtAwTbnt2sl4nnAr1U7mBN+zJmysXouRY9vTkLRBZKd0lFPwX
	 zilojZZWIAniygxXDqTzcTWp6T7ZTLydZo0Fa/EoB/BRH2OL93fCmopclDPgTvUSEM
	 xbyz6ey4eQesINSiZsKoCXgIfRuk2BzFFKyAczN1Dx4WxujApkqlTdsacINm7esyQo
	 DYsNoykUHRyrw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ian Forbes <ian.forbes@broadcom.com>,
	Kuzey Arda Bulut <kuzeyardabulut@gmail.com>,
	Zack Rusin <zack.rusin@broadcom.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 003/314] drm/vmwgfx: Return the correct value in vmw_translate_ptr functions
Date: Tue, 10 Mar 2026 07:14:22 -0400
Message-ID: <b1f1a3ee604f14fa171d1e573b807e9388538829.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ian Forbes <ian.forbes@broadcom.com>

[ Upstream commit 5023ca80f9589295cb60735016e39fc5cc714243 ]

Before the referenced fixes these functions used a lookup function that
returned a pointer. This was changed to another lookup function that
returned an error code with the pointer becoming an out parameter.

The error path when the lookup failed was not changed to reflect this
change and the code continued to return the PTR_ERR of the now
uninitialized pointer. This could cause the vmw_translate_ptr functions
to return success when they actually failed causing further uninitialized
and OOB accesses.

Reported-by: Kuzey Arda Bulut <kuzeyardabulut@gmail.com>
Fixes: a309c7194e8a ("drm/vmwgfx: Remove rcu locks from user resources")
Signed-off-by: Ian Forbes <ian.forbes@broadcom.com>
Reviewed-by: Zack Rusin <zack.rusin@broadcom.com>
Signed-off-by: Zack Rusin <zack.rusin@broadcom.com>
Link: https://patch.msgid.link/20260113175357.129285-1-ian.forbes@broadcom.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
index 3057f8baa7d25..e1f18020170ab 100644
--- a/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c
@@ -1143,7 +1143,7 @@ static int vmw_translate_mob_ptr(struct vmw_private *dev_priv,
 	ret = vmw_user_bo_lookup(sw_context->filp, handle, &vmw_bo);
 	if (ret != 0) {
 		drm_dbg(&dev_priv->drm, "Could not find or use MOB buffer.\n");
-		return PTR_ERR(vmw_bo);
+		return ret;
 	}
 	vmw_bo_placement_set(vmw_bo, VMW_BO_DOMAIN_MOB, VMW_BO_DOMAIN_MOB);
 	ret = vmw_validation_add_bo(sw_context->ctx, vmw_bo);
@@ -1199,7 +1199,7 @@ static int vmw_translate_guest_ptr(struct vmw_private *dev_priv,
 	ret = vmw_user_bo_lookup(sw_context->filp, handle, &vmw_bo);
 	if (ret != 0) {
 		drm_dbg(&dev_priv->drm, "Could not find or use GMR region.\n");
-		return PTR_ERR(vmw_bo);
+		return ret;
 	}
 	vmw_bo_placement_set(vmw_bo, VMW_BO_DOMAIN_GMR | VMW_BO_DOMAIN_VRAM,
 			     VMW_BO_DOMAIN_GMR | VMW_BO_DOMAIN_VRAM);
-- 
2.51.0

