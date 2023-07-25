Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E4E1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66400C433C8;
	Tue, 25 Jul 2023 11:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283152;
	bh=pOH/AnYFdh+7FnBn8CCYCqksboFsCkA+1derhDHiXVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lN0pp1CQ4y2iWMAdoPXvq9Ow7b1D6h3kaslJ+ufa2HdR+2WbloR/NsBm1wiB5gxeT
	 TSpgPA9AyRRs4uFU6cp6Fjmq2ePl2vE/XORCTuF1MLzGLvabzXexuEms6+y2g0EDhb
	 zLRSvaRkKpqzxiVGurH3Re7eIZZPFhFbuR2UfUlk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/183] octeontx2-pf: Dont allocate BPIDs for LBK interfaces
Date: Tue, 25 Jul 2023 12:45:56 +0200
Message-ID: <20230725104512.544243616@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geetha sowjanya <gakula@marvell.com>

[ Upstream commit 8fcd7c7b3a38ab5e452f542fda8f7940e77e479a ]

Current driver enables backpressure for LBK interfaces.
But these interfaces do not support this feature.
Hence, this patch fixes the issue by skipping the
backpressure configuration for these interfaces.

Fixes: 75f36270990c ("octeontx2-pf: Support to enable/disable pause frames via ethtool").
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Link: https://lore.kernel.org/r/20230716093741.28063-1-gakula@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index ed911d9946277..c236dba80ff1a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1452,8 +1452,9 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
 	if (err)
 		goto err_free_npa_lf;
 
-	/* Enable backpressure */
-	otx2_nix_config_bp(pf, true);
+	/* Enable backpressure for CGX mapped PF/VFs */
+	if (!is_otx2_lbkvf(pf->pdev))
+		otx2_nix_config_bp(pf, true);
 
 	/* Init Auras and pools used by NIX RQ, for free buffer ptrs */
 	err = otx2_rq_aura_pool_init(pf);
-- 
2.39.2



