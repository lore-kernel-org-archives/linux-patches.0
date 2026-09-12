Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F249B2D5C68;
	Sat, 12 Sep 2026 16:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230171; cv=none; b=ILUwxy6OEKeXngf5YD1BwScDrqRRnkLhUub0S2Lpq7G50zVXhvccJdnbyy2YjSQ3ut7YmB0eIgi6RPg5PrCYnhQeksltcglcK7kSNx+I2hLmD7FqkXHOsK34TzO6yxFnoGuGMMbSZQYJ6j9swPALCuQzfL62O53MZzaEjEG82/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230171; c=relaxed/simple;
	bh=2slRokZn6GCi/qwXcTkWUCEWPE/tXRnXKTNctFGljTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QoUXOYM1TlSbC/uiJRYOg71QlCf39K4cANO6pTTyfgufaHfvFiNoIA8CKBqybxRl2eXBjx8I8N1gXj3Jnvt0tK2WAsS1+h1zDN21q0GtouwQKZg2iNHKewnAM9xQ7n3tjD2uMc/G55GkAHqXLgmkTyVe2mDG5vDfggcSKlPiDG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZPhu+xea; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZPhu+xea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0651F000FF;
	Sat, 12 Sep 2026 16:22:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230168;
	bh=Nq+NT+2PJiTKAGm0gV5YuX0YEncclvRWJnD23+/yf00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZPhu+xeaSg7YfnJ24XPvx4pW6VtsjXiavVeuwavEpDTKXXQbyLLI51M6Smbs9pZ26
	 U3ZvsPsucDlBSHMId4647nYmGgg7Zofu6B+/HrJaOn0ey/ot684QhAwsC+SoV8jDJv
	 pc7R0PDAB+IrO3uYr01mNT3zbOHDiRUziJFU+oEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0696/1191] iommu/qcom: Fix inverted fault report check in qcom_iommu_fault()
Date: Sat, 12 Sep 2026 08:57:04 +0200
Message-ID: <20260912065603.893241912@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>

[ Upstream commit 1f33b8208a1978b0c0d6ad60a47fe4bb7a235e58 ]

report_iommu_fault() returns 0 when a fault handler successfully handles
the fault, and -ENOSYS when no handler is installed. The condition
'!report_iommu_fault()' evaluates to true (printing "Unhandled context
fault") precisely when the fault *was* handled, and stays silent when no
handler is present — the opposite of what is intended.

Remove the '!' so the driver logs unhandled faults correctly.

Fixes: 049541e178d5 ("iommu: qcom: wire up fault handler")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Mukesh Ojha <mukesh.ojha@oss.qualcomm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/arm/arm-smmu/qcom_iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/arm/arm-smmu/qcom_iommu.c b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
index cf8dcd2371e8f..96910ad0c9a7f 100644
--- a/drivers/iommu/arm/arm-smmu/qcom_iommu.c
+++ b/drivers/iommu/arm/arm-smmu/qcom_iommu.c
@@ -210,7 +210,7 @@ static irqreturn_t qcom_iommu_fault(int irq, void *dev)
 	fsynr = iommu_readl(ctx, ARM_SMMU_CB_FSYNR0);
 	iova = iommu_readq(ctx, ARM_SMMU_CB_FAR);
 
-	if (!report_iommu_fault(ctx->domain, ctx->dev, iova, 0)) {
+	if (report_iommu_fault(ctx->domain, ctx->dev, iova, 0)) {
 		dev_err_ratelimited(ctx->dev,
 				    "Unhandled context fault: fsr=0x%x, "
 				    "iova=0x%016llx, fsynr=0x%x, cb=%d\n",
-- 
2.53.0



