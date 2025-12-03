Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6AC436C0AC;
	Wed,  3 Dec 2025 16:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779503; cv=none; b=DkpZftkwquZ30qTPoL/WgByKAqXFG/+pcFjGM6y3p+JGjW0CMHCAAyCbzkdAp8CH0miSnFzcpmjZI/29xGdCxBI5v/Xc43um0JLCBw02uZyGnvDYKEBPeGP/ICKU8o8UYtrQkUAz701Z9sGKJosn0zLCvjNHfOd5zchfRLxIzAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779503; c=relaxed/simple;
	bh=QenGR01MiedSRs6bIYDWPQzgdZHLXrvYCRCARjwkVOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plIfIJHnw9/qugyVwmEBsfxWaAo1kOV/5EKDZzH2EbFJDzxeNDbM/+MhB/2YTUJxAGVLItYCPLRaVjGhYaaBVGzIp0oPAqOPZm02JJ9cCXOcTMaeGlntiRK3ap1ldHQ9heVKob4yeYKv+RXM2cyAGeevw6upBND30zT88iAeylE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ujJ/qVKf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ujJ/qVKf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C89C4CEF5;
	Wed,  3 Dec 2025 16:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779503;
	bh=QenGR01MiedSRs6bIYDWPQzgdZHLXrvYCRCARjwkVOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ujJ/qVKf6irEYZ0YJPZ59tj+MKz7G6SOWtCRNRyXNYzg1ZVyi0XTx29gBTmGv6pCD
	 neuR6xnpfUSLkDkJNPfQ9B+GZoDqKE+seE1Mw6DR7SNZlmcbaRxjbTZwPkJgHsJ+p7
	 1O7TfHoTjaUwweTFekX3JZCRslSSW+efCuQSDXnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 275/568] RDMA/irdma: Fix SD index calculation
Date: Wed,  3 Dec 2025 16:24:37 +0100
Message-ID: <20251203152450.782308748@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index cdc0b8a6ed483..8dd9e44ed2a4c 100644
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



