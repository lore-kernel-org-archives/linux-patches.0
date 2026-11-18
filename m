Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029867;
	b=QZqzvFXzpSrtOwPGF18zCLPK1cS/Y+hk1ytG4x28tqAl33SEE6wzsBJZvZvKFLRHW2di
	 zEdoz/ct3FHR0QcXuNb0LjQJSQ4mW5XTcCZLT9OgBIcTj50+UEltzUEfgQygHPOYTgepo
	 MnqMQlRbadeKZGqBLprbGAsVEjA/6UoskAxdb71AkBTETTZDoSbLge+mQVxB0DTvUmMb7
	 izUPvNsSdul3SA+Tji1js4Tw0vTBsqzCmnVRJhPkYEsJHsVpE1osAtCYXld677VzVNYbH
	 T04z1uyADdTIiKnr/YScv0VvNTLJzehBfjrYpiLkyYVg0A/KdkmF+e1ubKGyWx3cQLA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029867;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+VAPXgcAl4HWv5986QqunhtbJWCZFiIzXiWCJwsHwzc=;
	b=lZyOIBjBHJQineEQO4QI0KWk/AFYmwK0UpvAq+A0xlCagvAFX3dyNEgm15e9tTU6gctd
	 nWkwa/PdYNHOxsk6svLcLgBhRm7Odlwpi+e57I9OsSI154FCkrnfw9/i4CnW7A3VjjgAY
	 dsmaBf0VxEYvEn15ssapmBrHpHC9G9xBi1dypsCjLdHu7KGN/yVB9dSf0iYhMfMxNbrEH
	 cJXMAXJJoEwPGfL69Yyhg0ru7WbauisbHWB8Eal6kNFPJOLc9pLD5UA08clGFaTxTh4cL
	 QLWWB4PgBlXJZAiVSHM1SwMDCp/CkXXtTE5uEwDB/q55ZMDDjnOK6KFPLVBc0EU7OYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GdQj+qns;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D22606A31C;
	Wed, 18 Nov 2026 19:24:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GdQj+qns
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450191F000C4;
	Wed, 18 Nov 2026 19:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029866;
	bh=+VAPXgcAl4HWv5986QqunhtbJWCZFiIzXiWCJwsHwzc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GdQj+qns98JeTjPiPEUeSaZFGT9b73nCJY2/7KBHNOL/3nflgTWmZLPew97ToDppY
	 Q26DB7en061A4wpGtfQgfFok317L5u25ieLR28CT8dKAq3SUtHT5HIY00ysv42ZYCj
	 XnkatuGbnNmJjXDbee76XrqqHM8wkxmqVc6r0O+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Bongio <jbongio@google.com>,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0501/1756] RDMA/irdma: Use kvzalloc for lvl2 leafmem allocation
Date: Wed, 18 Nov 2026 15:43:48 +0100
Message-ID: <20261118150029.017778889@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Bongio <jbongio@google.com>

[ Upstream commit 9c40f13a63a4b87177de3e8c318af25068fc6ab4 ]

During VM live migration or when registering large memory regions
(e.g., guest memory >= 256 GB backed by 4 KiB pages), get_lvl2_pble()
calculates total leaves exceeding ~131,072. The memory required for
lvl2->leafmem.va exceeds 4 MiB (sizeof(*leaf) * total > 5.24 MiB).

Because kzalloc() requires physically contiguous pages, requests larger
than MAX_PAGE_ORDER (4 MiB on x86_64) fail and trigger a warning:

  WARNING: CPU: 123 PID: 119906 at mm/page_alloc.c:5997 __alloc_frozen_pages_noprof+0x50c/0x1050
  Call Trace:
   <TASK>
   alloc_frozen_pages_noprof+0xc0/0x240
   ___kmalloc_large_node+0x3d/0xd0
   __kmalloc_large_node_noprof+0x1b/0x90
   __kmalloc_noprof+0x254/0x660
   get_lvl1_lvl2_pble+0xbc/0x270 [irdma]
   irdma_get_pble+0x44/0xc0 [irdma]
   irdma_setup_pbles+0x46/0x1d0 [irdma]
   irdma_reg_user_mr_type_mem+0x41/0x230 [irdma]
   irdma_reg_user_mr+0x194/0x1c0 [irdma]
   ib_uverbs_reg_mr+0x1b0/0x2c0 [ib_uverbs]

The leafmem array is purely host software tracking structures (struct
irdma_pble_info) and does not require physically contiguous memory.

Switch the allocation from kzalloc() to kvzalloc() and free it with
kvfree() so that requests exceeding MAX_PAGE_ORDER fall back to
virtually contiguous memory via vmalloc.

Fixes: e8c4dbc2fcac ("RDMA/irdma: Add PBLE resource manager")
Assisted-by: LLM
Signed-off-by: Jeremy Bongio <jbongio@google.com>
Link: https://patch.msgid.link/20260916173203.2555458-1-jbongio@google.com
Tested-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/pble.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
index 9370fce3cc8e3..13bbd9d17c0a0 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -322,7 +322,7 @@ static void free_lvl2(struct irdma_hmc_pble_rsrc *pble_rsrc,
 	if (root->addr)
 		irdma_prm_return_pbles(&pble_rsrc->pinfo, &root->chunkinfo);
 
-	kfree(lvl2->leafmem.va);
+	kvfree(lvl2->leafmem.va);
 	lvl2->leaf = NULL;
 }
 
@@ -350,7 +350,7 @@ static int get_lvl2_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 	lvl2->leaf_cnt = total;
 
 	lvl2->leafmem.size = (sizeof(*leaf) * total);
-	lvl2->leafmem.va = kzalloc(lvl2->leafmem.size, GFP_KERNEL);
+	lvl2->leafmem.va = kvzalloc(lvl2->leafmem.size, GFP_KERNEL);
 	if (!lvl2->leafmem.va)
 		return -ENOMEM;
 
@@ -359,7 +359,7 @@ static int get_lvl2_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 	ret_code = irdma_prm_get_pbles(&pble_rsrc->pinfo, &root->chunkinfo,
 				       total << 3, &root->addr, &fpm_addr);
 	if (ret_code) {
-		kfree(lvl2->leafmem.va);
+		kvfree(lvl2->leafmem.va);
 		lvl2->leaf = NULL;
 		return -ENOMEM;
 	}
-- 
2.53.0



