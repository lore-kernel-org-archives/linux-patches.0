Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BBA11705
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498A5C433C7;
	Mon, 11 Sep 2023 14:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694443276;
	bh=RzUF3D7cL8MZsAAuXOduIUvD9gbdX/gmIWbnQYywEK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fwl6tVOtZSZq9k6QUzg3GAlmHw1jPlyeve4Rp4slBPIngZ0NaNA5BiEAV3W71wN3a
	 mPbBYh01MR5el8IkXzXt9XE+PyomkAohphBcv+DLl68CfPXmzG2COq814VDPFOJzbT
	 003/huy/gmjWsIllPEdObQLTVU3nMHEQvF0znW/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Stach <l.stach@pengutronix.de>,
	Christian Gmeiner <christian.gmeiner@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 320/737] drm/etnaviv: fix dumping of active MMU context
Date: Mon, 11 Sep 2023 15:42:59 +0200
Message-ID: <20230911134659.496663405@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

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
index 44b5f3c35aabe..898f84a0fc30c 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_dump.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_dump.c
@@ -130,9 +130,9 @@ void etnaviv_core_dump(struct etnaviv_gem_submit *submit)
 		return;
 	etnaviv_dump_core = false;
 
-	mutex_lock(&gpu->mmu_context->lock);
+	mutex_lock(&submit->mmu_context->lock);
 
-	mmu_size = etnaviv_iommu_dump_size(gpu->mmu_context);
+	mmu_size = etnaviv_iommu_dump_size(submit->mmu_context);
 
 	/* We always dump registers, mmu, ring, hanging cmdbuf and end marker */
 	n_obj = 5;
@@ -162,7 +162,7 @@ void etnaviv_core_dump(struct etnaviv_gem_submit *submit)
 	iter.start = __vmalloc(file_size, GFP_KERNEL | __GFP_NOWARN |
 			__GFP_NORETRY);
 	if (!iter.start) {
-		mutex_unlock(&gpu->mmu_context->lock);
+		mutex_unlock(&submit->mmu_context->lock);
 		dev_warn(gpu->dev, "failed to allocate devcoredump file\n");
 		return;
 	}
@@ -174,18 +174,18 @@ void etnaviv_core_dump(struct etnaviv_gem_submit *submit)
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



