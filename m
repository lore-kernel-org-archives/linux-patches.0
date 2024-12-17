Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C7D91F76C3;
	Tue, 17 Dec 2024 17:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456764; cv=none; b=UrnQqpm2V7r3wKmVAYR9cb5byzBoBYbjpAji8Mv9T6glFyganmtoGFXogjIsmfHHw7mqxjodDClzK3omqkblnfFPCjsCu02FHa8qLUAWhEu0HpKtCk88rMJ2XGr4/fTvWRw6OeM2uL+KlsHsoHcuuBqtrIRQ/jAvM/6/V0OEC8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456764; c=relaxed/simple;
	bh=YiS44/WhuLyoIh6L1FSImBbp9sUN63GAzWdowCLLc0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V3Asb2dKtXflm2QiDmF8nREVi30jyoJRhYi3cZ43OULwaiB/MtUc2h2J9c9XdbIRMs04HORbhP0ElSb1zwTP4ddWaUmksup4oD59+vRnUEEvNIKpdzt+5aXHorZr12zrO/lZQut6YEvAKgPknD7OLKIo4YQY7Y+MXEiiTCQtLiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxAh6Uu+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxAh6Uu+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C360DC4CED3;
	Tue, 17 Dec 2024 17:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456764;
	bh=YiS44/WhuLyoIh6L1FSImBbp9sUN63GAzWdowCLLc0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxAh6Uu+ENH6JKam5Zrn82BZqErlessyCmjxEDvmEhv4UuONiqra0WQCkh3VVji3+
	 a1WGNPClzVbBd2RuR7j8d5nlvwmQC2yR4HT2iTQWdlMZ74bhyq87y77/1iDw79QfFt
	 92rZtQFcrP2bdIIIglfr1yAyhW1Lkd/lGiISSPfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Roper <matthew.d.roper@intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 158/172] drm/xe/reg_sr: Remove register pool
Date: Tue, 17 Dec 2024 18:08:34 +0100
Message-ID: <20241217170552.886739762@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas De Marchi <lucas.demarchi@intel.com>

[ Upstream commit d7b028656c29b22fcde1c6ee1df5b28fbba987b5 ]

That pool implementation doesn't really work: if the krealloc happens to
move the memory and return another address, the entries in the xarray
become invalid, leading to use-after-free later:

	BUG: KASAN: slab-use-after-free in xe_reg_sr_apply_mmio+0x570/0x760 [xe]
	Read of size 4 at addr ffff8881244b2590 by task modprobe/2753

	Allocated by task 2753:
	 kasan_save_stack+0x39/0x70
	 kasan_save_track+0x14/0x40
	 kasan_save_alloc_info+0x37/0x60
	 __kasan_kmalloc+0xc3/0xd0
	 __kmalloc_node_track_caller_noprof+0x200/0x6d0
	 krealloc_noprof+0x229/0x380

Simplify the code to fix the bug. A better pooling strategy may be added
back later if needed.

Fixes: dd08ebf6c352 ("drm/xe: Introduce a new DRM driver for Intel GPUs")
Reviewed-by: Matt Roper <matthew.d.roper@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241209232739.147417-2-lucas.demarchi@intel.com
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
(cherry picked from commit e5283bd4dfecbd3335f43b62a68e24dae23f59e4)
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_reg_sr.c       | 31 ++++++----------------------
 drivers/gpu/drm/xe/xe_reg_sr_types.h |  6 ------
 2 files changed, 6 insertions(+), 31 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_reg_sr.c b/drivers/gpu/drm/xe/xe_reg_sr.c
index 440ac572f6e5..52969c090965 100644
--- a/drivers/gpu/drm/xe/xe_reg_sr.c
+++ b/drivers/gpu/drm/xe/xe_reg_sr.c
@@ -26,46 +26,27 @@
 #include "xe_reg_whitelist.h"
 #include "xe_rtp_types.h"
 
-#define XE_REG_SR_GROW_STEP_DEFAULT	16
-
 static void reg_sr_fini(struct drm_device *drm, void *arg)
 {
 	struct xe_reg_sr *sr = arg;
+	struct xe_reg_sr_entry *entry;
+	unsigned long reg;
+
+	xa_for_each(&sr->xa, reg, entry)
+		kfree(entry);
 
 	xa_destroy(&sr->xa);
-	kfree(sr->pool.arr);
-	memset(&sr->pool, 0, sizeof(sr->pool));
 }
 
 int xe_reg_sr_init(struct xe_reg_sr *sr, const char *name, struct xe_device *xe)
 {
 	xa_init(&sr->xa);
-	memset(&sr->pool, 0, sizeof(sr->pool));
-	sr->pool.grow_step = XE_REG_SR_GROW_STEP_DEFAULT;
 	sr->name = name;
 
 	return drmm_add_action_or_reset(&xe->drm, reg_sr_fini, sr);
 }
 EXPORT_SYMBOL_IF_KUNIT(xe_reg_sr_init);
 
-static struct xe_reg_sr_entry *alloc_entry(struct xe_reg_sr *sr)
-{
-	if (sr->pool.used == sr->pool.allocated) {
-		struct xe_reg_sr_entry *arr;
-
-		arr = krealloc_array(sr->pool.arr,
-				     ALIGN(sr->pool.allocated + 1, sr->pool.grow_step),
-				     sizeof(*arr), GFP_KERNEL);
-		if (!arr)
-			return NULL;
-
-		sr->pool.arr = arr;
-		sr->pool.allocated += sr->pool.grow_step;
-	}
-
-	return &sr->pool.arr[sr->pool.used++];
-}
-
 static bool compatible_entries(const struct xe_reg_sr_entry *e1,
 			       const struct xe_reg_sr_entry *e2)
 {
@@ -111,7 +92,7 @@ int xe_reg_sr_add(struct xe_reg_sr *sr,
 		return 0;
 	}
 
-	pentry = alloc_entry(sr);
+	pentry = kmalloc(sizeof(*pentry), GFP_KERNEL);
 	if (!pentry) {
 		ret = -ENOMEM;
 		goto fail;
diff --git a/drivers/gpu/drm/xe/xe_reg_sr_types.h b/drivers/gpu/drm/xe/xe_reg_sr_types.h
index ad48a52b824a..ebe11f237fa2 100644
--- a/drivers/gpu/drm/xe/xe_reg_sr_types.h
+++ b/drivers/gpu/drm/xe/xe_reg_sr_types.h
@@ -20,12 +20,6 @@ struct xe_reg_sr_entry {
 };
 
 struct xe_reg_sr {
-	struct {
-		struct xe_reg_sr_entry *arr;
-		unsigned int used;
-		unsigned int allocated;
-		unsigned int grow_step;
-	} pool;
 	struct xarray xa;
 	const char *name;
 
-- 
2.39.5



