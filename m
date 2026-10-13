Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E16342C80;
	Tue, 13 Oct 2026 12:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896058; cv=none; b=F5shj3Cn+vuCMBcKSuAtnqHcN+3kblVuwyzkyJfFM4UrmPuazJCHVYjn2EYGvWHYUYzn8OZfr7zYPZoE/xkGwWkIEb2DccBf1ftUPxDLzMH4sdPzq6C0muAW0s0R/CkKIJ+5rhgERINwyZenUgE1VryhV8582IE6dqI9bqE6JOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896058; c=relaxed/simple;
	bh=K5iES6AbZT3m4/138stg1kmnp/hFZ0U2d/s2tK0mZgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ol57oMJK/r/dR93AxqiAhJh/khlwTsxoNIBN5f+fzn3Bk0JJR0woZpzyBmX64NyYQi8FS6wpq9c8dYXO+7lAARi3naIgllWeCi8MxLOo9NruhH1m/TikR5cY8CjYhC5p/yB45y1v6tY7s91cvkkkcYwRX+8YUfsW/YEf22Wcj1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ghfaZYBE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ghfaZYBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4611C1F000FF;
	Tue, 13 Oct 2026 12:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896056;
	bh=AloGYN8IzVMJLXenl+MgEMBDWRjCxR7BghpBMDNm9rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ghfaZYBElmE4T0malWxniUjvtOCHYzMD8Hr0ZgpvGQiIiV8bQ1lff40ZNdo9B3T4x
	 +yr2WhBV7RZWT3suE0r/JSgFQLJAkQ2ZYjF7taoOA6Yst/ABiMr9NRNyUhSzaqm1gx
	 fzfQ1y+rA7TpD64Y43caV7Pk9ghQqSwrIl2KcDHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gyeyoung Baek <gye976@gmail.com>,
	Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Alessio Belle <alessio.belle@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 483/497] drm/imagination: Fix reference and vm_bo handling in remap()
Date: Tue, 13 Oct 2026 13:40:50 +0200
Message-ID: <20261013112919.340134482@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gyeyoung Baek <gye976@gmail.com>

[ Upstream commit 196d4d10c1b33ae176685ff42a9994a5952b1d0f ]

When a map overlaps part of an existing mapping, pvr_vm_gpuva_remap()
splits the mapping into prev/next parts covering what the request did
not take, instead of creating something new. It gets two things wrong.

- A GEM reference is taken for each part but it's never needed and never
  dropped, so it leaks one reference per split (remap-next-in-2m in
  tests/imagination/pvr_vm_map.c):

    CRITICAL: 33558528 bytes of shmem still held after close

- The parts still belong to the original object being split, but
  pvr_vm_gpuva_remap() links them to ctx->gpuvm_bo, the new object's
  vm_bo:

    prev_va --obj--> BO_A          BO_B <--obj-- vm_bo (ctx->gpuvm_bo)
            \___________link___________/  (mismatch: BO_A != BO_B)

  drm_gpuva_link() catches the mismatch:

    WARNING: drivers/gpu/drm/drm_gpuvm.c:2108 at drm_gpuva_link+0x2ec/0x310
      drm_WARN_ON(obj != vm_bo->obj)
    Call trace:
     drm_gpuva_link
     pvr_vm_gpuva_remap
     __drm_gpuvm_sm_map
     pvr_vm_map
     pvr_ioctl_vm_map

  Link them to op->remap.unmap->va->vm_bo instead.

The locking of the GPUVA lists of the other objects touched by a split is
not addressed here; it is handled by switching the GPUVM to immediate
mode.

Fixes: ff5f643de0bf ("drm/imagination: Add GEM and VM related code")
Signed-off-by: Gyeyoung Baek <gye976@gmail.com>
Reviewed-by: Brajesh Gupta <brajesh.gupta@imgtec.com>
Link: https://patch.msgid.link/20261001-pvr-fixes-a-v2-1-f58254e5dfb8@gmail.com
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_vm.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/imagination/pvr_vm.c b/drivers/gpu/drm/imagination/pvr_vm.c
index 5a4aca8be71fd..53fa5a4cc2049 100644
--- a/drivers/gpu/drm/imagination/pvr_vm.c
+++ b/drivers/gpu/drm/imagination/pvr_vm.c
@@ -412,6 +412,8 @@ pvr_vm_gpuva_unmap(struct drm_gpuva_op *op, void *op_ctx)
 static int
 pvr_vm_gpuva_remap(struct drm_gpuva_op *op, void *op_ctx)
 {
+	/* The split parts belong to the object of the mapping being split. */
+	struct drm_gpuvm_bo *vm_bo = op->remap.unmap->va->vm_bo;
 	struct pvr_vm_bind_op *ctx = op_ctx;
 	u64 va_start = 0, va_range = 0;
 	int err;
@@ -427,14 +429,12 @@ pvr_vm_gpuva_remap(struct drm_gpuva_op *op, void *op_ctx)
 	drm_gpuva_remap(&ctx->prev_va->base, &ctx->next_va->base, &op->remap);
 
 	if (op->remap.prev) {
-		pvr_gem_object_get(gem_to_pvr_gem(ctx->prev_va->base.gem.obj));
-		drm_gpuva_link(&ctx->prev_va->base, ctx->gpuvm_bo);
+		drm_gpuva_link(&ctx->prev_va->base, vm_bo);
 		ctx->prev_va = NULL;
 	}
 
 	if (op->remap.next) {
-		pvr_gem_object_get(gem_to_pvr_gem(ctx->next_va->base.gem.obj));
-		drm_gpuva_link(&ctx->next_va->base, ctx->gpuvm_bo);
+		drm_gpuva_link(&ctx->next_va->base, vm_bo);
 		ctx->next_va = NULL;
 	}
 
-- 
2.53.0



