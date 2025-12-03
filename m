Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D05434F497;
	Wed,  3 Dec 2025 16:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777918; cv=none; b=NeMHLgOhIB72/6fi1X+kOyvkQRSOWIjbhuOKqr9ZUoWOgEp/td+trybavU/U0Wf8CdsZE+VuUYD6OZE/6bfgwZ2o2UqyuTJXJQOsdf2E4oHAYQgUUjh4OS/kxWfi2Q8sbTLPH6XDwebQTC2sHhRVhDOVczvkg5LezrSM5iFg2Bw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777918; c=relaxed/simple;
	bh=2NzWQgHekCkpf6Sd7L+HgrdCbI67Bgek8dMhrBV/RA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fMAe+tI2Cszq4QdqV2PWR4oKGdN5S2DVMdSFzM4AapXeWo+YMf4xShSrtDyrX/qJaZBRc5XUvcbuxkvJGWCYSaM8JCnraTlMV4c/Clihl+/CBy/sSEeiD+u9om6EB6D6XCqh2hvleEU104UaG95WlG5E4opDyHq95N+voC2cYvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBmb+xUo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBmb+xUo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 811ABC4CEF5;
	Wed,  3 Dec 2025 16:05:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777917;
	bh=2NzWQgHekCkpf6Sd7L+HgrdCbI67Bgek8dMhrBV/RA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BBmb+xUolR6Oqfn80wdgP3fZp/YuI4WeHSUgjiV4Ce6HmK2VHTtxYoNzlmrvvrWWO
	 B8ko4RzdO0ey/XbQyrKaN/9gYG3bCpuMnLMkjFsn0nMJ0W40m1tRMDH83rTK/RK1r0
	 FMz8MeriRfnQdZloFnDOA9DUjWRv/RA+tnKcJvoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Tatyana Nikolova <tatyana.e.nikolova@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 187/392] RDMA/irdma: Fix SD index calculation
Date: Wed,  3 Dec 2025 16:25:37 +0100
Message-ID: <20251203152420.960135445@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fed49da770f3b..6562592695b70 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -74,7 +74,7 @@ irdma_hmc_init_pble(struct irdma_sc_dev *dev,
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



