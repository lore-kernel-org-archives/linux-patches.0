Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048445;
	b=Oo4foFqFBQS0ZSpq/YdaIO4DyE1KV1bGdPlun4C3AZSByTIm6X1Q/9STJClfHbRkt9K3
	 ciIAcPh6dfhMeXrDVPyDH/Sb6m1IzDmHX53paZHbwDcQXuBb2G06Dj/F8esNNbxMYdVEV
	 j+444rqfcXcXpdkPhnTvFdcVCFaA3U+SI2dXQ2hy7r7NFK3onjRE3QBtaWMQA8Y2y8Poi
	 csgNmc9CMBjWHIqwfVOhNsdfBlGkeEUwthDUon9hKYnpBuizypqozAWkizeylkuWha+GE
	 X3w74T8/D+QCXPE8AMedfZS9ryREm6u2WxCNf8XmIx2sUuGbLeBXMpo4ThRQu88AHng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048445;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qMBxmnbBI7YTzEmtpPbodbTtrvCd7hSC6mpAedatCIc=;
	b=Jc2KrjFMHr5bwpZkFM9w2ZU2zngmCDtcaWX5/7fPYGHFg6L9BwY0rXqY4EGNe3TiIl44
	 /6cMScSfobDREheiOwp9ggjOeV7Ix/dfgC28WOxfWUIJkEnjY1dZaloD9Y+aQfhACK8y6
	 SpSHkQVNLYr37TuHIvocUlVINYhBTR4VSvW/9j23DGs8kHjx4fEwbU0y6GeS/APHNyrrT
	 EDZiV8TbU0G3N5PTvPM1EP5TJNmNTwanszwjAwkxLDnWEhQazY35GXuY4fS05noqXO6qS
	 VMx9a8e7UVC49GglXT402raaNIJsWIhs0VHLpFM/qLCFC0Q584yuX15hxVQQgUp6cyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oajr4KFS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B030660A2616;
	Thu, 19 Nov 2026 00:34:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Oajr4KFS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E58F1F000C7;
	Thu, 19 Nov 2026 00:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048445;
	bh=qMBxmnbBI7YTzEmtpPbodbTtrvCd7hSC6mpAedatCIc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Oajr4KFS5X9DZ6JeyRmQrJwIpTYVbZrLozqClODFEpl8LdQjg4CuDifOMh/GDIdmq
	 XSdW5YSYCw+O69pEduJ8VSDTHAGMGqRJjRqH56+048dXfLvxL4pB2LjnaT9hmQbomC
	 9MNnQVyK63h4nysrsGPVg6UJC4FdnBEkDgepu+Bw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Bongio <jbongio@google.com>,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1998/2857] RDMA/irdma: Use kvzalloc for lvl2 leafmem allocation
Date: Wed, 18 Nov 2026 15:50:32 +0100
Message-ID: <20261118150313.308063894@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index d69ebab5c2111..7c9b96c1178b4 100644
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



