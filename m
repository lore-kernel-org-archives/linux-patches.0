Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6306834F270;
	Tue, 16 Dec 2025 11:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885655; cv=none; b=IgAAnaeD71QbBXuOtI9Ycwbx0416YQ2U1D+gYVgU12/qeIrxmVErgGSOrExxTQh8c9aJwIvuqr/pApZjZiYHokvhRJeeOwGqskkE5cWBG9y55u/IRRSG3BmpeGU+CZ9yCqOudK/uAlY+ZrLZzi047S5FlFBGfVEjjGYms/JIP0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885655; c=relaxed/simple;
	bh=z0+xDRTkrBLxdRi+Ujk7E7a5Vx1MNhmn6WqfkWcm3QU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kkg7D4ZUyvNtRg9exJo6jPDp2sH+DIUPun9/Dc6detpbZCs07N+FylHVAS6oJgrGPcocVKQeWN4ztrKImSoSnDKz5GtUxvw7ZCkVWRk5NjKGKmh5RuLlg06ExXC+9lD9Ly8XcEwr0+/mJQKOunrPClJFF36KGmspHZu46eC8e6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYyMVF/A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYyMVF/A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3000C4CEF1;
	Tue, 16 Dec 2025 11:47:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885655;
	bh=z0+xDRTkrBLxdRi+Ujk7E7a5Vx1MNhmn6WqfkWcm3QU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYyMVF/A56cyUgmynDBQsJlfH0CXVS9vIRl9U4BDuIMfu9tXYZCfvMd0Y17aMPPcu
	 zbTzp52G6UwaClcIH+cdaJG3iA69LpqR3uhlJf7MkN5nlvOu6i8X3l9BDOypY+IZaB
	 yEDu+OEKw2JJOryAorcN7wx2sF8x6IZsWEgBD+m0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Goel <akash.goel@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 203/507] drm/panthor: Fix potential memleak of vma structure
Date: Tue, 16 Dec 2025 12:10:44 +0100
Message-ID: <20251216111352.866683634@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index de6ec324c8efc..3d356a08695ab 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1118,6 +1118,20 @@ static void panthor_vm_cleanup_op_ctx(struct panthor_vm_op_ctx *op_ctx,
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
@@ -2057,8 +2071,10 @@ static int panthor_gpuva_sm_step_map(struct drm_gpuva_op *op, void *priv)
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



