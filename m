Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64044350858;
	Mon, 18 Aug 2025 14:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525913; cv=none; b=PWmH6SW8MkIoiZ4X0ksVoUFrutU13pcWAPgX9DgCpGi//EGLuoolVfBpzOp5IXSq2Ui8+D8SPsA6PThwFRzHkbl0g9ScvBvzErbBvbxsiHt8mMsVblXvWyrBhoFC53EauUhtEAct5nBUFTlNbvB501vxoSs/KPumU4qjkyHzZXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525913; c=relaxed/simple;
	bh=6Msd+yT9wKu36giPofJk9fS0Rx5sHbWSDtA77Qeu5Bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sVdmhK0WbBAFARYlFnANQrQ2UQ9inNV1bPfGPCXyy76Olqr2mlld1bHqofRH2gSMr+c3hf4onXVkyYVmlbr45yzYk23v/VeWFpcO81xM6Bx2WFgXk1uFEOwCueTu+zWZr39iBIAHuoxD6DyO0YE8MYwMpOgFQabTnKIAcNftJSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fAeL6DUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fAeL6DUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE3A1C4CEEB;
	Mon, 18 Aug 2025 14:05:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525913;
	bh=6Msd+yT9wKu36giPofJk9fS0Rx5sHbWSDtA77Qeu5Bg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fAeL6DUy9Y1rg7W4K2wujbd9M386Ebbm5svqCGgOUALE4sScABAV9PTVOKEPfEnt3
	 djzXH8V6oxQdvKX3aOsGonZTugTpifMpTCBqE/fSHxGZtxxF1zTswAUTtB85NlIYvy
	 sdLpN3D9EU2t5MGS+edxxKVtxbTGwOOts9m/umHc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francisco Gutierrez <frankramirez@google.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 403/570] scsi: pm80xx: Free allocated tags after failure
Date: Mon, 18 Aug 2025 14:46:30 +0200
Message-ID: <20250818124521.374398344@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francisco Gutierrez <frankramirez@google.com>

[ Upstream commit 258a0a19621793b811356fc9d1849f950629d669 ]

This change frees resources after an error is detected.

Signed-off-by: Francisco Gutierrez <frankramirez@google.com>
Link: https://lore.kernel.org/r/20250617210443.989058-1-frankramirez@google.com
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm80xx_hwi.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/pm8001/pm80xx_hwi.c b/drivers/scsi/pm8001/pm80xx_hwi.c
index 5b373c53c036..c4074f062d93 100644
--- a/drivers/scsi/pm8001/pm80xx_hwi.c
+++ b/drivers/scsi/pm8001/pm80xx_hwi.c
@@ -4677,8 +4677,12 @@ pm80xx_chip_phy_start_req(struct pm8001_hba_info *pm8001_ha, u8 phy_id)
 		&pm8001_ha->phy[phy_id].dev_sas_addr, SAS_ADDR_SIZE);
 	payload.sas_identify.phy_id = phy_id;
 
-	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
+	ret = pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
 				    sizeof(payload), 0);
+	if (ret < 0)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return ret;
 }
 
 /**
@@ -4704,8 +4708,12 @@ static int pm80xx_chip_phy_stop_req(struct pm8001_hba_info *pm8001_ha,
 	payload.tag = cpu_to_le32(tag);
 	payload.phy_id = cpu_to_le32(phy_id);
 
-	return pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
+	ret = pm8001_mpi_build_cmd(pm8001_ha, 0, opcode, &payload,
 				    sizeof(payload), 0);
+	if (ret < 0)
+		pm8001_tag_free(pm8001_ha, tag);
+
+	return ret;
 }
 
 /*
-- 
2.39.5



