Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFE181F7071;
	Tue,  3 Dec 2024 15:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240804; cv=none; b=Tp6Nz5jx3YEdHyhXE5ZgiiuVJ3emqqUD86aLt1mVsunSL5e2ZSvORErLbWpW7LhVYa8s+gjOUSymcUEga4N2xjulwU9d1LBHZhy+b4XwHbXf1e+9Qe1TBhU/jqCX3YzDsNs8IocNt4K/WCfYawDTgvii1d4enfta7fJr055828Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240804; c=relaxed/simple;
	bh=JVRmrdGEvvYQIbfi76nj5Zkod4Z5T5UlQq7X64WbQTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WuDsmqllSapftmYIHjDtE0D/XLu2vWUavOs+hOKc53gG2GwHvDakuYH5+YxXAFvlTPsSSlGhg3MtNcYgm9g35ekbPD8fJKJjgdN+ftjq+Fy2nhlRzJY8qTLmm8c32om6PpNI6bHJiZ9+BaQ9gbOrmyga30kBDbM3aPLya3QOIaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uYCKKVwi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uYCKKVwi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 613F4C4CECF;
	Tue,  3 Dec 2024 15:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240803;
	bh=JVRmrdGEvvYQIbfi76nj5Zkod4Z5T5UlQq7X64WbQTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uYCKKVwiQ6gnEpNJ+4GRfawKHkE/6hEpRbw54YvKBUYkaENLBCeue2D/7Nri+T7zZ
	 DL0weYt5nDzzc8k49E2gNH6Sp3Nj+qWw/RNLChoff7yiha6VFn/16N3zTO5aD4dD4F
	 MJNcGtsETkyDTjSuaOUd+GBKMhFzBaM9A0gbOgDQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 207/826] drm/v3d: Flush the MMU before we supply more memory to the binner
Date: Tue,  3 Dec 2024 15:38:54 +0100
Message-ID: <20241203144751.821883165@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

From: Maíra Canal <mcanal@igalia.com>

[ Upstream commit d2fb8811108b2c1285c56f4fba4fff8fe3525593 ]

We must ensure that the MMU is flushed before we supply more memory to
the binner, otherwise we might end up with invalid MMU accesses by the
GPU.

Fixes: 57692c94dcbe ("drm/v3d: Introduce a new DRM driver for Broadcom V3D V3.x+")
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Reviewed-by: Iago Toral Quiroga <itoral@igalia.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20240923141348.2422499-3-mcanal@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/v3d/v3d_drv.h | 1 +
 drivers/gpu/drm/v3d/v3d_irq.c | 2 ++
 drivers/gpu/drm/v3d/v3d_mmu.c | 2 +-
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/v3d/v3d_drv.h b/drivers/gpu/drm/v3d/v3d_drv.h
index cf4b23369dc44..75b4725d49c7e 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -553,6 +553,7 @@ void v3d_irq_disable(struct v3d_dev *v3d);
 void v3d_irq_reset(struct v3d_dev *v3d);
 
 /* v3d_mmu.c */
+int v3d_mmu_flush_all(struct v3d_dev *v3d);
 int v3d_mmu_set_page_table(struct v3d_dev *v3d);
 void v3d_mmu_insert_ptes(struct v3d_bo *bo);
 void v3d_mmu_remove_ptes(struct v3d_bo *bo);
diff --git a/drivers/gpu/drm/v3d/v3d_irq.c b/drivers/gpu/drm/v3d/v3d_irq.c
index d469bda52c1a5..20bf33702c3c4 100644
--- a/drivers/gpu/drm/v3d/v3d_irq.c
+++ b/drivers/gpu/drm/v3d/v3d_irq.c
@@ -70,6 +70,8 @@ v3d_overflow_mem_work(struct work_struct *work)
 	list_add_tail(&bo->unref_head, &v3d->bin_job->render->unref_list);
 	spin_unlock_irqrestore(&v3d->job_lock, irqflags);
 
+	v3d_mmu_flush_all(v3d);
+
 	V3D_CORE_WRITE(0, V3D_PTB_BPOA, bo->node.start << V3D_MMU_PAGE_SHIFT);
 	V3D_CORE_WRITE(0, V3D_PTB_BPOS, obj->size);
 
diff --git a/drivers/gpu/drm/v3d/v3d_mmu.c b/drivers/gpu/drm/v3d/v3d_mmu.c
index e36ec3343b06e..5bb7821c0243c 100644
--- a/drivers/gpu/drm/v3d/v3d_mmu.c
+++ b/drivers/gpu/drm/v3d/v3d_mmu.c
@@ -28,7 +28,7 @@
 #define V3D_PTE_WRITEABLE BIT(29)
 #define V3D_PTE_VALID BIT(28)
 
-static int v3d_mmu_flush_all(struct v3d_dev *v3d)
+int v3d_mmu_flush_all(struct v3d_dev *v3d)
 {
 	int ret;
 
-- 
2.43.0



