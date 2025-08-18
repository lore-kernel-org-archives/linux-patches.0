Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45407288C1F;
	Mon, 18 Aug 2025 14:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755526177; cv=none; b=Fkrfd0KFUPhxqpdzgdPc9wg2h7BgO0Q4SS8Xv50nWnPHPgIFp0TZcj1wFJlUGkk80wVgDK8dVvEBS7bThL+FvIs2whLyErb30aiCrobQT/efnfpBzI68apyVz6nGiDFk1s2Ew5RiibybKhuAF0JltraIy63l8k8nLr3hak7ws0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755526177; c=relaxed/simple;
	bh=ahsuBlpgvSvGeuuM0e9LV4+V/rYVVm6xYdGKhAsLpDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bzwfi6TjxDOS5Idl7VRmzHkhTMMLyAfUxcc9dPL2DVN0z6Ctn4arTJaXBUqXbmPGv6GgX6bTKoN50L3k0rPdN0MUSMiZ9sz+eYMYU/m51+/gHqrw1iCcPYZaOBiuctmgjW+Qv7saj4VW/OMYMRBpdkKNQz9ezwDyM5eRmyuHR4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ozkwH3Rt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ozkwH3Rt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB196C4CEEB;
	Mon, 18 Aug 2025 14:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755526177;
	bh=ahsuBlpgvSvGeuuM0e9LV4+V/rYVVm6xYdGKhAsLpDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ozkwH3RteAXWdWcyfvtG1HgVcWKcWm1qnVJ+MUOBQz02OBG3avhJWKTVKL0pik4gp
	 pcvhk17o3VvGz07b2m9TeMFkcPN2bw8B2pYBFtz8ANzRlPma4smm9xEAw0KKiw9Y/H
	 VQLwXR/NF3opadik5e0dXCVwFGNaCWeM1xmJNKoM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	Maciej Patelczyk <maciej.patelczyk@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Stuart Summers <stuart.summers@intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 479/570] drm/xe/migrate: prevent potential UAF
Date: Mon, 18 Aug 2025 14:47:46 +0200
Message-ID: <20250818124524.337467323@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

[ Upstream commit 145832fbdd17b1d77ffd6cdd1642259e101d1b7e ]

If we hit the error path, the previous fence (if there is one) has
already been put() prior to this, so doing a fence_wait could lead to
UAF. Tweak the flow to do to the put() until after we do the wait.

Fixes: 270172f64b11 ("drm/xe: Update xe_ttm_access_memory to use GPU for non-visible access")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Maciej Patelczyk <maciej.patelczyk@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: Stuart Summers <stuart.summers@intel.com>
Link: https://lore.kernel.org/r/20250731093807.207572-8-matthew.auld@intel.com
(cherry picked from commit 9b7ca35ed28fe5fad86e9d9c24ebd1271e4c9c3e)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_migrate.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_migrate.c b/drivers/gpu/drm/xe/xe_migrate.c
index 02c0a4a7372c..1e3fd139dfcb 100644
--- a/drivers/gpu/drm/xe/xe_migrate.c
+++ b/drivers/gpu/drm/xe/xe_migrate.c
@@ -1893,9 +1893,6 @@ int xe_migrate_access_memory(struct xe_migrate *m, struct xe_bo *bo,
 			current_bytes = min_t(int, current_bytes, S16_MAX * pitch);
 		}
 
-		if (fence)
-			dma_fence_put(fence);
-
 		__fence = xe_migrate_vram(m, current_bytes,
 					  (unsigned long)buf & ~PAGE_MASK,
 					  dma_addr + current_page,
@@ -1903,11 +1900,15 @@ int xe_migrate_access_memory(struct xe_migrate *m, struct xe_bo *bo,
 					  XE_MIGRATE_COPY_TO_VRAM :
 					  XE_MIGRATE_COPY_TO_SRAM);
 		if (IS_ERR(__fence)) {
-			if (fence)
+			if (fence) {
 				dma_fence_wait(fence, false);
+				dma_fence_put(fence);
+			}
 			fence = __fence;
 			goto out_err;
 		}
+
+		dma_fence_put(fence);
 		fence = __fence;
 
 		buf += current_bytes;
-- 
2.50.1



