Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E3953F12CE;
	Tue, 21 Jul 2026 17:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655846; cv=none; b=XUnOTfyNwvuG5MoHjbDQFtHKrbXzOQYEzc1swilVzkMt9jeyr3GtHviLCVPex3g8l+mXTxe00FT87moHqTzotxsEO0L/8go/DsVVXVGmS2uG+EeicCbrQF27B2cmRiuQ63F7S8Z8OfctOBTVG7bK/8G/YZlfOu1AKQYJMxsGPdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655846; c=relaxed/simple;
	bh=zx43zBnztV2iN8qL5RTnd197WQQsyZk3E5AVXMzUqaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nqVkPVVDCDYPVDedw/DEatvdmMSkH7PenUdeSwnRoR7GCmml1u9g68Ht849OzZ6TGbw/UGzMea8yRhCL+4xvIhTYXBtOBgFVIVXc6808IqySb2ca3fr7emLCDWdCidACDyYntfjx742EUYKy/wpwdyNy+XIFhjrJRhfyjKPQijQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jWKMyodH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jWKMyodH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946A51F000E9;
	Tue, 21 Jul 2026 17:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655845;
	bh=W36KC+OH4a/q6HRNMeeLh6wqhDU2RfDfHheyTVwvDEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jWKMyodHnvTN2PEu3ZJUDEq8OnTZYxab2l9w4lNb1nRQ/DiDdj+WHtOwwu/z2o2JI
	 wE422YHZKhJugRvUWEDTBjlAcaMOjoH9fjn0Mt7sBXWnPVupb6/ulRB0yubSDU4KmW
	 mk0JHHnslLOfSNABHOoep0i2EAhf06yAlxhC1mko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Shawn Guo <shengchao.guo@oss.qualcomm.com>,
	Bibek Kumar Patro <bibek.patro@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0163/1611] iommu/arm-smmu-qcom: Fix fastrpc compatible string in ACTLR client match table
Date: Tue, 21 Jul 2026 17:04:39 +0200
Message-ID: <20260721152518.551592194@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bibek Kumar Patro <bibek.patro@oss.qualcomm.com>

[ Upstream commit a6e1618a65d453d4e739e5898c662ccb1e3de6c0 ]

The qcom_smmu_actlr_client_of_match table contained "qcom,fastrpc" as
the compatible string for applying ACTLR prefetch settings to FastRPC
devices. However, "qcom,fastrpc" is the compatible string for the parent
rpmsg channel node, which is not an IOMMU client — it carries no
"iommus" property in the device tree and is never attached to an SMMU
context bank.

The actual IOMMU clients are the compute context bank (CB) child nodes,
which use the compatible string "qcom,fastrpc-compute-cb". These nodes
carry the "iommus" property and are probed by fastrpc_cb_driver via
fastrpc_cb_probe(), which sets up the DMA mask and IOMMU mappings for
each FastRPC session. The device tree structure is:

  fastrpc {
      compatible = "qcom,fastrpc";        /* rpmsg channel, no iommus */
      ...
      compute-cb@3 {
          compatible = "qcom,fastrpc-compute-cb";
          iommus = <&apps_smmu 0x1823 0x0>;  /* actual IOMMU client */
      };
  };

Since qcom_smmu_set_actlr_dev() calls of_match_device() against the
device being attached to the SMMU context bank, the "qcom,fastrpc"
entry was never matching any device. As a result, the ACTLR prefetch
settings (PREFETCH_DEEP | CPRE | CMTLB) were silently never applied
for FastRPC compute context banks.

Fix this by replacing "qcom,fastrpc" with "qcom,fastrpc-compute-cb"
in the match table so that the ACTLR settings are correctly applied
to the compute CB devices that are the true IOMMU clients.

Assisted-by: Claude:claude-sonnet-4-6
Fixes: 3e35c3e725de ("iommu/arm-smmu: Add ACTLR data and support for qcom_smmu_500")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
Signed-off-by: Bibek Kumar Patro <bibek.patro@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
index 2c442aa2181571..3b9fb1c71e5f91 100644
--- a/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
+++ b/drivers/iommu/arm/arm-smmu/arm-smmu-qcom.c
@@ -39,7 +39,7 @@ static const struct of_device_id qcom_smmu_actlr_client_of_match[] = {
 			.data = (const void *) (PREFETCH_DEEP | CPRE | CMTLB) },
 	{ .compatible = "qcom,adreno-smmu",
 			.data = (const void *) (PREFETCH_DEEP | CPRE | CMTLB) },
-	{ .compatible = "qcom,fastrpc",
+	{ .compatible = "qcom,fastrpc-compute-cb",
 			.data = (const void *) (PREFETCH_DEEP | CPRE | CMTLB) },
 	{ .compatible = "qcom,sc7280-mdss",
 			.data = (const void *) (PREFETCH_SHALLOW | CPRE | CMTLB) },
-- 
2.53.0



