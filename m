Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24252046BA;
	Wed, 20 May 2026 17:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298055; cv=none; b=RpzOGtvRwfguSy80aOIE5ooZH7St3K0cplUDtVI56i5jeng5TQ6IzLaw0Lb1BRli9hKlmeWMKBzoWyA2B6VehsHsV0Z7MuE0FeauJTwvU+ACFt5/GQoU0lUYqlPFBoQgotAOBMoCOis08nScdggwqrXoTq+ki/62eMmMQ7/1kRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298055; c=relaxed/simple;
	bh=APSqA9+6XGNJODXmHv10QYD0MRwJ0FImXFL+lrdZKP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JIt3aXbBB1YG8znCvxduA9lXFDn5CGbdrUVzBP6gi7e9AyvLpoDToRhIuWp2kl16wX5BhwQm3AjjywsSHBrHc5b1yaKPRmypY6FVEhjaYn4w30no50yCViTpJsUr8hIAaoWAsHtWq4h+6FKHJgSzNkhHkRmM55evpZfUsb1Nl7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hYHFdGh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hYHFdGh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D4141F000E9;
	Wed, 20 May 2026 17:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298054;
	bh=Y2uSAz4awn9BOKJyxkXoF0ERvHkqXNYrU+M2qVhPi0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hYHFdGh3dkwbu7RP/ccq21VVC60rM9tqxZTUEAdr9O6TYMNxy4clYjcNmFAzA/F8b
	 T/RCKa272c4M/pPYOjnu8uiPe2uE4amnzW1w5V7h26rDbvNemal78EgkIXE/E+JTRl
	 tjf7oeTlLqg/zv3gtoU6XhK3ZzEBKJgYvggzBZ+g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fangyu Yu <fangyu.yu@linux.alibaba.com>,
	Andrew Jones <andrew.jones@oss.qualcomm.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 223/957] iommu/riscv: Add IOTINVAL after updating DDT/PDT entries
Date: Wed, 20 May 2026 18:11:46 +0200
Message-ID: <20260520162139.378614693@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fangyu Yu <fangyu.yu@linux.alibaba.com>

[ Upstream commit f5c262b544975e067ea265fc7403aefbbea8563e ]

Add riscv_iommu_iodir_iotinval() to perform required TLB and context cache
invalidations after updating DDT or PDT entries, as mandated by the RISC-V
IOMMU specification (Section 6.3.1 and 6.3.2).

Fixes: 488ffbf18171 ("iommu/riscv: Paging domain support")
Signed-off-by: Fangyu Yu <fangyu.yu@linux.alibaba.com>
Reviewed-by: Andrew Jones <andrew.jones@oss.qualcomm.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/riscv/iommu.c | 70 +++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/iommu/riscv/iommu.c b/drivers/iommu/riscv/iommu.c
index ebb22979075df..c183818015813 100644
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -996,7 +996,67 @@ static void riscv_iommu_iotlb_inval(struct riscv_iommu_domain *domain,
 }
 
 #define RISCV_IOMMU_FSC_BARE 0
+/*
+ * This function sends IOTINVAL commands as required by the RISC-V
+ * IOMMU specification (Section 6.3.1 and 6.3.2 in 1.0 spec version)
+ * after modifying DDT or PDT entries
+ */
+static void riscv_iommu_iodir_iotinval(struct riscv_iommu_device *iommu,
+				       bool inval_pdt, unsigned long iohgatp,
+				       struct riscv_iommu_dc *dc,
+				       struct riscv_iommu_pc *pc)
+{
+	struct riscv_iommu_command cmd;
+
+	riscv_iommu_cmd_inval_vma(&cmd);
 
+	if (FIELD_GET(RISCV_IOMMU_DC_IOHGATP_MODE, iohgatp) ==
+	    RISCV_IOMMU_DC_IOHGATP_MODE_BARE) {
+		if (inval_pdt) {
+			/*
+			 * IOTINVAL.VMA with GV=AV=0, and PSCV=1, and
+			 * PSCID=PC.PSCID
+			 */
+			riscv_iommu_cmd_inval_set_pscid(&cmd,
+				FIELD_GET(RISCV_IOMMU_PC_TA_PSCID, pc->ta));
+		} else {
+			if (!FIELD_GET(RISCV_IOMMU_DC_TC_PDTV, dc->tc) &&
+			    FIELD_GET(RISCV_IOMMU_DC_FSC_MODE, dc->fsc) !=
+			    RISCV_IOMMU_DC_FSC_MODE_BARE) {
+				/*
+				 * DC.tc.PDTV == 0 && DC.fsc.MODE != Bare
+				 * IOTINVAL.VMA with GV=AV=0, and PSCV=1, and
+				 * PSCID=DC.ta.PSCID
+				 */
+				riscv_iommu_cmd_inval_set_pscid(&cmd,
+					FIELD_GET(RISCV_IOMMU_DC_TA_PSCID, dc->ta));
+			}
+			/* else: IOTINVAL.VMA with GV=AV=PSCV=0 */
+		}
+	} else {
+		riscv_iommu_cmd_inval_set_gscid(&cmd,
+			FIELD_GET(RISCV_IOMMU_DC_IOHGATP_GSCID, iohgatp));
+
+		if (inval_pdt) {
+			/*
+			 * IOTINVAL.VMA with GV=1, AV=0, and PSCV=1, and
+			 * GSCID=DC.iohgatp.GSCID, PSCID=PC.PSCID
+			 */
+			riscv_iommu_cmd_inval_set_pscid(&cmd,
+				FIELD_GET(RISCV_IOMMU_PC_TA_PSCID, pc->ta));
+		}
+		/*
+		 * else: IOTINVAL.VMA with GV=1,AV=PSCV=0,and
+		 * GSCID=DC.iohgatp.GSCID
+		 *
+		 * IOTINVAL.GVMA with GV=1,AV=0,and
+		 * GSCID=DC.iohgatp.GSCID
+		 * TODO: For now, the Second-Stage feature have not yet been merged,
+		 * also issue IOTINVAL.GVMA once second-stage support is merged.
+		 */
+	}
+	riscv_iommu_cmd_send(iommu, &cmd);
+}
 /*
  * Update IODIR for the device.
  *
@@ -1031,6 +1091,11 @@ static void riscv_iommu_iodir_update(struct riscv_iommu_device *iommu,
 		riscv_iommu_cmd_iodir_inval_ddt(&cmd);
 		riscv_iommu_cmd_iodir_set_did(&cmd, fwspec->ids[i]);
 		riscv_iommu_cmd_send(iommu, &cmd);
+		/*
+		 * For now, the SVA and PASID features have not yet been merged, the
+		 * default configuration is inval_pdt=false and pc=NULL.
+		 */
+		riscv_iommu_iodir_iotinval(iommu, false, dc->iohgatp, dc, NULL);
 		sync_required = true;
 	}
 
@@ -1056,6 +1121,11 @@ static void riscv_iommu_iodir_update(struct riscv_iommu_device *iommu,
 		riscv_iommu_cmd_iodir_inval_ddt(&cmd);
 		riscv_iommu_cmd_iodir_set_did(&cmd, fwspec->ids[i]);
 		riscv_iommu_cmd_send(iommu, &cmd);
+		/*
+		 * For now, the SVA and PASID features have not yet been merged, the
+		 * default configuration is inval_pdt=false and pc=NULL.
+		 */
+		riscv_iommu_iodir_iotinval(iommu, false, dc->iohgatp, dc, NULL);
 	}
 
 	riscv_iommu_cmd_sync(iommu, RISCV_IOMMU_IOTINVAL_TIMEOUT);
-- 
2.53.0



