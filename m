Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643576FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C71BCC433C8;
	Sun, 17 Sep 2023 19:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694978733;
	bh=eJWFwnU1uIKWYmyeVC5JGQo4d1N+873TZ/zoH8zb6z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjeP01AYD8IwOpxga6V4vxCelolsl2LOvTevnKsgHJN0HXztXM5GFAODWxyrjoh3k
	 NErIWn1n5x490VlSqPY7fbhDraMU0gsNjXRs5uymoI2t0UhpKg2DZz/rEE/SWcZLuW
	 mIoBeMU2A2zlSkjJRK3aUL8sbp+hEAzFstJZWOdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 137/406] drm/etnaviv: fix dumping of active MMU context
Date: Sun, 17 Sep 2023 21:09:51 +0200
Message-ID: <20230917191104.778578069@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 20faf2005ec85fa1a6acc9a74ff27de667f90576 ]

gpu->mmu_context is the MMU context of the last job in the HW queue, which
isn't necessarily the same as the context from the bad job. Dump the MMU
context from the scheduler determined bad submit to make it work as intended.

Fixes: 17e4660ae3d7 ("drm/etnaviv: implement per-process address spaces on MMUv2")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Christian Gmeiner <christian.gmeiner@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_dump.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_dump.c b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
index 706af0304ca4c..7b57d01ba865b 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_dump.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
@@ -125,9 +125,9 @@ void etnaviv_core_dump(struct etnaviv_gem_submit *submit)
 		return;
 	etnaviv_dump_core = false;
 
-	mutex_lock(&gpu->mmu_context->lock);
+	mutex_lock(&submit->mmu_context->lock);
 
-	mmu_size = etnaviv_iommu_dump_size(gpu->mmu_context);
+	mmu_size = etnaviv_iommu_dump_size(submit->mmu_context);
 
 	/* We always dump registers, mmu, ring, hanging cmdbuf and end marker */
 	n_obj = 5;
@@ -157,7 +157,7 @@ void etnaviv_core_dump(struct etnaviv_gem_submit *submit)
 	iter.start = __vmalloc(file_size, GFP_KERNEL | __GFP_NOWARN |
 			__GFP_NORETRY);
 	if (!iter.start) {
-		mutex_unlock(&gpu->mmu_context->lock);
+		mutex_unlock(&submit->mmu_context->lock);
 		dev_warn(gpu->dev, "failed to allocate devcoredump file\n");
 		return;
 	}
@@ -169,18 +169,18 @@ void etnaviv_core_dump(struct etnaviv_gem_submit *submit)
 	memset(iter.hdr, 0, iter.data - iter.start);
 
 	etnaviv_core_dump_registers(&iter, gpu);
-	etnaviv_core_dump_mmu(&iter, gpu->mmu_context, mmu_size);
+	etnaviv_core_dump_mmu(&iter, submit->mmu_context, mmu_size);
 	etnaviv_core_dump_mem(&iter, ETDUMP_BUF_RING, gpu->buffer.vaddr,
 			      gpu->buffer.size,
 			      etnaviv_cmdbuf_get_va(&gpu->buffer,
-					&gpu->mmu_context->cmdbuf_mapping));
+					&submit->mmu_context->cmdbuf_mapping));
 
 	etnaviv_core_dump_mem(&iter, ETDUMP_BUF_CMD,
 			      submit->cmdbuf.vaddr, submit->cmdbuf.size,
 			      etnaviv_cmdbuf_get_va(&submit->cmdbuf,
-					&gpu->mmu_context->cmdbuf_mapping));
+					&submit->mmu_context->cmdbuf_mapping));
 
-	mutex_unlock(&gpu->mmu_context->lock);
+	mutex_unlock(&submit->mmu_context->lock);
 
 	/* Reserve space for the bomap */
 	if (n_bomap_pages) {
-- 
2.40.1



