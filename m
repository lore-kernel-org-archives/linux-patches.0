Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1618F3451A6;
	Tue, 16 Dec 2025 12:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887605; cv=none; b=MArjzSSBjFh9ZVFACCeBQIzr1a1htvx4xzZ+BJmIRQ0HnbAaz6UeGV4r5xVshG6ExHgCALOZv4k6KoHy4Wk2Si9OI249fkp9ARU4/K0hWIdW51QCIWjCVvgS8RCwH0/YmV0NODw4hnhUD8H1D+DQO1y7NqyLY3ooZmPmC0qZaug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887605; c=relaxed/simple;
	bh=+PkCffZ6hiJ3r+LlBKdNzVCib0rqxjrMQh1llP3g5p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHeCLdFfts7Kir58wNagNgxQ4FRkD0Row8hDE+CxHWjViWWKgu2KVkEIWfKjdxznvNH6+Qvj4ytRXFafj3FHm7/BOSlOUPafOz2MGK/OHpZ+k+Y1ncL6ffD0RkipekY1f9c/3xV8GKPELF0RvRE8Gmo5moU1VA1z4uXhpZxc3mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dVyzY4QS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dVyzY4QS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC7BC4CEF1;
	Tue, 16 Dec 2025 12:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887605;
	bh=+PkCffZ6hiJ3r+LlBKdNzVCib0rqxjrMQh1llP3g5p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dVyzY4QSGrLIV7/EHjBF+78aNagx3skqZNfQNauq9q+37XKLxmyH6Ck7IyfHkvxqz
	 4II2j8T7+I+yzxpLV4LozkFippBBAXlPc+9UwlTrYzN/Lnz5Tu3qkJGA/KKQdJZDRN
	 +fEn+JaW6joqq5l1Wp/bkwKkg2S6G77l7DAzwZvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Goel <akash.goel@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 239/614] drm/panthor: Fix potential memleak of vma structure
Date: Tue, 16 Dec 2025 12:10:06 +0100
Message-ID: <20251216111410.027178940@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Akash Goel <akash.goel@arm.com>

[ Upstream commit 4492d54d59872bb72e119ff9f77969ab4d8a0e6b ]

This commit addresses a memleak issue of panthor_vma (or drm_gpuva)
structure in Panthor driver, that can happen if the GPU page table
update operation to map the pages fail.
The issue is very unlikely to occur in practice.

v2: Add panthor_vm_op_ctx_return_vma() helper (Boris)

v3: Add WARN_ON_ONCE (Boris)

Fixes: 647810ec2476 ("drm/panthor: Add the MMU/VM logical block")
Signed-off-by: Akash Goel <akash.goel@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://patch.msgid.link/20251021081042.1377406-1-akash.goel@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 7870e7dbaa5d4..15961629872e1 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1146,6 +1146,20 @@ static void panthor_vm_cleanup_op_ctx(struct panthor_vm_op_ctx *op_ctx,
 	}
 }
 
+static void
+panthor_vm_op_ctx_return_vma(struct panthor_vm_op_ctx *op_ctx,
+			     struct panthor_vma *vma)
+{
+	for (u32 i = 0; i < ARRAY_SIZE(op_ctx->preallocated_vmas); i++) {
+		if (!op_ctx->preallocated_vmas[i]) {
+			op_ctx->preallocated_vmas[i] = vma;
+			return;
+		}
+	}
+
+	WARN_ON_ONCE(1);
+}
+
 static struct panthor_vma *
 panthor_vm_op_ctx_get_vma(struct panthor_vm_op_ctx *op_ctx)
 {
@@ -2085,8 +2099,10 @@ static int panthor_gpuva_sm_step_map(struct drm_gpuva_op *op, void *priv)
 	ret = panthor_vm_map_pages(vm, op->map.va.addr, flags_to_prot(vma->flags),
 				   op_ctx->map.sgt, op->map.gem.offset,
 				   op->map.va.range);
-	if (ret)
+	if (ret) {
+		panthor_vm_op_ctx_return_vma(op_ctx, vma);
 		return ret;
+	}
 
 	/* Ref owned by the mapping now, clear the obj field so we don't release the
 	 * pinning/obj ref behind GPUVA's back.
-- 
2.51.0



