Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A53C1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ukhCD1UV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CC8C433C9;
	Wed,  4 Oct 2023 18:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443478;
	bh=nIewVcnKpTcwqub0DPkmAmtldsczTRhckyPR4Xb84S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ukhCD1UV+Z0nr+pARV2CzTtNyJ1MYhrzJhFzBw8MHPGIQBjbrn1ViouN+H+vOeKm0
	 Bc0jTLTpoc1C9Nub8ntgfuBe/iBTsrf0oyvr8KrC2gqsdniN58i7dtPSZsawVp/vyq
	 pVtKwQDYTTuRenFbtlwd/ctAx7XsR3HBIIlZ0Y6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Grzedzicki <mge@meta.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 171/259] scsi: pm80xx: Avoid leaking tags when processing OPC_INB_SET_CONTROLLER_CONFIG command
Date: Wed,  4 Oct 2023 19:55:44 +0200
Message-ID: <20231004175225.138186629@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Michal Grzedzicki <mge@meta.com>

[ Upstream commit c13e7331745852d0dd7c35eabbe181cbd5b01172 ]

Tags allocated for OPC_INB_SET_CONTROLLER_CONFIG command need to be freed
when we receive the response.

Signed-off-by: Michal Grzedzicki <mge@meta.com>
Link: https://lore.kernel.org/r/20230911170340.699533-2-mge@meta.com
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index bcccea7c1244a..2bf293e8f7472 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -3750,10 +3750,12 @@ static int mpi_set_controller_config_resp(struct pm8001_hba_info *pm8001_ha,
 			(struct set_ctrl_cfg_resp *)(piomb + 4);
 	u32 status = le32_to_cpu(pPayload->status);
 	u32 err_qlfr_pgcd = le32_to_cpu(pPayload->err_qlfr_pgcd);
+	u32 tag = le32_to_cpu(pPayload->tag);
 
 	pm8001_dbg(pm8001_ha, MSG,
 		   "SET CONTROLLER RESP: status 0x%x qlfr_pgcd 0x%x\n",
 		   status, err_qlfr_pgcd);
+	pm8001_tag_free(pm8001_ha, tag);
 
 	return 0;
 }
-- 
2.40.1



