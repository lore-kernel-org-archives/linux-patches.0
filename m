Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0A624F3EB6;
	Tue, 13 Oct 2026 12:28:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894534; cv=none; b=lzA++ivnIAymnRpZZJWI3PZwfhYMHKKB6wnigvPbQXf2s1fMOarw/D5nOFdS91+amnPgdXeL14NK0rS1oltCj/BV7UXr2Ns3+VbvdaBntxh6xlUJ5BsPN/gBJpEhiwUhE95o5v4UMOAkfITnC5bin7mp3lUEXK3U0Xe7v6mU4Z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894534; c=relaxed/simple;
	bh=lXSbnAuw1bqpkHqQcIHG8CHNtipsAdupczqMsLMDfNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSiHQVe628f3MtxCiDqkHtHPpSTAFt61d6xn2ZgHesdIHgNwgeihOEEULaRzZMEPmcHiXiZnr/pyFQLlIC60Z/lm9TZpQZ1qz0kJYGc8sGkuUcfGvVn+fhOgrAPdlDMBdMu0nSD6PidU6hM8Q2NHV/uxDMuWSAE6TS2VD1EX6YM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oMCbgjrq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oMCbgjrq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 067841F00899;
	Tue, 13 Oct 2026 12:28:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894531;
	bh=ZjmbOiNBuybnmgeyjLNxnXfhMmScvKpJhtcWXBJyhHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oMCbgjrqWWW3+x9E8NBP3i3MCsAqr9+IKTZ4jPihP2iEvmX31+dMUiHkfk7joXp6K
	 L1SKEGVMzeTgQdt5HhLitmu8w+ilwczi+NNjSyYPXTq/NXx5ATz5Ou+FaEo1cBXZ26
	 FJLwU+iLjH5ZOQ7fkM9aGs1HEvNm+jihk3W54IBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gyeyoung Baek <gye976@gmail.com>,
	Brajesh Gupta <brajesh.gupta@imgtec.com>,
	Alessio Belle <alessio.belle@imgtec.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 593/621] drm/imagination: Fix reference and vm_bo handling in remap()
Date: Tue, 13 Oct 2026 13:39:48 +0200
Message-ID: <20261013112934.875670010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e59b93c1a6e1a..bc699b600de1c 100644
--- a/drivers/gpu/drm/imagination/pvr_vm.c
+++ b/drivers/gpu/drm/imagination/pvr_vm.c
@@ -417,6 +417,8 @@ pvr_vm_gpuva_unmap(struct drm_gpuva_op *op, void *op_ctx)
 static int
 pvr_vm_gpuva_remap(struct drm_gpuva_op *op, void *op_ctx)
 {
+	/* The split parts belong to the object of the mapping being split. */
+	struct drm_gpuvm_bo *vm_bo = op->remap.unmap->va->vm_bo;
 	struct pvr_vm_bind_op *ctx = op_ctx;
 	u64 va_start = 0, va_range = 0;
 	int err;
@@ -432,14 +434,12 @@ pvr_vm_gpuva_remap(struct drm_gpuva_op *op, void *op_ctx)
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



