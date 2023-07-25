Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B557C1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:33:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384F5C433C8;
	Tue, 25 Jul 2023 11:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284785;
	bh=7fPFD8sCwIsEHdNXOyM+kPG/qViMhp7qC8hOyajuXtk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L3HUE+oN7TKFALfHkNZrUTvmDMVjTyF7qk8yhPwCYpVzM/JzA86GfK5QJwKx7WtQa
	 yEVd7TZKcZSuQaasbQHisytuEMuG21Y5GTPU7I7MNKJq5L3fN/xFzj1TWq0RWDnpgC
	 oDwcRpF6cDw6lPTDQl5vNF+0ZkJ+uZZaUdgWUq2Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geetha sowjanya <gakula@marvell.com>,
	Sunil Goutham <sgoutham@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 481/509] octeontx2-pf: Dont allocate BPIDs for LBK interfaces
Date: Tue, 25 Jul 2023 12:47:00 +0200
Message-ID: <20230725104615.763710913@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
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
index 54aeb276b9a0a..000dd89c4baff 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1311,8 +1311,9 @@ static int otx2_init_hw_resources(struct otx2_nic *pf)
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



