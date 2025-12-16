Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66BF341ACA;
	Tue, 16 Dec 2025 11:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884310; cv=none; b=Pu9ajQe4FE6/3uNfho9plwcsD7vUnxzG6TmHhADVL898HV/04EC4kTz2uohnclpxn4u12Qk1+lgGRSnL6vyuQL6MWEFvF72mXMfd12iXYakFAerC4VcpP5SGqXHRYa/Er2sCrpqIxjSyo9c3V8I3fTJj9DG7NtchsC3u34rfNzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884310; c=relaxed/simple;
	bh=KaA4e8dFhv3IKYxmdTzp371PACOCT4XrdSlM/4FXkaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o4XethROpYDF3a6/QffnIYFl2EKqcUyzVAQiOPgIpND77zMetYK+/eiijjTgywXD1t60gD4IDKq3qbUvuwfI1gVmYnP6ijlR07mOYxh15HvAyrmfbVcn0eIs40HRNvKpHO/40fME6Fozw5QdbXT8AlnC83aZHXevWVDZPMJKABY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I0BQ2SKi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I0BQ2SKi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E40C4CEF1;
	Tue, 16 Dec 2025 11:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884309;
	bh=KaA4e8dFhv3IKYxmdTzp371PACOCT4XrdSlM/4FXkaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0BQ2SKiC/VsfcZlWRaIVZ59ieq5VPrfhNG/dMMKj1qI9ewLUWhV0yv/KRT1GjQHR
	 D8gGcttYBUZyYkJajp4Ywc6woEvyESWaVJqbncGI7xR3MhE6qoRRgrbKtM0Bf40cXl
	 z1MBgJEITBgkUtIBikZuqjjn0okV/ec5guV99WG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akash Goel <akash.goel@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Steven Price <steven.price@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 137/354] drm/panthor: Fix potential memleak of vma structure
Date: Tue, 16 Dec 2025 12:11:44 +0100
Message-ID: <20251216111325.882351173@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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
index d548a6e0311dd..ed769749ec354 100644
--- a/drivers/gpu/drm/panthor/panthor_mmu.c
+++ b/drivers/gpu/drm/panthor/panthor_mmu.c
@@ -1139,6 +1139,20 @@ static void panthor_vm_cleanup_op_ctx(struct panthor_vm_op_ctx *op_ctx,
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
@@ -2037,8 +2051,10 @@ static int panthor_gpuva_sm_step_map(struct drm_gpuva_op *op, void *priv)
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



