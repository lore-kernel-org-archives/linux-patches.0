Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B3BCA4B;
	Tue, 17 Jun 2025 16:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750179364; cv=none; b=BUTeYSbliLEfvQhTaq/guiD+fdE0NYQkpdb8zYh9PUiYbBZM7+AzAr8hFjJWz7fUd35LOBPT/MCKmLej5WvilGAk0SalFknKyhttCVQV462/xk24FeXuKCnXfdRgQS2s8xbYcIPiAiClZua+PpdebU17i5HaImNFfyLdqsxebMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750179364; c=relaxed/simple;
	bh=vHxVcS77mJkzqBEahowLZYyD649WxJFWu9D0D0Y59PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qzM4dJKHEVzaVsc/vKHNDBjL7VUqPrJ8kr/HbYgJD/sGtGKN6jtmLtgcOMQ1PzZpk/oXYaZ+9CGnNgcXmSs5Lz+u+nvKxlOkYCiA/NiIztfnz/7lp8Csm+b/QRnM/liLY5J25XE0Ptp6sA2qzMjpFioNkO2pAAvWI0f0Zgouqgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2ZsjKydx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2ZsjKydx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1931FC4CEE3;
	Tue, 17 Jun 2025 16:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750179364;
	bh=vHxVcS77mJkzqBEahowLZYyD649WxJFWu9D0D0Y59PU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2ZsjKydxHWlRsd7YiWSbZ+il5szjgi4rmLtnLnaMl2n0xIeHfRbkXGBARiUZdVj8A
	 LsGVG1XU2ZqrHvOf8V8y0pyvNuBQM+dxPU4A+7kDJj0JCyITXQ32ScOmjktpqihp2R
	 hFVLOZ8vX0S3NmVAs+QfHxwV4f1ENP3W13YdKJ3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 723/780] drm/xe/lrc: Use a temporary buffer for WA BB
Date: Tue, 17 Jun 2025 17:27:11 +0200
Message-ID: <20250617152520.934399537@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit 9c7632faad434c98f1f2cc06f3647a5a5d05ddbf ]

In case the BO is in iomem, we can't simply take the vaddr and write to
it. Instead, prepare a separate buffer that is later copied into io
memory. Right now it's just a few words that could be using
xe_map_write32(), but the intention is to grow the WA BB for other
uses.

Fixes: 617d824c5323 ("drm/xe: Add WA BB to capture active context utilization")
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Link: https://lore.kernel.org/r/20250604-wa-bb-fix-v1-1-0dfc5dafcef0@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit ef48715b2d3df17c060e23b9aa636af3d95652f8)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_lrc.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_lrc.c b/drivers/gpu/drm/xe/xe_lrc.c
index 03bfba696b378..16e20b5ad325f 100644
--- a/drivers/gpu/drm/xe/xe_lrc.c
+++ b/drivers/gpu/drm/xe/xe_lrc.c
@@ -941,11 +941,18 @@ static void xe_lrc_finish(struct xe_lrc *lrc)
  * store it in the PPHSWP.
  */
 #define CONTEXT_ACTIVE 1ULL
-static void xe_lrc_setup_utilization(struct xe_lrc *lrc)
+static int xe_lrc_setup_utilization(struct xe_lrc *lrc)
 {
-	u32 *cmd;
+	u32 *cmd, *buf = NULL;
 
-	cmd = lrc->bb_per_ctx_bo->vmap.vaddr;
+	if (lrc->bb_per_ctx_bo->vmap.is_iomem) {
+		buf = kmalloc(lrc->bb_per_ctx_bo->size, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+		cmd = buf;
+	} else {
+		cmd = lrc->bb_per_ctx_bo->vmap.vaddr;
+	}
 
 	*cmd++ = MI_STORE_REGISTER_MEM | MI_SRM_USE_GGTT | MI_SRM_ADD_CS_OFFSET;
 	*cmd++ = ENGINE_ID(0).addr;
@@ -966,9 +973,16 @@ static void xe_lrc_setup_utilization(struct xe_lrc *lrc)
 
 	*cmd++ = MI_BATCH_BUFFER_END;
 
+	if (buf) {
+		xe_map_memcpy_to(gt_to_xe(lrc->gt), &lrc->bb_per_ctx_bo->vmap, 0,
+				 buf, (cmd - buf) * sizeof(*cmd));
+		kfree(buf);
+	}
+
 	xe_lrc_write_ctx_reg(lrc, CTX_BB_PER_CTX_PTR,
 			     xe_bo_ggtt_addr(lrc->bb_per_ctx_bo) | 1);
 
+	return 0;
 }
 
 #define PVC_CTX_ASID		(0x2e + 1)
@@ -1123,7 +1137,9 @@ static int xe_lrc_init(struct xe_lrc *lrc, struct xe_hw_engine *hwe,
 	map = __xe_lrc_start_seqno_map(lrc);
 	xe_map_write32(lrc_to_xe(lrc), &map, lrc->fence_ctx.next_seqno - 1);
 
-	xe_lrc_setup_utilization(lrc);
+	err = xe_lrc_setup_utilization(lrc);
+	if (err)
+		goto err_lrc_finish;
 
 	return 0;
 
-- 
2.39.5



