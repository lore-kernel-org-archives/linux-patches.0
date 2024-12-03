Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A334A1F6696;
	Tue,  3 Dec 2024 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238424; cv=none; b=bsjsfmwRgF5qPS3us3XTzOB6EF/tZZdwY8Tf1rrfAHBSia3gUc7PSwTLavS95UemLBp7nEn3/xb/WHpFaSZ6I+QwQEfMmzycWJXry/QplCuiX7wzUiHCRJzCEmH94AlK2bgDWIV/F9dNEDW351z4gXNt5+gxoZavCUFP3cqiurA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238424; c=relaxed/simple;
	bh=5wOmkz+5xV9vHHHU3TI+Bq66GZjMD7o306r4sSlJhU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jz3vW/9oFzRk9K2yaZlsLIUObgSZtEpDdWBShQpbGwslMRzesNNlXDR0mYSL0bEsR763b+dUJWApD1+DX1RM42xhsXc/uZjzvlMykW0aAhrLgoH8dx7+/zqpl7oIsdsFNEjZylOZmcCJjRDVnU6rvqgsDzbjLgkHTEdtkCfQSgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zsiph/Gf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zsiph/Gf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A641C4CECF;
	Tue,  3 Dec 2024 15:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238424;
	bh=5wOmkz+5xV9vHHHU3TI+Bq66GZjMD7o306r4sSlJhU0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zsiph/GfdHqr3LQAS6uyZ26J0R5yTCDxChDo6ajsdFkTH09cGIEIx2yJeC2oEQVCa
	 c5/hRsr+gB0s7A0qprCJztboB3xg4X9JWtxQ3lNouz7azxLkFKEMr6tsK3FLPgADJN
	 HVF3azXj2Cmv9WsVg2UmblScxWMAiLct4io5k3h4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Iago Toral Quiroga <itoral@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 241/817] drm/v3d: Flush the MMU before we supply more memory to the binner
Date: Tue,  3 Dec 2024 15:36:53 +0100
Message-ID: <20241203144005.165363777@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index a0febdb6f2145..eae37dcaaaeb7 100644
--- a/drivers/gpu/drm/v3d/v3d_drv.h
+++ b/drivers/gpu/drm/v3d/v3d_drv.h
@@ -560,6 +560,7 @@ void v3d_irq_disable(struct v3d_dev *v3d);
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



