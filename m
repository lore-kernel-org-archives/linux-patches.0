Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FA22E7185;
	Tue, 15 Jul 2025 13:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587050; cv=none; b=jRoEVV7yVtAK+oAVTBKjh5F2GNDomMc3zE8AjKqBlbfmFIoySI3Rjf6jB3MURQnRTtKNQrhOm6KgS7ZfFPgU13P4wxQr5wEA+et1lAQoPJK/oBndH36LI+i5dMm4TLkvgDeU1QZ1e1kGK4fLAlgx3AkwamlYQM1an9926UfRRTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587050; c=relaxed/simple;
	bh=ZvdUt4DS6lh6YkjSYHg0EA1ImKOpSPIQAJGnfpwM/00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b2onBV05VCRMS+7TZ0EEEq6mivhIKILo4OPX1G6ddkgc6Vz0Uv57c8eD8agRt3Gsr33bGuE+s0MNBzhfxKOgzNNsgNldGb9X32HVEwKjETYwD5hRRUjUtq0lWjZm835bo8gMHaEIlwA0mJljPoRyWHVPshSHyApWJEVQBvitrw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nz73L3Pk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nz73L3Pk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719D2C4CEE3;
	Tue, 15 Jul 2025 13:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587049;
	bh=ZvdUt4DS6lh6YkjSYHg0EA1ImKOpSPIQAJGnfpwM/00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nz73L3PkrYX3SDq+1KBJC4+BApkZGC9tmIOSMRiFVdZ+hcH61tYaFX6HdUr0XnE8D
	 HEPTFcCE23tAXCu88DnsP2lC6uf6pD2FA08JtcuyWMj4F9E6c+DZiLER6sZQVbEC8C
	 41L/vU9zEMTR/szy+5x4jTm1mJDKT9fKniJAj/kY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	=?UTF-8?q?Micha=C5=82=20Winiarski?= <michal.winiarski@intel.com>,
	Lukasz Laguna <lukasz.laguna@intel.com>,
	=?UTF-8?q?Piotr=20Pi=C3=B3rkowski?= <piotr.piorkowski@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 147/192] drm/xe/pf: Clear all LMTT pages on alloc
Date: Tue, 15 Jul 2025 15:14:02 +0200
Message-ID: <20250715130820.809996564@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 705a412a367f383430fa34bada387af2e52eb043 ]

Our LMEM buffer objects are not cleared by default on alloc
and during VF provisioning we only setup LMTT PTEs for the
actually provisioned LMEM range. But beyond that valid range
we might leave some stale data that could either point to some
other VFs allocations or even to the PF pages.

Explicitly clear all new LMTT page to avoid the risk that a
malicious VF would try to exploit that gap.

While around add asserts to catch any undesired PTE overwrites
and low-level debug traces to track LMTT PT life-cycle.

Fixes: b1d204058218 ("drm/xe/pf: Introduce Local Memory Translation Table")
Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Cc: Michał Winiarski <michal.winiarski@intel.com>
Cc: Lukasz Laguna <lukasz.laguna@intel.com>
Reviewed-by: Michał Winiarski <michal.winiarski@intel.com>
Reviewed-by: Piotr Piórkowski <piotr.piorkowski@intel.com>
Link: https://lore.kernel.org/r/20250701220052.1612-1-michal.wajdeczko@intel.com
(cherry picked from commit 3fae6918a3e27cce20ded2551f863fb05d4bef8d)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_lmtt.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/xe/xe_lmtt.c b/drivers/gpu/drm/xe/xe_lmtt.c
index 89393dcb53d9d..1337cf49f1c20 100644
--- a/drivers/gpu/drm/xe/xe_lmtt.c
+++ b/drivers/gpu/drm/xe/xe_lmtt.c
@@ -78,6 +78,9 @@ static struct xe_lmtt_pt *lmtt_pt_alloc(struct xe_lmtt *lmtt, unsigned int level
 	}
 
 	lmtt_assert(lmtt, xe_bo_is_vram(bo));
+	lmtt_debug(lmtt, "level=%u addr=%#llx\n", level, (u64)xe_bo_main_addr(bo, XE_PAGE_SIZE));
+
+	xe_map_memset(lmtt_to_xe(lmtt), &bo->vmap, 0, 0, bo->size);
 
 	pt->level = level;
 	pt->bo = bo;
@@ -91,6 +94,9 @@ static struct xe_lmtt_pt *lmtt_pt_alloc(struct xe_lmtt *lmtt, unsigned int level
 
 static void lmtt_pt_free(struct xe_lmtt_pt *pt)
 {
+	lmtt_debug(&pt->bo->tile->sriov.pf.lmtt, "level=%u addr=%llx\n",
+		   pt->level, (u64)xe_bo_main_addr(pt->bo, XE_PAGE_SIZE));
+
 	xe_bo_unpin_map_no_vm(pt->bo);
 	kfree(pt);
 }
@@ -226,9 +232,14 @@ static void lmtt_write_pte(struct xe_lmtt *lmtt, struct xe_lmtt_pt *pt,
 
 	switch (lmtt->ops->lmtt_pte_size(level)) {
 	case sizeof(u32):
+		lmtt_assert(lmtt, !overflows_type(pte, u32));
+		lmtt_assert(lmtt, !pte || !iosys_map_rd(&pt->bo->vmap, idx * sizeof(u32), u32));
+
 		xe_map_wr(lmtt_to_xe(lmtt), &pt->bo->vmap, idx * sizeof(u32), u32, pte);
 		break;
 	case sizeof(u64):
+		lmtt_assert(lmtt, !pte || !iosys_map_rd(&pt->bo->vmap, idx * sizeof(u64), u64));
+
 		xe_map_wr(lmtt_to_xe(lmtt), &pt->bo->vmap, idx * sizeof(u64), u64, pte);
 		break;
 	default:
-- 
2.39.5



