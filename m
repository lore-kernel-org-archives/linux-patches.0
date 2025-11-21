Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA22034EF10;
	Fri, 21 Nov 2025 13:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732952; cv=none; b=AbWaPhtd5fo0ay9F0kWUsbMI5B/tQLXc0I3nK2lDPpAUyIEIoPVPr1r5hHHh1rfFyHgv5KizcQwW3cJAZP9VjL1nAzPjMYHg/Tex6sJshkT9lTSAxQX2TicS9ZVlDG+4vF/LbjXreOcCRFtopz1B+RzDY2M8a1aox51jjFC+0lo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732952; c=relaxed/simple;
	bh=Xdf6FskXsmD/nYsqZYReqrEzRmYq6vpRfTzW9jtHsYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W2P6JdBtOCYutWT9FmuWf+uIw2XKMICb4cBzxX8yeiPLAkRX9qFRxjGu6p47bfGrYgUii9AxlTUoAwuw7lXONcCgXAtYMLe3CI/ILLIX9nhN38UbbmAR0aNBVWlSSvYlDgrM4q0dL5AIw0AOUGW13G1wnaPsKBj1syzYJbk0Mnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CCurRSwD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CCurRSwD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55798C4CEFB;
	Fri, 21 Nov 2025 13:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732952;
	bh=Xdf6FskXsmD/nYsqZYReqrEzRmYq6vpRfTzW9jtHsYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CCurRSwDvGyy/ipsh8Zcknt6HZzSsKzQXbUacgYQY90nuaFdb8C7JQ79UaDQxan3a
	 KERoXoSGdAlV4M85Xg6+ySq17OArjKJe+zgV2UG0dSJcUFeKyU/ucxe/Mn4Q1ftr+z
	 1QoWGUbLbmVzGQFOwCxTZGnfQxCsC+tpzihmtbIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 300/529] RDMA/irdma: Fix SD index calculation
Date: Fri, 21 Nov 2025 14:09:59 +0100
Message-ID: <20251121130241.700688751@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
References: <20251121130230.985163914@linuxfoundation.org>
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

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 8d158f47f1f33d8747e80c3afbea5aa337e59d41 ]

In some cases, it is possible for pble_rsrc->next_fpm_addr to be
larger than u32, so remove the u32 cast to avoid unintentional
truncation.

This fixes the following error that can be observed when registering
massive memory regions:

[  447.227494] (NULL ib_device): cqp opcode = 0x1f maj_err_code = 0xffff min_err_code = 0x800c
[  447.227505] (NULL ib_device): [Update PE SDs Cmd Error][op_code=21] status=-5 waiting=1 completion_err=1 maj=0xffff min=0x800c

Fixes: e8c4dbc2fcac ("RDMA/irdma: Add PBLE resource manager")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20250923190850.1022773-1-jmoroni@google.com
Acked-by: Tatyana Nikolova <tatyana.e.nikolova@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/pble.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
index c0bef11436b94..fa096557adc83 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -71,7 +71,7 @@ int irdma_hmc_init_pble(struct irdma_sc_dev *dev,
 static void get_sd_pd_idx(struct irdma_hmc_pble_rsrc *pble_rsrc,
 			  struct sd_pd_idx *idx)
 {
-	idx->sd_idx = (u32)pble_rsrc->next_fpm_addr / IRDMA_HMC_DIRECT_BP_SIZE;
+	idx->sd_idx = pble_rsrc->next_fpm_addr / IRDMA_HMC_DIRECT_BP_SIZE;
 	idx->pd_idx = (u32)(pble_rsrc->next_fpm_addr / IRDMA_HMC_PAGED_BP_SIZE);
 	idx->rel_pd_idx = (idx->pd_idx % IRDMA_HMC_PD_CNT_IN_SD);
 }
-- 
2.51.0



