Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F9133C511;
	Fri,  9 Jan 2026 11:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959945; cv=none; b=l1qOUL35+L5kK1Mp9kajuwoUh6NK43NmwqLFqvgw4jDJCSSF6V5eE7f7eNGZP0ldqnNm1SY1oBtQ5jgREVD3CGL+UxGv/SxpXcOvYiPZV+33P8U00eKPaQDGkrWk7EsxODdrRRYmP+hmPiyYiSRxjC5Owl8yW4JAi17CBehu4Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959945; c=relaxed/simple;
	bh=Kn9zYqdwmTz0azL91VmRnBba7b2mDzUI2IjFPHU4mec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ASqh45/V7IijJ+gK0Lse5/As0QzmCpTq7Fbxlr7qV3uDgW0GFC1jnkh8eghwUWYKZ3Ho0gukNcThLJgLfdvQ0731ZP6QQSdeicrb5cLZ6qvjDqHE09VY1jiWugxO3UxSKMHsBrkVzT8NrFE5XY62qLmISQerObZ8eAHYyZnRJN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VVPoK/Vc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VVPoK/Vc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6271CC4CEF1;
	Fri,  9 Jan 2026 11:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959944;
	bh=Kn9zYqdwmTz0azL91VmRnBba7b2mDzUI2IjFPHU4mec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VVPoK/Vc+uCT80hcvXRF3wut+6bXj0ie4eqZtudCXE81HMUYz8oYtiNHQB7fH+drX
	 C3E2rgeodfICBCdqEPTHT/Cir2Ebl//lN9pXzi+ulQby8uZmyfEl5BfxIvUk52G4JO
	 zqFKUpq//fwBd0kBRPRbfN0kiKMHV6HWzpXeT+N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Czurylo <krzysztof.czurylo@intel.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 213/737] RDMA/irdma: Fix data race in irdma_free_pble
Date: Fri,  9 Jan 2026 12:35:52 +0100
Message-ID: <20260109112142.010034851@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Czurylo <krzysztof.czurylo@intel.com>

[ Upstream commit 81f44409fb4f027d1e6d54edbeba5156ad94b214 ]

Protects pble_rsrc counters with mutex to prevent data race.
Fixes the following data race in irdma_free_pble reported by KCSAN:

BUG: KCSAN: data-race in irdma_free_pble [irdma] / irdma_free_pble [irdma]

write to 0xffff91430baa0078 of 8 bytes by task 16956 on cpu 5:
 irdma_free_pble+0x3b/0xb0 [irdma]
 irdma_dereg_mr+0x108/0x110 [irdma]
 ib_dereg_mr_user+0x74/0x160 [ib_core]
 uverbs_free_mr+0x26/0x30 [ib_uverbs]
 destroy_hw_idr_uobject+0x4a/0x90 [ib_uverbs]
 uverbs_destroy_uobject+0x7b/0x330 [ib_uverbs]
 uobj_destroy+0x61/0xb0 [ib_uverbs]
 ib_uverbs_run_method+0x1f2/0x380 [ib_uverbs]
 ib_uverbs_cmd_verbs+0x365/0x440 [ib_uverbs]
 ib_uverbs_ioctl+0x111/0x190 [ib_uverbs]
 __x64_sys_ioctl+0xc9/0x100
 do_syscall_64+0x44/0xa0
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

read to 0xffff91430baa0078 of 8 bytes by task 16953 on cpu 2:
 irdma_free_pble+0x23/0xb0 [irdma]
 irdma_dereg_mr+0x108/0x110 [irdma]
 ib_dereg_mr_user+0x74/0x160 [ib_core]
 uverbs_free_mr+0x26/0x30 [ib_uverbs]
 destroy_hw_idr_uobject+0x4a/0x90 [ib_uverbs]
 uverbs_destroy_uobject+0x7b/0x330 [ib_uverbs]
 uobj_destroy+0x61/0xb0 [ib_uverbs]
 ib_uverbs_run_method+0x1f2/0x380 [ib_uverbs]
 ib_uverbs_cmd_verbs+0x365/0x440 [ib_uverbs]
 ib_uverbs_ioctl+0x111/0x190 [ib_uverbs]
 __x64_sys_ioctl+0xc9/0x100
 do_syscall_64+0x44/0xa0
 entry_SYSCALL_64_after_hwframe+0x6e/0xd8

value changed: 0x0000000000005a62 -> 0x0000000000005a68

Fixes: e8c4dbc2fcac ("RDMA/irdma: Add PBLE resource manager")
Signed-off-by: Krzysztof Czurylo <krzysztof.czurylo@intel.com>
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Link: https://patch.msgid.link/20251125025350.180-3-tatyana.e.nikolova@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/pble.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
index fa096557adc83..c7bcdc1bf9319 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -498,12 +498,14 @@ int irdma_get_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 void irdma_free_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 		     struct irdma_pble_alloc *palloc)
 {
-	pble_rsrc->freedpbles += palloc->total_cnt;
-
 	if (palloc->level == PBLE_LEVEL_2)
 		free_lvl2(pble_rsrc, palloc);
 	else
 		irdma_prm_return_pbles(&pble_rsrc->pinfo,
 				       &palloc->level1.chunkinfo);
+
+	mutex_lock(&pble_rsrc->pble_mutex_lock);
+	pble_rsrc->freedpbles += palloc->total_cnt;
 	pble_rsrc->stats_alloc_freed++;
+	mutex_unlock(&pble_rsrc->pble_mutex_lock);
 }
-- 
2.51.0



