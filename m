Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024724;
	b=0i+fkbu/9hFU3wIyf4vQ9qiqg5ky66vOtrE8K62MPipXn6A6EVxoF2dz+7s/VC8eTO2A
	 s1e9J3183S0Y8DReZPM+CX2+El65vOPfocVX91ChoUeqMK7AKZ92g7zUcauuyZUqqiE99
	 F3ONuWgMPCRvuq2wSt5PhqXC2QcC2MzesJ+8YEiESWk1zILSUEmQLgJ0+/kFWk1eZtMqx
	 boKPkjfjqc2kGhc/JkfymK3B7BxrAziII1yPA/ppP/HsVG3mjycCF1NuRD1Q3Z72NtUTm
	 mGGsxsA718riaHhWfkwV0qYh4cGYcMHo214/HKcCY+y7fkqc5XBpYoHTZFle0R5hTyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024724;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4w5Gi+2PvqaEEV8+YNyoEpuDuHmFYTwUeiXH9MwPLpo=;
	b=FMGFUZ7zh4xfKfRb/aYsk7zrh4GeasyBwsmnA51kr4HciHrcDrGB+11e8LFQ8D+PSNsA
	 OJv4jvCSOjcU+NA4pd4HHOyd61nyI/2KB2Au42Qv0K09+izzTG5YJcoZxZe43OhPFJh/m
	 hQjGF98+JyxKqYmkEK/cxH2M0b1ICATX2as8VL9S7orG2yMlkqHkmf0iw1wOy1ar/50L6
	 9efhOREwI7988Z3orlj5FIfXqI3I0X+vUpDAru7H1tKXCXZsy3FRV3Ur/gGYLtUhqt7Y7
	 zeziAWiR+igy3AqMH4iS/KfTb+0900DS9qPMnvPiGI643WzlCyE3Dz3MgOS8IPmaMeQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TyuedyZ7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60CE0606A31C;
	Wed, 18 Nov 2026 17:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TyuedyZ7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFF421F000C4;
	Wed, 18 Nov 2026 17:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024724;
	bh=4w5Gi+2PvqaEEV8+YNyoEpuDuHmFYTwUeiXH9MwPLpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TyuedyZ74kFn/eHho0Fzslvmup5uRWVvq7rqVwZgHTUJRz7GzCg2JpoErE609CWRO
	 6/LIBrhu73Mk152RMxRVreomuld2HFbp3pJkNwA3c4QSwQOEekfWPNNJYLWDVJYXh5
	 l/5JZrnOfGjqlW4GOxZ4gLmUX82BAv2glZCz6g1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhaoJinming <zhaojinming@uniontech.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0786/2151] iommu/vt-d: Fix copied_tables bitmap leak on error in copy_translation_tables
Date: Wed, 18 Nov 2026 15:42:01 +0100
Message-ID: <20261118150150.741135438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: ZhaoJinming <zhaojinming@uniontech.com>

[ Upstream commit d9ef887fb26c8a73c904b5aed93e82dca64fe109 ]

The iommu->copied_tables bitmap was introduced by the IOMMU live
update series to track which context entries have been copied from
the previous kernel.  The allocation via bitmap_zalloc() was added
inside copy_translation_tables(), but the error paths were not
updated to free it:

  1. When old_rt_phys is 0 (invalid root table address)
  2. When memremap(old_rt_phys) fails
  3. When kcalloc for ctxt_tbls fails (goto out_unmap, which only
     unmaps old_rt without releasing the bitmap)

The bitmap is only cleaned up by free_dmar_iommu(), which is
called from the free_iommu error label in init_dmars().  However,
when copy_translation_tables() fails, init_dmars() does not jump
to free_iommu -- it logs the error, falls through, and continues
with the next IOMMU.  As a result, copied_tables is leaked.

Fix this by converting the two early returns to goto a new
err_free_bitmap label, and by making out_unmap fall through to
it so that the bitmap is always freed on any error path.  The
success path performs memunmap(old_rt) inline and returns 0
directly, since copied_tables must remain allocated for
subsequent use.

Signed-off-by: ZhaoJinming <zhaojinming@uniontech.com>
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Stable-dep-of: 53e15f28829f ("iommu/vt-d: Do not ignore context table copy failures")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 94781f6206803..5c07ddd931b20 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2038,12 +2038,16 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 		return -ENOMEM;
 
 	old_rt_phys = rtaddr_reg & VTD_PAGE_MASK;
-	if (!old_rt_phys)
-		return -EINVAL;
+	if (!old_rt_phys) {
+		ret = -EINVAL;
+		goto err_free_bitmap;
+	}
 
 	old_rt = memremap(old_rt_phys, PAGE_SIZE, MEMREMAP_WB);
-	if (!old_rt)
-		return -ENOMEM;
+	if (!old_rt) {
+		ret = -ENOMEM;
+		goto err_free_bitmap;
+	}
 
 	/* This is too big for the stack - allocate it from slab */
 	ctxt_table_entries = ext ? 512 : 256;
@@ -2087,11 +2091,14 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 
 	__iommu_flush_cache(iommu, iommu->root_entry, PAGE_SIZE);
 
-	ret = 0;
+	memunmap(old_rt);
+	return 0;
 
 out_unmap:
 	memunmap(old_rt);
-
+err_free_bitmap:
+	bitmap_free(iommu->copied_tables);
+	iommu->copied_tables = NULL;
 	return ret;
 }
 
-- 
2.53.0



