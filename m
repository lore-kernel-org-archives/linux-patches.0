Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82CF92D8DC3;
	Tue, 11 Nov 2025 01:20:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824057; cv=none; b=ALg8Qmn104W0Q6kyrZDPQx8Vid+E1OhJeKnkpg3Aui3+Der2ZKXOCITCCrWTmY+p55AkLEyQSNQNaV+PMVovQQy8e84AA/YAfAIrTUU4sfbvkelOsptNYwTjzERalOW4NcpzWAowz3al/PQHmphpSFUI+XBnz7lg35IlTL3XNIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824057; c=relaxed/simple;
	bh=nzCX9YuEq+hmEju//FW3dmbkbt5mG6lbpMTSZPns5ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prwzl4efDNoF0s1LoK+tTNeWJTB+Ek07TERvuWnYh460XeVz+Lx0Gtit0YdrEWsucT416kxEx2uNf4bxxqOKurJX/eXQPvJ0nCtsr+6LgC6VoaF5GquOgz2krpocamSmDpfdgtKxhOJuBPAg0Ubl3FCAZT/k7NqqjSOIfdlV8Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UfJ+4cCI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UfJ+4cCI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219C9C16AAE;
	Tue, 11 Nov 2025 01:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824057;
	bh=nzCX9YuEq+hmEju//FW3dmbkbt5mG6lbpMTSZPns5ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UfJ+4cCIunxKB7UdLNyX4T10zvZysx6iaZm5igI1lKHSHCQ/E7+ygDmINXnpy7w4Q
	 Q9/rxYo0Jbo1To5PM6ReGU9caHUTpvJfCtPupvt+8SInl527uMGlVWu0TveQUygaG+
	 u47h3wT814EQl6G2/J19Fp2FzuzPYkuJooqIaDmM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chia-I Wu <olvaffe@gmail.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 428/849] drm/panthor: check bo offset alignment in vm bind
Date: Tue, 11 Nov 2025 09:39:58 +0900
Message-ID: <20251111004546.782401171@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

From: Chia-I Wu <olvaffe@gmail.com>

[ Upstream commit 5afa9d2a9bb1410f816e0123846047288b16e4b9 ]

Fail early from panthor_vm_bind_prepare_op_ctx instead of late from
ops->map_pages.

Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Steven Price <steven.price@arm.com>
Link: https://lore.kernel.org/r/20250828200116.3532255-1-olvaffe@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panthor/panthor_mmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/panthor/panthor_mmu.c
index 0402f5f734a1b..de6ec324c8efc 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1198,7 +1198,7 @@ static int panthor_vm_prepare_map_op_ctx(struct panthor_vm_op_ctx *op_ctx,
 	    (flags & DRM_PANTHOR_VM_BIND_OP_TYPE_MASK) != DRM_PANTHOR_VM_BIND_OP_TYPE_MAP)
 		return -EINVAL;
 
-	/* Make sure the VA and size are aligned and in-bounds. */
+	/* Make sure the VA and size are in-bounds. */
 	if (size > bo->base.base.size || offset > bo->base.base.size - size)
 		return -EINVAL;
 
@@ -2415,7 +2415,7 @@ panthor_vm_bind_prepare_op_ctx(struct drm_file *file,
 	int ret;
 
 	/* Aligned on page size. */
-	if (!IS_ALIGNED(op->va | op->size, vm_pgsz))
+	if (!IS_ALIGNED(op->va | op->size | op->bo_offset, vm_pgsz))
 		return -EINVAL;
 
 	switch (op->flags & DRM_PANTHOR_VM_BIND_OP_TYPE_MASK) {
-- 
2.51.0



